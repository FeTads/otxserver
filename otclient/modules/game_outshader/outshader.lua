local shader = g_ui.displayUI("outshader")
local panelBars = shader:getChildById("panelbars")
local bar = shader:getChildById("Bar")
local onReceiveOpcodeHealthBar = 50
local onReceiveDestroyOpcode = 51
local name2 = nil
function init()
	connect(g_game, {
		onGameStart = naoexibir,
		onGameEnd = naoexibir
	})
	connect(LocalPlayer, {
		onPositionChange = onPositionChange
	})
	naoexibir()
	ProtocolGame.registerExtendedOpcode(onReceiveDestroyOpcode, function (protocol, opcode, buffer)
		onReceiveDestroyOpcodeBar(buffer)
	end)
	ProtocolGame.registerExtendedOpcode(onReceiveOpcodeHealthBar, function (protocol, opcode, buffer)
		onReceiveHealthBar(buffer)
	end)
	g_keyboard.bindKeyDown("Escape", naoexibir)
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
	naoexibir()
end

function onPositionChange(creature, newPos, oldPos)
	if creature:isLocalPlayer() and shader:isVisible() then
		naoexibir()
	end
end

local initialOutfit = nil

function exibir()
    local localPlayer = g_game.getLocalPlayer()
    if localPlayer then
        if not initialOutfit then  -- Salva o outfit inicial apenas na primeira vez
            initialOutfit = localPlayer:getOutfit()
        end
        shader:show()
    end
end

function naoexibir()
    shader:hide()
    local localPlayer = g_game.getLocalPlayer()
    if localPlayer and initialOutfit then
        localPlayer:setOutfit(initialOutfit)  -- Restaura o outfit inicial
    end
	initialOutfit = nil
end

function setOutfitBox(outfit, localPlayer)
	outfitPlayer:setCreature(localPlayer)
end

function onReceiveDestroyOpcodeBar(buffer)
	local param = buffer:split("@")
	local type = tostring(param[1])

	if type == "destroy" then
		panelBars:destroyChildren()
	end
end

function onReceiveHealthBar(buffer)
    panelBars:destroyChildren()  -- Limpa as barras existentes antes de adicionar novas

    local allBars = buffer:split(",")  -- Separando as barras individuais
    for i, barData in pairs(allBars) do
        if barData ~= "" then
            local data = barData:split(";")  -- Separando nome e status
            local name = tostring(data[1])
            local status = tostring(data[2])
            local valor = tostring(data[3])

            -- Adicionar a barra à UI
            addHealthBar(name, status, valor)
        end
    end

    exibir()
end

function addHealthBar(name, status, valor)
    local barname = g_ui.createWidget("UIWidget", panelBars)

    if status == "unlocked" then
        barname:setText(name)
        -- barname:setTextAutoResize("true")
        -- barname:setTextOffset("0 -55")
        -- barname:setTooltip("Clique aqui para equipar a shader bar: " .. name)
        barname:setColor("white")  -- Ou outra cor que indique disponível
		barname:setBorderWidth(1)
	    barname:setBorderColor("white")
    else
        barname:setText(name)
        -- barname:setTextAutoResize("true")
        -- barname:setTextOffset("0 -55")
        barname:setIcon("/images/ui/locked2")
        barname:setColor("red")
		barname:setBorderWidth(1)
	    barname:setBorderColor("white")
    end

    local image = g_ui.createWidget("UIWidget", barname)
    -- image:setSize("30 50")
    image:setOpacity(0.5)
    image:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
    image:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
	local widgetOutfit = g_ui.createWidget('CreatureOutfit', shader)
	local localPlayer = g_game.getLocalPlayer()

    local player = g_game.getLocalPlayer()
	local function updatePlayerOutfit()
		local player = g_game.getLocalPlayer()
		if player and widgetOutfit and widgetOutfit.outfitBox then
			local currentOutfit = player:getOutfit()
			local outfit2 = {
			type = currentOutfit.type,
			healthBar = currentOutfit.healthBar,
			manaBar = currentOutfit.manaBar,
			aura = currentOutfit.aura,
			wings = currentOutfit.wings,
			colorname = currentOutfit.colorname,
			shader = name2
			}
			if name ~= nil then
			localPlayer:setOutfit(outfit2)
			end
		end
		-- scheduleEvent(updatePlayerOutfit, 150)
	end
	-- updatePlayerOutfit()
    function image:onHoverChange(hovered)
        if hovered then
            image:setOpacity(1.0)
            widgetOutfit:setVisible(true)
			name2 = name
			updatePlayerOutfit()
        else
            image:setOpacity(0.5)
            widgetOutfit:setVisible(false)
			name2 = nil
			local currentOutfit = player:getOutfit()
			local outfit3 = {
			type = currentOutfit.type,
			healthBar = currentOutfit.healthBar,
			manaBar = currentOutfit.manaBar,
			aura = currentOutfit.aura,
			wings = currentOutfit.wings,
			colorname = currentOutfit.colorname,
			shader = currentOutfit.shader
			}
			localPlayer:setOutfit(outfit3)
        end
    end

    function barname:onHoverChange(hovered)
        if hovered then
            image:setOpacity(1.0)
            widgetOutfit:setVisible(true)
			name2 = name
			updatePlayerOutfit()
        else
            image:setOpacity(0.5)
            widgetOutfit:setVisible(false)
			name2 = nil
			local currentOutfit = player:getOutfit()
			local outfit3 = {
			type = currentOutfit.type,
			healthBar = currentOutfit.healthBar,
			manaBar = currentOutfit.manaBar,
			aura = currentOutfit.aura,
			wings = currentOutfit.wings,
			colorname = currentOutfit.colorname,
			shader = currentOutfit.shader
			}
			localPlayer:setOutfit(outfit3)
        end
    end

    function image.onClick()
        if status == "unlocked" then
            onEquipBar(name)
			else
			onBuyBar(name, valor)
        end
    end   
	function barname.onClick()
        if status == "unlocked" then
            onEquipBar(name)
			else
			onBuyBar(name, valor)
        end
    end
end

function onEquipBar(name)
    g_game.talk("/shaders " .. name)
	naoexibir()
end

function onBuyBar(name, valor)
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk("/buyshaders " .. name)
	acceptWindow:destroy()
	acceptWindow = nil
	naoexibir()
  end
  
  local cancelFunc = function() acceptWindow:destroy() acceptWindow = nil naoexibir() end

  acceptWindow = displayGeneralBox(tr('Aceitar transacao'), tr("Voce realmente deseja comprar o " ..name .. " ela custa: " .. valor .. ""),
  { { text=tr('Sim'), callback=acceptFunc },
    { text=tr('Nao'), callback=cancelFunc },
    anchor=AnchorHorizontalCenter }, acceptFunc, cancelFunc)
end

function DesativarBar()
    g_game.talk("/shaders none")
	naoexibir()
end