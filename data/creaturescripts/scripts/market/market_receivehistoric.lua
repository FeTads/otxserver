-- Criado por Thalles Vitor --
-- Market receive buyed items from the market --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 107 then
		doSendPlayerExtendedOpcode(cid, 114, "destroy3".."@")
		sendMarketMyHistoric(cid) -- source function
	end
	return true
end