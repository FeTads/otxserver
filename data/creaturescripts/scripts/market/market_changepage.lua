-- Criado por Thalles Vitor --
-- Market send items to category seller --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 233 then
		local param = buffer:explode("@")
		local type = tostring(param[1])
		local category = tostring(param[2])
		local page = tonumber(param[3])

		doSendPlayerExtendedOpcode(cid, 214, "destroy".."@")
		doSendPlayerExtendedOpcode(cid, 214, "destroy2".."@")
		sendMarketChangePage(cid, type, category, tonumber(page)) -- source function
	end
	return true
end