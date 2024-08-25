-- Criado por Thalles Vitor --
-- Market send offers for you to client --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 214 then
		local param = buffer:explode("@")
		local type = tostring(param[1])

		doSendPlayerExtendedOpcode(cid, 214, "destroy5".."@")
		sendMarketViewOffersToYou(cid) -- source function
	end
	return true
end