-- Criado por Thalles Vitor --
-- Market send the offerted item --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 210 then
		local param = buffer:explode("@")
		local type = tostring(param[1])
		local index = tonumber(param[2])
		local transaction_id = tonumber(param[3])
		
		if type == "executeDrop" then
			sendMarketMakeOfferRemoveItem(cid, index, transaction_id) -- source function
		end
	end
	return true
end