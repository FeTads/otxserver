function getPlayerFreeSlots(cid)
    local slots = 0
    local containers = {}
    for s = 3, 10 do
        local item = getPlayerSlotItem(cid, s)
        if item.itemid > 0 then
            if isContainer(item.uid) then
                table.insert(containers, item.uid)
            end
        else
            if s == 5 or s == 6 or s == 10 then
                slots = slots + 1
            end
        end
    end
    while #containers > 0 do
        for i = (getContainerSize(containers[1]) - 1), 0, -1 do
            local it = getContainerItem(containers[1], i)
            if isContainer(it.uid) then
                table.insert(containers, it.uid)
            end
        end
        slots = slots + (getContainerCap(containers[1]) - getContainerSize(containers[1]))
        table.remove(containers, 1)
    end
    return slots
end

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 105 then
		if getPlayerFreeCap(cid) < getItemWeightById(2160, 1) then
			doPlayerPopupFYI(cid, "Você não tem espaço suficiente para cancelar uma oferta no market.")
			return false
		end
		if getPlayerFreeSlots(cid) < getItemWeightById(2160, 1) then
			doPlayerPopupFYI(cid, "Você precisa de espaço na sua backpack para cancelar uma oferta no market.")
			return false
		end
		local param = buffer:explode("@")
		local numeration = tonumber(param[1])
		sendMarketCancelOffer(cid, numeration)
		local pesquisar = db.getResult("SELECT `remover`, `item_name`, `item_id`, `amount` FROM `players_mymarketoffers` WHERE `remover` = " .. getPlayerGUID(cid) .. ";")

		if pesquisar then
			local puxarRemoveVenda = pesquisar:getDataInt("remover")
			local puxarItem_id = pesquisar:getDataInt("item_id")
			local puxarAmount = pesquisar:getDataInt("amount")
			local item_name = pesquisar:getDataString("item_name")

			if puxarRemoveVenda == getPlayerGUID(cid) then
				local magiclevel, skillfist

				-- Verifique se a string contém [R], [N] ou [L]
				if string.find(item_name, "%[R%]") then
					-- [R] = 2
					magiclevel, skillfist = 2, 2
				elseif string.find(item_name, "%[N%]") then
					-- [N] = 1
					magiclevel, skillfist = 1, 1
				elseif string.find(item_name, "%[L%]") then
					-- [L] = 3
					magiclevel, skillfist = 3, 3
				else
					-- Se não contiver [R], [N] ou [L], defina como 0
					magiclevel, skillfist = 0, 0
				end

				if magiclevel > 0 then
					local item = doCreateItemEx(puxarItem_id)
					doItemSetAttribute(item, "name", item_name)
					doItemSetAttribute(item, "magiclevel", magiclevel)
					doItemSetAttribute(item, "skillfist", skillfist)
					doPlayerAddItemEx(cid, item, puxarAmount, false)
				else
					doPlayerAddItem(cid, puxarItem_id, puxarAmount)
				end
			end

			pesquisar:free()
			doPlayerPopupFYI(cid, "Você removeu o item do market.")
			if isCreature(cid) then
				db.executeQuery("DELETE FROM `players_mymarketoffers` WHERE `remover` = "..getPlayerGUID(cid))
			end
		end
		sendMarketMyOffers(cid)
 		sendMarketAllOffers(cid)
		doSendPlayerExtendedOpcode(cid, 114, "destroy".."@")
		doSendPlayerExtendedOpcode(cid, 114, "destroy2".."@")
		doPlayerSave(cid)
		end
	return true
end