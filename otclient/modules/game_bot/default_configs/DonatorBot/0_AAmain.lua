-- main UI.Separator()


 UI.Separator()


 local loadPanelName = "Donator"
  local ui = setupUI([[
Panel

  height: 20

  Label
    id: editDonator
    color: pink
    font: verdana-11px-rounded
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 20
    text: .       - Donated Scripts  -      .


  ]], parent)


ui.editDonator.onClick = function(widget)
end

 local loadPanelName = "Discord"
  local ui = setupUI([[
Panel

  height: 20

  Button
    id: editDiscord
    color: red
    font: verdana-11px-rounded
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 20
    text: - Discord  -
    tooltip: Grupo no discord


  ]], parent)


ui.editDiscord.onClick = function(widget)
g_platform.openUrl("https://discord.gg")
end UI.Separator()


 UI.Separator()






