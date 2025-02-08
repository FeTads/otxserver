function onKill(cid, target, damage, flags)
	local taskIndex = getPlayerStorageValue(cid, GameTaskSystem.storages.STORAGE_INDEX)
	local task = GameTaskSystem.taskList[taskIndex]

	if not task then
		return true
	end

	local monsterName = getCreatureName(target)
	if isInArray(task.monsterList, monsterName) then
        local baseStorage = GameTaskSystem.storages.STORAGE_KILL + taskIndex
        local playerKill = getPlayerStorageValue(cid, baseStorage)

        if playerKill < task.monsterCount then
	        setPlayerStorageValue(cid, baseStorage, playerKill + 1)
	        local newKill = getPlayerStorageValue(cid, baseStorage)
	        doPlayerSendTextMessage(cid, 19, "You've defeated " .. newKill .. " monsters out of " .. task.monsterCount .. ".")
	        GameTaskSystem:refreshKill(cid, taskIndex, newKill)

	        if newKill == task.monsterCount then
	        	doPlayerSendTextMessage(cid, 27, "Você finalizou a task " .. task.taskName .. ".")
	        end
	    end

	end

	return true
end