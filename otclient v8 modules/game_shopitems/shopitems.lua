-- Criado por Thalles Vitor --
-- Sistema de Auto Loot --

local shop = g_ui.displayUI("shopitems")
local itemList = shop:getChildById("itemList")
local categoryPanel = shop:getChildById("categoryPanel")
local shopbtn = nil
local prompt = false
local buyWindow = nil

function init()
  connect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  shopbtn = modules.client_topmenu.addRightGameToggleButton('shop', tr('Shop'), '/images/topbuttons/shop', exibir)
  shopbtn:setWidth(32)
  shopbtn:setOn(false)

  shop:hide()
end

function terminate()
  disconnect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  if buyWindow then
    buyWindow:destroy()
    buyWindow=nil
  end

  ProtocolGame.unregisterExtendedOpcode(156)
  ProtocolGame.unregisterExtendedOpcode(157)
  ProtocolGame.unregisterExtendedOpcode(158)

  shopbtn:setOn(false)
  shop:hide()
end

function exibir()
  if not g_game.isOnline() then
    return
  end

  if shop:isVisible() then
    shopbtn:setOn(false)
    shop:hide()
  else
    shopbtn:setOn(true)
    shop:show()

    if g_game.isOnline() then
      g_game.getProtocolGame():sendExtendedOpcode(154, "Promotions".."@") -- enviar para o servidor
    end
  end
end

function naoexibir()
  if buyWindow then
    buyWindow:destroy()
    buyWindow=nil
  end

  shop:hide()
  shopbtn:setOn(false)
end

ProtocolGame.registerExtendedOpcode(156, function(protocol, opcode, buffer) -- receive shop items
  local param = buffer:explode("@")
  local name = tostring(param[1])
  local image = tostring(param[2])
  local price = tonumber(param[3])
  local count = tonumber(param[4])
  local index = tonumber(param[5])
  local category = tostring(param[6])
  local points = tonumber(param[7])
  local description = tostring(param[8])

  -- Diamonds
  shop:getChildById("diamond_count"):setText(points)
  
  local background = g_ui.createWidget("UIButton", itemList)
  background:setMarginTop(9)
  background:setMarginLeft(7)
  background:setImageSource("images/product/productbox.png")

  local product_name = g_ui.createWidget("Label", background)
  product_name:addAnchor(AnchorTop, "parent", AnchorTop)
  product_name:addAnchor(AnchorLeft, "parent", AnchorLeft)
  product_name:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
  -- product_name:setFont("verdana-11px-antialised-10px")
  product_name:setMarginTop(5)
  product_name:setMarginLeft(0)
  product_name:setText(name)

  if category == "Outfits" then
    local product_img = g_ui.createWidget("UIButton", background)
    product_img:setSize("32 37")
    product_img:addAnchor(AnchorTop, "parent", AnchorTop)
    product_img:addAnchor(AnchorLeft, "parent", AnchorLeft)
	product_img:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
    product_img:setMarginTop(40)
    -- product_img:setMarginLeft(30)
    product_img:setImageSource(image)
	product_img:setTooltip(description)
  else
    local product_img = g_ui.createWidget("UIButton", background)
    product_img:setSize("32 32")
    product_img:addAnchor(AnchorTop, "parent", AnchorTop)
    product_img:addAnchor(AnchorLeft, "parent", AnchorLeft)
	product_img:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
    product_img:setMarginTop(40)
    -- product_img:setMarginLeft(30)
    product_img:setImageSource(image)
	product_img:setTooltip(description)
  end

  local diamond_icon = g_ui.createWidget("UIButton", background)
  diamond_icon:setImageSource("images/product/diamond.png")
  diamond_icon:addAnchor(AnchorTop, "parent", AnchorTop)
  diamond_icon:addAnchor(AnchorLeft, "parent", AnchorLeft)
  diamond_icon:setMarginTop(93)
  diamond_icon:setMarginLeft(20)

  local diamond_text = g_ui.createWidget("Label", background)
  diamond_text:setText(price)
  diamond_text:addAnchor(AnchorTop, "parent", AnchorTop)
  diamond_text:addAnchor(AnchorLeft, "parent", AnchorLeft)
  diamond_text:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
  diamond_text:setMarginTop(95)
  -- diamond_text:setMarginLeft(40)

  local buyBtn = g_ui.createWidget("UIButton", background)
  buyBtn:setSize("90 25")
  buyBtn:setImageSource("images/product/comprar.png")
  buyBtn:setOpacity(0.65)
  buyBtn:addAnchor(AnchorTop, "parent", AnchorTop)
  buyBtn:addAnchor(AnchorLeft, "parent", AnchorLeft)
  buyBtn:setMarginTop(113)
  buyBtn:setMarginLeft(5)
  buyBtn.onHoverChange = function(self, hovered)
    if hovered then
      buyBtn:setOpacity(100)
    else
      buyBtn:setOpacity(0.65)
    end
  end

  buyBtn.onClick = function()
    yesCallback = function()
    g_game.getProtocolGame():sendExtendedOpcode(160, category.."@"..index.."@")
    if buyWindow then
      buyWindow:destroy()
      buyWindow=nil
    end
  end

  local noCallback = function()
    buyWindow:destroy()
    buyWindow=nil
  end

  prompt = true
  if prompt then
    buyWindow = displayGeneralBox(tr('Comprar ' .. name), tr("Você deseja comprar: " .. name .. " ("..count.."x)por: " .. price .. " pontos?"), {
      { text=tr('Yes'), callback=yesCallback },
      { text=tr('No'), callback=noCallback },
      anchor=AnchorHorizontalCenter}, yesCallback, noCallback)
  else
     yesCallback()
  end
end
end)


ProtocolGame.registerExtendedOpcode(157, function(protocol, opcode, buffer) -- destroy infos
  local param = buffer:explode("@")
  local type = tostring(param[1])

  if type == "destroyProducts" then
    itemList:destroyChildren()
  end

  if type == "destroyCategories" then
    categoryPanel:destroyChildren()
  end
end)

local selectedCategory = ""

ProtocolGame.registerExtendedOpcode(158, function(protocol, opcode, buffer) -- shop categories
  local param = buffer:explode("@")
  local category = tostring(param[1])

  local image = g_ui.createWidget("UIButton", categoryPanel)
  image:setImageSource("images/category/" .. category .. ".png")
  image:setMarginTop(2)

  -- definir opacidade inicial do botão
  if category ~= selectedCategory then
    image:setOpacity(0.5)
  end

  image.onClick = function()
    changeCategory(category)
    selectedCategory = category

    -- atualizar opacidade dos botões
    for _, child in ipairs(categoryPanel:getChildren()) do
      if child:getClassName() == "UIButton" and child ~= image then
        child:setOpacity(0.5)
      else
        child:setOpacity(1)
      end
    end
  end
end)

function changeCategory(category)
  if g_game.isOnline() then
    g_game.getProtocolGame():sendExtendedOpcode(154, category.."@") -- enviar para o servidor
  end
end