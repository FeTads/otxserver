-- Criado por Thalles Vitor --
-- Market send all items offers to client again --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 117 then
		local param = buffer:explode("@")
		local type = tostring(param[1])

		doSendPlayerExtendedOpcode(cid, 114, "destroy".."@")
 		sendMarketAllOffers(cid) -- source function
	end
	return true
end