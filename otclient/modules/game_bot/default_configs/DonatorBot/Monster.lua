  local loadPanelName = "Jutsu"
  local ui = setupUI([[
Panel

  height: 20

  Button
    id: editJutsu
    color: yellow
    font: verdana-11px-rounded
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 20
    text: - Jutsu  -
    tooltip: !jutsu


  ]], parent)


ui.editJutsu.onClick = function(widget)
say("!jutsu")
end UI.Separator()





  local loadPanelName = "Outfit"
  local ui = setupUI([[
Panel

  height: 20

  Button
    id: editOutfit
    color: yellow
    font: verdana-11px-rounded
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 20
    text: - Outfit  -
    tooltip: Mudar de roupa


  ]], parent)


ui.editOutfit.onClick = function(widget)
    g_game.requestOutfit()
    schedule(100, function()
        if modules.game_outfit.outfitWindow then
            modules.game_outfit.outfitWindow:hide()
            modules.game_outfit.randomize()
            schedule(1000, function()
                modules.game_outfit.accept()
            end)
        end
    end)
end 
UI.Separator()












  local loadPanelName = "Zoom"
  local ui = setupUI([[
Panel

  height: 20

  Button
    id: editZoom
    color: yellow
    font: verdana-11px-rounded
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 20
    text: - Zoom Map  -
    tooltip: Aproximar a tela


  ]], parent)


ui.editZoom.onClick = function(widget)
zoomIn()
end UI.Separator()

  local loadPanelName = "Zoom2"
  local ui = setupUI([[
Panel

  height: 20

  Button
    id: editZoom2
    color: yellow
    font: verdana-11px-rounded
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 20
    text: - Zoom Map  -
    tooltip: Afastar a tela


  ]], parent)


ui.editZoom2.onClick = function(widget)
zoomOut()
end UI.Separator()









local mkPanelname = "monsterKill"
if not storage[mkPanelname] then storage[mkPanelname] = { min = false } end

local monsterKill = setupUI([[
Panel
  margin-top:2
  height: 115
  Button
    id: resetList
    anchors.left: parent.left
    anchors.top: parent.top
    width: 20
    height: 17
    margin-top: 2
    margin-left: 3
    text: !
    color: red
    tooltip: Resetar os monstros
  Button
    id: showList
    anchors.right: parent.right
    anchors.top: parent.top
    width: 20
    height: 17
    margin-top: 2
    margin-right: 3
    text: -
    color: red
    tooltip: Minimizar

  Label
    id: title
    text: Monstros Mortes
    color: pink
    font: verdana-11px-rounded
    text-align: center
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 20

  ScrollablePanel
    id: content
    image-source: /data/images/ui/menubox
    image-border: 4
    image-border-top: 17
    anchors.top: showList.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    height: 88
    padding: 3
    vertical-scrollbar: mkScroll
    layout:
      type: verticalBox

  BotSmallScrollBar
    id: mkScroll
    anchors.top: content.top
    anchors.bottom: content.bottom
    anchors.right: content.right
    margin-top: 2
    margin-bottom: 5
    margin-right: 5
  ]], parent)
monsterKill:setId(mkPanelname)

killList = {}
local lbls = {}

local function toggleWin(load)
  if load then
    monsterKill:setHeight(20)
    monsterKill.showList:setText("+")
    monsterKill.showList:setColor("green")
  else
    monsterKill:setHeight(115)
    monsterKill.showList:setText("-")
    monsterKill.showList:setColor("red")
  end
end

function refreshMK()
  if #lbls > 0 and (#killList == #lbls) then
    local i = 1
    for k, v in pairs(killList) do
      lbls[i].name:setText(k .. ':')
      lbls[i].count:setText("x"..v)
      i = i + 1
    end
  else
    for _, child in pairs(monsterKill.content:getChildren()) do
      child:destroy()
    end
    for k, v in pairs(killList) do
      lbls[k] = g_ui.loadUIFromString([[
Panel
  height: 16
  margin-left: 2

  Label
    id: name
    text:
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 2
    text-auto-resize: true
    font: verdana-11px-bold

  Label
    id: count
    text:
    anchors.top: name.top
    anchors.right: parent.right
    margin-right: 15
    text-auto-resize: true
    color: orange
    font: verdana-11px-bold

]], monsterKill.content)
      if lbls[k] then
        lbls[k].name:setText(k .. ':')
        lbls[k].count:setText("x"..v)
      end
    end
  end
end
refreshMK()
toggleWin(storage[mkPanelname].min)

monsterKill.showList.onClick = function(widget)
  storage[mkPanelname].min = (monsterKill:getHeight() == 115)
  toggleWin(storage[mkPanelname].min)
end

monsterKill.resetList.onClick = function(widget)
  killList = {}
  refreshMK()
end

function checkKill(mode, text)
  local mobName = nil
  local reg = { "Loot of a (.*):", "Loot of an (.*):", "Loot of the (.*):","Loot of (.*):"}
  for x = 1, #reg do
    _, _, mobName = string.find(text, reg[x])
    if mobName then
      if killList[mobName] then
        killList[mobName] = killList[mobName] + 1
      else
        killList[mobName] = 1
      end
      refreshMK()
      break
    end
  end
end

onTalk(function(name, level, mode, text, channelId, pos)
  if channelId == 11 then checkKill(mode, text) end
end)

onTextMessage(function(mode, text)
  checkKill(mode, text)
end)

--- examples NOT NEEDED
function getKills(mobName)
  -- example: warn(getKills("Troll"))
  if killList[mobName] then
    return killList[mobName]
  end
  return nil
end

function getDumpAllKills() -- test dump
  for k, v in pairs(killList) do
    warn(v .. "x " .. k)
  end
end UI.Separator()


