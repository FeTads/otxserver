local tierWindow
local confirmUpgrade = nil
local tierButton = nil
local clickConfirmWidget = false
local GameOpcodeTier = 30

local textPlayerFull = "Parabens! Voce desbloqueou todos os niveis e atingiu seu potencial maximo de forca! Agora voce esta pronto para enfrentar qualquer desafio com todo o seu poder!"
local showMessage = true

function init()
    connect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir,
    })

    tierWindow = g_ui.loadUI("tier", modules.game_interface.getRootPanel())

	tierButton = modules.client_topmenu.addRightGameToggleButton('tierButton', tr('Tier'), '/images/topbuttons/tier', exibir)
	tierButton:setOn(true)

    ProtocolGame.registerExtendedOpcode(GameOpcodeTier, onPlayerReceiveTier)
    tierWindow:hide()
end

function terminate()
    disconnect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir,
    })

	ProtocolGame.unregisterExtendedOpcode(GameOpcodeTier)
	tierWindow:hide()
end

function exibir()
	if tierButton:isOn() then
		naoexibir()
	else
    	g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "openTier"}))
		tierButton:setOn(true)
	end
end

function naoexibir()
  	tierWindow:hide()
	tierButton:setOn(false)
  	clickConfirmWidget = false
end

function onPlayerReceiveTier(protocol, opcode, payload)
	local status, json_data = pcall(function() return json.decode(payload) end)

	if json_data.type == "OpenTier" then
		tierWindow:setText(g_game.getCharacterName())
		tierWindow:setImageSource("vocations/default")

		tierWindow.panelInfo.labelVocationName:setText(json_data.vocationName)
		tierWindow.panelInfo.labelVocationName:setTooltip("Seu personagem e " .. json_data.vocationName)

		doUpdateStars(json_data.playerData)
		tierWindow.buttonUpgrade:setTooltip("Clique aqui para evoluir seu personagem para " .. json_data.playerData.nextRank)
		tierWindow.buttonUpgrade.onClick = function()
			doUpgrade("Upgrade Tier", getSilver(json_data))
		end
	end
	tierWindow:show()
end

function doUpdateStars(data)
	for i = 1, 5 do
		local widget = "star" .. i
		if i <= data.level then
			tierWindow.starsList[widget]:setEnabled(true)
			tierWindow.starsList[widget]:setTooltip("Nivel desbloqueado " .. i)
		else
			tierWindow.starsList[widget]:setEnabled(false)
		end

		tierWindow.starsList[widget]:setImageSource("stars/" .. data.rank)
	end

	if data.max then
		tierWindow.buttonUpgrade:setVisible(false)
		
		if showMessage then
			tierWindow.labelMaxText:setVisible(true)
			tierWindow.labelMaxText:setText(textPlayerFull)
		end
	else
		tierWindow.buttonUpgrade:setVisible(true)
		tierWindow.labelMaxText:setVisible(false)
	end

	tierWindow.panelInfo.labelLevel:setText("Seu nivel: " .. data.level)
	tierWindow.panelInfo.labelLevel:setTooltip("Seu nivel de modalidade atual")
	tierWindow.panelInfo.incrementHp:setText(" +(" .. math.ceil(data.maxHealth * (data.status / 100)) .. ")")
	tierWindow.panelInfo.incrementMp:setText(" +(" .. math.ceil(data.maxMana * (data.status / 100)) .. ")")
	tierWindow.panelInfo.incrementDef:setText(" +(" .. data.status .. ")")
	tierWindow.panelInfo.incrementDmg:setText(" +(" .. data.status .. ")")
end

function doUpgrade(name, cust)
    if not clickConfirmWidget then

	    if confirmUpgrade then
	        confirmUpgrade:hide()
	        confirmUpgrade = nil
	    end

    	clickConfirmWidget = true

	    yesCallback = function()
		    if confirmUpgrade then
		        confirmUpgrade:hide()
		        confirmUpgrade = nil
		    end
               
		    g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "upgradeTier"}))
		    clickConfirmWidget = false
	    end
	        
	    noCallback = function()
	        if confirmUpgrade then
	            confirmUpgrade:hide()
	            confirmUpgrade = nil
	        end

	        clickConfirmWidget = false
	    end

	    confirmUpgrade = displayGeneralBox(tr(name), tr("Tem certeza de que deseja atualizar o nivel do seu personagem para " .. formatNumber(cust).. " Moedas de Prata?"), {
	    { text=tr('Yes'), callback=yesCallback },
	    { text=tr('No'), callback=noCallback },
	    anchor=AnchorHorizontalCenter}, yesCallback, noCallback)
	end
end

function getSilver(json_data)
	local rank = json_data.ranks[json_data.playerData.rank]
	if rank[json_data.playerData.level + 1] then
		return rank[json_data.playerData.level + 1].silver
	else
		return json_data.ranks[json_data.playerData.nextRank][1].silver
	end
end

function formatNumber(value)
    if type(value) ~= "number" then
        return "NaN"
    end

    local formattedValue

    if value >= 1000 and value < 1000000 then
        formattedValue = string.format("%.1fk", value / 1000)
    elseif value >= 1000000 then
        formattedValue = string.format("%.1fkk", value / 1000000)
    else
        formattedValue = tostring(value)
    end

    return formattedValue:gsub("%.0([kK])", "%1")
end