SpeakTypesSettings = {
	none = {},
	say = {
		color = "#FFFF00",
		speakType = MessageModes.Say
	},
	whisper = {
		color = "#FFFF00",
		speakType = MessageModes.Whisper
	},
	yell = {
		color = "#FFFF00",
		speakType = MessageModes.Yell
	},
	broadcast = {
		color = "#F55E5E",
		speakType = MessageModes.GamemasterPrivateFrom
	},
	private = {
		color = "#5FF7F7",
		private = true,
		speakType = MessageModes.PrivateTo
	},
	privateRed = {
		color = "#F55E5E",
		private = true,
		speakType = MessageModes.GamemasterTo
	},
	privatePlayerToPlayer = {
		color = "#9F9DFD",
		private = true,
		speakType = MessageModes.PrivateTo
	},
	privatePlayerToNpc = {
		color = "#9F9DFD",
		npcChat = true,
		private = true,
		speakType = MessageModes.NpcTo
	},
	privateNpcToPlayer = {
		color = "#5FF7F7",
		npcChat = true,
		private = true,
		speakType = MessageModes.NpcFrom
	},
	channelYellow = {
		color = "#FFFF00",
		speakType = MessageModes.Channel
	},
	channelWhite = {
		color = "#FFFFFF",
		speakType = MessageModes.ChannelManagement
	},
	channelRed = {
		color = "#F55E5E",
		speakType = MessageModes.GamemasterChannel
	},
	channelOrange = {
		color = "#FE6500",
		speakType = MessageModes.ChannelHighlight
	},
	monsterSay = {
		color = "#FE6500",
		hideInConsole = true,
		speakType = MessageModes.MonsterSay
	},
	monsterYell = {
		color = "#FE6500",
		hideInConsole = true,
		speakType = MessageModes.MonsterYell
	},
	rvrAnswerFrom = {
		color = "#FE6500",
		speakType = MessageModes.RVRAnswer
	},
	rvrAnswerTo = {
		color = "#FE6500",
		speakType = MessageModes.RVRAnswer
	},
	rvrContinue = {
		color = "#FFFF00",
		speakType = MessageModes.RVRContinue
	}
}
ChatStatusActivated = false
ChatControlStatus = nil
SpeakTypes = {
	[MessageModes.Say] = SpeakTypesSettings.say,
	[MessageModes.Whisper] = SpeakTypesSettings.whisper,
	[MessageModes.Yell] = SpeakTypesSettings.yell,
	[MessageModes.GamemasterBroadcast] = SpeakTypesSettings.broadcast,
	[MessageModes.PrivateFrom] = SpeakTypesSettings.private,
	[MessageModes.GamemasterPrivateFrom] = SpeakTypesSettings.privateRed,
	[MessageModes.NpcTo] = SpeakTypesSettings.privatePlayerToNpc,
	[MessageModes.NpcFrom] = SpeakTypesSettings.privateNpcToPlayer,
	[MessageModes.Channel] = SpeakTypesSettings.channelYellow,
	[MessageModes.ChannelManagement] = SpeakTypesSettings.channelWhite,
	[MessageModes.GamemasterChannel] = SpeakTypesSettings.channelRed,
	[MessageModes.ChannelHighlight] = SpeakTypesSettings.channelOrange,
	[MessageModes.MonsterSay] = SpeakTypesSettings.monsterSay,
	[MessageModes.MonsterYell] = SpeakTypesSettings.monsterYell,
	[MessageModes.RVRChannel] = SpeakTypesSettings.channelWhite,
	[MessageModes.RVRContinue] = SpeakTypesSettings.rvrContinue,
	[MessageModes.RVRAnswer] = SpeakTypesSettings.rvrAnswerFrom,
	[MessageModes.NpcFromStartBlock] = SpeakTypesSettings.privateNpcToPlayer,
	[MessageModes.Spell] = SpeakTypesSettings.none,
	[MessageModes.BarkLow] = SpeakTypesSettings.none,
	[MessageModes.BarkLoud] = SpeakTypesSettings.none
}
SayModes = {
	{
		icon = "/images/game/chat/icons/whisper",
		speakTypeDesc = "whisper"
	},
	{
		icon = "/images/game/chat/icons/say",
		speakTypeDesc = "say"
	},
	{
		icon = "/images/game/chat/icons/yell",
		speakTypeDesc = "yell"
	}
}
MAX_HISTORY = 500
MAX_LINES = 100
HELP_CHANNEL = 9
TIME_CLEAR_TEXT = 15000
chatWindow = nil
contentPanel = nil
consoleTabBar = nil
textEdit = nil
channels = nil
channelsWindow = nil
communicationWindow = nil
ownPrivateName = nil
messageHistory = {}
currentMessageIndex = 0
ignoreNpcMessages = false
defaultTab = nil
serverTab = nil
violationsChannelId = nil
violationWindow = nil
violationReportTab = nil
chatLocked = false
ignoredChannels = {}
filters = {}
local hk = false
local isOnline = false
local chatactive = true
local communicationSettings = {
	yelling = false,
	useIgnoreList = true,
	allowVIPs = false,
	useWhiteList = true,
	privateMessages = false,
	ignoredPlayers = {},
	whitelistedPlayers = {}
}
local options = {
	chatAlwaysActive = false,
	classicChat = false,
	chatAlwaysActiveEnableWASD = false,
	backgroundAlwaysVisible = false
}

