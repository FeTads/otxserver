CraftSystem = {
	opcodes = {
		receive = {
			openCraftWindow = 36,
			selectCategory = 137,
			requestIngredients = 139,
			searchItem = 141,
			craft = 142,
		},
		send = {
			categoryAndMoneyInfo = 135,
			destroyInfo = 136,
			itemsCategory = 138,
			ingredientsData = 140,
		},
	},

	-- ordem das categorias
	categories_order = "Helmets;Amulet;Legs;Armas;Armors;Rings;Materiais;Bracelet;Boots;Shield;",

	items_to_craft = {
		{
			itemID = 15033, -- id do item para craftar -- Uchiha
			clientID = 13964, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Helmets", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15021, clientID = 13952, count = 1 }, -- ingrediente 1
				{ id = 15083, clientID = 14014, count = 1000 }, -- ingrediente 1
				{ id = 14375, clientID = 13306, count = 1000 }, -- ingrediente 1
				{ id = 14376, clientID = 13307, count = 1000 }, -- ingrediente 1
				{ id = 14371, clientID = 13302, count = 1000 }, -- ingrediente 1
				{ id = 14374, clientID = 13305, count = 1000 }, -- ingrediente 1
				-- etc...
			},
		},
		{
			itemID = 15034, -- id do item para craftar
			clientID = 13965, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Armors", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15022, clientID = 13953, count = 1 }, -- ingrediente 1
				{ id = 15083, clientID = 14014, count = 1000 }, -- ingrediente 1
				{ id = 14375, clientID = 13306, count = 1000 }, -- ingrediente 1
				{ id = 14376, clientID = 13307, count = 1000 }, -- ingrediente 1
				{ id = 14371, clientID = 13302, count = 1000 }, -- ingrediente 1
				{ id = 14374, clientID = 13305, count = 1000 }, -- ingrediente 1
				-- etc...
			},
		},
		{
			itemID = 15035, -- id do item para craftar
			clientID = 13966, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Legs", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15023, clientID = 13954, count = 1 }, -- ingrediente 1
				{ id = 15083, clientID = 14014, count = 1000 }, -- ingrediente 1
				{ id = 14375, clientID = 13306, count = 1000 }, -- ingrediente 1
				{ id = 14376, clientID = 13307, count = 1000 }, -- ingrediente 1
				{ id = 14371, clientID = 13302, count = 1000 }, -- ingrediente 1
				{ id = 14374, clientID = 13305, count = 1000 }, -- ingrediente 1
				-- etc...
			},
		},
		{
			itemID = 15036, -- id do item para craftar
			clientID = 13967, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Boots", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15024, clientID = 13955, count = 1 }, -- ingrediente 1
				{ id = 15083, clientID = 14014, count = 1000 }, -- ingrediente 1
				{ id = 14375, clientID = 13306, count = 1000 }, -- ingrediente 1
				{ id = 14376, clientID = 13307, count = 1000 }, -- ingrediente 1
				{ id = 14371, clientID = 13302, count = 1000 }, -- ingrediente 1
				{ id = 14374, clientID = 13305, count = 1000 }, -- ingrediente 1
				-- etc...
			},
		},
		
--======================================================== Red
			{
			itemID = 15037, -- id do item para craftar -- Uchiha
			clientID = 13968, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Helmets", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15033, clientID = 13964, count = 1 }, -- ingrediente 1
				{ id = 15083, clientID = 14014, count = 2000 }, -- ingrediente 1
				{ id = 14375, clientID = 13306, count = 2000 }, -- ingrediente 1
				{ id = 14376, clientID = 13307, count = 2000 }, -- ingrediente 1
				{ id = 14371, clientID = 13302, count = 2000 }, -- ingrediente 1
				{ id = 14374, clientID = 13305, count = 2000 }, -- ingrediente 1
				-- etc...
			},
		},
		{
			itemID = 15038, -- id do item para craftar
			clientID = 13969, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Armors", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15034, clientID = 13965, count = 1 }, -- ingrediente 1
				{ id = 15083, clientID = 14014, count = 2000 }, -- ingrediente 1
				{ id = 14375, clientID = 13306, count = 2000 }, -- ingrediente 1
				{ id = 14376, clientID = 13307, count = 2000 }, -- ingrediente 1
				{ id = 14371, clientID = 13302, count = 2000 }, -- ingrediente 1
				{ id = 14374, clientID = 13305, count = 2000 }, -- ingrediente 1
				-- etc...
			},
		},
		{
			itemID = 15039, -- id do item para craftar
			clientID = 13970, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Legs", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15035, clientID = 13966, count = 1 }, -- ingrediente 1
				{ id = 15083, clientID = 14014, count = 2000 }, -- ingrediente 1
				{ id = 14375, clientID = 13306, count = 2000 }, -- ingrediente 1
				{ id = 14376, clientID = 13307, count = 2000 }, -- ingrediente 1
				{ id = 14371, clientID = 13302, count = 2000 }, -- ingrediente 1
				{ id = 14374, clientID = 13305, count = 2000 }, -- ingrediente 1
				-- etc...
			},
		},
		{
			itemID = 15040, -- id do item para craftar
			clientID = 13971, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Boots", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15036, clientID = 13967, count = 1 }, -- ingrediente 1
				{ id = 15083, clientID = 14014, count = 2000 }, -- ingrediente 1
				{ id = 14375, clientID = 13306, count = 2000 }, -- ingrediente 1
				{ id = 14376, clientID = 13307, count = 2000 }, -- ingrediente 1
				{ id = 14371, clientID = 13302, count = 2000 }, -- ingrediente 1
				{ id = 14374, clientID = 13305, count = 2000 }, -- ingrediente 1
				-- etc...
			},
		},
