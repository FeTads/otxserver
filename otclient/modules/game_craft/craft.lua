local craftt = g_ui.displayUI("craft")
-- local panelBars = craftt:getChildById("panelbars")
local bar = craftt:getChildById("Bar")
local onReceiveOpcodeHealthBar = 195
local onReceiveDestroyOpcode = 196
local item_UIWidget = craftt:getChildById("itemiduiwidget")
local item_UIWidget2 = craftt:getChildById("itemiduiwidget2")
local item_UIWidget3 = craftt:getChildById("itemiduiwidget3")
local item_UIWidget4 = craftt:getChildById("itemiduiwidget4")
local item_UIWidget5 = craftt:getChildById("itemiduiwidget5")

local itemrequiredwidget = craftt:getChildById("itemrequiredwidget")
local itemrequiredwidget2 = craftt:getChildById("itemrequiredwidget2")
local itemrequiredwidget3 = craftt:getChildById("itemrequiredwidget3")
local itemrequiredwidget4 = craftt:getChildById("itemrequiredwidget4")
local itemrequiredwidget5 = craftt:getChildById("itemrequiredwidget5")
local itemrequiredwidget6 = craftt:getChildById("itemrequiredwidget6")
local itemrequiredwidget7 = craftt:getChildById("itemrequiredwidget7")
local itemrequiredwidget8 = craftt:getChildById("itemrequiredwidget8")
local itemrequiredwidget9 = craftt:getChildById("itemrequiredwidget9")
local itemrequiredwidget10 = craftt:getChildById("itemrequiredwidget10")
local itemrequiredwidget11 = craftt:getChildById("itemrequiredwidget11")
local itemrequiredwidget12 = craftt:getChildById("itemrequiredwidget12")
local itemrequiredwidget13 = craftt:getChildById("itemrequiredwidget13")
local itemrequiredwidget14 = craftt:getChildById("itemrequiredwidget14")
local itemrequiredwidget15 = craftt:getChildById("itemrequiredwidget15")
local itemrequiredwidget16 = craftt:getChildById("itemrequiredwidget16")
local itemrequiredwidget17 = craftt:getChildById("itemrequiredwidget17")
local itemrequiredwidget18 = craftt:getChildById("itemrequiredwidget18")
local itemrequiredwidget19 = craftt:getChildById("itemrequiredwidget19")
local itemrequiredwidget20 = craftt:getChildById("itemrequiredwidget20")
local itemrequiredwidget21 = craftt:getChildById("itemrequiredwidget21")
local itemrequiredwidget22 = craftt:getChildById("itemrequiredwidget22")
local itemrequiredwidget23 = craftt:getChildById("itemrequiredwidget23")
local itemrequiredwidget24 = craftt:getChildById("itemrequiredwidget24")
local itemrequiredwidget25 = craftt:getChildById("itemrequiredwidget25")
local itemrequiredwidget26 = craftt:getChildById("itemrequiredwidget26")
local itemrequiredwidget27 = craftt:getChildById("itemrequiredwidget27")
local itemrequiredwidget28 = craftt:getChildById("itemrequiredwidget28")
local itemrequiredwidget29 = craftt:getChildById("itemrequiredwidget29")
local itemrequiredwidget30 = craftt:getChildById("itemrequiredwidget30")
local itemrequiredwidget31 = craftt:getChildById("itemrequiredwidget31")
local itemrequiredwidget32 = craftt:getChildById("itemrequiredwidget32")
local itemrequiredwidget33 = craftt:getChildById("itemrequiredwidget33")
local itemrequiredwidget34 = craftt:getChildById("itemrequiredwidget34")
local itemrequiredwidget35 = craftt:getChildById("itemrequiredwidget35")

local currentPage = 1
local itemsPerPage = 5
local lastBuffer = nil  -- Variável global para armazenar o último buffer
local nextPageButton = craftt:getChildById("nextPageButton")
local previousPageButton = craftt:getChildById("previousPageButton")
local totalPages = 0  -- Variável global para armazenar o total de páginas

function init()
    connect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir
    })
    connect(LocalPlayer, {
        onPositionChange = onPositionChange
    })
    ProtocolGame.registerExtendedOpcode(onReceiveDestroyOpcode, function (protocol, opcode, buffer)
        onReceiveDestroyOpcodeBar(buffer)
    end)
    ProtocolGame.registerExtendedOpcode(onReceiveOpcodeHealthBar, function (protocol, opcode, buffer)
        onReceiveHealthBar(buffer)
    end)
    g_keyboard.bindKeyDown("Escape", naoexibir)
	
	naoexibir()
