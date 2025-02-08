GameTaskSystem = {
	opcode = 123, -- N�o modifique
	protectionZone = false, -- true para precisar est� em protection zone para abrir o module, false para n�o precisar.

	storages = {
		STORAGE_INDEX = 30022, -- Storage que ser� salvo a task atual.
		STORAGE_COMPLETE = 35000, -- Storage Complete base, esse valor 35000 sempre ser� somado com o index da task para obter o valor.
		STORAGE_KILL = 36000, -- Storage kill Base, esse valor 36000 sempre ser� somado com o index da task para obter o valor.
	},

	taskList = {
        [1] = {
			taskName = "Boss 1",
			monsterList = {"Boss Rock", "Boss Snake", "Boss Sebas"},
			monsterCount = 1,
			experience = 10000000,
			power_points = 15,
			reward = {{15083,250}, {14223,250}, {13539,250}},
		},
       
		--[[
			Exemplo de cria��o de uma nova task
			[] entre os colchete adicione um numero a mais do que o valor da task acima, ou seja, se a task acima � 2, voc� adicionar 3 
			[4] = {
				taskName = "New name task",
				monsterList = {"monster1", "monster2", "monster3"}, Voc� pode adicionar quantos monstros desejar, o module possui suporte para usar o wheel do mouse.
				monsterCount = 50, -- Quantidade de monstros que ser� necess�rio o jogador matar.
				experience = 30000,	-- Quantidade de experience que o jogador ganhar� ao finalizar a task.
				reward = {{22805, 10}, {11390, 1}}, -- reward em items que o jogador ganhar� ao finalizar a task, {itemid, quantidade}, se for um item n�o stackavel utilize a quantidade 1.
			},

		]]--
	}
}

function GameTaskSystem:getPlayerInTask(cid)
	return getPlayerStorageValue(cid, self.storages.STORAGE_INDEX) > 0
end

function GameTaskSystem:hasTaskStarted(cid, index)
	return getPlayerStorageValue(cid, self.storages.STORAGE_INDEX) == index
end

function GameTaskSystem:isTaskCompleted(cid, index)
    local storageBase = self.storages.STORAGE_COMPLETE + index
    return getPlayerStorageValue(cid, storageBase) > 0
end

function GameTaskSystem:start(cid, index)
	local task = self.taskList[index]

	if not task then
		return doPlayerPopupFYI(cid, "Essa task nao existe!")
	end

	if self:getPlayerInTask(cid) then
		local taskIndex = getPlayerStorageValue(cid, self.storages.STORAGE_INDEX)
        return doPlayerPopupFYI(cid, "Voce ja esta participando da task '" .. self.taskList[taskIndex].taskName .. "' e nao pode aceitar outra task. Por favor, conclua a task atual antes de iniciar uma nova.")
	end

	setPlayerStorageValue(cid, self.storages.STORAGE_INDEX, index)
	local storageBaseKll = self.storages.STORAGE_KILL + index

	if getPlayerStorageValue(cid, storageBaseKll) == -1 then
		setPlayerStorageValue(cid, storageBaseKll, 0)
	end

	registerCreatureEvent(cid, "playerTaskKill")
	self:refreshCacheTask(cid, index)
	local monsterString = table.concat(task.monsterList, ", ")
	doPlayerSendTextMessage(cid, 19, "Voce acabou de iniciar a tarefa '" .. task.taskName .. "'. Seu objetivo e derrotar " .. task.monsterCount .. " " .. monsterString .. ".")
end

function GameTaskSystem:cancel(cid, index)
	if not self:getPlayerInTask(cid) then
		return doPlayerPopupFYI(cid, "Voce nao esta em nenhuma task no momento.")
	end


	if not self:hasTaskStarted(cid, index) then
		return doPlayerPopupFYI(cid, "Voce nao pode cancelar essa task.")
	end

	unregisterCreatureEvent(cid, "playerTaskKill")
	setPlayerStorageValue(cid, (self.storages.STORAGE_KILL + index), 0)
	setPlayerStorageValue(cid, self.storages.STORAGE_INDEX, 0)
	self:refreshCacheTask(cid, index)
	doPlayerSendTextMessage(cid, 19, "Vocee cancelou a tarefa. Seu progresso atual nao foi salvo.")
end

