local craft = g_ui.displayUI("itemscraft")
local panelInfo = craft:getChildById("panelcategory")
local panelitemscraft = craft:getChildById("panelitemscraft")
local panelitemsinfo = craft:getChildById("panelitemsinfo")
local searchItem = craft:getChildById("searchItem")
local buttoncraft = craft:getChildById("buttoncraft")
local scrollbar = craft:getChildById("countScrollBar")
local textCount = craft:getChildById("textcount")
local PercentItem = craft:getChildById("progress")
local categorylist = craft:getChildById("categorylist")
local item_UIWidget = craft:getChildById("itemiduiwidget")
local money_uiwidget = craft:getChildById("money_uiwidget")
local OPCODESENDINFO_craft = 135
local OPCODEDESTROYINFO = 136
local ONSENDOPCODE_CRAFTITEMS = 138
local ONSENDINFOITEMCRAFT = 140
local OPCODESENDINFOCraft = 137
local OPCODESENDINFOITEMCRAFT = 139
local ONSEARCHITEM = 141
local SENDCRAFTBUTTON = 142
local iteminfo = nil
local progressWidgets = {}
local categories = {}
local selectcategory = false
local defaultcategory = "Todos"
local selecitemcraft = false
local changecategory = false
local recebevalue = nil

function init()
	craftTopButton = modules.client_topmenu.addRightGameToggleButton('craftTopButton', "Craft", '/images/topbuttons/craft', exibir, true)
	craftTopButton:setOn(true)

	connect(g_game, {
		onGameStart = naoexibir,
		onGameEnd = naoexibir
	})
	connect(LocalPlayer, {
		onPositionChange = onPositionChange
	})
	craft:hide()
	ProtocolGame.registerExtendedOpcode(ONSENDINFOITEMCRAFT, function (protocol, opcode, buffer)
		onReceiveItemsInfo(buffer)
	end)
	ProtocolGame.registerExtendedOpcode(ONSENDOPCODE_CRAFTITEMS, function (protocol, opcode, buffer)
		onReceiveItemsCategory(buffer)
	end)
	ProtocolGame.registerExtendedOpcode(OPCODESENDINFO_craft, function (protocol, opcode, buffer)
		onReceivecraft(buffer)
	end)
	ProtocolGame.registerExtendedOpcode(OPCODEDESTROYINFO, function (protocol, opcode, buffer)
		onReceiveDestroyInfo(buffer)
	end)
end

function terminate()
	disconnect(g_game, {
		onGameStart = naoexibir,
		onGameEnd = naoexibir
	})
	disconnect(Creature, {
		onPositionChange = onPositionChange
	})
	ProtocolGame.unregisterExtendedOpcode(ONSENDINFOITEMCRAFT)
	ProtocolGame.unregisterExtendedOpcode(ONSENDOPCODE_CRAFTITEMS)
	ProtocolGame.unregisterExtendedOpcode(OPCODESENDINFO_craft)
	ProtocolGame.unregisterExtendedOpcode(OPCODEDESTROYINFO)
	craft:hide()
end

function onPositionChange(creature, newPos, oldPos)
	if creature:isLocalPlayer() and craft:isVisible() then
		naoexibir()
	end
end

function exibir()
	if craft:isVisible() then
		naoexibir()
	else
		craft:show()

		if g_game.isOnline() then
			addEvent(function ()
				g_effects.fadeIn(craft, 500)
			end)
			g_game.getProtocolGame():sendExtendedOpcode(36, "openCraftModule" .. "@")
		end
	end
end

function naoexibir()
	craft:hide()

	if panelitemsinfo then
		panelitemsinfo:destroyChildren()
	end

	if panelitemscraft then
		panelitemscraft:destroyChildren()
		searchItem:setVisible(false)
		buttoncraft:setVisible(false)
	end

	if item_UIWidget then
		item_UIWidget:setVisible(false)
	end

	if money_uiwidget then
		money_uiwidget:setVisible(false)
	end

	if selecitemcraft then
		selecitemcraft = false
	end

	if selectcategory then
		selectcategory = false
	end

	if changecategory then
		changecategory = false
	end

	if searchItem then
		searchItem:clearText()
	end

	onClearScrollViewCount()
	categorylist:clearOptions()
end

function onReceiveDestroyInfo(buffer)
	local param = buffer:split("@")
	local type = tostring(param[1])

	if type == "destroy" then
		onClearScrollViewCount()
	end

	if type == "itemcraft" then
		panelitemscraft:destroyChildren()
		onClearScrollViewCount()

		if panelitemsinfo then
			item_UIWidget:setVisible(false)
			panelitemsinfo:destroyChildren()
			buttoncraft:setVisible(false)
			textCount:clearText()
			money_uiwidget:clearText()
		end
	end

	if type == "item" then
		panelitemsinfo:destroyChildren()
	end

	if selectcategory then
		selectcategory = false
	end
end

function onReceivecraft(buffer)
	local param = buffer:split("@")
	local category = tostring(param[1])
	local money = tonumber(param[2])
	category = category:sub(1, -2)
	local _categorys = string.explode(category, ";")

	table.insert(_categorys, 1, "Todos")
	buttoncraft:setVisible(false)

	local balance = craft:getChildById("balance")

	balance:setText(convertToKB(money))
	balance:setTooltip("Balance atual: " .. convertToKB(money))

	for i = 1, #_categorys do
		categorylist.onOptionChange = nil

		categorylist:addOption(_categorys[i])
	end

	function categorylist.onOptionChange(widget)
		if not changecategory then
			changecategory = true

			categorylist:setEnabled(false)

			local selectedCategory = widget:getCurrentOption().text

			g_game.getProtocolGame():sendExtendedOpcode(OPCODESENDINFOCraft, selectedCategory .. "@")
			panelitemsinfo:destroyChildren()
			scheduleEvent(function ()
				categorylist:setEnabled(true)

				changecategory = false
			end, 1000)
		end
	end

	if not selectcategory then
		selectcategory = true
		g_game.getProtocolGame():sendExtendedOpcode(OPCODESENDINFOCraft, defaultcategory .. "@")
	end
