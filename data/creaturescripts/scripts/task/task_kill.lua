
function onKill(cid, target)
   if not isCreature(cid) then
      return true
   end

   if not isCreature(target) then
      return true
   end

   if getPlayerStorageValue(cid, TASKSYSTEM_ISINMISSION_STORAGE) >= 1 then
      local name = getCreatureName(target)
      local tabela = TASKSYSTEM_MONSTERS[name]
      if not tabela then
         return true
      end

      if getPlayerStorageValue(cid, tabela.storage) > 0 then
         if getPlayerStorageValue(cid, tabela.storage) < tabela.count then
            setPlayerStorageValue(cid, tabela.storage, getPlayerStorageValue(cid, tabela.storage)+1)
            doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Muito bem! Você matou: " .. getPlayerStorageValue(cid, tabela.storage) .. " de " .. tabela.count .. " "..name .."'s, continue para completar a task.")
         end

         if getPlayerStorageValue(cid, tabela.storage) >= tabela.count then
            setPlayerStorageValue(cid, tabela.storage, tabela.count)
            doPlayerSendTextMessage(cid, 25, "Muito bem! Você completou a task, abra o modulo de TASK para coletar sua recompensa.")
            setPlayerStorageValue(cid, TASKSYSTEM_ISINMISSION_STORAGE, 0)
         end
      end
   end
   return true
end