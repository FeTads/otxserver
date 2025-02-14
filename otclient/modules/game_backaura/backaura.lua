local healthbar = g_ui.displayUI("backaura")
local panelBars = healthbar:getChildById("panelbars")
local bar = healthbar:getChildById("Bar")
local onReceiveOpcodeHealthBar = 38
local onReceiveDestroyOpcode = 39

function init()
	connect(g_game, {
		onGameStart = naoexibir,
		onGameEnd = naoexibir
	})
	connect(LocalPlayer, {
		onPositionChange = onPositionChange
	})
	healthbar:hide()
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
	healthbar:hide()
end

function onPositionChange(creature, newPos, oldPos)
	if creature:isLocalPlayer() and healthbar:isVisible() then
		naoexibir()
	end
end

function exibir()
	healthbar:show()
end

function naoexibir()
	healthbar:hide()
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
        barname:setTextAutoResize("true")
        barname:setTextOffset("0 -55")
        barname:setTooltip("Clique aqui para equipar a health bar: " .. name)
        barname:setColor("white")  -- Ou outra cor que indique disponível
		barname:setBorderWidth(1)
	    barname:setBorderColor("white")
    else
        barname:setText(name)
        barname:setTextAutoResize("true")
        barname:setTextOffset("0 -55")
        barname:setColor("red")
	    barname:setIcon("/images/ui/locked3")
        barname:setTooltip(name .. " ainda nao foi desbloqueada.")
		barname:setBorderWidth(1)
	    barname:setBorderColor("white")
    end

    local image = g_ui.createWidget("UIWidget", barname)
    image:setImageSource("/data/images/backaura/" .. name)
    image:setSize("80 100")
    image:setOpacity(0.5)
    image:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
    image:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
	if name == "Zekro" then
	image:setSize("80 40")
	image:setMarginTop(20)
	end
	if name == "Vrax" then
	image:setSize("80 40")
	image:setMarginTop(20)
	end
	local widgetOutfit = g_ui.createWidget('CreatureOutfit', healthbar)
    local player = g_game.getLocalPlayer()
	widgetOutfit.outfitBox:setOutfit(player:getOutfit())
	local function updatePlayerOutfit()
		local player = g_game.getLocalPlayer()
		if player and widgetOutfit and widgetOutfit.outfitBox then
			local currentOutfit = player:getOutfit()
			local outfit = {
			type = currentOutfit.type
			}
			widgetOutfit.outfitBox:setOutfit(outfit)
		end
		scheduleEvent(updatePlayerOutfit, 150)
	end
	
	updatePlayerOutfit()
    local widgetOutfit2 = g_ui.createWidget('CreatureOutfit', healthbar)
    widgetOutfit2:setImageSource("/data/images/backaura/" .. name)
    widgetOutfit2:setSize("200 300")
    widgetOutfit2:setMarginTop(-43)
    widgetOutfit2:setMarginLeft(-166)
    widgetOutfit2:setVisible(false)
	if name == "Zekro" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
	if name == "Fynar" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
	if name == "Tregos" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
	if name == "Vrax" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
	if name == "Draxil" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
	if name == "Orlen" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
	if name == "Kyros" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
	if name == "Veld" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
	if name == "Makar" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
	if name == "Zilon" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
	if name == "Brex" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
	if name == "Lokan" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
	if name == "Tyrex" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
	if name == "Vornar" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
	if name == "Kryon" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
	if name == "Sylar" then
	widgetOutfit2:setSize("230 300")
	widgetOutfit2:setMarginTop(-20)
    widgetOutfit2:setMarginLeft(-160)
	widgetOutfit:raise()
	end
    function image:onHoverChange(hovered)
        if hovered then
            image:setOpacity(1.0)
            widgetOutfit2:setVisible(true)
        else
            image:setOpacity(0.5)
            widgetOutfit2:setVisible(false)
        end
    end

    function barname:onHoverChange(hovered)
        if hovered then
            image:setOpacity(1.0)
            widgetOutfit2:setVisible(true)
        else
            image:setOpacity(0.5)
            widgetOutfit2:setVisible(false)
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
    g_game.talk("/backaura " .. name)
	naoexibir()
end
function DesativarBar()
    g_game.talk("/backaura none")
	naoexibir()
end

function onBuyBar(name, valor)
  if acceptWindow then
    return true
  end

  local acceptFunc = function()
    g_game.talk("/buybackauras " .. name)
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