end

function onReceiveItemsCategory(buffer)
	local param = buffer:split("@")
	local category = tostring(param[1])
	local subcategory = tonumber(param[2])
	local itemid = tonumber(param[3])
	local name = tostring(param[4])
	local info = tostring(param[5])

	buttoncraft:setVisible(false)

	local sub_category = g_ui.createWidget("UIItem", panelitemscraft)

	sub_category:setImageSource("window/slotitem")
	sub_category:setSize("70 70")

	local item_category = g_ui.createWidget("UIItem", sub_category)

	item_category:addAnchor(AnchorTop, "parent", AnchorTop)
	item_category:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
	item_category:setMarginTop(7)
	item_category:setItemId(itemid)
	item_category:setTooltipTable(name .. "\n" .. info, itemid)
	item_category:setSize("45 45")

	function item_category.onClick()
		if not selecitemcraft then
			selecitemcraft = true

			g_game.getProtocolGame():sendExtendedOpcode(OPCODESENDINFOITEMCRAFT, category .. "@" .. subcategory .. "@")
			scheduleEvent(function ()
				item_UIWidget:setVisible(true)
				money_uiwidget:setVisible(true)
			end, 200)
			scheduleEvent(function ()
				selecitemcraft = false
			end, 1000)
		end
	end

	searchItem:setVisible(true)
	searchItem:setTextOffset("0 -5")

	function searchItem:onTextChange(value)
		if value == "" or value == nil then
			g_game.getProtocolGame():sendExtendedOpcode(OPCODESENDINFOCraft, category .. "@")

			return
		end

		if panelitemsinfo then
			item_UIWidget:setVisible(false)
			panelitemsinfo:destroyChildren()
			buttoncraft:setVisible(false)
			textCount:clearText()
			money_uiwidget:clearText()
		end
		g_game.getProtocolGame():sendExtendedOpcode(ONSEARCHITEM, category .. "@" .. value .. "@" .. "craft" .. "@")
	end
end

function onReceiveItemsInfo(buffer)
	local param = buffer:split("@")
	local itemid = tonumber(param[1])
	local ingredientes = tonumber(param[2])
	local ingredientes_count = tonumber(param[3])
	local money = tonumber(param[4])
	local category = tostring(param[5])
	local subcategory = tonumber(param[6])
	local getItemPlayerCount = tonumber(param[7])
	local playerMoney = tonumber(param[8])
	local clientItemID = tonumber(param[9])
	local nameItem = tostring(param[10])

	item_UIWidget:setItemId(clientItemID)
	money_uiwidget:setText(convertToKB(money))
	money_uiwidget:setTooltip("Quantidade de zeni necessario: " .. convertToKB(money) .. " voce tem " .. convertToKB(playerMoney) .. ".")

	iteminfo = g_ui.createWidget("UIItem", panelitemsinfo)

	iteminfo:setSize("60 50")
	iteminfo:setFont("sans-bold-16px")
	iteminfo:setItemId(ingredientes)
	iteminfo:setTooltipTable(nameItem,ingredientes)

	local progressPercent = g_ui.createWidget("ProgressBar", iteminfo)
	local percent = math.floor(getItemPlayerCount / ingredientes_count * 100)

	progressPercent:setPercent(percent)
	progressPercent:setSize("57 15")
	progressPercent:setMarginBottom(0)
	progressPercent:addAnchor(AnchorBottom, "parent", AnchorBottom)
	progressPercent:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
	progressPercent:setBackgroundColor("green")
	progressPercent:setText(getItemPlayerCount .. " / " .. ingredientes_count)
	progressPercent:setTextAutoResize("true")
	progressPercent:setWidth(57)

	if ingredientes_count then
		progressPercent.ingredientesCount = ingredientes_count
		progressPercent.getCount = getItemPlayerCount
	end

	table.insert(progressWidgets, progressPercent)
	scrollbar:setVisible(true)
	scrollbar:setRange(1, 100)
	scrollbar:setValue(1)
	textCount:setText("1")
	textCount:setTextAutoResize("true")
	textCount:setFont("sans-bold-16px")
	buttoncraft:setVisible(true)

	function scrollbar.onValueChange(widget, value)
		textCount:setText(value)
		textCount:setTextAutoResize("true")
		textCount:setFont("sans-bold-16px")

		for _, v in ipairs(progressWidgets) do
			if v.ingredientesCount and v.getCount then
				v:setText(v.getCount .. " / " .. v.ingredientesCount * value)

				local calculo = v.ingredientesCount * value

				v:setPercent(v.getCount / calculo * 100)
			end
		end

		money_uiwidget:setText(convertToKB(money * value))
		money_uiwidget:setTooltip("Quantidade de zeni necessário: " .. convertToKB(money * value) .. " você tem " .. convertToKB(playerMoney) .. ".")
	end

	function buttoncraft.onClick()
		local value = scrollbar:getValue()
		g_game.getProtocolGame():sendExtendedOpcode(SENDCRAFTBUTTON, category .. "@" .. subcategory .. "@" .. itemid .. "@" .. value .. "@")
	end
end

function onClearScrollViewCount()
	textCount:clearText()
	scrollbar:setVisible(false)
end

function convertToKB(value)
	local kb = math.floor(value / 1024)

	return tostring(kb) .. "K"
end
