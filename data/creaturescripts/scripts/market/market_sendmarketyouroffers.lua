-- Criado por Thalles Vitor --
-- Market send your offers to client --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 211 then
		local param = buffer:explode("@")
		local type = tostring(param[1])

		doSendPlayerExtendedOpcode(cid, 214, "destroy4".."@")
		sendMarketViewYourOffers(cid) -- source function
	end
	return true
end