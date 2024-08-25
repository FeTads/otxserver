-- Criado por Thalles Vitor --
-- Market send all items offers to client again --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 218 then
		local param = buffer:explode("@")
		local value = tostring(param[1])

		doSendPlayerExtendedOpcode(cid, 214, "destroy2".."@")
		sendMarketChangeOption(cid, value)
	end
	return true
end