--======================================================== 
		{
			itemID = 15026, -- id do item para craftar -- 
			clientID = 13957, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Helmets", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15011, clientID = 13942, count = 1 }, -- ingrediente 1
				{ id = 6543, clientID = 6543, count = 1000 }, -- ingrediente 1
				{ id = 6541, clientID = 6541, count = 1000 }, -- ingrediente 1
				-- etc...
			},
		},
		{
			itemID = 15027, -- id do item para craftar
			clientID = 13958, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Armors", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15015, clientID = 13946, count = 1 }, -- ingrediente 1
				{ id = 6543, clientID = 6543, count = 1000 }, -- ingrediente 1
				{ id = 6541, clientID = 6541, count = 1000 }, -- ingrediente 1
				-- etc...
			},
		},
		{
			itemID = 15028, -- id do item para craftar
			clientID = 13959, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Legs", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15016, clientID = 13947, count = 1 }, -- ingrediente 1
				{ id = 6543, clientID = 6543, count = 1000 }, -- ingrediente 1
				{ id = 6541, clientID = 6541, count = 1000 }, -- ingrediente 1
				-- etc...
			},
		},
		{
			itemID = 15029, -- id do item para craftar
			clientID = 13960, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Boots", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15017, clientID = 13948, count = 1 }, -- ingrediente 1
				{ id = 6543, clientID = 6543, count = 1000 }, -- ingrediente 1
				{ id = 6541, clientID = 6541, count = 1000 }, -- ingrediente 1
				-- etc...
			},
		},
--======================================================== 
		{
			itemID = 15041, -- id do item para craftar -- 
			clientID = 13972, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Helmets", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15026, clientID = 13957, count = 1 }, -- ingrediente 1
				{ id = 6543, clientID = 6543, count = 1000 }, -- ingrediente 1
				{ id = 6541, clientID = 6541, count = 1000 }, -- ingrediente 1
				-- etc...
			},
		},
		{
			itemID = 15042, -- id do item para craftar
			clientID = 13973, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Armors", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15027, clientID = 13958, count = 1 }, -- ingrediente 1
				{ id = 6543, clientID = 6543, count = 1000 }, -- ingrediente 1
				{ id = 6541, clientID = 6541, count = 1000 }, -- ingrediente 1
				-- etc...
			},
		},
		{
			itemID = 15043, -- id do item para craftar
			clientID = 13974, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Legs", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15028, clientID = 13959, count = 1 }, -- ingrediente 1
				{ id = 6543, clientID = 6543, count = 1000 }, -- ingrediente 1
				{ id = 6541, clientID = 6541, count = 1000 }, -- ingrediente 1
				-- etc...
			},
		},
		{
			itemID = 15044, -- id do item para craftar
			clientID = 13975, -- client id do item
			price = 1000000, -- preco em dinheiro para criar alem dos ingredientes (100k = 10 golds, 1kk = 100 golds)
			category = "Boots", -- categoria
			ingredients = {
				-- ingredientes para craftar
				{ id = 15029, clientID = 13960, count = 1 }, -- ingrediente 1
				{ id = 6543, clientID = 6543, count = 1000 }, -- ingrediente 1
				{ id = 6541, clientID = 6541, count = 1000 }, -- ingrediente 1
				-- etc...
			},
		},
	},
}

