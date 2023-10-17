-- lib and functions by Vitor Bertolucci (Killua)

function warnPlayersWithStorage(storage, value, class, message) -- By Killua
    if not value then value = 1 end
	if not class then class = MESSAGE_SATUS_CONSOLE_WARNING end
	if not storage or not message then return end
    if #getPlayersOnline() == 0 then
        return
    end
    for _, pid in pairs(getPlayersOnline()) do
        if getPlayerStorageValue(pid, storage) == value then
            doPlayerSendTextMessage(pid, class, message)
		end
	if getPlayerAccess(pid) >= 4 then	
		doPlayerSendTextMessage(pid, class, "Message to those with storage "..storage..message) -- Gms will always receive the messages
	end
    end
end

function getPlayerStorageZero(cid, storage) -- By Killua
    local sto = getPlayerStorageValue(cid, storage)
    return sto > 0 and sto or 0
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


function getStorageZero(storage) -- By Killua
    local sto = getGlobalStorageValue(storage)
    return sto > 0 and sto or 0
end

function countTable(table) -- By Killua
    local y = 0
    if type(table) == "table" then
        for _ in pairs(table) do
            y = y + 1
        end
        return y
    end
    return false
end

function getPlayersInArea(frompos, topos) -- By Killua
    local players_ = {}
    local count = 1
    for _, pid in pairs(getPlayersOnline()) do
        if isInArea(getCreaturePosition(pid), frompos, topos) then
            players_[count] = pid
            count = count + 1
        end
    end
    return countTable(players_) > 0 and players_ or false
end

function getMonstersInArea(pos1,pos2)
    local monsters = {}
    if pos1.x and pos1.y and pos2.x and pos2.y and pos1.z == pos2.z then
        for a = pos1.x, pos2.x do
            for b = pos1.y,pos2.y do
                local pos = {x=a,y=b,z=pos1.z}
                if isMonster(getTopCreature(pos).uid) and not isSummon(getTopCreature(pos).uid) then
                    table.insert(monsters,getTopCreature(pos).uid)
                end
            end
        end
        return monsters
    else
        return false
    end
end

function getContainerItemsInfo(containerUid) -- By Killua
    local table = {}
    if containerUid and containerUid > 0 then
        local a = 0   
        for i = 0, getContainerSize(containerUid) - 1 do
            local item = getContainerItem(containerUid,i)
            a = a + 1
            table[a] = {uid = item.uid, itemid = item.itemid, quant = item.type}
        end
        return table
    end
    return false
end

function getTableEqualValues(table) -- By Killua
    local ck = {}
    local eq = {}
    if type(table) == "table" then
      	if countTable(table) and countTable(table) > 0 then
           	for i = 1, countTable(table) do
             	if not isInArray(ck, table[i]) then
                    ck[i] = table[i]
                else
                    eq[i] = table[i]
                end
            end
            return countTable(eq) > 0 and eq or 0
        end
    end
    return false
end

function killuaGetItemLevel(uid) -- By Killua
	local name = getItemName(uid)
	local pos = 0
	for i = 1, #name do
		if string.byte(name:sub(i,i)) == string.byte('+') then
			pos = i + 1
			break
		end
	end
	return tonumber(name:sub(pos,pos))
end

k_table_storage_lib = {
	filtrateString = function(str) -- By Killua
		local tb, x, old, last = {}, 0, 0, 0
		local first, second, final = 0, 0, 0
		if type(str) ~= "string" then
			return tb
		end
		for i = 2, #str-1 do
			if string.byte(str:sub(i,i)) == string.byte(':') then
				x, second, last = x+1, i-1, i+2
				for t = last,#str-1 do
					if string.byte(str:sub(t,t)) == string.byte(',') then
						first = x == 1 and 2 or old
						old, final = t+2, t-1
						local index, var = str:sub(first,second), str:sub(last,final)
						tb[tonumber(index) or tostring(index)] = tonumber(var) or tostring(var)
						break
					end
				end
			end
		end
		return tb
	end,

	translateIntoString = function(tb) -- By Killua
		local str = ""
		if type(tb) ~= "table" then
			return str
		end
		for i, t in pairs(tb) do
			str = str..i..": "..t..", "
		end
		str = "a"..str.."a"
		return tostring(str)
	end
}

function setPlayerTableStorage(cid, key, value) -- By Killua
	return doPlayerSetStorageValue(cid, key, k_table_storage_lib.translateIntoString(value))
end

function getPlayerTableStorage(cid, key) -- By Killua
	return k_table_storage_lib.filtrateString(getPlayerStorageValue(cid, key))
end

function setGlobalTableStorage(key, value) -- By Killua
	return setGlobalStorageValue(key, k_table_storage_lib.translateIntoString(value))
end

function getGlobalTableStorage(key) -- By Killua
	return k_table_storage_lib.filtrateString(getGlobalStorageValue(key))
end

function printTableKillua(table, includeIndices,prnt) -- By Killua
    if includeIndices == nil then includeIndices = true end
    if prnt == nil then prnt = true end
    if type(table) ~= "table" then
        error("Argument must be a table")
        return
    end
    local str, c = "{", ""
    for v, b in pairs(table) do
        if type(b) == "table" then
            str = includeIndices and str..c.."["..v.."]".." = "..printTable(b,true,false) or str..c..printTable(b,false,false)
        else
            str = includeIndices and str..c.."["..v.."]".." = "..b or str..c..b
        end
        c = ", "
    end
    str = str.."}"
    if prnt then print(str) end
    return str
 end
 
function checkString(str) -- By Killua
	local check = true
	for i = 1, #str do
		local letra = string.byte(str:sub(i,i))
		if letra >= string.byte('a') and letra <= string.byte('z') or letra >= string.byte('A') and letra <= string.byte('Z') or letra >= string.byte('0') and letra <= string.byte('9') then
			check = true
		else
			check = false
			break
		end
	end
	return check
end

function isArmor(itemid) -- By Killua
	return getItemInfo(itemid).armor > 0
end

function isWeapon(uid) -- By Killua
	return getItemWeaponType(uid) ~= 0
end

function isShield(uid) -- By Killua
	return getItemWeaponType(uid) == 5
end

function isSword(uid) -- By Killua
	return getItemWeaponType(uid) == 1
end

function isClub(uid) -- By Killua
	return getItemWeaponType(uid) == 2
end

function isAxe(uid) -- By Killua
	return getItemWeaponType(uid) == 3
end

function isBow(uid) -- By Killua
	return getItemWeaponType(uid) == 4
end

function isWand(uid) -- By Killua
	return getItemWeaponType(uid) == 7
end
