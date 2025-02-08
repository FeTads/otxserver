
local taskOPCODE_sendINFOS = 167 -- opcode que vai enviar para o servidor sinalizando que precisa enviar as informacoes de volta pro cliente
local taskOPCODE_changeRANK = 168 -- opcode que vai enviar para o servidor sinalizando que ele tem que trocar a categoria do ranking
local taskOPCODE_acceptTASK = 169 -- opcode que vai enviar para o servidor sinalizando que ele tem que aceitar a task X
local taskOPCODE_collectTASK = 170 -- opcode que vai enviar para o servidor sinalizando que ele tem que recolher o premio da task
local taskOPCODE_cancelTASK = 171 -- opcode que vai enviar para o servidor sinalizando que ele tem que cancelar a task

function onExtendedOpcode(cid, opcode, buffer)
   if opcode == taskOPCODE_sendINFOS then
      sendTaskWindow(cid, "E")
   end

   if opcode == taskOPCODE_changeRANK then
      local param = buffer:explode("@")
      local rank = tostring(param[1])
      sendTaskWindow(cid, rank)
   end

   if opcode == taskOPCODE_acceptTASK then
      local param = buffer:explode("@")
      local monster = tostring(param[1])
      local rank = tostring(param[2])

      doAcceptTask(cid, monster, rank)
   end

   if opcode == taskOPCODE_collectTASK then
      local param = buffer:explode("@")
      local monster = tostring(param[1])
      local rank = tostring(param[2])

      doCollectTaskRecompense(cid, monster, rank)
   end

   if opcode == taskOPCODE_cancelTASK then
      local param = buffer:explode("@")
      local monster = tostring(param[1])
      local rank = tostring(param[2])

      doCancelTask(cid, monster, rank)
   end
   
   return true
end