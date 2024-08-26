function onMarketInsert(cid, item)
    local function getItemValue(item, attribute)
        local itemInfo = getItemInfo(item.itemid)
        return itemInfo[attribute] or 0
    end

    local function getCategoryAndVar(isWeapon)
        local var2 = isWeapon and "weapons" or "armors"
        local var = 0
        return var, var2
    end

    local isWeapon = getItemValue(item, "attack") > 0 or getItemValue(item, "defense") > 0
    local isArmor = getItemValue(item, "armor") > 0

    local itemid = getItemValue(item, "clientId")
    local name = getItemValue(item, "name")
    local var, var2

    if isWeapon then
        var, var2 = getCategoryAndVar(true)
    elseif isArmor then
        var, var2 = getCategoryAndVar(false)
    else
        var, var2 = 0, "others"
    end

    local random = math.random(1, 10000 * 2 + 150)

    doSendPlayerExtendedOpcode(cid, 188, itemid .. "@" .. name .. "@" .. var .. "@" .. var .. "@" .. var2 .. "@" .. item.type .. "@" .. random .. "@")
    doItemSetAttribute(item.uid, "itemSELECTED", random)

    return true
end