end

function terminate()
    disconnect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir
    })
    disconnect(Creature, {
        onPositionChange = onPositionChange
    })
    ProtocolGame.unregisterExtendedOpcode(onReceiveDestroyOpcode)
    ProtocolGame.unregisterExtendedOpcode(onReceiveOpcodeHealthBar)
end

function onPositionChange(creature, newPos, oldPos)
    if creature:isLocalPlayer() and craftt:isVisible() then
        naoexibir()
    end
end

function exibir()
    craftt:show()
end

function naoexibir()
	currentPage = 1
    craftt:hide()
end

function onReceiveDestroyOpcodeBar(buffer)
    local param = buffer:split("@")
    local type = tostring(param[1])

    -- if type == "destroy" then
        -- panelBars:destroyChildren()
    -- end
end

function onReceiveHealthBar(buffer)
    -- panelBars:destroyChildren()  -- Limpa as barras existentes antes de adicionar novas

    local allBars = buffer:split(",")  -- Separando as barras individuais
    local itemIndex = 1
    for i, barData in pairs(allBars) do
        if barData ~= "" then
            local data = barData:split(";")  -- Separando id, número, categoria, nome, itens necessários, contagens e nomes
            local id = data[1]
            local numero = tonumber(data[2])
            local categoria = data[3]
            local name = data[4]
            local requiredStr = data[5]
            local requiredCountsStr = data[6]
            local requiredNamesStr = data[7]
            local totalpages = data[8]

            local requiredItems = requiredStr:split(":")  -- IDs dos itens necessários
            local requiredCounts = requiredCountsStr:split(":")  -- Contagens dos itens necessários
            local requiredNames = requiredNamesStr:split(":")  -- Nomes dos itens necessários

            if itemIndex > itemsPerPage * currentPage then
                currentPage = currentPage + 1
                itemIndex = 1
            end

            -- Adicionar a barra à UI se estiver dentro da faixa de itens da página atual
            if itemIndex > itemsPerPage * (currentPage - 1) and itemIndex <= itemsPerPage * currentPage then
                addHealthBar(id, itemIndex - itemsPerPage * (currentPage - 1), categoria, name, requiredItems, requiredCounts, requiredNames, totalpages)
            end
            itemIndex = itemIndex + 1
        end
    end
    exibir()
end

function onReceiveHealthBar(buffer)
    lastBuffer = parseAndSortBuffer(buffer)
    updateDisplay()
    updateNavigationButtons()
end

function parseAndSortBuffer(buffer)
    local allBars = buffer:split(",")  -- Supõe-se que o buffer seja uma string dividida por vírgulas
    local items = {}
    
    for i, barData in ipairs(allBars) do
        if barData ~= "" then
            local data = barData:split(";")
            local totalpages = tonumber(data[8])  -- Asume que o número total de páginas é o oitavo elemento

            if totalpages then
                totalPages = totalpages  -- Atualiza a variável global
            end

            table.insert(items, {
                id = data[1],
                numero = tonumber(data[2]),
                categoria = data[3],
                name = data[4],
                required = data[5]:split(":"),
                requiredCounts = data[6]:split(":"),
                requiredNames = data[7]:split(":"),
            })
        end
    end
	currentPage = 1
    table.sort(items, function(a, b) return a.numero < b.numero end)
    return items
end

function updateNavigationButtons()
    nextPageButton:setVisible(currentPage < totalPages)
    previousPageButton:setVisible(currentPage > 1)
end

