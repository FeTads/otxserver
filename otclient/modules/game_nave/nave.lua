local naveWindow = nil

local youAreHere = nil
local GameNaveOpcode = 4

-- Cache Info Nave
NaveCache = {}

function init()
    connect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir,
    })

    naveWindow = g_ui.loadUI("nave", modules.game_interface.getRootPanel())

    ProtocolGame.registerExtendedOpcode(GameNaveOpcode, onPlayerReceiveNave)
    naveWindow:hide()
end

function terminate()
    disconnect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir,
    })

	ProtocolGame.unregisterExtendedOpcode(GameNaveOpcode)
	naveWindow:hide()
end

function exibir()
	if naveWindow:isVisible() then
		naoexibir()
	else
    	naveWindow:show()
	end
end

function naoexibir()
  	naveWindow:hide()
end

function sendInfoNave(uniqueId, planetName)
	if naveWindow:isVisible() then
		return naoexibir()
	end

	if NaveCache[planetName] then
		createNaveInfo(NaveCache[planetName][1], uniqueId)
	else
		g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "getInfoNave", uniqueId = uniqueId, planetName = planetName}))
	end
end

function onPlayerReceiveNave(protocol, opcode, payload)
	local status, json_data = pcall(function() return json.decode(payload) end)

  	if json_data.type == "openNave" then
  		sendInfoNave(json_data.uniqueId, json_data.planetName)
  	elseif json_data.type == "naveInfo" then
  		NaveCache[json_data.planetName] = {}

  		table.insert(NaveCache[json_data.planetName], json_data)
  		sendInfoNave(json_data.uniqueId, json_data.planetName)
  	elseif json_data.type == "closeNave" then
  		naoexibir()
  	end
end

function createNaveInfo(planetInfo, uniqueId)
	exibir()
	
	for _, data in ipairs(planetInfo.planetData) do
		local uiwidgetPlanet = naveWindow.PanelPlanetList.planetList[data.name]
		uiwidgetPlanet:setTooltip("{" .. data.name .. "#3B98D1}")

		-- Selecionar e ativar informa��o que ele est� nesse planeta
		if uniqueId == data.uniqueId then
			createInfo(data)
			uiwidgetPlanet:focus()

			if youAreHere then
				youAreHere:destroy()
				youAreHere = nil
			end
			
			youAreHere = g_ui.createWidget("Label", naveWindow.PanelPlanetList.planetList)
			youAreHere:addAnchor(AnchorTop, uiwidgetPlanet:getId(), AnchorTop)
			youAreHere:addAnchor(AnchorHorizontalCenter, uiwidgetPlanet:getId(), AnchorHorizontalCenter)
			youAreHere:setText("Voce esta aqui")
			youAreHere:setFont("start_big")
			youAreHere:setColor("white")
			youAreHere:setTextAutoResize(true)
		end

		uiwidgetPlanet.onClick = function()
			createInfo(data)
		end
	end
end

function createInfo(data)
	local minimap = g_ui.createWidget("NaveMinimap", naveWindow.PanelPlanetInfo.panelMinimap)
	minimap:fill("parent")
	minimap:load()
	minimap.blockZoom = true

	for index, info in ipairs(data.infoPosition) do
		local markTeleport = g_ui.createWidget('MarkPosition')
		markTeleport:setTooltip(string.format("Distace: %d sqms\n%s", getDistance(info.position), info.tooltip))

		minimap:insertChild(1, markTeleport)
		minimap:centerInPosition(markTeleport, info.position)
		minimap:disableAutoWalk()
		
		-- levar o minimap apenas na primeira posi��o recebida do servidor
		if index == 1 then
			minimap:setCameraPosition(info.position)
			markTeleport:focus()

			naveWindow.PanelPlanetInfo.labelDistance:setText("Distancia: {" .. getDistance(info.position) .. "#3B98D1} sqms")
			naveWindow.PanelPlanetInfo.labelPrice:setText("Valor: {" .. comma_value(getMoney(data.price, getDistance(info.position))) .. "#63E571} cents")
			doTeleport(info, data.uniqueId)
		end

		markTeleport.onClick = function()
			naveWindow.PanelPlanetInfo.labelDistance:setText("Distancia: {" .. getDistance(info.position) .. "#3B98D1} sqms")
			naveWindow.PanelPlanetInfo.labelPrice:setText("PreValoro: {" .. comma_value(getMoney(data.price, getDistance(info.position))) .. "#63E571} cents")
			doTeleport(info, data.uniqueId)

			local highlightData = getNewHighlightedText(naveWindow.PanelPlanetInfo.labelDistance:getText(), "white", "#ffffff")
		    if #highlightData > 2 then
		        naveWindow.PanelPlanetInfo.labelDistance:setColoredText(highlightData)
		    end

		    local highlightData = getNewHighlightedText(naveWindow.PanelPlanetInfo.labelPrice:getText(), "white", "#ffffff")
		    if #highlightData > 2 then
		        naveWindow.PanelPlanetInfo.labelPrice:setColoredText(highlightData)
		    end	
		end
	end

	naveWindow.PanelPlanetInfo.labelName:setText(data.name)

	local highlightData = getNewHighlightedText(naveWindow.PanelPlanetInfo.labelDistance:getText(), "white", "#ffffff")
    if #highlightData > 2 then
        naveWindow.PanelPlanetInfo.labelDistance:setColoredText(highlightData)
    end

    local highlightData = getNewHighlightedText(naveWindow.PanelPlanetInfo.labelPrice:getText(), "white", "#ffffff")
    if #highlightData > 2 then
        naveWindow.PanelPlanetInfo.labelPrice:setColoredText(highlightData)
    end
end

function getDistance(fromPos)
	local player = g_game.getLocalPlayer()
	local pos = player:getPosition()

	local distance = (fromPos.x - pos.x)^2 + (fromPos.y - pos.y)^2
    return math.floor(math.sqrt(distance))
end

function getMoney(price, distance)
	local player = g_game.getLocalPlayer()
	local freeLevel = 100
	local priceDistance = 2

	return math.floor((((player:getLevel() - freeLevel) / 100) * price) + (distance * priceDistance))
end

function doTeleport(info, uniqueId)
	naveWindow.buttonTravel.onClick = function()
		g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "doTeleportNave", distance = getDistance(info.position), position = info.position, uniqueId = uniqueId, tooltip = info.tooltip}))
	end
end