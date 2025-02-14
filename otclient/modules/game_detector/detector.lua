local OPCODE_OPENDECTECTOR = 170

detector = g_ui.displayUI('detector')
local setname = detector:getChildById("setName")
local outfittarget = detector:getChildById("outfit")

function init()
	connect(g_game, { onGameEnd = onGameEnd })
	
	ProtocolGame.registerExtendedOpcode(OPCODE_OPENDECTECTOR, function(protocol, opcode, buffer) 
		getDGG(buffer)
	end)
	detector:hide()
end

function terminate()
	disconnect(g_game, { onGameEnd = onGameEnd })
	ProtocolGame.unregisterExtendedOpcode(OPCODE_OPENDECTECTOR, getdetectoracters)
	detector:destroy()
end

function refresh()
	local player = g_game.getLocalPlayer()
end

function onGameEnd()
    detector:hide()
end

function onClose()
	detector:hide()
end

function setOutfitBox(outfit, localPlayer)
	outfittarget:setCreature(localPlayer)
end

function getDGG(value)
	local localPlayer = g_game.getLocalPlayer()
	local param = string.explode(value, ";")
	local name = tostring(param[2])
	local health = tonumber(param[3])
	local mana = tonumber(param[4])
	local outfit = tostring(param[5])

	if tonumber(param[1]) then
		detector:show()

		outfittarget:setOutfit({type = outfit})
		-- outfittarget:setOutfit(outfit)
		setname:setText("Name: "..name)






	end
end