function init()
	connect(g_game, {
		onTalk = onTalk,
		onChannelList = onChannelList,
		onOpenChannel = onOpenChannel,
		onOpenPrivateChannel = onOpenPrivateChannel,
		onOpenOwnPrivateChannel = onOpenOwnPrivateChannel,
		onCloseChannel = onCloseChannel,
		onRuleViolationChannel = onRuleViolationChannel,
		onRuleViolationRemove = onRuleViolationRemove,
		onRuleViolationCancel = onRuleViolationCancel,
		onRuleViolationLock = onRuleViolationLock,
		onGameEnd = onGameEnd,
		onGameStart = onGameStart
	})

	chatWindow = g_ui.loadUI("chat", modules.game_interface.getRootPanel())
	configWindow = g_ui.loadUI("config", modules.game_interface.getRootPanel())
	allchat = g_ui.loadUI("allchat", modules.game_interface.getRootPanel())
	configWindow.configsContent.chatAlwaysActive.tooltip = "Essa opção desabilita o WASD."
	configWindow.configsContent.chatAlwaysActiveEnableWASD.tooltip = "Essa opção ativa o WASD quando o seu chat está com a opção chatAlwaysActive ativa."
	allchatPanel = allchat.consoleBuffer

	allchat:fill("chat")

	textEdit = chatWindow.textEdit
	contentPanel = chatWindow.contentPanel
	consoleTabBar = chatWindow.consoleTabBar

	consoleTabBar:setContentWidget(contentPanel)
	consoleTabBar:setTabSpacing(1)

	chatTextLineWindow = chatWindow.textLineWindow
	chatEnterBackground = chatWindow.enterBackground
	backgroundEmotes = chatWindow.backgroundEmotes
	emotesPanel = chatWindow.backgroundEmotes.Emotes
	EmotesButton = chatWindow.EmotesButton

	function chatWindow:onGeometryChange()
		chatTextLineWindow:setHeight(self:getHeight() - 75)
		chatTextLineWindow:setWidth(self:getWidth() - 47)
		chatEnterBackground:setWidth(self:getWidth() - 36)
	end

	chatWindow.rB:setMaximum(1000)
	chatWindow.rB:setMinimum(245)
	chatWindow.rB2:setMaximum(600)
	chatWindow.rB2:setMinimum(140)

	chatWindow.rB3.inverted = true

	chatWindow.rB3:setMaximum(600)
	chatWindow.rB3:setMinimum(140)

	chatWindow.rB4.inverted = true

	chatWindow.rB4:setMaximum(1000)
	chatWindow.rB4:setMinimum(245)

	chatWindow.closeChannelButton.tooltip = tr("Close this channel") .. " (Ctrl + E)"
	chatWindow.clearChannelButton.tooltip = tr("Clear current message window")
	chatWindow.channelsButton.tooltip = tr("Open new channel") .. " (Ctrl+O)"
	chatWindow.ignoreButton.tooltip = tr("Ignore players")
	chatWindow.sayModeButton.tooltip = tr("Adjust volume")

	hide()

	channels = {}

	function chatWindow:onKeyPress(keyCode, keyboardModifiers)
		if keyboardModifiers ~= KeyboardCtrlModifier or keyCode ~= KeyC then
			return false
		end

		local tab = consoleTabBar:getCurrentTab()

		if not tab then
			return false
		end

		local consoleBuffer = tab.tabPanel.consoleBuffer

		if not consoleBuffer then
			return false
		end

		local consoleLabel = consoleBuffer:getFocusedChild()

		if not consoleLabel or not consoleLabel:hasSelection() then
			return false
		end

		g_window.setClipboardText(consoleLabel:getSelection())

		return true
	end

	g_keyboard.bindKeyPress("Shift+Up", function ()
		navigateMessageHistory(1)
	end, chatWindow)
	g_keyboard.bindKeyPress("Shift+Down", function ()
		navigateMessageHistory(-1)
	end, chatWindow)
	g_keyboard.bindKeyPress("Tab", function ()
		consoleTabBar:selectNextTab()
	end, chatWindow)
	g_keyboard.bindKeyPress("Shift+Tab", function ()
		consoleTabBar:selectPrevTab()
	end, chatWindow)
	g_keyboard.bindKeyPress("Ctrl+A", function ()
		textEdit:clearText()
	end, consolePanel)
	g_keyboard.bindKeyDown("Ctrl+O", g_game.requestChannels)
	g_keyboard.bindKeyDown("Ctrl+E", removeCurrentTab)
	g_keyboard.bindKeyDown("Ctrl+H", openHelp)
	consoleTabBar:setNavigation(chatWindow.prevChannelButton, chatWindow.nextChannelButton)

	consoleTabBar.onTabChange = onTabChange

	load()
	chatWindow:setVisible(false)
end

function isActive()
	return chatWindow:isFocusable()
end

function doToggleAllChat()
	if chatWindow:isVisible() then
		allchat:setVisible(false)
	else
		allchat:setVisible(true)
	end
end

function doSendCurrentMessageBtn()
	local message = textEdit:getText()

	if #message == 0 or not isActive() then
		return true
	end

	doCloseWindowEmoticons()
	sendCurrentMessage()
end

function sendCurrentMessage()
	local message = textEdit:getText()

	if #message == 0 or not isActive() then
		toggleChat()
		doToggleAllChat()

		return
	end

	textEdit:clearText()
	sendMessage(message)

	if options.classicChat == false then
		toggleChat()
		doToggleAllChat()
	end
end

function sendMessage(message, tab)
	local tab = tab or getCurrentTab()

	if not tab then
		return
	end

	for k, func in pairs(filters) do
		if func(message) then
			return true
		end
	end

	local name = tab:getText()

	if tab == serverTab or tab == getRuleViolationsTab() then
		tab = defaultTab
		name = defaultTab:getText()
	end

	local channel = tab.channelId
	local originalMessage = message
	local chatCommandSayMode, chatCommandPrivate, chatCommandPrivateReady, chatCommandMessage = nil
	chatCommandMessage = message:match("^%#[y|Y] (.*)")

	if chatCommandMessage ~= nil then
		chatCommandSayMode = "yell"
		channel = 0
		message = chatCommandMessage
	end

	local chatCommandMessage = message:match("^%#[w|W] (.*)")

	if chatCommandMessage ~= nil then
		chatCommandSayMode = "whisper"
		message = chatCommandMessage
		channel = 0
	end

	local chatCommandMessage = message:match("^%#[s|S] (.*)")

	if chatCommandMessage ~= nil then
		chatCommandSayMode = "say"
		message = chatCommandMessage
		channel = 0
	end

	local findIni, findEnd, chatCommandInitial, chatCommandPrivate, chatCommandEnd, chatCommandMessage = message:find("([%*%@])(.+)([%*%@])(.*)")

	if findIni ~= nil and findIni == 1 and chatCommandInitial == chatCommandEnd then
		chatCommandPrivateRepeat = false

		if chatCommandInitial == "*" then
			setTextEditText("*" .. chatCommandPrivate .. "* ")
		end

		message = chatCommandMessage:trim()
		chatCommandPrivateReady = true
	end

	message = message:gsub("^(%s*)(.*)", "%2")

	if #message == 0 then
		return
	end

	currentMessageIndex = 0

	if #messageHistory == 0 or messageHistory[#messageHistory] ~= originalMessage then
		table.insert(messageHistory, originalMessage)

		if MAX_HISTORY < #messageHistory then
			table.remove(messageHistory, 1)
		end
	end

	local speaktypedesc = nil

	if (channel or tab == defaultTab) and not chatCommandPrivateReady then
		if tab == defaultTab then
			speaktypedesc = chatCommandSayMode or SayModes[chatWindow.sayModeButton.sayMode].speakTypeDesc

			if speaktypedesc ~= "say" then
				sayModeChange(2)
			end
		else
			speaktypedesc = chatCommandSayMode or "channelYellow"
		end

		g_game.talkChannel(SpeakTypesSettings[speaktypedesc].speakType, channel, message)

		return
	else
		local isPrivateCommand = false
		local priv = true
		local tabname = name

		if chatCommandPrivateReady then
			speaktypedesc = "privatePlayerToPlayer"
			name = chatCommandPrivate
			isPrivateCommand = true
		elseif tab.npcChat then
			speaktypedesc = "privatePlayerToNpc"
		elseif tab == violationReportTab then
			if violationReportTab.locked then
				modules.game_textmessage.displayFailureMessage("Wait for a gamemaster reply.")

				return
			end

			speaktypedesc = "rvrContinue"
			tabname = tr("Report Rule") .. "..."
		elseif tab.violationChatName then
			speaktypedesc = "rvrAnswerTo"
			name = tab.violationChatName
			tabname = tab.violationChatName .. "'..."
		else
			speaktypedesc = "privatePlayerToPlayer"
		end

		local speaktype = SpeakTypesSettings[speaktypedesc]
		local player = g_game.getLocalPlayer()

		g_game.talkPrivate(speaktype.speakType, name, message)

		message = applyMessagePrefixies(g_game.getCharacterName(), player:getLevel(), message)

		addPrivateText(message, speaktype, tabname, isPrivateCommand, g_game.getCharacterName())
	end
