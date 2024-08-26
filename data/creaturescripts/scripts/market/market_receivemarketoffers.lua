-- Criado por Thalles Vitor --
-- Market receive buyed items from the market --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 112 then
		local param = buffer:explode("@")
		local type = tostring(param[1])
		local transaction_id = tonumber(param[2])

		sendMarketViewAllSlotsOffers(cid, transaction_id) -- source function
	end
	return true
end