-- Criado por Thalles Vitor --
-- Market insert item in client --




function onMarketInsert(cid, item)

	local function isWeapon(item)
        if getItemInfo(item.itemid).attack and getItemInfo(item.itemid).attack > 0 then
            return true
        end
    
        if getItemInfo(item.itemid).defense and getItemInfo(item.itemid).defense > 0 then
            return true
        end
    
        return false
    end
    
    local function isArmor(item)
        if getItemInfo(item.itemid).armor and getItemInfo(item.itemid).armor > 0 then
            return true
        end
        return false
    end

	local senzus = {7589, 7588, 13556, 7618, 7620}
	local material = {20494, 20496, 20495}
	local quests = {}
	local item_points = {7845}	


	if getItemAttribute(item.uid, "10002") then
		local pokemon_itemid = getItemInfo(item.itemid).clientId
		local pokemon_name = getItemAttribute(item.uid, "10002")
		local pokemon_gender = getItemAttribute(item.uid, "10016") or 0
		local pokemon_level = getItemAttribute(item.uid, "10005") or 1
		local pokemon = "isPokemon"
		local random = math.random(1, 10000 * 2 + 150)

		doSendPlayerExtendedOpcode(cid, 211, pokemon_itemid.."@"..pokemon_name.."@"..pokemon_gender.."@"
		..pokemon_level.."@"..pokemon.."@"..item.type.."@"..random.."@")
		doItemSetAttribute(item.uid, "itemSELECTED", random)
	else
		local itemid = getItemInfo(item.itemid).clientId
		local name = getItemInfo(item.itemid).name
		local var = 0
		local var2 = "notPokemon"
		local random = math.random(1, 10000 * 2 + 150)

		doSendPlayerExtendedOpcode(cid, 211, itemid.."@"..name.."@"..var.."@"..var.."@"..var2.."@"..item.type.."@"..random.."@")
		doItemSetAttribute(item.uid, "itemSELECTED", random)
	end

	if isWeapon(item) then
		local itemid = getItemInfo(item.itemid).clientId
		local name = getItemInfo(item.itemid).name
		local var = 0
		local var2 = "weapons"
		local random = math.random(1, 10000 * 2 + 150)

		doSendPlayerExtendedOpcode(cid, 211, itemid.."@"..name.."@"..var.."@"..var.."@"..var2.."@"..item.type.."@"..random.."@")
		doItemSetAttribute(item.uid, "itemSELECTED", random)

	end
	if isArmor(item) then
			local itemid = getItemInfo(item.itemid).clientId
			local name = getItemInfo(item.itemid).name
			local var = 0
			local var2 = "armors"
			local random = math.random(1, 10000 * 2 + 150)
	
			doSendPlayerExtendedOpcode(cid, 211, itemid.."@"..name.."@"..var.."@"..var.."@"..var2.."@"..item.type.."@"..random.."@")
			doItemSetAttribute(item.uid, "itemSELECTED", random)
	end
	if isInArray(item_points, item.itemid) then
				local itemid = getItemInfo(item.itemid).clientId
				local name = getItemInfo(item.itemid).name
				local var = 0 
				local var2 = "points"
				local random = math.random(1, 10000 * 2 + 150)
		
				doSendPlayerExtendedOpcode(cid, 211, itemid.."@"..name.."@"..var.."@"..var.."@"..var2.."@"..item.type.."@"..random.."@")
				doItemSetAttribute(item.uid, "itemSELECTED", random)
	end

	if isInArray(material, item.itemid) then
		local itemid = getItemInfo(item.itemid).clientId
		local name = getItemInfo(item.itemid).name
		local var = 0 
		local var2 = "material"
		local random = math.random(1, 10000 * 2 + 150)

		doSendPlayerExtendedOpcode(cid, 211, itemid.."@"..name.."@"..var.."@"..var.."@"..var2.."@"..item.type.."@"..random.."@")
		doItemSetAttribute(item.uid, "itemSELECTED", random)
	end
	if isInArray(quests, item.itemid) then
		local itemid = getItemInfo(item.itemid).clientId
		local name = getItemInfo(item.itemid).name
		local var = 0 
		local var2 = "quests"
		local random = math.random(1, 10000 * 2 + 150)

		doSendPlayerExtendedOpcode(cid, 211, itemid.."@"..name.."@"..var.."@"..var.."@"..var2.."@"..item.type.."@"..random.."@")
		doItemSetAttribute(item.uid, "itemSELECTED", random)
	end
	if isInArray(senzus, item.itemid) then
		local itemid = getItemInfo(item.itemid).clientId
		local name = getItemInfo(item.itemid).name
		local var = 0 
		local var2 = "senzu"
		local random = math.random(1, 10000 * 2 + 150)

		doSendPlayerExtendedOpcode(cid, 211, itemid.."@"..name.."@"..var.."@"..var.."@"..var2.."@"..item.type.."@"..random.."@")
		doItemSetAttribute(item.uid, "itemSELECTED", random)
	end


	return true
end