-- Criado por Thalles Vitor --
-- Market send items to category seller --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 205 then
		local param = buffer:explode("@")
		local numeration = tonumber(param[1])

		doSendPlayerExtendedOpcode(cid, 214, "destroy".."@")
		doSendPlayerExtendedOpcode(cid, 214, "destroy2".."@")
		sendMarketCancelOffer(cid, numeration) -- source function
		sendMarketMyOffers(cid) -- source function
 		sendMarketAllOffers(cid) -- source function
	end
	return true
end