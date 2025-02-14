extraHotkeys = {}
luizprotecao = {}

function addExtraHotkey(name, description, callback)
  table.insert(extraHotkeys, {
    name = name:lower(),
    description = tr(description),
    callback = callback
  })
  
end

function setupExtraHotkeys(combobox)
  addExtraHotkey("none", "None", nil)
  addExtraHotkey("cancelAttack", "Stop attacking", function(repeated)
    if not repeated then
      g_game.attack(nil)
    end
  end)

  addExtraHotkey("toogleWsad", "Enable/disable wsad walking", function(repeated)
    if repeated or not modules.game_console then
      return
    end
    if not modules.game_console.consoleToggleChat:isChecked() then
      modules.game_console.disableChat(true) 
    else
      modules.game_console.enableChat(true) 
    end    
  end)  
  
  for index, actionDetails in ipairs(extraHotkeys) do
    combobox:addOption(actionDetails.description)
  end
end

function executeExtraHotkey(action, repeated)
  action = action:lower()
  for index, actionDetails in ipairs(extraHotkeys) do
    if actionDetails.name == action and actionDetails.callback then
      actionDetails.callback(repeated)
    end
  end
end

function translateActionToActionComboboxIndex(action)
  action = action:lower()
  for index, actionDetails in ipairs(extraHotkeys) do
    if actionDetails.name == action then
      return index
    end
  end
  return 1
end

function translateActionComboboxIndexToAction(index)
  if index > 1 and index <= #extraHotkeys then
    return extraHotkeys[index].name  
  end
  return nil
end

function getActionDescription(action)
  action = action:lower()
  for index, actionDetails in ipairs(extraHotkeys) do
    if actionDetails.name == action then
      return actionDetails.description
    end
  end
  return "invalid action"
end