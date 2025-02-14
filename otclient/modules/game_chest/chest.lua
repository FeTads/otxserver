local chestWindow = nil
local receiveItemWidget = nil
local buttonChest = nil
local chestOpcode = 43
local widgetBorderMargins = {}

-- Events
local chestEventUnFocus = nil
local chestEventFocus = nil

local spriteIdLock = 12928

function init()
    connect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir,
    })

    connect(LocalPlayer, { onPositionChange = onPositionChange })
    
    chestWindow = g_ui.loadUI("chest", modules.game_interface.getRootPanel())
    buttonChest = modules.client_topmenu.addRightGameToggleButton('Chest', tr('Chest'), '/images/topbuttons/chest', exibir, false, 1)
    buttonChest:setOn(false)

    ProtocolGame.registerExtendedOpcode(chestOpcode, onPlayerReceiveChest)
    chestWindow:hide()
end

function terminate()
    disconnect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir,
    })

    disconnect(Creature, { onPositionChange = onPositionChange })
    
    ProtocolGame.unregisterExtendedOpcode(chestOpcode)
    chestWindow:hide()
end

function exibir()
    if buttonChest:isOn() then
        naoexibir()
    else
        g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "chestSystem"}))
        chestWindow:show()
        buttonChest:setOn(true)
    end
end

function onPositionChange(creature, newPos, oldPos)
    if creature:isLocalPlayer() and chestWindow:isVisible() then
        naoexibir()
    end
end

function naoexibir()
    chestWindow:hide()
    buttonChest:setOn(false)
    removeReceiveItem()
end

function onPlayerReceiveChest(protocol, opcode, payload)
    local status, json_data = pcall(function() return json.decode(payload) end)

    if json_data.type == "chestUpdate" then


        for _, chestData in ipairs(json_data.chestData) do
            local chest = "chest" .. chestData.index
            local chestWidget = chestWindow.chestPanel[chest]

            chestWidget:setImageSource("chest/chest1")
            chestWidget.index = chestData.index
			chestWidget.key = chestData.key
            removeMargin(chestWidget)

            if chestData.index == 1 then
                chestWidget.fragmentLock:setItemId(spriteIdLock)
                chestWidget:focus()
                chestWidget:setSize("160 120")
                chestWidget:setMarginBottom(70)
				chestWindow.chestPanel.keyPanel.keys:setText("Chaves: " .. chestWidget.key)
				chestWindow.chestPanel.keyPanel.keys:setTooltip("Chaves: " .. chestWidget.key)
				
            elseif chestData.index == 2 then
                chestWidget.chestList2:destroyChildren()
                chestWidget:setSize("80 60")
                chestWidget:setMarginRight(140)

                for num, itemData in ipairs(chestData.fragmentos) do
                    local itemWidget = g_ui.createWidget("ItemFragment", chestWidget.chestList2)
                    itemWidget:setItemId(itemData.id)
                end

            elseif chestData.index == 3 then
                chestWidget.chestList3:destroyChildren()
                chestWidget:setSize("80 60")
                chestWidget:setMarginLeft(140)

                for num, itemData in ipairs(chestData.fragmentos) do
                    local itemWidget = g_ui.createWidget("ItemFragment", chestWidget.chestList3)
                    itemWidget:setItemId(itemData.id)
                end
            end

            chestWidget.onFocusChange = function(widget, focused)

                if focused then
                    widgetBorderMargins = {}
                    table.insert(widgetBorderMargins, {left = widget:getMarginLeft(), right = widget:getMarginRight()})
                    setAnimateFocusChild(widget)
					chestWindow.chestPanel.keyPanel.keys:setText("Chaves: " .. widget.key)
					chestWindow.chestPanel.keyPanel.keys:setTooltip("Chaves: " .. widget.key)
                else
                    chestWindow.chestPanel:setEnabled(false)
                    setAnimateUnfocusChild(widget)
                end
            end 
        end

        chestWindow.chestPanel.openChest.onClick = function()
            g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "openChest", index = chestWindow.chestPanel:getFocusedChild().index}))
        end

    elseif json_data.type == "updateSucess" then
        chestWindow.chestPanel.keyPanel.keys:setText("Chaves: " .. json_data.key)
		chestWindow.chestPanel:getFocusedChild().key = json_data.key
        chestWindow.chestPanel.openChest:setEnabled(false)
        removeReceiveItem()
        openChest(chestWindow.chestPanel.openChest, chestWindow.chestPanel:getFocusedChild(), json_data.itemId, json_data.fragmentCount)

    end
