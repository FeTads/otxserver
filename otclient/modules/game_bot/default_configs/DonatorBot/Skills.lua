---------------------------------------------- SKILLS -----------------------------------------------------





local skills = setupUI([[
Panel
  size: 14 14
  height:500
  anchors.bottom: parent.bottom
  anchors.left: parent.left
  opacity: 0.87




  Label
    id: skills1
    height: 12
    color: #00FFFF
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 260
    opacity: 0.87
    text-auto-resize: true
    text-align: center


  Label
    id: skills3
    height: 12
    color: #00FFFF
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 244
    opacity: 0.87
    text-auto-resize: true
    text-align: center



  Label
    id: skills5
    height: 12
    color: #00FFFF
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 227
    opacity: 0.87
    text-auto-resize: true
    text-align: center



  Label
    id: skills7
    height: 12
    color: #00FFFF
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 210
    opacity: 0.87
    text-auto-resize: true
    text-align: center

  Label
    id: skills9
    height: 12
    color: #00FFFF
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 193
    opacity: 0.87
    text-auto-resize: true
    text-align: center

  Label
    id: skills11
    height: 12
    color: #00FFFF
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 177
    opacity: 0.87
    text-auto-resize: true
    text-align: center

  Label
    id: skills13
    height: 12
    color: #00FFFF
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 160
    opacity: 0.87
    text-auto-resize: true
    text-align: center


  Label
    id: skills15
    height: 12
    color: #00FFFF
    font: verdana-11px-rounded
    background-color: #00000090
    anchors.bottom: parent.bottom
    margin-bottom: 144
    opacity: 0.87
    text-auto-resize: true
    text-align: center




]], modules.game_interface.getMapPanel())


macro(200, function()
skills.skills1:setText("Level: ".. player:getLevel() .. "   %".. player:getLevelPercent())
skills.skills3:setText("ML: ".. player:getMagicLevel().. "    % ".. player:getMagicLevelPercent())
skills.skills5:setText("Fist: ".. player:getSkillLevel() .. "   % ".. player:getSkillLevelPercent())
skills.skills7:setText("Glove: ".. player:getSkillLevel(1) .. "   % ".. player:getSkillLevelPercent(1))
skills.skills9:setText("Sword: ".. player:getSkillLevel(2) .. "   % ".. player:getSkillLevelPercent(2))
skills.skills11:setText("Dista: ".. player:getSkillLevel(4) .. "   % ".. player:getSkillLevelPercent(4))
skills.skills13:setText("Deff: ".. player:getSkillLevel(5) .. "   % ".. player:getSkillLevelPercent(5))
skills.skills15:setText("Stamina: ".. player:getStamina())
end)


if not storage.timers then  storage.timers = {  time = 1 } end
local widgetTC = setupUI([[
Panel
  size: 14 14
  anchors.bottom: parent.bottom
  anchors.left: parent.left
  margin-bottom: 125
  Label
    id: lblTimer
    color: #FF1493
    font: verdana-11px-rounded
    height: 12
    background-color: #00000040
    opacity: 0.87
    background-color: #00000090
    text-auto-resize: true
    !text: tr('00:00:00 Horas')

]], modules.game_interface.getMapPanel())

local doFormatTime = function(v)
    local hours = string.format(v['hour'])
    local mins = string.format(v['min'])
    local seconds = string.format(v['sec'])
    return hours .. ":" .. mins .. ":" .. seconds .. " Horas"
end
macro(1000, function(widget)
    real_time = os.date('*t', os.time())
    schedule(100, function()
        widgetTC.lblTimer:setText(doFormatTime(real_time))
    end)
        return
    widgetTC.lblTimer:setText(doFormatTime(real_time)) 
end)