end

function sayModeChange(sayMode)
	local buttom = chatWindow.sayModeButton

	if sayMode == nil then
		sayMode = buttom.sayMode + 1
	end

	if sayMode > #SayModes then
		sayMode = 1
	end

	buttom:setIcon(SayModes[sayMode].icon)

	buttom.sayMode = sayMode
end

function getOwnPrivateTab()
	if not ownPrivateName then
		return
	end

	return getTab(ownPrivateName)
end

function setIgnoreNpcMessages(ignore)
	ignoreNpcMessages = ignore
end

function navigateMessageHistory(step)
	local numCommands = #messageHistory

	if numCommands > 0 then
		currentMessageIndex = math.min(math.max(currentMessageIndex + step, 0), numCommands)

		if currentMessageIndex > 0 then
			local command = messageHistory[numCommands - currentMessageIndex + 1]

			setTextEditText(command)
		else
			textEdit:clearText()
		end
	end
end

function clearChannel(consoleTabBar)
	consoleTabBar:getCurrentTab().tabPanel.consoleBuffer:destroyChildren()
end

function setTextEditText(text)
	textEdit:setText(text)
	textEdit:setCursorPos(-1)
end

function openHelp()
	local helpChannel = 9

	if g_game.getClientVersion() <= 810 then
		helpChannel = 8
	end

	g_game.joinChannel(helpChannel)
end

function openPlayerReportRuleViolationWindow()
	if violationWindow or violationReportTab then
		return
	end

	violationWindow = g_ui.loadUI("violationwindow", rootWidget)

	function violationWindow.onEscape()
		violationWindow:destroy()

		violationWindow = nil
	end

	function violationWindow.onEnter()
		local text = violationWindow.text:getText()

		g_game.talkChannel(MessageModes.RVRChannel, 0, text)

		violationReportTab = addTab(tr("Report Rule") .. "...", true)

		addTabText(tr("Please wait patiently for a gamemaster to reply") .. ".", SpeakTypesSettings.privateRed, violationReportTab)
		addTabText(applyMessagePrefixies(g_game.getCharacterName(), 0, text), SpeakTypesSettings.say, violationReportTab, g_game.getCharacterName())

		violationReportTab.locked = true

		violationWindow:destroy()

		violationWindow = nil
	end
end

function addTab(name, focus)
	local tab = getTab(name)

	if tab then
		if not focus then
			focus = true
		end
	else
		tab = consoleTabBar:addTab(name, nil, processChannelTabMenu)

		tab:setImageSource("/images/game/chat/channelButtons")
	end

	if focus then
		consoleTabBar:selectTab(tab)
	end

	return tab
end

function removeTab(tab)
	if type(tab) == "string" then
		tab = consoleTabBar:getTab(tab)
	end

	if tab == defaultTab or tab == serverTab then
		return
	end

	if tab == violationReportTab then
		g_game.cancelRuleViolation()

		violationReportTab = nil
	elseif tab.violationChatName then
		g_game.closeRuleViolation(tab.violationChatName)
	elseif tab.channelId then
		for k, v in pairs(channels) do
			if k == tab.channelId then
				channels[k] = nil
			end
		end

		g_game.leaveChannel(tab.channelId)
	elseif tab:getText() == "NPCs" then
		g_game.closeNpcChannel()
	end

	consoleTabBar:removeTab(tab)
end

function removeCurrentTab()
	removeTab(consoleTabBar:getCurrentTab())
	consoleTabBar:selectTab(defaultTab)
end

function getTab(name)
	return consoleTabBar:getTab(name)
end

function getChannelTab(channelId)
	local channel = channels[channelId]

	if channel then
		return getTab(channel)
	end

	return nil
end

function getRuleViolationsTab()
	if violationsChannelId then
		return getChannelTab(violationsChannelId)
	end

	return nil
end

function getCurrentTab()
	return consoleTabBar:getCurrentTab()
end

function addChannel(name, id)
	channels[id] = name
	local focus = not table.find(ignoredChannels, id)
	local tab = addTab(name, focus)
	tab.channelId = id

	return tab
end

function addPrivateChannel(receiver)
	channels[receiver] = receiver

	return addTab(receiver, false)
end

function addPrivateText(text, speaktype, name, isPrivateCommand, creatureName)
	local focus = false

	if speaktype.npcChat then
		name = "NPCs"
		focus = true
	end

	local privateTab = getTab(name)

	if privateTab == nil then
		if modules.client_options.getOption("showPrivateMessagesInConsole") and not focus or isPrivateCommand and not privateTab then
			privateTab = defaultTab
		else
			privateTab = addTab(name, focus)
			channels[name] = name
		end

		privateTab.npcChat = speaktype.npcChat
	elseif focus then
		consoleTabBar:selectTab(privateTab)
	end

	addTabText(text, speaktype, privateTab, creatureName)
end

function addText(text, speaktype, tabName, creatureName)
	local tab = getTab(tabName)

	if tab ~= nil then
		addTabText(text, speaktype, tab, creatureName)
	end
end

local letterWidth = {
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	1,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	nil,
	1,
	3,
	6,
	8,
	7,
	13,
	9,
	3,
	5,
	5,
	6,
	8,
	4,
	5,
	3,
	8,
	7,
	6,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	3,
	4,
	8,
	8,
	8,
	6,
	10,
	9,
	7,
	7,
	8,
	7,
	7,
	8,
	8,
	5,
	5,
	7,
	7,
	9,
	8,
	8,
	7,
	8,
	8,
	7,
	8,
	8,
	8,
	12,
	8,
	8,
	7,
	5,
	8,
	5,
	9,
	8,
	5,
	7,
	7,
	6,
	7,
	7,
	5,
	7,
	7,
	3,
	4,
	7,
	3,
	11,
	7,
	7,
	7,
	7,
	6,
	6,
	5,
	7,
	8,
	10,
	8,
	8,
	6,
	7,
	4,
	7,
	8,
	1,
	7,
	6,
	3,
	7,
	6,
	11,
	7,
	7,
	7,
	13,
	7,
	4,
	11,
	6,
	6,
	6,
	6,
	4,
	3,
	7,
	6,
	6,
	7,
	10,
	7,
	10,
	6,
	5,
	11,
	6,
	6,
	8,
	4,
	3,
	7,
	7,
	7,
	8,
	4,
	7,
	6,
	10,
	6,
	8,
	8,
	16,
	10,
	8,
	5,
	8,
	5,
	5,
	6,
	7,
	7,
	3,
	5,
	6,
	6,
	8,
	12,
	12,
	12,
	6,
	9,
	9,
	9,
	9,
	9,
	9,
	11,
	7,
	7,
	7,
	7,
	7,
	5,
	5,
	6,
	5,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	8,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	11,
	6,
	7,
	7,
	7,
	7,
	3,
	4,
	4,
	4,
	7,
	7,
	7,
	7,
	7,
	7,
	7,
	9,
	7,
	7,
	7,
	7,
	7,
	8,
	7,
	8
}

function applyMessagePrefixies(name, level, message)
	if name then
		if modules.client_options.getOption("showLevelsInConsole") and level > 0 then
			message = name .. " [" .. level .. "]: " .. message
		else
			message = name .. ": " .. message
		end
	end

	return message
