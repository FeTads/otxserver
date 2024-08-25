-- Criado por Thalles Vitor --
-- Market send offers confirm --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 209 then
		local param = buffer:explode("@")
		local transaction_id = tonumber(param[1])
		local item_seller = tostring(param[2])
		local index = tonumber(param[3])

		sendMarketMakeOfferConfirm(cid, transaction_id, item_seller, index) -- source function
	end
	return true
end