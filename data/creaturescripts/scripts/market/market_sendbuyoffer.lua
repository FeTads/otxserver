-- Criado por Thalles Vitor --
-- Market buy item from category: all offers --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 206 then
		local param = buffer:explode("@")
		local price = tonumber(param[1])
		local transaction_id = tonumber(param[2])
		local countSelectedScrollBar = tonumber(param[3])

		sendMarketBuyOffer(cid, price, transaction_id, countSelectedScrollBar) -- source function
		doSendPlayerExtendedOpcode(cid, 214, "destroy3".."@")
		sendMarketMyHistoric(cid) -- source function
	end
	return true
end