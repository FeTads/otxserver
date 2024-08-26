-- Criado por Thalles Vitor --
-- Market send offers confirm --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 142 then
		local param = buffer:explode("@")
		local type = tostring(param[1])
		local transaction_id = tonumber(param[2])

		doSendPlayerExtendedOpcode(cid, 114, "destroy4".."@")
		sendMarketCancelYourOfferBackBuyer(cid, transaction_id) -- source function
	end
	return true
end