end

function setAnimateUnfocusChild(widget)
    if chestEventUnFocus then
        removeEvent(chestEventUnFocus)
        chestEventUnFocus = nil
    end

    if widget:getId() == "chest1" then
        widget.fragmentLock:setSize("25 25")
    elseif widget:getId() == "chest2" then
        widget.chestList2:getLayout():setCellSize("25 25")
        widget.chestList2:setHeight(25)
    elseif widget:getId() == "chest3" then
        widget.chestList3:getLayout():setCellSize("25 25")
        widget.chestList3:setHeight(25)
    end

    removeReceiveItem()
    widget:setImageSource("chest/chest1")

    local height, width, marginRight, marginBottom = widget:getHeight(), widget:getWidth(), 0, widget:getMarginBottom()
    chestEventUnFocus = cycleEvent(function()
        height = math.max(height - 10, 60)
        width = math.max(width - 10, 80)
        marginRight = math.min(140, marginRight + 20)
        marginBottom = math.max(marginBottom - 10, 0)

        widget:setHeight(height)
        widget:setWidth(width)

        if widgetBorderMargins[1] and widgetBorderMargins[1].left > 0 and widgetBorderMargins[1].right <= 0 then
            widget:setMarginLeft(marginRight)
        elseif widgetBorderMargins[1] and widgetBorderMargins[1].left <= 0 and widgetBorderMargins[1].right > 0 then
            widget:setMarginRight(marginRight)
        end

        widget:setMarginBottom(marginBottom)
        
        if width <= 80 and height <= 60 then
            if chestEventUnFocus then
                removeEvent(chestEventUnFocus)
                chestEventUnFocus = nil
            end

            scheduleEvent(function()
                chestWindow.chestPanel:setEnabled(true)
            end, 200)
        end
    end, 60)
end

function setAnimateFocusChild(widget)
    if chestEventFocus then
        removeEvent(chestEventFocus)
        chestEventFocus = nil
    end

    if widget:getId() == "chest1" then
        widget.fragmentLock:setSize("38 38")
    elseif widget:getId() == "chest2" then
        widget.chestList2:getLayout():setCellSize("38 38")
        widget.chestList2:setHeight(45)
    elseif widget:getId() == "chest3" then
        widget.chestList3:getLayout():setCellSize("38 38")
        widget.chestList3:setHeight(45)
    end

    removeMargin(widget)
    local height, width, marginBottom = widget:getHeight(), widget:getWidth(), 0
    chestEventFocus = cycleEvent(function()
        height = math.min(120, height + 10)
        width = math.min(160, width + 10)
        marginBottom = math.min(70, marginBottom + 10)

        widget:setHeight(height)
        widget:setWidth(width)
        widget:setMarginBottom(marginBottom)

        if width >= 160 and height >= 120 then
            if chestEventFocus then
                removeEvent(chestEventFocus)
                chestEventFocus = nil
            end
        end
    end, 80)
end

function openChest(widgetUse, widget, itemId, count)
    local parentWidget = chestWindow.chestPanel:getFocusedChild()

    for i = 1, 6 do
        scheduleEvent(function()
            widget:setImageSource("chest/chest" .. i)

            if i == 6 then
                widgetUse:setEnabled(true)

                receiveItemWidget = g_ui.createWidget("ItemFragment", parentWidget)
                receiveItemWidget:addAnchor(AnchorTop, "parent", AnchorTop)
                receiveItemWidget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
                receiveItemWidget:setItemId(itemId)
                receiveItemWidget:setItemCount(count)
            end
        end, 100 * i)
    end
end

function removeReceiveItem()
    if receiveItemWidget then
        receiveItemWidget:destroy()
        receiveItemWidget = nil
    end
end

function removeMargin(widget)
    widget:setMarginRight(0)
    widget:setMarginBottom(0)
    widget:setMarginLeft(0)
end