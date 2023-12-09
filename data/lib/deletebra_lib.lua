function isItemFluidContainer(itemid)
	local item = getItemInfo(itemid)
	return item and item.group == ITEM_GROUP_FLUID or false
end

function getAccountStorageValue(accid, key)
    local value = db.getResult("SELECT `value` FROM `account_storage` WHERE `account_id` = " .. accid .. " and `key` = " .. key .. " LIMIT 1;")
    if(value:getID() ~= -1) then
        return value:getDataInt("value")
    else
        return -1
    end
    value:free()
end

function setAccountStorageValue(accid, key, value)
    local getvalue = db.getResult("SELECT `value` FROM `account_storage` WHERE `account_id` = " .. accid .. " and `key` = " .. key .. " LIMIT 1;")
    if(getvalue:getID() ~= -1) then
        db.executeQuery("UPDATE `account_storage` SET `value` = " .. accid .. " WHERE `key`=" .. key .. " LIMIT 1');")
        getvalue:free()
        return 1
    else
        db.executeQuery("INSERT INTO `account_storage` (`account_id`, `key`, `value`) VALUES (" .. accid .. ", " .. key .. ", '"..value.."');")
        return 1
    end
end


function doSpawnInArea(monsters, fromPos, toPos, count)
	if not type(monsters) == 'table' then
        return false
    end
	local countFreeTiles = 0
	for i=fromPos.x, toPos.x do
		for j=fromPos.y, toPos.y do
			if isWalkable({x=i, y=j, z=fromPos.z}, true, true, true, false) then
				countFreeTiles = countFreeTiles + 1
				if countFreeTiles >= count then break end
			end
		end	
		if countFreeTiles >= count then break end
	end
	
	for i=1, countFreeTiles do
		local pos = {x=math.random(fromPos.x, toPos.x), y=math.random(fromPos.y, toPos.y), z=fromPos.z}
		while(not isWalkable(pos, true, true, true, false)) do
			pos = {x=math.random(fromPos.x, toPos.x), y=math.random(fromPos.y, toPos.y), z=fromPos.z}
		end
		local monster = monsters[math.random(1, #monsters)]
		doCreateMonster(monster, pos, false, true)
	end
	
return true
end

function doCleanArena()
    local monsters = getMonstersInArea(posplayers.pos1, posplayers.pos2)
    for _, cid in pairs(monsters) do
        doRemoveCreature(cid)
    end
end

function doStartWave(waveID)
    if waves[waveID] then
        doSpawnInArea(waves[waveID].monsters, posplayers.pos1, posplayers.pos2, waves[waveID].count)
    end
end


function verificaPlayers(frompos, topos)
	for x = frompos.x, topos.x do
		for y = frompos.y, topos.y do
   			if isPlayer(getThingFromPos({x = x, y = y, z = frompos.z, stackpos = 253}).uid) then
				return true
			end
		end
	end
end

function verificaBoss(frompos, topos)
	for x = frompos.x, topos.x  do
		for y = frompos.y, topos.y do
			if isMonster(getThingFromPos({x = x, y = y, z = frompos.z, stackpos = 253}).uid) then
				doRemoveCreature(getThingFromPos({x = x, y = y, z = frompos.z, stackpos = 253}).uid)
			end
		end
	end
end

function removePlayersTime(frompos, topos)
	for x = frompos.x, topos.x  do
		for y = frompos.y, topos.y do
			local remove, clean = true, true
			local pos = {x = x, y = y, z = frompos.z}
			local m = getTopCreature(pos).uid
			if m ~= 0 and isPlayer(m) then
				doTeleportThing(m, getTownTemplePosition(1))
			end
		end
	end
	return true
end

function getTimeString(self)
    local format = {
        {'dia', self / 60 / 60 / 24},
        {'hora', self / 60 / 60 % 24},
        {'minuto', self / 60 % 60},
        {'segundo', self % 60}
    }
    
    local out = {}
    for k, t in ipairs(format) do
        local v = math.floor(t[2])
        if(v > 0) then
            table.insert(out, (k < #format and (#out > 0 and ', ' or '') or ' e ') .. v .. ' ' .. t[1] .. (v ~= 1 and 's' or ''))
        end
    end
    local ret = table.concat(out)
    if ret:len() < 16 and ret:find('segundo') then
        local a, b = ret:find(' e ')
        ret = ret:sub(b+1)
    end
    return ret
end

function formatTime(t, short)
	local str = ""
	local hour = math.floor(t / 3600)
	local min = math.floor(t / 60) % 60
	local sec = math.floor(t % 60)
	if (hour ~= 0) then
		str = hour .. (short and "h" or " h")..(short and "" or "ora")..(short and "" or (hour > 1 and "s" or "")) .. ", "
	end

	if (min ~= 0) then
		str = str .. min .. (short and "m" or " m")..(short and "" or "inuto") .. (short and "" or (min > 1 and "s" or "")) .. ", "
	end

	if (sec ~= 0) then
		str = str .. sec .. (short and "s" or " s")..(short and "" or "egundo") .. (short and "" or(sec > 1 and "s" or "")).. ", "
	end
	return str ~= "" and str:sub(1, #str - 2):gsub("(.+), (.+)", "%1 e %2", 1) or ""
end

function isPlayerOnline(name)
	local queryResult = db.storeQuery("SELECT `online` FROM `players` WHERE `name` = '"..name.."'")
	local result = result.getDataInt(queryResult, "online") > 0 and true or false
	return result
end

function getOfflinePlayerStorage(guid, storage)
	if not isPlayerOnline(getPlayerNameByGUID(guid)) then
		local queryResult = db.storeQuery("SELECT `value` FROM `player_storage` WHERE `key` = '"..storage.."' and `player_id` = "..guid.."")
		local result = queryResult and result.getDataInt(queryResult, "value") or -1
		return result
	end
end

function setOfflinePlayerStorage(guid, storage, value)
	if not isPlayerOnline(getPlayerNameByGUID(guid)) then
		db.query("UPDATE `player_storage` SET `value` = '"..value.."' WHERE `key` = '"..storage.."' and `player_id` = "..guid.."")
	end
end

function getItemNameByCount(itemID, count)
	if tonumber(count) and count > 1 and isItemStackable(itemID) then
		return getItemInfo(itemID).plural
	end
	return getItemNameById(itemID)
end

function printTable(_table)
	local function getTable(_table, expand, tabs)
		
		local aux = ""
		if not type(_table) == "table" then
			return _table
		else
			for key,value in pairs(_table) do
				if type(value) == "table" then
				
					for i = 1, tabs -1 do
						aux = aux.."\t"
					end
					
					if type(key)  == "string" then
						aux = aux.. '["'..key..'"] =\t{ \n'..getTable(value, true, tabs +1)
					else
						aux = aux.. "["..key.."] =\t{ \n"..getTable(value, true, tabs +1)
					end
					
					for i = 1, tabs do
						aux = aux.. "\t"
					end
					
					aux = aux.."},\n"				
				else
					if expand then
						for i = 1, tabs -1 do
							aux = aux.. "\t"
						end
					end
					if type(key)  == "string" then
						aux = aux.. '["'..key..'"] = '..(type(value) == "string" and '"'..value..'"' or tostring(value))..",\n"
					else
						aux = aux.. '['..key..'] = '..(type(value) == "string" and '"'..value..'"' or tostring(value))..",\n"
					end
				end
			end
		end

		return aux
	end
    if type(_table) == "table" then
        print(getTable(_table, false, 1))
        return true
    else
        error("Parameter is not a table!")
        return false
    end
end

function canPlayerReceiveItem(cid, itemId, ammount)
    local weight = getItemWeightById(itemId, ammount, true)
    if isItemStackable(itemId) then
        ammount = math.ceil(ammount / 100)
    end
    local freeCap = getPlayerFreeCap(cid)
    local freeSlots = 0
    if weight <= freeCap then
        local backpack = getPlayerSlotItem(cid, CONST_SLOT_BACKPACK)
        if backpack.uid > 0 and isContainer(backpack.uid) then
            return getContainerFreeSlots(backpack.uid) >= ammount
        end
    end
    return false
end

function getContainerFreeSlots(container)
    local size = getContainerSize(container)
    local slots = getContainerCap(container) - size
    for i = 0, size - 1 do
        local item = getContainerItem(container, i)
        if isContainer(item.uid) then
            slots = slots + getContainerFreeSlots(item.uid)
        end
    end
    return slots
end

function convertTimeString(a)
	if(type(tonumber(a)) == "number" and a > 0) then
		if (a <= 3599) then
			local minute = math.floor(a/60)
			local second = a - (60 * minute)
			if(second == 0) then
				return ((minute)..((minute > 1) and " minutes" or " minute"))
			else
				return ((minute ~= 0) and ((minute>1) and minute.." minutes and " or minute.." minute and ").. ((second>1) and second.." seconds" or second.." second") or ((second>1) and second.." seconds" or second.. " second"))
			end
		else
			local hour = math.floor(a/3600)
			local minute = math.floor((a - (hour * 3600))/60)
			local second = (a - (3600 * hour) - (minute * 60))
			if (minute == 0 and second > 0) then
				return (hour..((hour > 1) and " hours and " or " hour and "))..(second..((second > 1) and " seconds" or " second"))
			elseif (second == 0 and minute > 0) then
				return (hour..((hour > 1) and " hours and " or " hour and "))..(minute..((minute > 1) and " minutes" or " minute"))
			elseif (second == 0 and minute == 0) then
				return (hour..((hour > 1) and " hours" or " hour"))
			end

			return (hour..((hour > 1) and " hours, " or " hour, "))..(minute..((minute > 1) and " minutes and " or " minute and "))..(second..((second > 1) and " seconds" or " second"))
		end
	end
end

function convertTimeNumber(a)
	if(type(tonumber(a)) == "number" and a > 0) then
		if (a <= 3599) then
			local minute = math.floor(a/60)
			local second = a - (60 * minute)
			if(second == 0) then
				return ((minute < 10) and "0"..minute..":00" or minute..":00")
			else
				return ((minute ~= 0) and ((minute<10) and "0"..minute..":" or minute..":").. ((second<10) and "0"..second or second) or ((second<10) and "0"..second or second))
			end
		else
			local hour = math.floor(a/3600)
			local minute = math.floor((a - (hour * 3600))/60)
			local second = (a - (3600 * hour) - (minute * 60))
			if (minute == 0 and second > 0) then
				return ((hour < 10) and "0"..hour..":" or hour..":").."00:"..((second < 10) and "0"..second or second)
			elseif (second == 0 and minute > 0) then
				return ((hour < 10) and "0"..hour..":" or hour..":")..((minute < 10) and "0"..minute..":" or minute..":").."00"
			elseif (second == 0 and minute == 0) then
				return ((hour < 10) and "0"..hour..":" or hour..":").."00:00"
			end

			return ((hour < 10) and "0"..hour..":" or hour..":")..((minute < 10) and "0"..minute..":" or minute..":")..((second < 10) and "0"..second or second)
		end
	end
end

function mathtime(table) -- by dwarfer
local unit = {"sec", "min", "hour", "day"}
	for i, v in pairs(unit) do
		if v == table[2] then
			return table[1]*(60^(v == unit[4] and 2 or i-1))*(v == unit[4] and 24 or 1)
		end
	end
	
	return error("Bad declaration in mathtime function.")
end

function countDownTeleport(position, duration)
	if (duration == 0) then
		return true
	end

	local minute = duration >= 60
	local dateParameter = minute and "%M:%S" or "%S"
	local color = minute and COLOR_WHITE or COLOR_RED
	doSendAnimatedText(position, os.date(dateParameter, duration), color)
	doSendMagicEffect(position, minute and CONST_ME_MAGIC_BLUE or CONST_ME_MAGIC_RED)

	addEvent(countDownTeleport, 1000, position, duration - 1)
end

function getCreaturesFromArea(fromPos, toPos, onlyPlayers)
    local creatureInArea = {}
    for posx = fromPos.x, toPos.x do
        for posy = fromPos.y, toPos.y do
            for posz = fromPos.z, toPos.z do
                local tmp = getTopCreature({x=posx,y=posy,z=posz}).uid
                if(tmp > 0) then
					for s = 0, 255 do
						search_pos = {x = posx, y = posy, z = posz, stackpos = s}
						tmpCreature = getThingfromPos(search_pos).uid
						if tmpCreature > 0 and isCreature(tmpCreature) then
							if (onlyPlayers and isPlayer(tmpCreature) and not isSummon(tmpCreature)) or (not onlyPlayers and not isSummon(tmpCreature)) then
								if not isInArray(creatureInArea, tmpCreature) then
									table.insert(creatureInArea, tmpCreature)
								end
							end
						end
					end
                end
            end
        end
    end
    return creatureInArea
end

function getMonstersFromArea(fromPos, toPos)
    local monsterInArea = {}
    for posx = fromPos.x, toPos.x do
        for posy = fromPos.y, toPos.y do
            for posz = fromPos.z, toPos.z do
                local tmp = getTopCreature({x=posx,y=posy,z=posz}).uid
                if(tmp > 0) then
					for s = 0, 255 do
						_search_pos = {x = posx, y = posy, z = posz, stackpos = s}
						tmpMonster = getThingfromPos(_search_pos).uid
						if tmpMonster > 0 and isMonster(tmpMonster) and not isSummon(tmpMonster) and not isInArray(monsterInArea, tmpMonster) then
							table.insert(monsterInArea, tmpMonster)
						end
					end
                end
            end
        end
    end
    return monsterInArea
end

function doPlayerReceiveParcel(name, town, items, extraTextLabel, id) 
    if (getPlayerGUIDByName(name) ~= 0) then
        local parcel = doCreateItemEx(2595)
        local label = doAddContainerItem(parcel, 2599)
		doSetItemText(label, name.."\n"..getTownName(town))
		if (extraTextLabel ~= "") then
			local letter = doAddContainerItem(parcel, id)
			doSetItemText(letter, extraTextLabel)
		end

        for i = 1, #items do
            if type(items[i]) == 'table' then
                local tempitem = doAddContainerItem(parcel, tonumber(items[i].id), tonumber(items[i].count) or 1)
            else
                doAddContainerItem(parcel, items[i], 1)
            end
        end

		doPlayerSendMailByName(name, parcel, town)
    else
        debugPrint("doPlayerSendParcel: Player "..name.." not found.")
    end
end 

function isWalkable(pos, checkCreatures, checkStairs, checkPZ, checkFields)
	if getTileThingByPos({x = pos.x, y = pos.y, z = pos.z, stackpos = 0}).itemid == 0 then return false end
	if checkCreatures and getTopCreature(pos).uid > 0 then return false end
	if checkPZ and getTilePzInfo(pos) then return false end
	for i = 0, 255 do
		pos.stackpos = i
		local tile = getTileThingByPos(pos)
		if tile.itemid ~= 0 and not isCreature(tile.uid) then
			if hasProperty(tile.uid, CONST_PROP_BLOCKPROJECTILE) or hasProperty(tile.uid, CONST_PROP_IMMOVABLEBLOCKSOLID) or (hasProperty(tile.uid, CONST_PROP_BLOCKPATHFIND) and not((not checkFields and getTileItemByType(pos, ITEM_TYPE_MAGICFIELD).itemid > 0) or hasProperty(tile.uid, CONST_PROP_HASHEIGHT) or hasProperty(tile.uid, CONST_PROP_FLOORCHANGEDOWN) or hasProperty(tile.uid, CONST_PROP_FLOORCHANGEUP))) then
				return false
			elseif checkStairs then
				if hasProperty(tile.uid, CONST_PROP_FLOORCHANGEDOWN) or hasProperty(tile.uid, CONST_PROP_FLOORCHANGEUP) then
					return false
				end
			end
		else
			break
		end
	end
	return true
end

function Split(s, delimiter)		-- suck func, use carefully
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function getPlayerNameById(id)
	local resultName = db.storeQuery("SELECT `name` FROM `players` WHERE `id` = " .. db.escapeString(id))
	if resultName ~= false then
		local name = result.getDataString(resultName, "name")
		result.free(resultName)
		return name
	end
	return 0
end

function getPlayerIdByName(name)
	local resultID = db.storeQuery("SELECT `id` FROM `players` WHERE `name` = " .. db.escapeString(name))
	if resultID ~= false then
		local id = result.getDataString(resultID, "id")
		result.free(resultID)
		return id
	end
	return 0
end

function getPlayerID(cid)
	return getPlayerIdByName(getPlayerName(cid))
end

function getAccountPoints(cid)
	local ret = 0
	local res = db.getResult('select `premium_points` from accounts where name = \''..getPlayerAccount(cid)..'\'')
	if(res:getID() == -1) then
		return false
	else
		ret = res:getDataInt("premium_points")
		res:free()
	end
	return tonumber(ret)
end

function doAccountAddPoints(cid, count)
	return db.query("UPDATE `accounts` SET `premium_points` = '".. getAccountPoints(cid) + count .."' WHERE `name` ='"..getPlayerAccount(cid).."'")
end

function doAccountRemovePoints(cid, count)
	return db.query("UPDATE `accounts` SET `premium_points` = '".. getAccountPoints(cid) - count .."' WHERE `name` ='"..getPlayerAccount(cid).."'")
end

function getItemPeriod(uid)
	local period = doItemGetPeriod(uid)
	if period > 0 then	
		 period = doItemGetPeriod(uid) - os.time()
	end
	return period
end

function getItemsInContainerById(container, itemid) -- Function By Kydrai
    local items = {}
    if isContainer(container) and getContainerSize(container) > 0 then
        for slot=0, (getContainerSize(container)-1) do
            local item = getContainerItem(container, slot)
            if isContainer(item.uid) then
                local itemsbag = getItemsInContainerById(item.uid, itemid)
                for i=0, #itemsbag do
                    table.insert(items, itemsbag[i])
                end
            else
                if itemid == item.itemid then
                    table.insert(items, item.uid)
                end
            end
        end
    end
    return items
end

--Do not use this script below to check VPS without knowing how to use server line or threads
----------------------------------------------------
local blockeByConfig = getConfigValue('blockedVps') --{"google","amazon","amazon.com","oracle","vultr","azure","google.com"}
local blockeds = {}
for element in blockeByConfig:gmatch("([^;]+)") do
    table.insert(blockeds, element)
end
-----------------------------------------------------
function isInVPS(cid)
    local http = require("socket.http")
    local json = require("json")
    local ipAddress = doConvertIntegerToIp(getPlayerIp(cid))
    local requestUrl = "http://ipinfo.io/" .. ipAddress .. "/json"
    local response, err = http.request(requestUrl)
    local jsonResponse = json.decode(response)
    local org = jsonResponse.org or "Desconhecido"
        --print("Provedor de internet: " .. org)
		--print("ip: ".. ipAddress)
	local s = string.explode(org, " ")
	for i = 1, #s do
		if isInArray(blockeds, string.lower(s[i])) then
			return true
		end
	end
    return false
end

function upgradeGuildLevel(cid, guildId)
	local func = db.query or db.executeQuery
	if guildId and guildId ~= 0 then
		local level = 0
		local result = db.getResult('SELECT `guild_level` FROM `guilds` WHERE `id` = '..guildId)
		if result:getID() ~= -1 then
			level = tonumber(result:getDataInt("guild_level"))
			result:free()
		end
		if level < 10 then
			func("UPDATE `guilds` set `guild_level` = guild_level + 1 WHERE `id` = "..guildId)
			doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Parabéns!! sua guild subiu de level\n[Level atual]: "..(level+1))
			return true
		else
			doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Sua Guild ja está no level máximo.")
			return false
		end
	else
		doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Você não possui guild!")
		return false
	end
	
	return false
end

function getExclusiveCoins(cid)
	local ret = 0
	local res = db.getResult('select `exclusive_coin` from accounts where name = \''..getPlayerAccount(cid)..'\'')
	if(res:getID() == -1) then
		return false
	else
		ret = res:getDataInt("exclusive_coin")
		res:free()
	end
	return tonumber(ret)
end

function setExclusiveCoins(cid, count)
	return db.query("UPDATE `accounts` SET `exclusive_coin` = '".. getExclusiveCoins(cid) + count .."' WHERE `name` ='"..getPlayerAccount(cid).."'")
end

function removeExclusivePoints(cid, count)
	return db.query("UPDATE `accounts` SET `exclusive_coin` = '".. getExclusiveCoins(cid) - count .."' WHERE `name` ='"..getPlayerAccount(cid).."'")
end

function giveRewardTable(cid, tableReward, parcelitem)
	if type(tableReward) ~= "table" then
		doPlayerSendTextMessage(cid, MESSAGE_FIRST, "Please contact administrador with message '/check giveRewardTable(cid, tableReward) reward not is a table/' ")
		return "notTable"
	end
	if #tableReward < 1 then
		return true
	end
	if not parcelitem then parcelitem = ITEM_PARCEL end
	local parcel = doCreateItemEx(parcelitem)
	for i=1, #tableReward do
		if not isItemStackable(tableReward[i][1]) then	-- CASO //NÃO// SEJA STACKAVEL
			if tableReward[i][2] > 1 then		-- não stackavel mas é pra add mais que 1
				for j=1, tableReward[i][2] do		-- For só pra add varios items não stackaveis
					local itemCreated = doCreateItemEx(tableReward[i][1], 1)
					doAddContainerItemEx(parcel, itemCreated)
				end
			else
				local itemCreated = doCreateItemEx(tableReward[i][1], 1)
					doAddContainerItemEx(parcel, itemCreated)
			end
		else			-- CASO O ITEM SEJA STACKAVEL
			local itemCreated = 0
			if tableReward[i][2] > 100 then
				local flagCem = tableReward[i][2]
				while flagCem > 0 do
					itemCreated = doCreateItemEx(tableReward[i][1], flagCem >= 100 and 100 or flagCem)
					doAddContainerItemEx(parcel, itemCreated)
					flagCem = flagCem - 100
				end
			else
				itemCreated = doCreateItemEx(tableReward[i][1], tableReward[i][2])
				doAddContainerItemEx(parcel, itemCreated)
			end
		end
	end

	return doPlayerAddItemEx(cid, parcel, true) == RETURNVALUE_NOERROR
end

function getPlayerWeaponHand(cid)
	if isCreature(cid) and isPlayer(cid) then
		local esquerda = getPlayerSlotItem(cid, CONST_SLOT_LEFT)
		if esquerda and esquerda.uid ~= 0 and isWeapon(esquerda.uid) and not isShield(esquerda.uid) then
			return esquerda
		else
			local direita = getPlayerSlotItem(cid, CONST_SLOT_RIGHT)
			if direita and direita.uid ~=0 and isWeapon(direita.uid) and not isShield(direita.uid) then
				return direita
			end
		end
	end
	return nil
end