do
	for i = 1, #CraftSystem.items_to_craft do
		local itemData = CraftSystem.items_to_craft[i]
		local name
		local tooltip
		local itemInfo = getItemInfo(itemData.itemID)
		if (itemInfo) then
			name = itemInfo.name
			tooltip = "Informações\nWeight: " .. itemInfo.weight .. " oz"
			if (itemInfo.armor > 0) then
				tooltip = tooltip .. "\nArmor: " .. itemInfo.armor
			end
			if (itemInfo.defense > 0) then
				tooltip = tooltip .. "\nDefense: " .. itemInfo.defense
			end
			if (itemInfo.description ~= "") then
				tooltip = tooltip .. "\nDescription:\n" .. itemInfo.description
			end
		else
			name = "UNKNOWN_ITEM"
			tooltip = ""
		end

		if (not itemData.name) then
			itemData.name = name
		end
		if (not itemData.tooltip) then
			itemData.tooltip = tooltip
		end

		for j = 1, #itemData.ingredients do
			local ingredientData = itemData.ingredients[j]
			itemInfo = getItemInfo(ingredientData.id)
			if (itemInfo) then
				name = itemInfo.name
			else
				name = "UNKNOWN_ITEM"
			end

			if (not ingredientData.name) then
				ingredientData.name = name
			end
		end
	end
end

function CraftSystem:sendCategoryData(cid, category, searchText)
	local opcode = self.opcodes.send.itemsCategory
	local buffer = {}
	for i = 1, #self.items_to_craft do
		local itemData = self.items_to_craft[i]
		if (itemData.category == category or category == "Todos") then
			if (not searchText or itemData.name:find(searchText, 1, true)) then
				buffer[1] = category
				buffer[2] = itemData.itemID
				buffer[3] = itemData.clientID
				buffer[4] = itemData.name
				buffer[5] = itemData.tooltip
				doSendPlayerExtendedOpcode(cid, opcode, table.concat(buffer, "@"))
			end
		end
	end
end

function CraftSystem:sendCategoryAndMoneyInfo(cid)
	local opcode = self.opcodes.send.categoryAndMoneyInfo
	doSendPlayerExtendedOpcode(cid, opcode, self.categories_order .. "@" .. getPlayerMoney(cid))
end

function CraftSystem:sendIngredientsData(cid, category, itemID)
	local opcode = self.opcodes.send.ingredientsData
	for i = 1, #self.items_to_craft do
		local itemData = self.items_to_craft[i]
		if (itemData.itemID == itemID) then
			local buffer = {}
			buffer[1] = itemData.itemID
			buffer[2] = nil -- ingredient id
			buffer[3] = nil -- ingredient count
			buffer[4] = itemData.price
			buffer[5] = itemData.category
			buffer[6] = itemData.itemID -- subcategory - itemid?
			buffer[7] = nil -- ingredient player count
			buffer[8] = getPlayerMoney(cid)
			buffer[9] = itemData.clientID
			buffer[10] = nil -- ingredient name

			for j = 1, #itemData.ingredients do
				local ingredientData = itemData.ingredients[j]
				buffer[2] = ingredientData.clientID
				buffer[3] = ingredientData.count
				buffer[7] = getPlayerItemCount(cid, ingredientData.id)
				buffer[10] = ingredientData.name
				doSendPlayerExtendedOpcode(cid, opcode, table.concat(buffer, "@"))
			end
			break
		end
	end
end

function CraftSystem:sendDestroyInfo(cid, infoType)
	local opcode = self.opcodes.send.destroyInfo
	doSendPlayerExtendedOpcode(cid, opcode, infoType)
end

function CraftSystem:craft(cid, itemID, count, category)
	for i = 1, #self.items_to_craft do
		local itemData = self.items_to_craft[i]
		if (itemData.itemID == itemID) then
			local totalPrice = itemData.price * count
			if (getPlayerMoney(cid) < totalPrice) then
				doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Você não tem dinheiro suficiente.")
				return false
			end

			for j = 1, #itemData.ingredients do
				local ingredientData = itemData.ingredients[j]
				if (getPlayerItemCount(cid, ingredientData.id) < ingredientData.count) then
					doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Falta ingredientes para craftar esse item.")
					return false
				end
			end

			doPlayerRemoveMoney(cid, totalPrice)
			for j = 1, #itemData.ingredients do
				local ingredientData = itemData.ingredients[j]
				doPlayerRemoveItem(cid, ingredientData.id, ingredientData.count)
			end

			doPlayerAddItem(cid, itemData.itemID, count, true, 1, 0)
			doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Você craftou " .. count .. " " .. itemData.name .. " com sucesso!")

			--self:sendCategoryAndMoneyInfo(cid)
			return true
		end
	end
	return false
end
