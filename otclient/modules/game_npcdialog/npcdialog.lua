
-- ui widgets
local windowDialog 
local buttonHolder
local labelTitle
local outfitBox
local panelMessage
local scrollPanel
local labelMessage

-- variables
local OpcodeDialog = 80
local Actions = {
  open = 1,
  closed = 2
}

function init()
  connect(g_game, { onGameEnd = closeDialog })
  connect(LocalPlayer, { onPositionChange = onPositionChange })
	
  ProtocolGame.registerExtendedOpcode(OpcodeDialog, function(protocol, opcode, buffer)
    local status, result = pcall(function() return loadstring("return "..buffer)() end) -- loadstring deprecated, use load for lua 5.2 
	if not status then
	  return error("game_npcdialog/npcdialog.lua:ProtocolGame.registerExtendedOpcode: \n" .. result)
	end	
	switch( result.action ){
	  [Actions.open]   = function() createDialog(result.data) end,
	  [Actions.closed] = function() closeDialog()             end,
	  
	  default = function() error("game_npcdialog/npcdialog.lua: Action not defined.") end
	}
  end) 
	
  windowDialog = g_ui.displayUI('npcdialog')
	
  buttonHolder = windowDialog:getChildById('buttonHolder')
  labelTitle   = windowDialog:getChildById('labelTitle')
  scrollPanel  = windowDialog:getChildById('scrollPanel')
  panelMessage = windowDialog:getChildById('panelMessage')
  outfitBox    = windowDialog:getChildById('outfitBox')
  
  labelMessage = g_ui.createWidget('LabelText', panelMessage)
end

function terminate()
  disconnect(g_game, { onGameEnd = closeDialog })
  disconnect(Creature, { onPositionChange = onPositionChange })
  ProtocolGame.unregisterExtendedOpcode(OpcodeDialog)
  windowDialog:destroy()
end

function closeDialog()
  windowDialog:hide()
end

function onPositionChange(creature, newPos, oldPos)
  if creature:isLocalPlayer() then
	windowDialog:hide()
  end
end

function openDialog()
  windowDialog:raise()
  windowDialog:show()
end

function createDialog(value)
  
  local Npc = g_map.getCreatureById(value.npcId)
	
  labelTitle:setText(Npc:getName())
  outfitBox:setOutfit(Npc:getOutfit())
  
  labelMessage:clearText()
  labelMessage:setText(value.message)
  scrollPanel:setVisible(labelMessage:getTextSize().height > panelMessage.limitText)
  
  buttonHolder:destroyChildren()  
  if value.options ~= '' then
    local options = value.options:split('&')
	
	for i = 1, #options do			
	  local button = g_ui.createWidget('OptionButton', buttonHolder)
	  button:setText(tr(options[i]))			  
	  button.onClick = function() g_game.talkChannel(MessageModes.NpcTo, 0, options[i]) end
	end
	
	buttonHolder:setHeight(#options > 6 and 48 or 25)
  end
    	
  openDialog()
end
