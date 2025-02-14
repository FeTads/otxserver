-- tools tab
setDefaultTab("Hotkeys")

--  UI.Separator() local customPanelName = "Custom"
  local ui = setupUI([[
Panel

  height: 25

  Label
    id: editCustom
    color: red
    font: verdana-11px-rounded
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 25
    text: .                 -  @DONATOR   1.6   -         .


  ]], parent)


ui.editCustom.onClick = function(widget)
reload()
end UI.Separator()UI.Separator()