

function onLogin(cid)
	registerCreatureEvent(cid, "CraftOpcode_extendedopcode")
	return true
end

function onExtendedOpcode(cid, opcode, buffer)
	local opcodes = CraftSystem.opcodes.receive
	if (opcode == opcodes.openCraftWindow) then
		CraftSystem:sendCategoryAndMoneyInfo(cid)
		CraftSystem:sendCategoryData(cid, "Todos")
	elseif (opcode == opcodes.requestIngredients) then
		CraftSystem:sendDestroyInfo(cid, "item")
		local data = buffer:explode("@")
		local category = data[1]
		local itemID = tonumber(data[2])
		if (category and itemID) then
			CraftSystem:sendIngredientsData(cid, category, itemID)
		end
	elseif (opcode == opcodes.selectCategory) then
		CraftSystem:sendDestroyInfo(cid, "itemcraft")
		local data = buffer:explode("@")
		local category = data[1]
		if (category) then
			CraftSystem:sendCategoryData(cid, category)
		end
	elseif (opcode == opcodes.searchItem) then
		CraftSystem:sendDestroyInfo(cid, "itemcraft")
		local data = buffer:explode("@")
		local category = data[1]
		local searchText = data[2]
		if (category and searchText and #searchText <= 50) then
			CraftSystem:sendCategoryData(cid, category, searchText)
		end
	elseif (opcode == opcodes.craft) then
		local data = buffer:explode("@")
		local category = data[1]
		local itemID = tonumber(data[3])
		local count = tonumber(data[4])
		if (itemID and count and count > 0) then
			CraftSystem:craft(cid, itemID, count, category)
		end
	end
	
	if opcode == 33 then
		local protocol = json.decode(buffer)

		-- Task System 
		if protocol.type == "openTask" then
			GameTaskSystem:sendInfo(cid)
		elseif protocol.type == "startTask" then
			GameTaskSystem:start(cid, protocol.taskIndex)
		elseif protocol.type == "taskReward" then
			GameTaskSystem:getReward(cid, protocol.taskIndex)
		elseif protocol.type == "cancelTask" then
			GameTaskSystem:cancel(cid, protocol.taskIndex)
			
		-- shop system
		elseif protocol.type == "openShop" then
			GameShop:sendInfo(cid)
		elseif protocol.type == "buyItemShop" then
			GameShop:buying(cid, protocol.index, protocol.count)
		elseif protocol.type == "transferCoins" then
			GameShop:transfer(cid, protocol.name, protocol.count)
			
	end
	
	return true

end