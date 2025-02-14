UI.Separator()

 local msgtPanelName = "listt"
  local ui = setupUI([[
Panel

  height: 25

  Button
    id: editMsg
    color: red    
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 25
    text: - Mensagem Canal -

  ]], parent)
  ui:setId(msgtPanelName)

  if not storage[msgtPanelName] then
    storage[msgtPanelName] = { 

    }
  end

rootWidget = g_ui.getRootWidget()
if rootWidget then
    msgsWindow = g_ui.createWidget('MensagemWindow', rootWidget)
    msgsWindow:hide()
    TabBar5 = msgsWindow.msgsTabBar
    TabBar5:setContentWidget(msgsWindow.msgssImagem)
   for v = 1, 1 do





menPanel = g_ui.createWidget("menPanel") -- Creates Panel
menPanel:setId("panelButtons") -- sets ID

menPanel2 = g_ui.createWidget("menPanel") -- Creates Panel
menPanel2:setId("2") -- sets ID


TabBar5:addTab("Mensagem", menPanel)
        color= UI.Label("by: @Donator",menPanel)
color:setColor("orange")
        UI.Separator(menPanel)



macro(60000, "Msg trade", function()
  local Trade = getChannelId("advertising")
  if not Trade then
    Trade = getChannelId("Trade")
  end
  if Trade and storage.autoTradeMessage:len() > 0 then    
    sayChannel(Trade, storage.autoTradeMessage)
  end
end,menPanel)
UI.TextEdit(storage.autoTradeMessage or "hi ", function(widget, text)    
  storage.autoTradeMessage = text
end,menPanel)

macro(60000, "Msg Help", function()
  local Help = getChannelId("advertising")
  if not Help then
    Help = getChannelId("Help")
  end
  if Help and storage.autoHelpMessage:len() > 0 then    
    sayChannel(Help, storage.autoHelpMessage)
  end
end,menPanel)
UI.TextEdit(storage.autoHelpMessage or "hi", function(widget, text)    
  storage.autoHelpMessage = text
end,menPanel)






TabBar5:addTab("Mensagem 2", menPanel2)
        color= UI.Label("by: @Donator",menPanel2)
color:setColor("orange")
        UI.Separator(menPanel2)


local afkMsg = false
addSwitch("afkMsg", "AFK Mensagem", function(widget)
    afkMsg = not afkMsg
    widget:setOn(afkMsg)
end,menPanel2)

onTalk(function(name, level, mode, text, channelId, pos) --quando receber uma pm vai responder com a mensagem escolhida abaixo
    if mode == 4 and afkMsg == true then
        g_game.talkPrivate(5, name, storage.afkMsg)
        delay(5000)
    end
end,menPanel2)
UI.TextEdit(storage.afkMsg or "MENSAGEM", function(widget, newText) -- campo de texto pra alterar a mensagem que vai ser a resposta (mude somente o texto)
storage.afkMsg = newText
end,menPanel2)








end
end


  msgsWindow.closeButton.onClick = function(widget)
    msgsWindow:hide()
  end


  
ui.editMsg.onClick = function(widget)
    msgsWindow:show()
    msgsWindow:raise()
    msgsWindow:focus()
  end

UI.Separator()