-- Receber Informacoes do Shop --
local SHOP_RECEIVE_OPCODE = 154 -- receber o shop do cliente e enviar de volta
local SHOP_RECEIVE_BUY = 160 -- receber a compra do player

function onExtendedOpcode(cid, opcode, buffer)
   if opcode == SHOP_RECEIVE_OPCODE then
      local param = buffer:explode("@")
      local category = tostring(param[1])
      sendShopWindow(cid, category)
   end

   if opcode == SHOP_RECEIVE_BUY then
      local param = buffer:explode("@")
      local category = tostring(param[1])
      local index = tonumber(param[2])
      sendBuyProduct(cid, category, index)
   end
   return true
end