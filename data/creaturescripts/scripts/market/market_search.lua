-- Criado por Thalles Vitor --
-- Market send items to category seller --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 234 then
		local param = buffer:explode("@")
		local text = tostring(param[1])
		local category = tostring(param[2])

		doSendPlayerExtendedOpcode(cid, 214, "destroy".."@")
		doSendPlayerExtendedOpcode(cid, 214, "destroy2".."@")
		sendMarketSearch(cid, text, category) -- source function
	end
	return true
end