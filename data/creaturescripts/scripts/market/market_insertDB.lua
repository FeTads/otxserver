-- Criado por Thalles Vitor --
-- Market add item in database --

function onExtendedOpcode(cid, opcode, buffer)
	if opcode == 103 then
		local param = buffer:explode("@")
		local itemid = tonumber(param[1])
		local name = tostring(param[2])
		local gender = tonumber(param[3])
		local level = tonumber(param[4])
		local ispokemon = tostring(param[5])
		local count = tonumber(param[6])
		local price = tonumber(param[7])
		local integgerAttribute = tonumber(param[8])
		local onlyoffers = tonumber(param[9])

		sendMarketToDatabase(cid, itemid, name, gender, level, ispokemon, count, price, integgerAttribute, onlyoffers)
		doPlayerSave(cid)
	end
	return true
end