function updateDisplay()
    -- panelBars:destroyChildren()  -- Limpa as barras existentes antes de adicionar novas

    if not lastBuffer then return end  -- Se não há dados, não faz nada

    local startIndex = (currentPage - 1) * itemsPerPage + 1
    local endIndex = currentPage * itemsPerPage
    local maxIndex = math.min(endIndex, #lastBuffer)

    for i = startIndex, maxIndex do
        local item = lastBuffer[i]
        addHealthBar(item.id, i - startIndex + 1, item.categoria, item.name, item.required, item.requiredCounts, item.requiredNames, currentPage)
    end

    -- Checa se a quantidade de itens é menor que 'itemsPerPage' e ajusta a interface se necessário
    if maxIndex - startIndex + 1 < itemsPerPage then
        for i = maxIndex + 1, endIndex do
            local itemNumber = i - startIndex + 1
            clearHealthBarSlot(itemNumber)  -- Limpa ou oculta os widgets adicionais que não têm itens
        end
    end
    exibir()
    updateNavigationButtons()
end

function clearHealthBarSlot(slotNumber)
    local itemWidgets = {item_UIWidget, item_UIWidget2, item_UIWidget3, item_UIWidget4, item_UIWidget5}
    if itemWidgets[slotNumber] then
        itemWidgets[slotNumber]:setVisible(false)  -- Esconde o widget
    end
    button:setVisible(false)  -- Esconde o widget
end

function nextPage()
    if currentPage < totalPages then
        currentPage = currentPage + 1
        updateDisplay()  -- Atualiza a exibição imediatamente após a mudança de página
        updateNavigationButtons()
		addHealthBar()
    end
end

function previousPage()
    if currentPage > 1 then
        currentPage = currentPage - 1
        updateDisplay()  -- Atualiza a exibição imediatamente após a mudança de página
        updateNavigationButtons()
    end
end


function addHealthBar(id, numero, categoria, name, required, requiredCounts, requiredNames, currentPage)
    local itemWidgets = {item_UIWidget, item_UIWidget2, item_UIWidget3, item_UIWidget4, item_UIWidget5}
    local requiredWidgets = {
        itemrequiredwidget, itemrequiredwidget2, itemrequiredwidget3, itemrequiredwidget4, itemrequiredwidget5,
        itemrequiredwidget6, itemrequiredwidget7, itemrequiredwidget8, itemrequiredwidget9, itemrequiredwidget10,
        itemrequiredwidget11, itemrequiredwidget12, itemrequiredwidget13, itemrequiredwidget14, itemrequiredwidget15,
        itemrequiredwidget16, itemrequiredwidget17, itemrequiredwidget18, itemrequiredwidget19, itemrequiredwidget20,
        itemrequiredwidget21, itemrequiredwidget22, itemrequiredwidget23, itemrequiredwidget24, itemrequiredwidget25,
        itemrequiredwidget26, itemrequiredwidget27, itemrequiredwidget28, itemrequiredwidget29, itemrequiredwidget30,
        itemrequiredwidget31, itemrequiredwidget32, itemrequiredwidget33, itemrequiredwidget34, itemrequiredwidget35,
    }
    local marginTop = {-125, -46, 33, 110, 191} -- Margens pré-definidas para cada posição

    if not numero then
        numero = 0
    end
    local firstIndex = (numero - 1) * 7 + 1
    local lastIndex = numero * 7
    for i = firstIndex, lastIndex do
        if requiredWidgets[i] then
            requiredWidgets[i]:setVisible(false)
        end
    end

    if numero >= 1 and numero <= 5 and categoria == "helmet" then
        local widget = itemWidgets[numero]
        widget:setVisible(true)
        widget:setItemId(id)
		if name ~= "a" then
        -- widget:setTooltipTable(name, id)
		end
        widget:setMarginTop(marginTop[numero])
        widget:setMarginLeft(-142)
        widget:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
        widget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)

        local offset = 80 -- Espaço horizontal entre os itens
        local lastWidgetPosition = -142
        for i, reqId in ipairs(required) do
            local widgetIndex = (numero - 1) * 7 + i
            if requiredWidgets[widgetIndex] then
                local reqWidget = requiredWidgets[widgetIndex]
                reqWidget:setVisible(true)
                reqWidget:setItemId(reqId)

                local count = (requiredCounts and requiredCounts[i]) or "N/A"
                local itemName = (requiredNames and requiredNames[i]) or "Desconhecido"

                reqWidget:setTooltip("")
                reqWidget:setText("")
                if count > "0" then
                    reqWidget:setText("x" .. count)
					if name ~= "a" then
                    reqWidget:setTooltipTable(itemName .. " x" .. count, reqId, 1)
					end
                end
                reqWidget:setMarginTop(marginTop[numero])
                reqWidget:setMarginLeft(-142 + offset)
                reqWidget:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
                reqWidget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
                lastWidgetPosition = -142 + offset
                offset = offset + 50
            end
        end

        -- Calcula o número absoluto do item baseado na página atual
		local absoluteNumber = numero
		local absoluteNumber2 = name
		if lastWidgetPosition then
			createCraftButton(absoluteNumber, lastWidgetPosition + 50, marginTop[numero], widget, absoluteNumber2)
		end
	end

    if numero >= 1 and numero <= 5 and categoria == "armor" then
        local widget = itemWidgets[numero]
        widget:setVisible(true)
        widget:setItemId(id)
		if name ~= "a" then
        -- widget:setTooltipTable(name, id)
		end
        widget:setMarginTop(marginTop[numero])
        widget:setMarginLeft(-142)
        widget:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
        widget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)

        local offset = 80 -- Espaço horizontal entre os itens
        local lastWidgetPosition = -142
        for i, reqId in ipairs(required) do
            local widgetIndex = (numero - 1) * 7 + i
            if requiredWidgets[widgetIndex] then
                local reqWidget = requiredWidgets[widgetIndex]
                reqWidget:setVisible(true)
                reqWidget:setItemId(reqId)

                local count = (requiredCounts and requiredCounts[i]) or "N/A"
                local itemName = (requiredNames and requiredNames[i]) or "Desconhecido"

                reqWidget:setTooltip("")
                reqWidget:setText("")
                if count > "0" then
                    reqWidget:setText("x" .. count)
					if name ~= "a" then
                    reqWidget:setTooltipTable(itemName .. " x" .. count, reqId, 1)
					end
                end
                reqWidget:setMarginTop(marginTop[numero])
                reqWidget:setMarginLeft(-142 + offset)
                reqWidget:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
                reqWidget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
                lastWidgetPosition = -142 + offset
                offset = offset + 50
            end
        end

        -- Calcula o número absoluto do item baseado na página atual
		local absoluteNumber = numero
		local absoluteNumber2 = name
		if lastWidgetPosition then
			createCraftButton2(absoluteNumber, lastWidgetPosition + 50, marginTop[numero], widget, absoluteNumber2)
		end
    end

    if numero >= 1 and numero <= 5 and categoria == "legs" then
        local widget = itemWidgets[numero]
        widget:setVisible(true)
        widget:setItemId(id)
		if name ~= "a" then
        -- widget:setTooltipTable(name, id)
		end
        widget:setMarginTop(marginTop[numero])
        widget:setMarginLeft(-142)
        widget:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
        widget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)

        local offset = 80 -- Espaço horizontal entre os itens
        local lastWidgetPosition = -142
        for i, reqId in ipairs(required) do
            local widgetIndex = (numero - 1) * 7 + i
            if requiredWidgets[widgetIndex] then
                local reqWidget = requiredWidgets[widgetIndex]
                reqWidget:setVisible(true)
                reqWidget:setItemId(reqId)

                local count = (requiredCounts and requiredCounts[i]) or "N/A"
                local itemName = (requiredNames and requiredNames[i]) or "Desconhecido"

                reqWidget:setTooltip("")
                reqWidget:setText("")
                if count > "0" then
                    reqWidget:setText("x" .. count)
					if name ~= "a" then
                    reqWidget:setTooltipTable(itemName .. " x" .. count, reqId, 1)
					end
                end
                reqWidget:setMarginTop(marginTop[numero])
                reqWidget:setMarginLeft(-142 + offset)
                reqWidget:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
                reqWidget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
                lastWidgetPosition = -142 + offset
                offset = offset + 50
            end
        end

        -- Calcula o número absoluto do item baseado na página atual
		local absoluteNumber = numero
		local absoluteNumber2 = name
		if lastWidgetPosition then
			createCraftButton3(absoluteNumber, lastWidgetPosition + 50, marginTop[numero], widget, absoluteNumber2)
		end
    end

    if numero >= 1 and numero <= 5 and categoria == "boots" then
        local widget = itemWidgets[numero]
        widget:setVisible(true)
        widget:setItemId(id)
		if name ~= "a" then
        -- widget:setTooltipTable(name, id)
		end
        widget:setMarginTop(marginTop[numero])
        widget:setMarginLeft(-142)
        widget:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
        widget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)

        local offset = 80 -- Espaço horizontal entre os itens
        local lastWidgetPosition = -142
        for i, reqId in ipairs(required) do
            local widgetIndex = (numero - 1) * 7 + i
            if requiredWidgets[widgetIndex] then
                local reqWidget = requiredWidgets[widgetIndex]
                reqWidget:setVisible(true)
                reqWidget:setItemId(reqId)

                local count = (requiredCounts and requiredCounts[i]) or "N/A"
                local itemName = (requiredNames and requiredNames[i]) or "Desconhecido"

                reqWidget:setTooltip("")
                reqWidget:setText("")
                if count > "0" then
                    reqWidget:setText("x" .. count)
					if name ~= "a" then
                    reqWidget:setTooltipTable(itemName .. " x" .. count, reqId, 1)
					end
                end
                reqWidget:setMarginTop(marginTop[numero])
                reqWidget:setMarginLeft(-142 + offset)
                reqWidget:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
                reqWidget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
                lastWidgetPosition = -142 + offset
                offset = offset + 50
            end
        end

        -- Calcula o número absoluto do item baseado na página atual
		local absoluteNumber = numero
		local absoluteNumber2 = name
		if lastWidgetPosition then
			createCraftButton4(absoluteNumber, lastWidgetPosition + 50, marginTop[numero], widget, absoluteNumber2)
		end
    end
