-- Criado por Thalles Vitor --
-- Market send items to category seller --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 104 then
		local param = buffer:explode("@")
		local type = tostring(param[1])
		if type == "receiveMyItems" then
			sendMarketMyOffers(cid) -- source function
		end
	end
	return true
end