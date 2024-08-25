-- Criado por Thalles Vitor --
-- Reedem itens offers to player again --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 219 then
		local param = buffer:explode("@")
		local type = tostring(param[1])

		sendMarketReedemMyItemsOffer(cid) -- source function
	end
	return true
end