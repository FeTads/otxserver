local powerUpWindow
local powerUpPanel
local widgetBestiaryPoints
local POWERUPButton = nil

local unlockedWindow = nil
local unlockedIsClicked = false

function init()
    connect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir,
    })

    connect(LocalPlayer, { onPositionChange = onPositionChange })
    
    powerUpWindow = g_ui.displayUI("powerup", modules.game_interface.getRootPanel())
    POWERUPButton = modules.client_topmenu.addRightGameToggleButton('powerUP', "Power Up", 'window/top_button', exibir, true)
    POWERUPButton:setOn(false)

    ProtocolGame.registerExtendedOpcode(90, onReceiveChangePowerUp)
    powerUpWindow:hide()
end

function onPositionChange(creature, newPos, oldPos)
    if creature:isLocalPlayer() and powerUpWindow:isVisible() then
        naoexibir()
    end
end

function terminate()
    disconnect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir,
    })
    disconnect(Creature, { onPositionChange = onPositionChange })
    
    ProtocolGame.unregisterExtendedOpcode(90)
    powerUpWindow:hide()
end

function exibir()
    if POWERUPButton:isOn() then
        naoexibir()
    else
        g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "doPlayerSendOpenPowerUp"}))

        powerUpWindow:show()
        powerUpWindow:raise()
        powerUpWindow:focus()
        POWERUPButton:setOn(true)
    end
end

function naoexibir()
    powerUpWindow:hide()
    POWERUPButton:setOn(false)
    closeUnlocked()
end

function onReceiveChangePowerUp(protocol, opcode, payload)
    local status, json_data = pcall(function() return json.decode(payload) end)

    if json_data.type == "update" then
        powerUpWindow.statsList:destroyChildren()
        local statsContainer = powerUpWindow.statsList

        for _, statsData in ipairs(json_data.statsData) do
            local statsPanel = g_ui.createWidget("StatsPanelPoints", powerUpWindow.statsList)

            statsPanel.statsName:setText(statsData.name)
            statsPanel.statsName:setColor(statsData.color)
            statsPanel.statsName:setTooltip(statsData.description)

            if not statsData.isBlocked then
                statsPanel.blocked:setOn(true)
                statsPanel.blocked:setTooltip("Desbloqueado")
            else
                statsPanel.blocked:setOn(statsData.unlocked)
                statsPanel.blocked:setTooltip(statsData.unlocked and "Desbloqueado" or "Bloqueado")
                statsPanel.increment:setEnabled(statsData.unlocked)
            end

            statsPanel.blocked.onClick = function()
                unlocked(statsData.name)
            end

            statsPanel.statsValue:setText("(+" .. statsData.statspoints .. "%)")
            statsPanel.statsValue:setTooltip(string.format("Power Up Stats: {%s%s}\nLimite PowerUp: {%d%%#00EC07}\nRequisito de Power Up Points: {%d#00EC07}\nSua Porcentagem: {%d%%#00EC07}", statsData.name, statsData.color, statsData.limit, statsData.nextPoints, statsData.statspoints))

            statsPanel.increment:setTooltip(string.format("Power Up Stats: {%s%s}\nRequisito de Power Up Points: {%d#00EC07}\nVoc� possui {%d%s} Power Up Points", statsData.name, statsData.color, statsData.nextPoints, json_data.playerpoints, getColorByValue(json_data.playerpoints)))
            statsPanel.increment.onClick = function()
                if not statsData.unlocked then
                    print(tostring(statsData.unlocked))
                    return
                end

                g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "doPlayerAddPowerUpBonus", category = statsData.name}))
            end

            if statsData.statspoints >= statsData.limit then
                statsPanel.increment:disable()
                statsPanel.statsValue:setTooltip(string.format("Power Up Stats: {%s%s}\nSua Porcentagem: {%d%%#00EC07}\n{Limite de Aprimoramento Atingido#F70909}", statsData.name, statsData.color, statsData.statspoints))
            end
        end

        local containerSize = 160 + (statsContainer:getChildCount() * 35)
        powerUpWindow:setHeight(containerSize - 3)

        powerUpWindow.points:setText("Power Up Points: {" .. json_data.playerpoints .. getColorByValue(json_data.playerpoints) .."}")
        powerUpWindow.points:setTooltip("Voc� possui {" .. json_data.playerpoints .. getColorByValue(json_data.playerpoints) .."} Power Up Points.")

        local highlightData = getNewHighlightedText(powerUpWindow.points:getText(), "white", "#ffffff")
        if #highlightData > 2 then
            powerUpWindow.points:setColoredText(highlightData)
        end
    end
end

function getColorByValue(value)
    if value <= 10 then
        return "#FF0000"
    elseif value <= 100 then
        return "#FFA500"
    elseif value <= 500 then
        return "#FFFF00"
    else
        return "#2FC7F0"
    end
end

function doPlayerResetPowerUpPoints()
    g_game.getProtocolGame():sendExtendedOpcode(36, json.encode({type = "doResetStatsPoints"}))
end

function closeUnlocked()
    if unlockedWindow then
        unlockedWindow:destroy()
        unlockedWindow = nil
        unlockedIsClicked = false
    end
end

function unlocked(name)
    if not unlockedIsClicked then
        closeUnlocked()
        unlockedIsClicked = true

        yesCallback = function()
            closeUnlocked()

            g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "doUnlockedStats", category = name}))
        end
            
        noCallback = function()
            closeUnlocked()
        end

        unlockedWindow = displayGeneralBox(tr(name), tr("Voc� deseja desbloquear o stats " .. name .. "?"), {
        { text = tr('Yes'), callback = yesCallback },
        { text = tr('No'), callback = noCallback },
        anchor = AnchorHorizontalCenter}, yesCallback, noCallback)
    end
end