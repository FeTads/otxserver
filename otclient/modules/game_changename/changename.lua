local name, searchName, buttonChange = nil
local opcodeOpenModule = 40
local Change_name = nil

function init()
	connect(g_game, {
		onGameStart = naoexibir,
		onGameEnd = naoexibir
	})
	connect(LocalPlayer, {
		onPositionChange = onPositionChange
	})


	Change_name = modules.client_topmenu.addRightGameToggleButton('Change name', tr('Change name'), '/images/topbuttons/changename', exibir)
	Change_name:setWidth(32)
	Change_name:setOn(false)
	name = g_ui.displayUI("changename", modules.game_interface.getRootPanel())
	searchName = name:getChildById("searchName")
	buttonChange = name:getChildById("changeNick")

	name:hide()
	ProtocolGame.registerExtendedOpcode(opcodeOpenModule, function (protocol, opcode, buffer)
		onReceiveChangeName(buffer)
	end)
end

function onPositionChange(creature, newPos, oldPos)
	if creature:isLocalPlayer() and name:isVisible() then
		naoexibir()
	end
end

function terminate()
	disconnect(g_game, {
		onGameStart = naoexibir,
		onGameEnd = naoexibir
	})
	disconnect(Creature, {
		onPositionChange = onPositionChange
	})
	ProtocolGame.unregisterExtendedOpcode(opcodeOpenModule)
	Change_name:setOn(false)
	name:hide()
end

function exibir()
	if name:isVisible() then
		Change_name:setOn(false)
		naoexibir()
	else
		Change_name:setOn(true)
		name:show()

		if g_game.isOnline() then
			addEvent(function ()
				g_effects.fadeIn(name, 500)
			end)
			g_game.getProtocolGame():sendExtendedOpcode(36, "changeNameOpen" .. "@")
		end
	end
end

function naoexibir()
	name:hide()
	searchName:clearText()
	Change_name:setOn(false)
end

function onReceiveChangeName(buffer)
	local param = buffer:split("@")
	local limiteCaracters = 16
	local minimoCaracters = 5

	function searchName:onTextChange(value)
		if value == "" or value == nil then
			return
		end

		if string.match(value, "%d") then
			displayErrorBox(tr("Trocar de nome"), "Você não pode colocar números em seu nome.")

			return searchName:setText("")
		end

		if limiteCaracters < #value then
			displayErrorBox(tr("Trocar de nome"), "Limite máximo de 16 caracters.")

			return searchName:setText("")
		end
	end

	function buttonChange.onClick()
		local name = searchName:getText()

		if name == nil or name == "" then
			displayErrorBox(tr("Trocar de nome"), "Você precisa digitar um nome para trocar o nome.")

			return
		end

		if #name < minimoCaracters then
			displayErrorBox(tr("Trocar de nome"), "O nome precisa ter no mínimo 5 caracters.")

			return
		end

		g_game.getProtocolGame():sendExtendedOpcode(36, "changeName" .. "@" .. "1" .. "@" .. name .. "@")
	end
end
