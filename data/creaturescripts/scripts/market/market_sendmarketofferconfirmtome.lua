-- Criado por Thalles Vitor --
-- Market send offers to me confirm --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 216 then
		local param = buffer:explode("@")
		local type = tostring(param[1])
		local transaction_id = tonumber(param[2])

		sendMarketConfirmOfferToMe(cid, transaction_id) -- source function
	end
	return true
end