function GameTaskSystem:getReward(cid, index)
	local task = self.taskList[index]

	if not task then
		return doPlayerPopupFYI(cid, "Essa task nao existe!")
	end

	if not self:getPlayerInTask(cid) then
		return doPlayerPopupFYI(cid, "Voce nao esta em nenhuma task no momento.")
	end

	if not self:hasTaskStarted(cid, index) then
		return doPlayerPopupFYI(cid, "Voce nao pode receber o reward dessa task.")
	end

	local storageBaseKill = getPlayerStorageValue(cid, self.storages.STORAGE_KILL + index)
	if storageBaseKill < task.monsterCount then
		return doPlayerPopupFYI(cid, "Vocee ainda nao derrotou todos os monstros. Restante [" .. storageBaseKill .. " / " .. task.monsterCount .. "].")
	end

	setPlayerStorageValue(cid, self.storages.STORAGE_INDEX, 0)
	setPlayerStorageValue(cid, (self.storages.STORAGE_KILL + index), 0)
	unregisterCreatureEvent(cid, "playerTaskKill")
	doPlayerAddPowerUpPoints(cid, task.power_points)
	
	local reward = self:doPlayerAddReward(cid, task.reward)
	doPlayerAddExperience(cid, task.experience)
	doPlayerSendTextMessage(cid, 19, "Parabens! Voce completou a tarefa '" .. task.taskName .. "' e recebeu a seguinte recompensa: " .. reward .. ".")
	self:refreshCacheTask(cid, index)
end

function GameTaskSystem:doPlayerAddReward(cid, reward)
    if not reward then
        return nil
    end

    local messageRewardParts = {}

    for _, data in ipairs(reward) do
        doPlayerAddItem(cid, data[1], data[2])
        local itemDescription = data[2] .. " " .. getItemNameById(data[1])
        table.insert(messageRewardParts, itemDescription)
    end

    local messageReward = table.concat(messageRewardParts, ", ")

    return messageReward
end


-- Fun��es de informa��es, n�o modifique nada abaixo.

function GameTaskSystem:open(cid)
	doSendPlayerExtendedJSONOpcode(cid, self.opcode, json.encode({type = "open"}))
end

function GameTaskSystem:refreshCacheTask(cid, index)
    local taskData = {index = index, start = self:hasTaskStarted(cid, index), complete = self:isTaskCompleted(cid, index)}
    doSendPlayerExtendedJSONOpcode(cid, self.opcode, json.encode({type = "updateTaskInfo", taskData = taskData}))
end

function GameTaskSystem:refreshKill(cid, index, count)
	local taskData = {index = index, count = count}
	doSendPlayerExtendedJSONOpcode(cid, self.opcode, json.encode({type = "updateKillTask", taskData = taskData}))
end

function GameTaskSystem:sendInfo(cid)
	local taskData = {}

	for index, data in ipairs(self.taskList) do
		local taskInfo = {
			index = index,
			name = data.taskName,
			monsterCount = data.monsterCount,
			experience = data.experience,
			kill = getPlayerStorageValue(cid, (self.storages.STORAGE_KILL + index)),
			start = self:hasTaskStarted(cid, index),
			complete = self:isTaskCompleted(cid, index),
			monsterList = {},
			rewards = {},
		}

		for _, name in ipairs(data.monsterList) do
			local monsterInfo = {name = name, outfit = getMonsterInfo(name)['outfit']['lookType']}
			table.insert(taskInfo.monsterList, monsterInfo)
		end

		for _, reward in ipairs(data.reward) do
			local rewardInfo = {name = getItemNameById(reward[1]), itemId = getItemInfo(reward[1]).clientId, count = reward[2]}
			table.insert(taskInfo.rewards, rewardInfo)
		end

		table.insert(taskData, taskInfo)
	end

	doSendPlayerExtendedJSONOpcode(cid, self.opcode, json.encode({type = "update", taskData = taskData}))
end

OPCODE_MAX_LENGTH = 3000
function doSendPlayerExtendedJSONOpcode(cid, opcode, message)
    -- se a mensagem foi maior que o opcode permite
    if type(message) == "string" and message:len() > OPCODE_MAX_LENGTH then
        local remains = message:len()
        local offset = 0

        -- enviar opcode extended de inicio
        doSendPlayerExtendedOpcode(cid, opcode, "S")

        -- enviar até mandar tudo
        while (remains > 0) do
            local size = math.min(remains, OPCODE_MAX_LENGTH)
            local payload = message:sub(offset + 1, offset + size)
            offset = offset + payload:len()
            remains = remains - payload:len()

            doSendPlayerExtendedOpcode(cid, opcode, "P" .. payload)
        end
        doSendPlayerExtendedOpcode(cid, opcode, "E")
        return
    end

    doSendPlayerExtendedOpcode(cid, opcode, message)
end