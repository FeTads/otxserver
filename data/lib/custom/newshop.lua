GameShop = {
    opcode = 40,
    depot = 1,

    category = {
        {name = "Promocao", description = "Todos os Nossos pack's exclusivos por um valor qque cabe no seu bolso"},
        {name = "Vocation", description = "Aqui pode comprar seus dias Vip."},
        {name = "Item", description = "Aqui fica todos os itens vendidos."}
		--{name = "", description = ""}
    },

    Zshop = {
		 [1] = {
            itemId = 15110,
            name = "Dragontide Helmet",
            points = 15,
            description = "Mana/Vida +20000/.",
            category = "Item",
        },
		 [2] = {
            itemId = 15111,
            name = "Dragontide Armor",
            points = 15,
            description = "Mana/Vida +20000/.",
            category = "Item",
        },
		 [3] = {
            itemId = 15112,
            name = "Dragontide Legs",
            points = 15,
            description = "Mana/Vida +20000/.",
            category = "Item",
        },
		 [4] = {
            itemId = 15113,
            name = "Dragontide Boots",
            points = 15,
            description = "Mana/Vida +20000/.",
            category = "Item",
        },
		 [5] = {
            itemId = 15114,
            name = "Black Shen Sword",
            points = 15,
            description = "Attack +100.",
            category = "Item",
        },
		 [6] = {
            itemId = 15117,
            name = "Dragontide Amulet",
            points = 15,
            description = "Protect All 1%.",
            category = "Item",
        },
		 [7] = {
            itemId = 15116,
            name = "Dragontide Ring",
            points = 15,
            description = "Protect All 1%.",
            category = "Item",
        },
		 [8] = {
            itemId = 15115,
            name = "Dragontide Shield",
            points = 15,
            description = "Protect All 1%.",
            category = "Item",
        },
		 [9] = {
            itemId = 15063,
            name = "PACC 7 Dias",
            points = 5,
            description = "Se torne Premium Account por 7 Dias",
            category = "Item",
        },
		 [10] = {
            itemId = 15064,
            name = "PACC 7 Dias",
            points = 20,
            description = "Se torne Premium Account por 30 Dias",
            category = "Item",
        },
		 [11] = {
            itemId = 15065,
            name = "PACC 90 Dias",
            points = 50,
            description = "Se torne Premium Account por 90 Dias",
            category = "Item",
        },
		 [12] = {
            itemId = 15080,
            name = "Key Gacha",
            points = 3,
            description = "Usado para o Gacha",
            category = "Item",
        },
		
		 [13] = {
            itemId = 15131,
            name = "Gas",
            points = 15,
            category = "Vocation",
        },
		 [14] = {
            itemId = 15128,
            name = "Granola",
            points = 15,
            category = "Vocation",
        },
		 [15] = {
            itemId = 15123,
            name = "Fuu",
            points = 15,
            category = "Vocation",
        },
		 [16] = {
            itemId = 15125,
            name = "Gogeta",
            points = 15,
            category = "Vocation",
        },
		
    },

}


function GameShop:sendInfo(cid)
    local shopData = {}

    for index, data in ipairs(self.Zshop) do
        local offerInfo = {
            itemId = getItemInfo(data.itemId).clientId,
            name = data.name,
            points = data.points,
            description = data.description,
            category = data.category,
            index = index,
        }

        table.insert(shopData, offerInfo)
    end

    doSendPlayerExtendedJSONOpcode(cid, self.opcode, json.encode({type = "openShop", category = self.category, shopData = shopData, premiumPoints = getAccountPoints(cid)}))
end

function GameShop:reloadShop(cid)
    doSendPlayerExtendedJSONOpcode(cid, self.opcode, json.encode({type = "reloadShop", premiumPoints = getAccountPoints(cid)}))
end

function GameShop:buying(cid, index, count)
    if type(count) ~= "number" then
        return doPlayerPopupFYI(cid, "Error - type number")
    end

    if count <= 0 then
        return doPlayerPopupFYI(cid, "Error")
    end

    local zShop = self.Zshop[index]
    if not zShop then
        return doPlayerPopupFYI(cid, "Error - table.")
    end

    local premiumPoints = (count * zShop.points)
    local playerPoints = getAccountPoints(cid)
    if playerPoints < premiumPoints then
        return doPlayerPopupFYI(cid, "Voce nao possui a quantidade necessaria de Premium Points. Para efetuar esta compra, voce precisa de mais " .. (premiumPoints - playerPoints) .. " Premium Points.")
    end

    if self:addItem(cid, zShop.itemId, count) then
        doAccountRemovePoints(cid, premiumPoints)
        doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, "Parabens! Voce realizou uma compra de " .. count .. " " .. zShop.name .. ". Foram retirados " .. premiumPoints .. " Premium Points da sua conta.")
    end

    self:reloadShop(cid)
end

function GameShop:addItem(cid, itemId, count)
    local mainBackpack = getPlayerSlotItem(cid, 3)
    local freeSlot = getContainerCap(mainBackpack.uid) - (getContainerSize(mainBackpack.uid))
    local stackable = isItemStackable(itemId)
    local playerCap = getPlayerFreeCap(cid)
    local itemCap = (getItemInfo(itemId).weight * count)

    if stackable and freeSlot >= 1 and playerCap >= itemCap then
        doPlayerAddItem(cid, itemId, count)
    elseif not stackable and freeSlot >= count and playerCap >= itemCap then
        for i = 1, count do
            doPlayerAddItem(cid, itemId, 1)
        end
    else
        local mail = doCreateItemEx(2595)
        if mail then
            if stackable then
                doAddContainerItem(mail, itemId, count)
            else
                for i = 1, count do
                    doAddContainerItem(mail, itemId, 1)
                end
            end

            doPlayerSendMailByName(getCreatureName(cid), mail, self.depot)
            doPlayerSendTextMessage(cid, MESSAGE_EVENT_ORANGE, "Devido a falta de espaco em sua mochila ou capacidade de seu personagem, seus itens foram transferidos para o depot.")
        else
            return false
        end
    end

    return true
end

function GameShop:transfer(cid, name, transfer)

    local player = getPlayerByNameWildcard(name)  

    if(not player or (isPlayerGhost(player) and getPlayerGhostAccess(player) > getPlayerGhostAccess(cid))) then   
        doPlayerPopupFYI(cid, "O jogador nao existe ou esta offline.")  
        return false
    end

    if transfer == nil or type(transfer) ~= "number" or transfer <= 0 then
        doPlayerPopupFYI(cid, "Error - transfer points.")
        return false 
    end

    if getAccountPoints(cid) < transfer then
        doPlayerPopupFYI(cid, "Voce nao possui essa quantidade de premium points.")
        return false
    end

    local transferName = getPlayerName(cid)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_ORANGE, "Voce transferiu " .. transfer .. " premium points para o jogador " .. name .. ".")
    doPlayerSendTextMessage(player, MESSAGE_STATUS_CONSOLE_ORANGE, "Voce recebeu " .. transfer .. " premium points de " .. transferName .. ".")  
    doAccountRemovePoints(cid, transfer)
    doAccountAddPoints(player, transfer)
    self:reloadShop(player)
    self:reloadShop(cid)
    return true
end