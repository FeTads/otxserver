local healthbar = g_ui.displayUI("healthbar")
local panelBars = healthbar:getChildById("panelbars")
local outfitPlayer = healthbar:getChildById("outfit")
local bar = healthbar:getChildById("Bar")
local onReceiveOpcodeHealthBar = 20
local onReceiveDestroyOpcode = 21

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
	local param = buffer:split("@")
	local name = tostring(param[1])
	local status = tostring(param[2])

	exibir()

	local barname = g_ui.createWidget("UIWidget", panelBars)

	if status == "unlock" then
		barname:setText(name)
		barname:setTextAutoResize("true")
		barname:setTextOffset("0 -55")
		barname:setTooltip("Clique aqui para equipar a health bar: " .. name)
	else
		barname:setText(name)
		barname:setTextAutoResize("true")
		barname:setTextOffset("0 -55")
		barname:setColor("red")
		barname:setTooltip(name .. " ainda n\xe3o foi desbloqueada.")
	end

	local image = g_ui.createWidget("UIWidget", barname)

	image:setImageSource("/data/images/bars/" .. name)
	image:setSize("80 40")
	image:setOpacity(0.5)
	image:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
	image:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)

	function image:onHoverChange(hovered)
		if hovered then
			image:setOpacity(100)
		else
			image:setOpacity(0.5)
		end
	end

	function image.onClick()
		if status == "unlock" then
			onEquipBar(name)
		end
	end
end

function onEquipBar(name)
	g_game.talk("/bar " .. name)
end
