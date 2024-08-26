-- Criado por Thalles Vitor --
-- Market send items to category seller --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 134 then
		local param = buffer:explode("@")
		local text = tostring(param[1])
		local category = tostring(param[2])

		doSendPlayerExtendedOpcode(cid, 114, "destroy".."@")
		doSendPlayerExtendedOpcode(cid, 114, "destroy2".."@")
		sendMarketSearch(cid, text, category) -- source function
	end
	return true
end