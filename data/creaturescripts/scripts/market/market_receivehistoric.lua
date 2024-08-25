-- Criado por Thalles Vitor --
-- Market receive buyed items from the market --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 207 then
		doSendPlayerExtendedOpcode(cid, 214, "destroy3".."@")
		sendMarketMyHistoric(cid) -- source function
	end
	return true
end