end

function createCraftButton(numero, marginLeft, marginTop, parentWidget, absoluteNumber2)
	local button = g_ui.createWidget('UIButton', parentWidget)
		button:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
		button:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
		button:setMarginLeft(-15)
		button:setTooltip("Embreve")
		if absoluteNumber2 ~= "a" then
		button:setTooltip("Craftar: " ..absoluteNumber2)
		end
		button:setImageSource("craftar")
		button:setHeight(40)
		button:setWidth(40)
		button:setVisible(true)
		if absoluteNumber2 ~= "a" then
		button.onClick = function()
			local absoluteNumber = (currentPage - 1) * itemsPerPage + numero
			CraftConfirmed(absoluteNumber)
		end
		return button
	end
end

function CraftConfirmed(absoluteNumber)
    g_game.talk("/craftum " .. absoluteNumber)
    naoexibir()
end

function createCraftButton2(numero, marginLeft, marginTop, parentWidget, absoluteNumber2)
	local button = g_ui.createWidget('UIButton', parentWidget)
		button:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
		button:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
		button:setMarginLeft(-15)
		button:setTooltip("Embreve")
		if absoluteNumber2 ~= "a" then
		button:setTooltip("Craftar: " ..absoluteNumber2)
		end
		button:setImageSource("craftar")
		button:setHeight(40)
		button:setWidth(40)
		button:setVisible(true)
		if absoluteNumber2 ~= "a" then
		button.onClick = function()
			local absoluteNumber = (currentPage - 1) * itemsPerPage + numero
			CraftConfirmed2(absoluteNumber)
		end
		return button
	end
