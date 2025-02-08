local taskWindow = nil
local searchTask

local GameTaskOpcode = 123
local hasTaskStarted = false
local numberCreateIndex = 1

local taskButton = nil
TaskCache = {}

function init()
    connect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir,
    })

    taskWindow = g_ui.loadUI("task", modules.game_interface.getRootPanel())
    searchTask = taskWindow:getChildById("searchTask")
	taskButton = modules.client_topmenu.addRightGameToggleButton('taskButton', tr('Task') .. ' (Ctrl+I)', '/images/topbuttons/task', sendInfoTask)
    taskButton:setOn(false)
	
    ProtocolGame.registerExtendedJSONOpcode(GameTaskOpcode, onPlayerReceiveTask)
    taskWindow:hide()
end

function terminate()
    disconnect(g_game, {
        onGameStart = naoexibir,
        onGameEnd = naoexibir,
    })

	ProtocolGame.unregisterExtendedJSONOpcode(GameTaskOpcode)
	taskWindow:hide()
end

function exibir()
	if taskButton:isOn() then
		naoexibir()
	else
		taskButton:setOn(true)
    	taskWindow:show()
	end
end

function naoexibir()
  	taskWindow:hide()
	taskButton:setOn(false)
	
  	if searchTask then
  		searchTask:clearText()
  	end
end

function sendInfoTask()
	if TaskCache[1] then
		createTaskInfo(TaskCache[1])
	else
		g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "openTask"}))
	end
end

function onPlayerReceiveTask(protocol, opcode, payload)

  	if payload.type == "update" then
  		table.insert(TaskCache, payload)
  		createTaskInfo(payload)

  	elseif payload.type == "open" then
  		sendInfoTask()

  	elseif payload.type == "updateKillTask" then
  		local taskIndex = payload.taskData.index
		local killCount = payload.taskData.count

  		if TaskCache[1] then
			TaskCache[1].taskData[taskIndex].kill = killCount
		end

	elseif payload.type == "updateTaskInfo" then
		-- Atualizar o cache quando o jogador cancelar ou startar uma task
		if TaskCache[1] then
			local taskIndex = payload.taskData.index
			local taskStart = payload.taskData.start
			-- local taskComplete = payload.taskData.complete

			TaskCache[1].taskData[taskIndex].start = taskStart
			-- TaskCache[1].taskData[taskIndex].complete = taskComplete
			TaskCache[1].taskData[taskIndex].kill = 0
			
			sendInfoTask()
		end
  	end
end

function createTaskInfo(payload)
	if not taskWindow:isVisible() then
		exibir()
	end

	taskWindow.description:setText("Participe do nosso sistema de tarefas: venca desafios, derrote monstros e ganhe premios gratificantes a medida que avanca nas tarefas!")
	hasTaskStarted = false
	taskWindow.PanelTaskList.taskList:destroyChildren()
	for index, data in ipairs(payload.taskData) do
		local PanelTask = g_ui.createWidget("PanelTask", taskWindow.PanelTaskList.taskList)
		PanelTask.labelTaskName:setText(data.name)
		PanelTask.outfitBox:setOutfit({type = data.monsterList[1].outfit})
		PanelTask:setId(data.index)

		if data.start then
			hasTaskStarted = true
			PanelTask:setImageSource("images/panelStart")
			PanelTask.labelTaskName:setColor("#3A6EBA")
		end

		-- if data.complete then
		-- 	PanelTask:setImageSource("images/completePanel")
		-- 	PanelTask.labelTaskName:setColor("green")
		-- end

		if index == numberCreateIndex then
			createInfo(data)
			PanelTask:focus()
		end

		PanelTask.onClick = function()
			createInfo(data)
		end

	end

	searchTask.onTextChange = function(self, value) -- search
	    if value == "" or value == nil then
	       	local children = taskWindow.PanelTaskList.taskList:getChildren()
	        for _, child in pairs(children) do
	            child:setVisible(true)
	        end
	    	return 
		end

		local control = false
	   	local searching = string.lower(value)
	   	local children = taskWindow.PanelTaskList.taskList:getChildren()
	   	for index, child in ipairs(children) do
	   		local taskname = string.lower(child.labelTaskName:getText())

	   		if string.find(taskname, searching) then
	   			if not control then
	   				control = true
	   				createInfo(payload.taskData[tonumber(child:getId())])
	   			end

	   			child:setVisible(true)
	   		else
	   			child:setVisible(false)
	   		end
	   	end
    end
    
end

function createInfo(data)
	
	taskWindow.panelTaskInfo.panelMonsterList.monsterList:destroyChildren()
	local monsterListCount = #data.monsterList
	taskWindow.panelTaskInfo.panelMonsterList.monsterList:resize(monsterListCount * 44, 48)

	local monsterListName = ""
	for _, monsterData in ipairs(data.monsterList) do
		local TaskOutfit = g_ui.createWidget("TaskOutfit", taskWindow.panelTaskInfo.panelMonsterList.monsterList)
		TaskOutfit:setOutfit({type = monsterData.outfit})
		TaskOutfit:setTooltip(monsterData.name)


		monsterListName = monsterListName .. monsterData.name .. ", "
	end

	monsterListName = monsterListName:gsub(",%s*$", "")
	taskWindow.panelTaskInfo.taskInfo.labelMonstersName:setText("Lista de monstros: " .. monsterListName .. ".")

	data.kill = (data.kill == -1) and 0 or data.kill
	taskWindow.panelTaskInfo.taskInfo.labelMonsterCount:setText("Quantia: [" .. data.kill .. " / " .. data.monsterCount .. "] Monsters.")
	taskWindow.panelTaskInfo.taskInfo.labelExperience:setText("Experience: " .. comma_value(data.experience))

	taskWindow.panelTaskInfo.taskReward.rewardList:destroyChildren()
	local itemListCount = #data.rewards
	taskWindow.panelTaskInfo.taskReward.rewardList:resize(itemListCount * 44, 38)

	for _, reward in ipairs(data.rewards) do
		local ItemTask = g_ui.createWidget("ItemTask", taskWindow.panelTaskInfo.taskReward.rewardList)
		ItemTask:setItemId(reward.itemId)
		ItemTask:setTooltip(reward.count .. " " .. reward.name)
		ItemTask.itemCount:setText(reward.count)
	end

	taskWindow.panelTaskInfo.startTask.onClick = function()
		g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "startTask", taskIndex = data.index}))
	end

	taskWindow.panelTaskInfo.getReward.onClick = function()
		g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "taskReward", taskIndex = data.index}))
	end

	taskWindow.panelTaskInfo.cancelTask.onClick = function()
		g_game.getProtocolGame():sendExtendedOpcode(33, json.encode({type = "cancelTask", taskIndex = data.index}))
	end

	numberCreateIndex = data.index
	doButtonControl(data)
end

function doButtonControl(data)

	taskWindow.panelTaskInfo.startTask:setEnabled(true)
	taskWindow.panelTaskInfo.getReward:setEnabled(false)
	taskWindow.panelTaskInfo.cancelTask:setEnabled(true)

	if not data.start and hasTaskStarted then
		taskWindow.panelTaskInfo.startTask:setEnabled(false)
		taskWindow.panelTaskInfo.getReward:setEnabled(false)
		taskWindow.panelTaskInfo.cancelTask:setEnabled(false)
	end

	if data.start and hasTaskStarted then
		taskWindow.panelTaskInfo.startTask:setEnabled(false)

		if data.kill >= data.monsterCount then
			taskWindow.panelTaskInfo.getReward:setEnabled(true)
		end
	end
end