end

function getHighlightedText(text)
	local tmpData = {}

	repeat
		local tmp = {
			string.find(text, "{([^}]+)}", tmpData[#tmpData - 1])
		}

		for _, v in pairs(tmp) do
			table.insert(tmpData, v)
		end
	until not string.find(text, "{([^}]+)}", tmpData[#tmpData - 1])

	return tmpData
end

function addTabText(text, speaktype, tab, creatureName)
	if not tab or tab.locked or not text or #text == 0 then
		return
	end

	if modules.client_options.getOption("showTimestampsInConsole") then
		text = os.date("%H:%M") .. " " .. text
	end

	local panel = consoleTabBar:getTabPanel(tab)
	local consoleBuffer = panel.consoleBuffer
	local label = g_ui.createWidget("ConsoleLabel", consoleBuffer)

	label:setId("consoleLabel" .. consoleBuffer:getChildCount())
	label:setText(text)
	label:setColor(speaktype.color)

	local highlightData = getNewHighlightedText(text, speaktype.color, "#ffffff")

	if #highlightData > 2 then
		label:setColoredText(highlightData)
	end

	if not ChatStatusActivated then
		ChatStatusActivated = true
		local label2 = g_ui.createWidget("ConsoleLabel", allchatPanel)

		label2:setId("consoleLabel" .. consoleBuffer:getChildCount())
		label2:setText(text)

		local highlightData = getNewHighlightedText(text, speaktype.color, "#ffffff")

		if #highlightData > 2 then
			label:setColoredText(highlightData)
		end

		label2:setColor(speaktype.color)
		g_effects.fadeIn(label2, 350)
		scheduleEvent(function ()
			g_effects.fadeOut(label2, 350)
			scheduleEvent(function ()
				label2:destroy()

				label2 = nil
			end, 500)
		end, TIME_CLEAR_TEXT + 550)
	end

	consoleTabBar:blinkTab(tab)

	if speaktype.npcChat and (g_game.getCharacterName() ~= creatureName or g_game.getCharacterName() == "Account Manager") then
		local highlightData = getHighlightedText(text)

		if #highlightData > 0 then
			local labelHighlight = g_ui.createWidget("ConsolePhantomLabel", label)

			labelHighlight:fill("parent")
			labelHighlight:setId("consoleLabelHighlight" .. consoleBuffer:getChildCount())
			labelHighlight:setColor("#1f9ffe")

			for i = 1, #highlightData / 3 do
				local dataBlock = {
					_start = highlightData[(i - 1) * 3 + 1],
					_end = highlightData[(i - 1) * 3 + 2],
					words = highlightData[(i - 1) * 3 + 3]
				}
				text = text:gsub("%{(.-)%}", dataBlock.words, 1)
				highlightData[(i - 1) * 3 + 1] = dataBlock._start - (i - 1) * 2
				highlightData[(i - 1) * 3 + 2] = dataBlock._end - (1 + (i - 1) * 2)
			end

			label:setText(text)

			local drawText = label:getDrawText()
			local tmpText = ""

			for i = 1, #highlightData / 3 do
				local dataBlock = {
					_start = highlightData[(i - 1) * 3 + 1],
					_end = highlightData[(i - 1) * 3 + 2],
					words = highlightData[(i - 1) * 3 + 3]
				}
				local lastBlockEnd = highlightData[(i - 2) * 3 + 2] or 1

				for letter = lastBlockEnd, dataBlock._start - 1 do
					local tmpChar = string.byte(drawText:sub(letter, letter))
					local fillChar = (tmpChar == 10 or tmpChar == 32) and string.char(tmpChar) or string.char(127)
					tmpText = tmpText .. string.rep(fillChar, letterWidth[tmpChar])
				end

				tmpText = tmpText .. dataBlock.words
			end

			local finalBlockEnd = highlightData[(#highlightData / 3 - 1) * 3 + 2] or 1

			for letter = finalBlockEnd, drawText:len() do
				local tmpChar = string.byte(drawText:sub(letter, letter))
				local fillChar = (tmpChar == 10 or tmpChar == 32) and string.char(tmpChar) or string.char(127)
				tmpText = tmpText .. string.rep(fillChar, letterWidth[tmpChar])
			end

			labelHighlight:setText(tmpText)
		end
	end

	label.name = creatureName

	function label:onMouseRelease(mousePos, mouseButton)
		processMessageMenu(mousePos, mouseButton, creatureName, text, self, tab)
	end

	if MAX_LINES < consoleBuffer:getChildCount() then
		consoleBuffer:getFirstChild():destroy()
	end
end

function removeTabLabelByName(tab, name)
	local panel = consoleTabBar:getTabPanel(tab)
	local consoleBuffer = panel.consoleBuffer

	for _, label in pairs(consoleBuffer:getChildren()) do
		if label.name == name then
			label:destroy()
		end
	end
end

function processChannelTabMenu(tab, mousePos, mouseButton)
	local menu = g_ui.createWidget("PopupMenu")
	channelName = tab:getText()

	if tab ~= defaultTab and tab ~= serverTab then
		menu:addOption(tr("Close"), function ()
			removeTab(channelName)
		end)
		menu:addSeparator()
	end

	if consoleTabBar:getCurrentTab() == tab then
		menu:addOption(tr("Clear Messages"), function ()
			clearChannel(consoleTabBar)
		end)
	end

	menu:display(mousePos)
end

function processMessageMenu(mousePos, mouseButton, creatureName, text, label, tab)
	if mouseButton == MouseRightButton then
		local menu = g_ui.createWidget("PopupMenu")

		if creatureName and #creatureName > 0 then
			if creatureName ~= g_game.getCharacterName() then
				menu:addOption(tr("Message to " .. creatureName), function ()
					g_game.openPrivateChannel(creatureName)
				end)

				if not g_game.getLocalPlayer():hasVip(creatureName) then
					menu:addOption(tr("Add to VIP list"), function ()
						g_game.addVip(creatureName)
					end)
				end

				if modules.game_chat.getOwnPrivateTab() then
					menu:addSeparator()
					menu:addOption(tr("Invite to private chat"), function ()
						g_game.inviteToOwnChannel(creatureName)
					end)
					menu:addOption(tr("Exclude from private chat"), function ()
						g_game.excludeFromOwnChannel(creatureName)
					end)
				end

				if isIgnored(creatureName) then
					menu:addOption(tr("Unignore") .. " " .. creatureName, function ()
						removeIgnoredPlayer(creatureName)
					end)
				else
					menu:addOption(tr("Ignore") .. " " .. creatureName, function ()
						addIgnoredPlayer(creatureName)
					end)
				end

				menu:addSeparator()
			end

			if modules.game_ruleviolation.hasWindowAccess() then
				menu:addOption(tr("Rule Violation"), function ()
					modules.game_ruleviolation.show(creatureName, text:match(".+%:%s(.+)"))
				end)
				menu:addSeparator()
			end

			menu:addOption(tr("Copy name"), function ()
				g_window.setClipboardText(creatureName)
			end)
		end

		if label:hasSelection() then
			menu:addOption(tr("Copy"), function ()
				g_window.setClipboardText(label:getSelection())
			end, "(Ctrl+C)")
		end

		menu:addOption(tr("Copy message"), function ()
			g_window.setClipboardText(text)
		end)
		menu:addOption(tr("Select all"), function ()
			label:selectAll()
		end)

		if tab.violations then
			menu:addSeparator()
			menu:addOption(tr("Process") .. " " .. creatureName, function ()
				processViolation(creatureName, text)
			end)
			menu:addOption(tr("Remove") .. " " .. creatureName, function ()
				g_game.closeRuleViolation(creatureName)
			end)
		end

		menu:display(mousePos)
	end
end

function terminate()
	disconnect(g_game, {
		onTalk = onTalk,
		onChannelList = onChannelList,
		onOpenChannel = onOpenChannel,
		onOpenPrivateChannel = onOpenPrivateChannel,
		onOpenOwnPrivateChannel = onOpenPrivateChannel,
		onCloseChannel = onCloseChannel,
		onRuleViolationChannel = onRuleViolationChannel,
		onRuleViolationRemove = onRuleViolationRemove,
		onRuleViolationCancel = onRuleViolationCancel,
		onRuleViolationLock = onRuleViolationLock,
		onGameEnd = onGameEnd,
		onGameStart = onGameStart
	})
	chatWindow:destroy()
end

function save()
	local settings = {
		messageHistory = messageHistory
	}

	g_settings.setNode("game_chat", settings)
end

function load()
	local settings = g_settings.getNode("game_chat")

	if settings then
		messageHistory = settings.messageHistory or {}
	end

	loadCommunicationSettings()
end

function onTabChange(tabBar, tab)
	if tab == defaultTab or tab == serverTab then
		chatWindow.closeChannelButton:disable()
	else
		chatWindow.closeChannelButton:enable()
	end
end

function clear()
	local lastChannelsOpen = g_settings.getNode("lastChannelsOpen") or {}
	local char = g_game.getCharacterName()
	local savedChannels = {}
	local set = false

	for channelId, channelName in pairs(channels) do
		if type(channelId) == "number" then
			savedChannels[channelName] = channelId
			set = true
		end
	end

	if set then
		lastChannelsOpen[char] = savedChannels
	else
		lastChannelsOpen[char] = nil
	end

	g_settings.setNode("lastChannelsOpen", lastChannelsOpen)

	for _, channelName in pairs(channels) do
		local tab = consoleTabBar:getTab(channelName)

		consoleTabBar:removeTab(tab)
	end

	channels = {}

	consoleTabBar:removeTab(defaultTab)
	consoleTabBar:removeTab(serverTab)

	local npcTab = consoleTabBar:getTab("NPCs")

	if npcTab then
		consoleTabBar:removeTab(npcTab)
	end

	if violationReportTab then
		consoleTabBar:removeTab(violationReportTab)

		violationReportTab = nil
	end

	textEdit:clearText()

	if violationWindow then
		violationWindow:destroy()

		violationWindow = nil
	end

	if channelsWindow then
		channelsWindow:destroy()

		channelsWindow = nil
	end
end

function onGameStart()
	isOnline = true
	defaultTab = addTab(tr("Default"), true)
	serverTab = addTab(tr("Server Log"), false)

	if g_game.getClientVersion() < 862 then
		g_keyboard.bindKeyDown("Ctrl+R", openPlayerReportRuleViolationWindow)
	end

	local lastChannelsOpen = g_settings.getNode("lastChannelsOpen")

	if lastChannelsOpen then
		local savedChannels = lastChannelsOpen[g_game.getCharacterName()]

		if savedChannels then
			for channelName, channelId in pairs(savedChannels) do
				channelId = tonumber(channelId)

				if channelId ~= -1 and channelId < 100 and not table.find(channels, channelId) then
					g_game.joinChannel(channelId)
					table.insert(ignoredChannels, channelId)
				end
			end
		end
	end

	scheduleEvent(function ()
		ignoredChannels = {}
	end, 3000)

	local lB = chatWindow.lockButton

	if chatLocked then
		chatWindow:setPhantom(true)
		enableResize(false)
		lB:setImageSource("/images/game/chat/lockSmall")

		function lB.onHoverChange(s, h)
			if h then
				s:setImageSource("/images/game/chat/unlockSmall")
			else
				s:setImageSource("/images/game/chat/lockSmall")
			end
		end
	else
		chatWindow:setPhantom(false)

		if not options.classicChat then
			enableResize(true)
		end

		lB:setImageSource("/images/game/chat/unlockSmall")

		function lB.onHoverChange(s, h)
			if h then
				s:setImageSource("/images/game/chat/lockSmall")
			else
				s:setImageSource("/images/game/chat/unlockSmall")
			end
		end
	end

	local cB = chatWindow.configButton

	cB:setImageSource("/images/game/chat/configSmall")
	show()
end

function enableResize(e)
	if e then
		chatWindow.rB:setVisible(true)
		chatWindow.rB2:setVisible(true)
		chatWindow.rB3:setVisible(true)
		chatWindow.rB4:setVisible(true)
	else
		chatWindow.rB:setVisible(false)
		chatWindow.rB2:setVisible(false)
		chatWindow.rB3:setVisible(false)
		chatWindow.rB4:setVisible(false)
	end
end

function onGameEnd()
	isOnline = false

	hide()
	clear()
end

function clickLockButton()
	local lB = chatWindow.lockButton

	if chatLocked then
		if not options.classicChat then
			chatWindow:setPhantom(false)
			enableResize(true)
		end

		lB:setImageSource("/images/game/chat/lockSmall")

		function lB.onHoverChange(s, h)
			if h then
				s:setImageSource("/images/game/chat/lockSmall")
			else
				s:setImageSource("/images/game/chat/unlockSmall")
			end
		end

		chatLocked = false
	else
		chatWindow:setPhantom(true)
		enableResize(false)
		lB:setImageSource("/images/game/chat/unlockSmall")

		function lB.onHoverChange(s, h)
			if h then
				s:setImageSource("/images/game/chat/unlockSmall")
			else
				s:setImageSource("/images/game/chat/lockSmall")
			end
		end

		chatLocked = true
	end
end

function onTalk(name, level, mode, message, channelId, creaturePos)
	if mode == 44 then
		ChatStatusActivated = true
	else
		ChatStatusActivated = false
	end

	if mode == MessageModes.GamemasterBroadcast then
		modules.game_textmessage.displayBroadcastMessage(name .. ": " .. message)

		return
	end

	if ignoreNpcMessages and mode == MessageModes.NpcFrom then
		return
	end

	speaktype = SpeakTypes[mode]

	if not speaktype then
		perror("unhandled onTalk message mode " .. mode .. ": " .. message)

		return
	end

	local localPlayer = g_game.getLocalPlayer()

	if name ~= g_game.getCharacterName() and isUsingIgnoreList() and not isUsingWhiteList() or isUsingWhiteList() and not isWhitelisted(name) and (not isAllowingVIPs() or not localPlayer:hasVip(name)) then
		if mode == MessageModes.Yell and isIgnoringYelling() then
			return
		elseif speaktype.private and isIgnoringPrivate() and mode ~= MessageModes.NpcFrom then
			return
		elseif isIgnored(name) then
			return
		end
	end

	if mode == MessageModes.RVRChannel then
		channelId = violationsChannelId
	end

	if (mode == MessageModes.Say or mode == MessageModes.Whisper or mode == MessageModes.Yell or mode == MessageModes.Spell or mode == MessageModes.MonsterSay or mode == MessageModes.MonsterYell or mode == MessageModes.NpcFrom or mode == MessageModes.BarkLow or mode == MessageModes.BarkLoud) and creaturePos then
		local staticMessage = message

		if mode == MessageModes.NpcFrom then
			local highlightData = getHighlightedText(staticMessage)

			if #highlightData > 0 then
				for i = 1, #highlightData / 3 do
					local dataBlock = {
						_start = highlightData[(i - 1) * 3 + 1],
						_end = highlightData[(i - 1) * 3 + 2],
						words = highlightData[(i - 1) * 3 + 3]
					}
					staticMessage = staticMessage:gsub("{" .. dataBlock.words .. "}", dataBlock.words)
				end
			end
		end

		local staticText = StaticText.create()

		staticText:addMessage(name, mode, staticMessage)
		g_map.addThing(staticText, creaturePos, -1)
	end

	local defaultMessage = mode <= 3 and true or false

	if speaktype == SpeakTypesSettings.none then
		return
	end

	if speaktype.hideInConsole then
		return
	end

	local composedMessage = applyMessagePrefixies(name, level, message)

	if mode == MessageModes.RVRAnswer then
		violationReportTab.locked = false

		addTabText(composedMessage, speaktype, violationReportTab, name)
	elseif mode == MessageModes.RVRContinue then
		addText(composedMessage, speaktype, name .. "'...", name)
	elseif speaktype.private then
		addPrivateText(composedMessage, speaktype, name, false, name)

		if modules.client_options.getOption("showPrivateMessagesOnScreen") and speaktype ~= SpeakTypesSettings.privateNpcToPlayer then
			modules.game_textmessage.displayPrivateMessage(name .. ":\n" .. message)
		end
	else
		local channel = tr("Default")

		if not defaultMessage then
			channel = channels[channelId]
		end

		if channel then
			ChatControlStatus = mode

			addText(composedMessage, speaktype, channel, name)
		else
			pwarning("message in channel id " .. channelId .. " which is unknown, this is a server bug, relogin if you want to see messages in this channel")
		end
	end
end

function onOpenChannel(channelId, channelName)
	addChannel(channelName, channelId)
end

function onOpenPrivateChannel(receiver)
	addPrivateChannel(receiver)
end

function onOpenOwnPrivateChannel(channelId, channelName)
	local privateTab = getTab(channelName)

	if privateTab == nil then
		addChannel(channelName, channelId)
	end

	ownPrivateName = channelName
end

function onCloseChannel(channelId)
	local channel = channels[channelId]

	if channel then
		local tab = getTab(channel)

		if tab then
			consoleTabBar:removeTab(tab)
		end

		for k, v in pairs(channels) do
			if k == tab.channelId then
				channels[k] = nil
			end
		end
	end
end

function processViolation(name, text)
	local tabname = name .. "'..."
	local tab = addTab(tabname, true)
	channels[tabname] = tabname
	tab.violationChatName = name

	g_game.openRuleViolation(name)
	addTabText(text, SpeakTypesSettings.say, tab, name)
end

function onRuleViolationChannel(channelId)
	violationsChannelId = channelId
	local tab = addChannel(tr("Rule Violations"), channelId)
	tab.violations = true
end

function onRuleViolationRemove(name)
	local tab = getRuleViolationsTab()

	if not tab then
		return
	end

	removeTabLabelByName(tab, name)
end

function onRuleViolationCancel(name)
	local tab = getTab(name .. "'...")

	if not tab then
		return
	end

	addTabText(tr("%s has finished the request", name) .. ".", SpeakTypesSettings.privateRed, tab)

	tab.locked = true
end

function onRuleViolationLock()
	if not violationReportTab then
		return
	end

	violationReportTab.locked = false

	addTabText(tr("Your request has been closed") .. ".", SpeakTypesSettings.privateRed, violationReportTab)

	violationReportTab.locked = true
end

function show()
	local player = g_game.getLocalPlayer()

	if not chatWindow:isVisible() or chatWindow:getOpacity() < 0.95 then
		addEvent(function ()
			g_effects.fadeIn(chatWindow, 250, 0, 237.5)
		end)
	end

	chatWindow:show()

	return true
end

function showConfigs()
	configWindow:show()

	local cC = configWindow.configsContent
	local oBAV = cC.backgroundAlwaysVisible
	local oCC = cC.classicChat
	local oCAA = cC.chatAlwaysActive
	local WASD = cC.chatAlwaysActiveEnableWASD

	WASD:setEnabled(oBAV:isChecked())
	oCC:setEnabled(oBAV:isChecked())
	oCAA:setEnabled(oBAV:isChecked())
end

function hideConfigs()
	configWindow:hide()
end

function clickConfigButton()
	if configWindow:isVisible() then
		configWindow:hide()
	else
		showConfigs()
	end
end

function getrB3()
	return chatWindow.backgroundkeys
end

function setOption(key, value, force)
	if not force and options[key] == value then
		return
	end

	local gameMapPanel = modules.game_interface.getMapPanel()

	if key == "backgroundAlwaysVisible" then
		configWindow.configsContent.classicChat:setEnabled(value)
		configWindow.configsContent.chatAlwaysActive:setEnabled(value)
		configWindow.configsContent.chatAlwaysActiveEnableWASD:setEnabled(value)

		if not value then
			options.classicChat = value
			options.chatAlwaysActive = value
			options.chatAlwaysActiveEnableWASD = value
		end
	elseif key == "classicChat" then
		modules.game_interface.getBottomPanel():setOn(value)

		local cSB = chatWindow:recursiveGetChildById("consoleScrollBar")

		if value then
			chatWindow:fill("gameBottomPanel")
			cSB:setMarginBottom(22)
			enableResize(false)
			chatWindow:setDraggable(false)
			modules.game_interface.bottomSplitter:setVisible(true)
		else
			chatWindow:setSize("551 255")
			chatWindow:removeAnchor(AnchorTop)
			chatWindow:removeAnchor(AnchorRight)
			chatWindow:addAnchor(AnchorBottom, "parent", AnchorBottom)
			chatWindow:addAnchor(AnchorLeft, "parent", AnchorLeft)
			cSB:setMarginBottom(0)
			enableResize(true)
			chatWindow:setDraggable(true)
			modules.game_interface.bottomSplitter:setVisible(false)
		end

		chatWindow:setPhantom(value)
	elseif key == "showFps" then
		modules.client_topmenu.setFpsVisible(value)
		modules.client_botmenu.setFpsVisible(value)
	elseif key == "fullscreen" then
		g_window.setFullscreen(value)
	end

	g_settings.set(key, value)

	if configWindow.configsContent.chatAlwaysActiveEnableWASD:isChecked() then
		modules.game_walking.enableWSAD()
	elseif configWindow.configsContent.chatAlwaysActive:isChecked() then
		modules.game_walking.disableWSAD()
	end

	options[key] = value
end

function getOption(key)
	return options[key]
end

function toggleChat()
	local gameInterface = modules.game_interface

	if isActive() and not configWindow.configsContent.chatAlwaysActive:isChecked() then
		modules.game_walking.enableWSAD()
	end

	if not isActive() then
		modules.game_walking.disableWSAD()
		chatWindow:setFocusable(true)
		chatWindow:setVisible(true)
		chatWindow:focus()

		hk = false

		emotesPanel:destroyChildren()

		for i = 1, #emotesTable do
			emoticon = g_ui.createWidget("EmotesButtonUI", emotesPanel)

			emoticon:setText(emotesTable[i].type)

			function emoticon.onClick()
				textEdit:setText(textEdit:getText() .. "" .. emotesTable[i].type)
				textEdit:setCursorPos(1)
			end
		end

		chatWindow.textEdit:setFocusable(true)
	elseif not options.chatAlwaysActive then
		chatWindow:setFocusable(false)
		chatWindow:setVisible(false)
		chatWindow.textEdit:setFocusable(false)

		hk = true
	end
end

function doCloseWindowEmoticons()
	if backgroundEmotes:isVisible() then
		backgroundEmotes:setVisible(false)
		EmotesButton:setImageSource("/images/game/chat/icons/emotes")
	end
end

function doShowWindowEmoticons()
	if not backgroundEmotes:isVisible() then
		backgroundEmotes:setVisible(true)
		EmotesButton:setImageSource("/images/game/chat/icons/emote_light")
	end
end

function doToggleWindowEmoticons()
	if backgroundEmotes:isVisible() then
		doCloseWindowEmoticons()
	else
		doShowWindowEmoticons()
	end
end

function doChannelListSubmit()
	local channelListPanel = channelsWindow.channelList
	local openPrivateChannelWith = channelsWindow.openPrivateChannelWith:getText()

	if openPrivateChannelWith ~= "" then
		if openPrivateChannelWith:lower() ~= g_game.getCharacterName():lower() then
			g_game.openPrivateChannel(openPrivateChannelWith)
		else
			modules.game_textmessage.displayFailureMessage("You cannot create a private chat channel with yourself.")
		end
	else
		local selectedChannelLabel = channelListPanel:getFocusedChild()

		if not selectedChannelLabel then
			return
		end

		if selectedChannelLabel.channelId == 65535 then
			g_game.openOwnChannel()
		else
			g_game.joinChannel(selectedChannelLabel.channelId)
		end
	end

	channelsWindow:destroy()
end

function onChannelList(channelList)
	if channelsWindow then
		channelsWindow:destroy()
	end

	channelsWindow = g_ui.displayUI("channelswindow")
	local channelListPanel = channelsWindow.channelList
	channelsWindow.onEnter = doChannelListSubmit

	function channelsWindow.onDestroy()
		channelsWindow = nil
	end

	g_keyboard.bindKeyPress("Down", function ()
		channelListPanel:focusNextChild(KeyboardFocusReason)
	end, channelsWindow)
	g_keyboard.bindKeyPress("Up", function ()
		channelListPanel:focusPreviousChild(KeyboardFocusReason)
	end, channelsWindow)

	for k, v in pairs(channelList) do
		local channelId = v[1]
		local channelName = v[2]

		if #channelName > 0 then
			local label = g_ui.createWidget("ChannelListLabel", channelListPanel)
			label.channelId = channelId

			label:setText(channelName)
			label:setPhantom(false)

			label.onDoubleClick = doChannelListSubmit
		end
	end
end

function loadCommunicationSettings()
	communicationSettings.whitelistedPlayers = {}
	communicationSettings.ignoredPlayers = {}
	local ignoreNode = g_settings.getNode("IgnorePlayers")

	if ignoreNode then
		for i = 1, #ignoreNode do
			table.insert(communicationSettings.ignoredPlayers, ignoreNode[i])
		end
	end

	local whitelistNode = g_settings.getNode("WhitelistedPlayers")

	if whitelistNode then
		for i = 1, #whitelistNode do
			table.insert(communicationSettings.whitelistedPlayers, whitelistNode[i])
		end
	end

	communicationSettings.useIgnoreList = g_settings.getBoolean("UseIgnoreList")
	communicationSettings.useWhiteList = g_settings.getBoolean("UseWhiteList")
	communicationSettings.privateMessages = g_settings.getBoolean("IgnorePrivateMessages")
	communicationSettings.yelling = g_settings.getBoolean("IgnoreYelling")
	communicationSettings.allowVIPs = g_settings.getBoolean("AllowVIPs")
end

function saveCommunicationSettings()
	local tmpIgnoreList = {}
	local ignoredPlayers = getIgnoredPlayers()

	for i = 1, #ignoredPlayers do
		table.insert(tmpIgnoreList, ignoredPlayers[i])
	end

	local tmpWhiteList = {}
	local whitelistedPlayers = getWhitelistedPlayers()

	for i = 1, #whitelistedPlayers do
		table.insert(tmpWhiteList, whitelistedPlayers[i])
	end

	g_settings.set("UseIgnoreList", communicationSettings.useIgnoreList)
	g_settings.set("UseWhiteList", communicationSettings.useWhiteList)
	g_settings.set("IgnorePrivateMessages", communicationSettings.privateMessages)
	g_settings.set("IgnoreYelling", communicationSettings.yelling)
	g_settings.setNode("IgnorePlayers", tmpIgnoreList)
	g_settings.setNode("WhitelistedPlayers", tmpWhiteList)
end

function getIgnoredPlayers()
	return communicationSettings.ignoredPlayers
end

function getWhitelistedPlayers()
	return communicationSettings.whitelistedPlayers
end

function isUsingIgnoreList()
	return communicationSettings.useIgnoreList
end

function isUsingWhiteList()
	return communicationSettings.useWhiteList
end

function isIgnored(name)
	return table.find(communicationSettings.ignoredPlayers, name, true)
end

function addIgnoredPlayer(name)
	if isIgnored(name) then
		return
	end

	table.insert(communicationSettings.ignoredPlayers, name)
end

function removeIgnoredPlayer(name)
	table.removevalue(communicationSettings.ignoredPlayers, name)
end

function isWhitelisted(name)
	return table.find(communicationSettings.whitelistedPlayers, name, true)
end

function addWhitelistedPlayer(name)
	if isWhitelisted(name) then
		return
	end

	table.insert(communicationSettings.whitelistedPlayers, name)
end

function removeWhitelistedPlayer(name)
	table.removevalue(communicationSettings.whitelistedPlayers, name)
end

function isIgnoringPrivate()
	return communicationSettings.privateMessages
end

function isIgnoringYelling()
	return communicationSettings.yelling
end

function isAllowingVIPs()
	return communicationSettings.allowVIPs
end

function onClickIgnoreButton()
	if communicationWindow then
		return
	end

	communicationWindow = g_ui.displayUI("communicationwindow")
	local ignoreListPanel = communicationWindow.ignoreList
	local whiteListPanel = communicationWindow.whiteList

	function communicationWindow.onDestroy()
		communicationWindow = nil
	end

	local useIgnoreListBox = communicationWindow.checkboxUseIgnoreList

	useIgnoreListBox:setChecked(communicationSettings.useIgnoreList)

	local useWhiteListBox = communicationWindow.checkboxUseWhiteList

	useWhiteListBox:setChecked(communicationSettings.useWhiteList)

	local removeIgnoreButton = communicationWindow.buttonIgnoreRemove

	removeIgnoreButton:disable()

	function ignoreListPanel.onChildFocusChange()
		removeIgnoreButton:enable()
	end

	function removeIgnoreButton.onClick()
		local selection = ignoreListPanel:getFocusedChild()

		if selection then
			ignoreListPanel:removeChild(selection)
			selection:destroy()
		end

		removeIgnoreButton:disable()
	end

	local removeWhitelistButton = communicationWindow.buttonWhitelistRemove

	removeWhitelistButton:disable()

	function whiteListPanel.onChildFocusChange()
		removeWhitelistButton:enable()
	end

	function removeWhitelistButton.onClick()
		local selection = whiteListPanel:getFocusedChild()

		if selection then
			whiteListPanel:removeChild(selection)
			selection:destroy()
		end

		removeWhitelistButton:disable()
	end

	local newlyIgnoredPlayers = {}
	local addIgnoreName = communicationWindow.ignoreNameEdit
	local addIgnoreButton = communicationWindow.buttonIgnoreAdd

	local function addIgnoreFunction()
		local newEntry = addIgnoreName:getText()

		if newEntry == "" then
			return
		end

		if table.find(getIgnoredPlayers(), newEntry) then
			return
		end

		if table.find(newlyIgnoredPlayers, newEntry) then
			return
		end

		local label = g_ui.createWidget("IgnoreListLabel", ignoreListPanel)

		label:setText(newEntry)
		table.insert(newlyIgnoredPlayers, newEntry)
		addIgnoreName:setText("")
	end

	addIgnoreButton.onClick = addIgnoreFunction
	local newlyWhitelistedPlayers = {}
	local addWhitelistName = communicationWindow.whitelistNameEdit
	local addWhitelistButton = communicationWindow.buttonWhitelistAdd

	local function addWhitelistFunction()
		local newEntry = addWhitelistName:getText()

		if newEntry == "" then
			return
		end

		if table.find(getWhitelistedPlayers(), newEntry) then
			return
		end

		if table.find(newlyWhitelistedPlayers, newEntry) then
			return
		end

		local label = g_ui.createWidget("WhiteListLabel", whiteListPanel)

		label:setText(newEntry)
		table.insert(newlyWhitelistedPlayers, newEntry)
		addWhitelistName:setText("")
	end

	addWhitelistButton.onClick = addWhitelistFunction

	function communicationWindow.onEnter()
		if addWhitelistName:isFocused() then
			addWhitelistFunction()
		elseif addIgnoreName:isFocused() then
			addIgnoreFunction()
		end
	end

	local ignorePrivateMessageBox = communicationWindow.checkboxIgnorePrivateMessages

	ignorePrivateMessageBox:setChecked(communicationSettings.privateMessages)

	local ignoreYellingBox = communicationWindow.checkboxIgnoreYelling

	ignoreYellingBox:setChecked(communicationSettings.yelling)

	local allowVIPsBox = communicationWindow.checkboxAllowVIPs

	allowVIPsBox:setChecked(communicationSettings.allowVIPs)

	local saveButton = communicationWindow:recursiveGetChildById("buttonSave")

	function saveButton.onClick()
		communicationSettings.ignoredPlayers = {}

		for i = 1, ignoreListPanel:getChildCount() do
			addIgnoredPlayer(ignoreListPanel:getChildByIndex(i):getText())
		end

		communicationSettings.whitelistedPlayers = {}

		for i = 1, whiteListPanel:getChildCount() do
			addWhitelistedPlayer(whiteListPanel:getChildByIndex(i):getText())
		end

		communicationSettings.useIgnoreList = useIgnoreListBox:isChecked()
		communicationSettings.useWhiteList = useWhiteListBox:isChecked()
		communicationSettings.yelling = ignoreYellingBox:isChecked()
		communicationSettings.privateMessages = ignorePrivateMessageBox:isChecked()
		communicationSettings.allowVIPs = allowVIPsBox:isChecked()

		communicationWindow:destroy()
	end

	local cancelButton = communicationWindow:recursiveGetChildById("buttonCancel")

	function cancelButton.onClick()
		communicationWindow:destroy()
	end

	local ignoredPlayers = getIgnoredPlayers()

	for i = 1, #ignoredPlayers do
		local label = g_ui.createWidget("IgnoreListLabel", ignoreListPanel)

		label:setText(ignoredPlayers[i])
	end

	local whitelistedPlayers = getWhitelistedPlayers()

	for i = 1, #whitelistedPlayers do
		local label = g_ui.createWidget("WhiteListLabel", whiteListPanel)

		label:setText(whitelistedPlayers[i])
	end
end

function online()
	defaultTab = addTab(tr("Default"), true)
	serverTab = addTab(tr("Server Log"), false)

	if g_game.getClientVersion() < 862 then
		g_keyboard.bindKeyDown("Ctrl+R", openPlayerReportRuleViolationWindow)
	end

	local lastChannelsOpen = g_settings.getNode("lastChannelsOpen")

	if lastChannelsOpen then
		local savedChannels = lastChannelsOpen[g_game.getCharacterName()]

		if savedChannels then
			for channelName, channelId in pairs(savedChannels) do
				channelId = tonumber(channelId)

				if channelId ~= -1 and channelId < 100 and not table.find(channels, channelId) then
					g_game.joinChannel(channelId)
					table.insert(ignoredChannels, channelId)
				end
			end
		end
	end

	scheduleEvent(function ()
		ignoredChannels = {}
	end, 3000)
end

function hide()
	g_effects.fadeOut(chatWindow, 200)
	scheduleEvent(function ()
		if not isOnline then
			chatWindow:hide()
		end
	end, 200)
	configWindow:hide()
end

function refreshByUIMode(mode)
	local b = chatWindow.background
	local tLW = chatWindow.textLineWindow
	local cTB = chatWindow.consoleTabBar
	local contP = chatWindow.contentPanel
	local eB = chatWindow.enterBackground
	local pCB = chatWindow.prevChannelButton
	local nCB = chatWindow.nextChannelButton
	local cCB = chatWindow.closeChannelButton
	local cleCB = chatWindow.clearChannelButton
	local cB = chatWindow.channelsButton
	local iB = chatWindow.ignoreButton
	local sMB = chatWindow.sayModeButton
	local conOk = configWindow.okButton
	local cSB = chatWindow:recursiveGetChildById("consoleScrollBar")
	local cSBSlBu = cSB.sliderButton
	local cSBDeBu = cSB.decrementButton
	local cSBInBu = cSB.incrementButton
	local cTBB = cTB:getChildren()
	local buttons = {
		pCB,
		nCB,
		cCB,
		cleCB,
		cB,
		iB
	}

	b:setImageSource("/images/game/chat/background")
	eB:setImageSource("/images/game/chat/textBackground")
	configWindow:setImageSource("/images/game/chat/window")
	conOk:setImageSource("/images/game/chat/button_rounded")
	conOk:setImageBorder(5)
	cSBSlBu:setImageSource("/images/game/chat/slider")
	cSBDeBu:setImageSource("/images/game/chat/scrollBar")
	cSBInBu:setImageSource("/images/game/chat/scrollBar")

	for a = 1, #buttons do
		buttons[a]:setImageSource("/images/game/chat/tabBarButtons")
	end

	for b = 1, #cTBB do
		cTBB[b]:setImageSource("/images/game/chat/channelButtons")
	end
end