end

function CraftConfirmed2(absoluteNumber)
    g_game.talk("/craftdois " .. absoluteNumber)
    naoexibir()
end

function createCraftButton3(numero, marginLeft, marginTop, parentWidget, absoluteNumber2)
	local button = g_ui.createWidget('UIButton', parentWidget)
		button:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
		button:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
		button:setMarginLeft(-15)
		button:setTooltip("Embreve")
		if absoluteNumber2 ~= "a" then
		button:setTooltip("Craftar: " ..absoluteNumber2)
		end
		button:setImageSource("craftar")
		button:setHeight(40)
		button:setWidth(40)
		button:setVisible(true)
		if absoluteNumber2 ~= "a" then
		button.onClick = function()
			local absoluteNumber = (currentPage - 1) * itemsPerPage + numero
			CraftConfirmed3(absoluteNumber)
		end
		return button
	end
end

function CraftConfirmed3(absoluteNumber)
    g_game.talk("/crafttres " .. absoluteNumber)
    naoexibir()
end

function createCraftButton4(numero, marginLeft, marginTop, parentWidget, absoluteNumber2)
	local button = g_ui.createWidget('UIButton', parentWidget)
		button:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
		button:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
		button:setMarginLeft(-15)
		button:setTooltip("Embreve")
		if absoluteNumber2 ~= "a" then
		button:setTooltip("Craftar: " ..absoluteNumber2)
		end
		button:setImageSource("craftar")
		button:setHeight(40)
		button:setWidth(40)
		button:setVisible(true)
		if absoluteNumber2 ~= "a" then
		button.onClick = function()
			local absoluteNumber = (currentPage - 1) * itemsPerPage + numero
			CraftConfirmed4(absoluteNumber)
		end
		return button
	end
end

function CraftConfirmed4(absoluteNumber)
    g_game.talk("/craftquatro " .. absoluteNumber)
    naoexibir()
end
