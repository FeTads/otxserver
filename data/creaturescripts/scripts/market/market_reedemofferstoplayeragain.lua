-- Criado por Thalles Vitor --
-- Reedem itens offers to player again --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 119 then
		local param = buffer:explode("@")
		local type = tostring(param[1])

		sendMarketReedemMyItemsOffer(cid) -- source function
	end
	return true
end