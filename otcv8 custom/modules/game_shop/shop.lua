local shopWindow
local buyPanel
local transferPanel
local buttonShop = nil

local gameShopOpcode = 40
local categoryPattern = "Premium Account"
local zShopCache = {}

function init()
    connect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = offline,
    })

    shopWindow = g_ui.loadUI("shop", modules.game_interface.getRootPanel())
    shopWindow:hide()
	
	buttonShop = modules.client_topmenu.addRightGameToggleButton('shopSystem', "Shop", 'window/top_button', sendShopInfo, true)
    ProtocolGame.registerExtendedJSONOpcode(gameShopOpcode, onPlayerReceiveShop)
end

function terminate()
    disconnect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = offline,
    })

    ProtocolGame.unregisterExtendedJSONOpcode(gameShopOpcode)
    naoexibir()
end

function offline()
    zShopCache = {}
end

function sendShopInfo(bool)
    if buttonShop:isOn() and not bool then
        return naoexibir()
    end

    if zShopCache[1] then
        doCreateShopInfo(zShopCache[1], bool)
		buttonShop:setOn(true)
    else
        g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "openShop"}))
    end
end

function exibir()
    shopWindow:show()
end

function naoexibir()
    shopWindow:hide()
    closePanelBuying()
    closeTransfer()
	buttonShop:setOn(false)
end

function onPlayerReceiveShop(protocol, opcode, payload)

    if payload.type == "openShop" then
        doCreateShopInfo(payload)
        table.insert(zShopCache, payload)
		buttonShop:setOn(true)
    elseif payload.type == "reloadShop" then
        if zShopCache[1] then
            zShopCache[1].premiumPoints = payload.premiumPoints
        end

        sendShopInfo(true)
    end
end

function doCreateShopInfo(shopData, bool)
    if not shopWindow:isVisible() and not bool then
        exibir()
    end

    shopWindow.premiumPoints:setText(shopData.premiumPoints)
    shopWindow.premiumPoints:setTooltip("Premium points: " .. shopData.premiumPoints)

    shopWindow.PanelCategory.categoryList:destroyChildren()
    for index, categoryData in ipairs(shopData.category) do
        local shopOffer = g_ui.createWidget("ButtonCategory", shopWindow.PanelCategory.categoryList)
        shopOffer:setImageSource("menus/" .. categoryData.name)

        if categoryData.name == categoryPattern then
            shopOffer:focus()
            shopWindow.categoryInfo.descriptionPanel.descriptionLabel:setText(categoryData.description)
            doCreateItems(shopData)
        end

        shopOffer.onClick = function()
            categoryPattern = categoryData.name
            shopWindow.categoryInfo.descriptionPanel.descriptionLabel:setText(categoryData.description)
            doCreateItems(shopData)
        end
    end

    shopWindow.transfer.onClick = function()
        if transferPanel then
            return
        end

        transferPanel = g_ui.createWidget("transferPanel", shopWindow)
        transferPanel.playerName:setValidCharacters('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ')
        transferPanel.labelTransfer:setText("1")
        amount(transferPanel)

        transferPanel.closeTransferPanel.onClick = function()
            closeTransfer()
        end

        transferPanel.transfer.onClick = function()
            local params = {
                type = "transferCoins",
                name = transferPanel.playerName:getText(),
                count = tonumber(transferPanel.amountPanel.textAmount:getText()),
            }

            g_game.getProtocolGame():sendExtendedOpcode(33, json.encode(params))
            closeTransfer()
        end
    end
end

function doCreateItems(shopData)
    closePanelBuying()
    shopWindow.PanelShopList.shopList:destroyChildren()

    for _, data in ipairs(shopData.shopData) do
        if data.category == categoryPattern then
            local shopItem = g_ui.createWidget("shopItem", shopWindow.PanelShopList.shopList)
            shopItem:setId(data.category)

            local tooltipItem = string.format("%s\n%s", data.name, data.description)
            shopItem:setTooltip(tooltipItem)
            shopItem.item:setItemId(data.itemId)
            shopItem.itemName:setText(data.name)
            shopItem.itemPoints:setText(data.points)
            shopItem.icon:setTooltip("Points: " .. data.points)

            shopItem.onClick = function()
                if buyPanel then
                    return 
                end

                buyPanel = g_ui.createWidget("BuyPanel", shopWindow)

                buyPanel.buyLabelName:setText(data.name)
                buyPanel.item:setItemId(data.itemId)
                buyPanel.price:setText(data.points)
                amount(buyPanel, data)

                buyPanel.buy.onClick = function()
                    local params = {
                        type = "buyItemShop",
                        count = tonumber(buyPanel.amountPanel.textAmount:getText()),
                        index = data.index,
                    }

                    g_game.getProtocolGame():sendExtendedOpcode(33, json.encode(params))
                end

                buyPanel.closeBuyPanel.onClick = function()
                    closePanelBuying()
                end
            end
        end
    end
end

function closePanelBuying()
    if buyPanel then
        buyPanel:destroy()
        buyPanel = nil 
    end
end

function closeTransfer()
    if transferPanel then
        transferPanel:destroy()
        transferPanel = nil
    end
end

function amount(widget, data)
    widget.amountPanel.textAmount:setText(1)
    widget.amountPanel.textAmount:setValidCharacters('0123456789')
    widget.amountPanel.textAmount:setFocusable(false)
    widget.amountPanel.textAmount.minimum = 1

    if data then
        widget.amountPanel.textAmount.maximum = 100
    else
        widget.amountPanel.textAmount.maximum = 1000
    end

    widget.amountPanel.textAmount.onTextChange = function(self, text, oldText)
        local number = tonumber(text)

        if not number then
            self:setText(number)
        else
            if number < 1 then
                self:setText(self.minimum)
                return
            elseif number > self.maximum then
                self:setText(self.maximum)
                return
            end
        end

        if text:len() == 0 then
            self:setText(self.minimum)
            number = 1
        end

        if data then
            widget.price:setText(number * data.points)
        else
            widget.labelTransfer:setText(number)
        end
    end

    widget.amountPanel.decrementAll.onClick = function()
        widget.amountPanel.textAmount:setText(1)
    end

    widget.amountPanel.decrement.onClick = function()
        widget.amountPanel.textAmount:setText(math.max(1, tonumber(widget.amountPanel.textAmount:getText()) - 1))
    end

    widget.amountPanel.incrementAll.onClick = function()
        widget.amountPanel.textAmount:setText(widget.amountPanel.textAmount.maximum)
    end

    widget.amountPanel.increment.onClick = function()
        widget.amountPanel.textAmount:setText(math.min(tonumber(widget.amountPanel.textAmount:getText()) + 1, widget.amountPanel.textAmount.maximum))
    end
end