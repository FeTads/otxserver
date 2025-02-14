-- @docclass
g_tooltip = {}

-- private variables
local toolTipLabel
local currentHoveredWidget
local currentImage
local itemName
local panel
local backgroundTooltip					   
local attributes = {}	

-- private functions
local function moveToolTip(first)
  if not first and (not toolTipLabel:isVisible() or toolTipLabel:getOpacity() < 0.1) then return end

  local pos = g_window.getMousePosition()
  local windowSize = g_window.getSize()
  local labelSize = toolTipLabel:getSize()

  pos.x = pos.x + 1
  pos.y = pos.y + 1

  if windowSize.width - (pos.x + labelSize.width) < 10 then
    pos.x = pos.x - labelSize.width - 3
  else
    pos.x = pos.x + 10
  end

  if windowSize.height - (pos.y + labelSize.height) < 10 then
    pos.y = pos.y - labelSize.height - 3
  else
    pos.y = pos.y + 10
  end

  toolTipLabel:setPosition(pos)
end

local function onWidgetHoverChange(widget, hovered)
  if hovered then
    if widget.tooltip and not g_mouse.isPressed() then
      local itemId = widget.itemId or 0
      local itemNameText = widget.itemName
	  
      if itemId ~= 0 then
	  local itemWidget = widget:getItem()

        g_tooltip.display(widget.tooltip, itemId)
      else
        g_tooltip.display(widget.tooltip, nil)
      end 
      currentHoveredWidget = widget
    end
  else
    if widget == currentHoveredWidget then
      g_tooltip.hide()
      currentHoveredWidget = nil
    end
  end
end

local function onWidgetStyleApply(widget, styleName, styleNode)
  if styleNode.tooltip then
    widget.tooltip = styleNode.tooltip
  end
end

-- public functions
function g_tooltip.init()
  connect(UIWidget, {  onStyleApply = onWidgetStyleApply,
                       onHoverChange = onWidgetHoverChange})

  addEvent(function()
    toolTipLabel = g_ui.createWidget('UILabel', rootWidget)
    toolTipLabel = g_ui.displayUI('corelib_tooltip')
    toolTipLabel:setId('toolTip')
	-- toolTipLabel:setImageSource("navigation_button")
    -- toolTipLabel:setBackgroundColor('#111111cc')
    toolTipLabel:setTextAlign(AlignCenter)
    toolTipLabel:hide()
  end)
end

function g_tooltip.terminate()
  disconnect(UIWidget, { onStyleApply = onWidgetStyleApply,
                         onHoverChange = onWidgetHoverChange })

  currentHoveredWidget = nil
  toolTipLabel:destroy()
  toolTipLabel = nil

  g_tooltip = nil
end

function g_tooltip.display(text, itemId)
  if text == nil or text:len() == 0 then return end
  if not toolTipLabel then return end

  local panel = toolTipLabel:getChildById('panelHeader')
  toolTipLabel:setImageSource("/images/ui/comumx")

  local currentImage = panel:getChildById('itemImage')
  local itemName = panel:getChildById('itemName')                                                     
  if itemId then
    currentImage:show()
    currentImage:setItemId(itemId)
    currentImage:setHeight(50)
    currentImage:setWidth(50)
	currentImage:setImageSource("/images/ui/comum")
  else
    currentImage:hide()
  end

  toolTipLabel:setText(text)
  toolTipLabel:setTextWrap(true)
  toolTipLabel:setFont("verdana-11px-rounded")
  toolTipLabel:resizeToText()

  -- Ajusta a altura dinamicamente com base no texto
  local textHeight = toolTipLabel:getHeight()  -- Obtém a altura calculada do tooltip
  toolTipLabel:setHeight(textHeight + 50)  -- Adiciona algum padding, se necessário

  toolTipLabel:setWidth(320)
  toolTipLabel:setX((g_window.getWidth() - toolTipLabel:getWidth()) / 2)

  toolTipLabel:show()
  toolTipLabel:raise()
  toolTipLabel:enable()
  g_effects.fadeIn(toolTipLabel, 100)
  moveToolTip(true)

  connect(rootWidget, {onMouseMove = moveToolTip})
end

function g_tooltip.hide()
  g_effects.fadeOut(toolTipLabel, 100)
  
  disconnect(rootWidget, {
    onMouseMove = moveToolTip,
  })  
end


-- @docclass UIWidget @{

-- UIWidget extensions
function UIWidget:setTooltip(text)
  self.tooltip = text
end

function UIWidget:setTooltipTable(text, itemId, itemName)
  self.itemId = itemId
  self.tooltip = text
  self.itemName = itemName
end

function UIWidget:removeTooltip()
  self.tooltip = nil
end

function UIWidget:getTooltip()
  return self.tooltip
end

-- @}

g_tooltip.init()
connect(g_app, { onTerminate = g_tooltip.terminate })
