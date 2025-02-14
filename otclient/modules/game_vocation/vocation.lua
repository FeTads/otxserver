local vocationWindow = nil
local changeVocationWindow = nil
local changeVocationClicked = false
local newVocationButton = nil

local GameVocationOpcode = 10
Cache_G = {}

function init()
    connect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = offline,
    })

    vocationWindow = g_ui.loadUI("vocation", modules.game_interface.getRootPanel())
	newVocationButton = modules.client_topmenu.addRightGameToggleButton('newVocationButton', tr('Change Vocation'), '/images/topbuttons/changevoc', sendInfo)
    newVocationButton:setOn(false)
	
    ProtocolGame.registerExtendedOpcode(GameVocationOpcode, onReceiveVocation)
    vocationWindow:hide()
end

function terminate()
    disconnect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = offline,
    })

	ProtocolGame.unregisterExtendedOpcode(GameVocationOpcode)
	vocationWindow:hide()
end

function exibir()
	if vocationWindow:isVisible() then
		naoexibir()
	else
    	vocationWindow:show()
	end
end

function offline()
	Cache_G = {}
end

function naoexibir()
  	vocationWindow:hide()
  	changeVocationClicked = false
	newVocationButton:setOn(false)
end

function sendInfo()
	if newVocationButton:isOn() then
		return naoexibir()
	end

	if Cache_G[1] then
		createVocationInfo(Cache_G[1])
	else
		g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "openVocation"}))
	end
end

function onReceiveVocation(protocol, opcode, payload)
	local status, json_data = pcall(function() return json.decode(payload) end)

  	if json_data.type == "update" then
  		table.insert(Cache_G, json_data)
  		createVocationInfo(json_data)
  	elseif json_data.type == "refreshCache" then

  		if Cache_G[1] then
			for index, data in ipairs(Cache_G[1].vocations) do
				if data.name == json_data.name then
					Cache_G[1].vocations[index].unlocked = true
				end
			end
		end
  	end
end

function createVocationInfo(payload)
	newVocationButton:setOn(true)
	exibir()
	if payload.type == "update" then
		vocationWindow.description:setText(payload.category[1].description)

		vocationWindow.PanelFilters:destroyChildren()

		for _, data in ipairs(payload.category) do
			local buttonCategory = g_ui.createWidget("VocationButtonCategory", vocationWindow.PanelFilters)
			buttonCategory:setText(data.category)

			buttonCategory.onClick = function()
				local children = vocationWindow.PanelVocations.VocationList:getChildren()
				vocationWindow.description:setText(payload.category[_].description)

				for index, child in ipairs(children) do

					if data.category == "Todos" then
						child:setVisible(true)
					else
			            if child:getId() == data.category then
			            	child:setVisible(true)
			            else
			            	child:setVisible(false)
			            end
					end
		        end
			end
		end

		vocationWindow.PanelVocations.VocationList:destroyChildren()
		for _, data in ipairs(payload.vocations) do
			local imageVocation = g_ui.createWidget("imageVocation", vocationWindow.PanelVocations.VocationList)
			imageVocation:setTooltip(data.name)
			imageVocation:setId(data.category)

			if data.unlocked then
				imageVocation:setImageSource("images/desbloqueado")
			else
				imageVocation:setEnabled(false)
			end

			imageVocation.imagePersonagem:setImageSource("personagens/".. data.name)
			imageVocation.vocationName:setText(data.name)

			imageVocation.onClick = function()
				doChangeVocation(data.name)
			end
		end

  	end
end

function doChangeVocation(name)
    if not changeVocationClicked then
	    if changeVocationWindow then
	        changeVocationWindow:hide()
	        changeVocationWindow = nil
	    end

    	changeVocationClicked = true

	    yesCallback = function()
		    if changeVocationWindow then
		        changeVocationWindow:hide()
		        changeVocationWindow = nil
		    end

		    changeVocationClicked = false                   
		    g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "changeVocation", name = name}))
		    naoexibir()
	    end
	        
	    noCallback = function()
	        if changeVocationWindow then
	            changeVocationWindow:hide()
	            changeVocationWindow = nil
	        end

	        changeVocationClicked = false
	    end

	    changeVocationWindow = displayGeneralBox(tr(name), tr("Deseja mudar para a vocacao " .. name .. "?"), {
	    { text=tr('Yes'), callback=yesCallback },
	    { text=tr('No'), callback=noCallback },
	    anchor=AnchorHorizontalCenter}, yesCallback, noCallback)
	end
end