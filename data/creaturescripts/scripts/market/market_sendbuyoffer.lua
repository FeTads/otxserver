-- Criado por Thalles Vitor --
-- Market buy item from category: all offers --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 106 then
		local param = buffer:explode("@")
		local price = tonumber(param[1])
		local transaction_id = tonumber(param[2])
		local countSelectedScrollBar = tonumber(param[3])
		local pesquisar = db.storeQuery("SELECT `item_time` FROM `players_mymarketoffers` WHERE `transaction_id` = " .. transaction_id .. ";")
		local puxarTiming = result.getDataInt(pesquisar, "item_time")
		
		if puxarTiming - os.time() >= 1 then
		sendMarketBuyOffer(cid, price, transaction_id, countSelectedScrollBar) -- source function
		sendMarketMyHistoric(cid) -- source function
		doSendPlayerExtendedOpcode(cid, 114, "destroy3".."@")
		else
		doPlayerPopupFYI(cid, "O tempo de oferta desse item expirou.")
		end
	end
	return true
end