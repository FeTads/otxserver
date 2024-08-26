-- Criado por Thalles Vitor --
-- Market receiving item from client --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 102 then
		local param = buffer:explode("@")
		local index = tonumber(param[1])

		sendMarketItem(cid, index) -- source function
	end
	return true
end