
-- Sistema de Market --

local market = g_ui.displayUI("marketplayer")

-- Aba de Compra
local category_label = market:getChildById("category_label")
local category = market:getChildById("category")
local search_product = market:getChildById("search_product")
local search_btn = market:getChildById("search_btn")
local sharp_btn = market:getChildById("sharp_btn")
local item_btn = market:getChildById("item_btn")
local itemname_btn = market:getChildById("itemname_btn")
local vendedor_btn = market:getChildById("vendedor_btn")
local quantidade_btn = market:getChildById("quantidade_btn")
local preco_btn = market:getChildById("preco_btn")
local products_list = market:getChildById("products_list")
local products_scrollbar = market:getChildById("products_scrollbar")
local comprarAgora_btn = market:getChildById("comprarAgora_btn")
local fazerOferta_btn = market:getChildById("fazerOferta_btn")
local atualizar_btn = market:getChildById("atualizar_btn")
local fechar_btn = market:getChildById("fechar_btn")

-- Aba de Venda
local seller_panel = market:getChildById("seller_panel")
local item_seller = market:getChildById("item_seller")
local item_name = market:getChildById("item_name")
local pokemon_gender = market:getChildById("pokemon_gender")
local amount_text = market:getChildById("amount_text")
local priceperunit_text = market:getChildById("priceperunit_text")
local priceperunit_textedit = market:getChildById("priceperunit_textedit")
local select_objectbtn = market:getChildById("select_objectbtn")
local seller_btn = market:getChildById("seller_btn")
local sharp2_btn = market:getChildById("sharp2_btn")
local item2_btn = market:getChildById("item2_btn")
local itemname2_btn = market:getChildById("itemname2_btn")
local tempo_btn = market:getChildById("tempo_btn")
local quantidade2_btn = market:getChildById("quantidade2_btn")
local preco2_btn = market:getChildById("preco2_btn")
local products_list2 = market:getChildById("products_list2")
local products_scrollbar2 = market:getChildById("products_scrollbar2")
local atualizar2_btn = market:getChildById("atualizar2_btn")
local fechar2_btn = market:getChildById("fechar2_btn")
local amount_scrollbar = market:getChildById("amount_scrollbar")

-- Aba de Ofertas
local offers_tome = market:getChildById("offers_tome")
local sharp3_btn = market:getChildById("sharp3_btn")
local item3_btn = market:getChildById("item3_btn")
local itemname3_btn = market:getChildById("itemname3_btn")
local offers3_btn = market:getChildById("offers3_btn")
local tempo3_btn = market:getChildById("tempo3_btn")
local action_btn = market:getChildById("action_btn")
local products_list3 = market:getChildById("products_list3")
local products_scrollbar3 = market:getChildById("products_scrollbar3")
local offer_myoffers = market:getChildById("offer_myoffers")
local products_list4 = market:getChildById("products_list4")
local products_scrollbar4 = market:getChildById("products_scrollbar4")
local sharp4_btn = market:getChildById("sharp4_btn")
local item4_btn = market:getChildById("item4_btn")
local itemname4_btn = market:getChildById("itemname4_btn")
local seller3_btn = market:getChildById("seller3_btn")
local offers4_btn = market:getChildById("offers4_btn")
local action2_btn = market:getChildById("action2_btn")
local atualizar3_btn = market:getChildById("atualizar3_btn")
local fechar3_btn = market:getChildById("fechar3_btn")

-- Aba de Historico
local products_list5 = market:getChildById("products_list5")
local products_scrollbar5 = market:getChildById("products_scrollbar5")
local fechar4_btn = market:getChildById("fechar4_btn")
local pirateCoinsLabel = market:getChildById("pirateCoinLabel")

registered = {} -- tabela de items da aba de venda
registered2 = {} -- tabela de items da aba de compra
registered3 = {} -- tabela de historico de market do player
registered4 = {} -- tabela de your offers
registered5 = {} -- tabela de offers for you
time_list = {} -- tabela de tempo da aba de venda
time_list2 = {} -- tabela de tempo da aba de ofertas
options_list = {} -- opcoes do market na caixinha

transaction_id_list = {} -- tabela de transaction id da aba de venda
transaction_id_list2 = {} -- tabela de transaction id da aba de ofertas

globalCount = 0 -- quantidade de items do historico do player
makeoffer = nil -- janela de fazer oferta

globalCount_numerationsPage = 0 -- quantidade de paginas global (armazenado pelo sistema)
globalCount_numerationsPage2 = 0 -- quantidade de paginas passadas ou voltadas (armazenado pelo jogador ao passar as paginas)
passando = false

function abreviateNumber(n)
  if n >= 10^6 then
      return string.format("%.0fkk", n / 10^6)
  elseif n >= 10^3 then
      return string.format("%.0fk", n / 10^3)
  else
      return tostring(n)
  end
end

function init()
  connect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  g_ui.importStyle('/game_interface/styles/countwindow')

  mouseGrabberWidget = g_ui.createWidget('UIWidget')
  mouseGrabberWidget:setVisible(false)
  mouseGrabberWidget:setFocusable(false)
  mouseGrabberWidget.onMouseRelease = onChooseItemMouseRelease
  market:hide()
  
  connect(g_game, 'onTextMessage', serverComunication)
end

function terminate()
  disconnect(g_game, {
    onGameStart = naoexibir,
    onGameEnd = naoexibir,
  })

  if makeoffer then
    makeoffer:hide()
    makeoffer = nil
  end
  market:hide()
  disconnect(g_game, 'onTextMessage', serverComunication)
end

function serverComunication(mode, text)
  local player = g_game.getLocalPlayer()
  if not player or not g_game.isOnline() then
    return
  end
g_game.getProtocolGame():sendExtendedOpcode(192)
g_game.getProtocolGame():sendExtendedOpcode(191)
g_game.getProtocolGame():sendExtendedOpcode(193)
end

function exibir()
  if market:isVisible() then
    market:hide()
  else
    market:show()
	
	g_game.getProtocolGame():sendExtendedOpcode(192)
	g_game.getProtocolGame():sendExtendedOpcode(191)
	g_game.getProtocolGame():sendExtendedOpcode(193)
  end
end

function naoexibir()
  if makeoffer then
    makeoffer:hide()
    makeoffer = nil
  end

  market:hide()
end

ProtocolGame.registerExtendedOpcode(191, function(protocol, opcode, buffer)
    local param = buffer:split("@")
    local player_name = tostring(param[1])
	local player = g_game.getLocalPlayer()
	
	pirateCoinsLabel:setText("Points: "..player_name)
	pirateCoinsLabel:setColor("#88745B")
end)

ProtocolGame.registerExtendedOpcode(192, function(protocol, opcode, buffer)
local param = buffer:split("@")
local player_name = tostring(param[1])
local player = g_game.getLocalPlayer()

market:hide()
end)

ProtocolGame.registerExtendedOpcode(193, function(protocol, opcode, buffer)
    local param = buffer:split("@")
    local player_name = tostring(param[1])
end)

ProtocolGame.registerExtendedOpcode(110, function(protocol, opcode, buffer) -- show market window
  local param = buffer:split("@")
  local type = tostring(param[1])

  if type == "market" then
     market:show()
     buyproductCategory() -- pra quando abrir nao estar em outra aba

     amount_scrollbar:setText("1")
     amount_scrollbar:setMaximum(1)
     amount_scrollbar:setMinimum(1)
     amount_scrollbar:setValue(1)
     item_seller:setText("")
     item_seller:setItemId(0)
     item_name:setText("")
     pokemon_gender:setImageSource("")
     priceperunit_textedit:setText("")
	 g_game.getProtocolGame():sendExtendedOpcode(191)
  end
end)

ProtocolGame.registerExtendedOpcode(188, function(protocol, opcode, buffer) -- insert item to sell in slot
  local param = buffer:split("@")
  local itemid = tonumber(param[1])
  local name = tostring(param[2])
  local gender = tonumber(param[3])
  local level = tonumber(param[4])
  local ispokemon = tostring(param[5])
  local itemcount = tonumber(param[6])
  local integgerAttribute = tonumber(param[7])

  if ispokemon == "isPokemon" then
    item_seller:setText("Lv."..level)
    item_seller:setItemId(itemid)
    item_name:setText(name)
    pokemon_gender:setImageSource("images/"..gender..".png")
  else
    item_seller:setText("")
    item_seller:setItemId(itemid)
    item_name:setText(name)
    pokemon_gender:setImageSource("")
    priceperunit_textedit:setText("")
  end

  amount_scrollbar:setText(1)
  amount_scrollbar:setMaximum(itemcount)
  amount_scrollbar:setMinimum(1)
  amount_scrollbar:setValue(1)
  
  amount_scrollbar.onValueChange = function(self, value)
    amount_scrollbar:setText(value)
    amount_scrollbar:setValue(value)
  end

  seller_btn.onClick = function() 
  sellProduct(itemid, name, gender, level, ispokemon, amount_scrollbar:getValue(), integgerAttribute)

  end
end)

ProtocolGame.registerExtendedOpcode(112, function(protocol, opcode, buffer) -- insert my offers in panel seller
  local param = buffer:explode("@")
  local itemid = tonumber(param[1])
  local itemname = tostring(param[2])
  local itemslotmsg = tostring(param[2])
  local itemtime = tonumber(param[3])
  local amount = tonumber(param[4])
  local price = tonumber(param[5])
  local gender = tonumber(param[6])
  local level = tonumber(param[7])
  local ispokemon = tostring(param[8])
  local description = tostring(param[9])
  local count_row = tonumber(param[10])
  local count_row_id = tonumber(param[11])
  local transaction_id = tonumber(param[12])
-- copia
  if not registered[count_row] then
    local button = g_ui.createWidget("UIButton", products_list2)
    button:setId("button"..count_row)
    button:setSize("454 33")
    button:setBackgroundColor("#1a1314")
    button:setBorderWidth(1)
	button:setBorderColor("#362a2b")
    button:setMarginTop(2)
    button:setMarginBottom(1)
    button:setMarginLeft(2)
    button:setMarginRight(-454)
    button.onClick = function()
      for i = 1, #registered do
        if products_list2:getChildById("button"..i) then
          products_list2:getChildById("button"..i):setBackgroundColor("#1a1314")
        end
      end

      button:setBackgroundColor("#EFCDF350")
    end

    button.onMouseRelease = function(self, mousePosition, mouseButton) 
       if mouseButton == 2 then
        for i = 1, #registered do
          if products_list2:getChildById("button"..i) then
            products_list2:getChildById("button"..i):setBackgroundColor("#1a1314")
          end
        end
  
        button:setBackgroundColor("#EFCDF350")

        local menu = g_ui.createWidget("PopupMenu")
        menu:addOption(tr("Cancelar"), function() 
          if not g_game.isOnline() then
             return
          end
          g_game.getProtocolGame():sendExtendedOpcode(105, transaction_id.."@") 
			if not g_game.isOnline() then
				return
			end
			g_game.getProtocolGame():sendExtendedOpcode(104, "receiveMyItems")
        end)
		
		
        menu:display(mousePosition)
       end
    end

    local numeration = g_ui.createWidget("Label", button)
    numeration:addAnchor(AnchorTop, "parent", AnchorTop)
    numeration:addAnchor(AnchorLeft, "parent", AnchorLeft)
    numeration:setMarginLeft(5)
    numeration:setMarginTop(7)
    numeration:setText(count_row)

	local item = g_ui.createWidget("Item", button)
	item:setSize("27 27")
	item:addAnchor(AnchorTop, "parent", AnchorTop)
	item:addAnchor(AnchorLeft, "parent", AnchorLeft)
	item:setMarginLeft(40)
	item:setMarginTop(2)
	if itemname and string.find(itemname, "%[L%]") then
		item:setImageSource("/images/game/slots/rarity-purple")
	elseif itemname and string.find(itemname, "%[R%]") then
		item:setImageSource("/images/game/slots/rarity-orange")
	elseif itemname and string.find(itemname, "%[N%]") then
		item:setImageSource("/images/game/slots/rarity-green")
	end
	item:setVirtual(true)
	item:setItemId(itemid)

	item.onMouseRelease = function(widget, mousePos, mouseButton)
		if mouseButton == MouseLeftButton then
			displayErrorBox(tr, itemslotmsg)
		end
	end

    local name = g_ui.createWidget("Label", button)
    name:addAnchor(AnchorTop, "parent", AnchorTop)
    name:addAnchor(AnchorLeft, "parent", AnchorLeft)
	local maxCharacters = 15
	if string.len(itemname) > maxCharacters then
		itemname = string.sub(itemname, 1, maxCharacters) .. "..."
	end
	name:setFont('verdana-11px-rounded')
	name:setMarginLeft(82)
	name:setMarginTop(7)
	name:setText(""..itemname.."   ")

    local time = g_ui.createWidget("Label", button)
    time:setId("time"..count_row)
    time:addAnchor(AnchorTop, "parent", AnchorTop)
    time:addAnchor(AnchorLeft, "parent", AnchorLeft)
    time:setMarginLeft(225)
    time:setMarginTop(7)
	time:setFont('verdana-11px-rounded')

    if itemtime - os.time() > 0 then
       time:setText(os.date("%X", itemtime - os.time()))
    else
      time:setText("Expired   ")
    end

    local count = g_ui.createWidget("Label", button)
    count:addAnchor(AnchorTop, "parent", AnchorTop)
    count:addAnchor(AnchorLeft, "parent", AnchorLeft)
    count:setMarginLeft(345)
    count:setMarginTop(7)
    count:setText(""..amount.."   ")
	count:setFont('verdana-11px-rounded')

    local pricee = g_ui.createWidget("Label", button)
    pricee:addAnchor(AnchorTop, "parent", AnchorTop)
    pricee:addAnchor(AnchorLeft, "parent", AnchorLeft)
    pricee:setMarginLeft(430)
    pricee:setMarginTop(7)
    pricee:setText(""..abreviateNumber(price).."   ")
	pricee:setFont('verdana-11px-rounded')
    registered[count_row] = itemname
    time_list[count_row] = itemtime
    transaction_id_list[count_row] = transaction_id
  end

  cycleEvent(updateTimeSellerProducts, 1000)
  cycleEvent(updateTimeSellerProducts2, 1000)
end)

ProtocolGame.registerExtendedOpcode(113, function(protocol, opcode, buffer) -- insert my offers in panel seller
  local param = buffer:explode("@")
  local itemid = tonumber(param[1])
  local itemname = tostring(param[2])
  local itemtime = tonumber(param[3])
  local amount = tonumber(param[4])
  local price = tonumber(param[5])
  local gender = tonumber(param[6])
  local level = tonumber(param[7])
  local ispokemon = tostring(param[8])
  local description = tostring(param[9])
  local count_row = tonumber(param[10])
  local count_row_id = tonumber(param[11])
  local transaction_id = tonumber(param[12])

  if not registered[count_row] then
    local button = g_ui.createWidget("UIButton", products_list2)
    button:setId("button"..count_row)
    button:setSize("454 33")
    button:setBackgroundColor("#1a1314")
    button:setMarginTop(-3)
    button:setMarginBottom(5)
    button:setMarginLeft(0)
    button:setMarginRight(-454)
    button.onClick = function()
      for i = 1, #registered do
        if products_list2:getChildById("button"..i) then
          products_list2:getChildById("button"..i):setBackgroundColor("#1a1314")
        end
      end

      button:setBackgroundColor("#EFCDF350")
    end

    button.onMouseRelease = function(self, mousePosition, mouseButton) 
       if mouseButton == 2 then
        for i = 1, #registered do
          if products_list2:getChildById("button"..i) then
            products_list2:getChildById("button"..i):setBackgroundColor("#1a1314")
          end
        end
  
        --button:setBackgroundColor("#EFCDF350")
		button:setBackgroundColor("#EFCDF350")
		
        local menu = g_ui.createWidget("PopupMenu")
        menu:addOption(tr("Cancelar"), function() 
          if not g_game.isOnline() then
             return
          end

          g_game.getProtocolGame():sendExtendedOpcode(105, transaction_id.."@") 
        end)
        menu:display(mousePosition)
       end
    end

    local numeration = g_ui.createWidget("Label", button)
    numeration:addAnchor(AnchorTop, "parent", AnchorTop)
    numeration:addAnchor(AnchorLeft, "parent", AnchorLeft)
    numeration:setMarginLeft(8)
    numeration:setMarginTop(13)
    numeration:setText(""..count_row.."   ")

    local item = g_ui.createWidget("Item", button)
    item:setSize("27 27")
    item:addAnchor(AnchorTop, "parent", AnchorTop)
    item:addAnchor(AnchorLeft, "parent", AnchorLeft)
    item:setMarginLeft(42)
    item:setMarginTop(5)
	if itemname and string.find(itemname, "%[L%]") then
		item:setImageSource("/images/game/slots/rarity-purple")
	elseif itemname and string.find(itemname, "%[R%]") then
		item:setImageSource("/images/game/slots/rarity-orange")
	elseif itemname and string.find(itemname, "%[N%]") then
		item:setImageSource("/images/game/slots/rarity-green")
	end
    item:setVirtual(true)
    item:setItemId(itemid)

    local name = g_ui.createWidget("Label", button)
    name:addAnchor(AnchorTop, "parent", AnchorTop)
    name:addAnchor(AnchorLeft, "parent", AnchorLeft)
	local maxCharacters = 15
	if string.len(itemname) > maxCharacters then
		itemname = string.sub(itemname, 1, maxCharacters) .. "..."
	end
	name:setMarginLeft(82)
	name:setMarginTop(7)
	name:setText(""..itemname.."   ")
	name:setFont('verdana-11px-rounded')

    local time = g_ui.createWidget("Label", button)
    time:setId("time"..count_row)
    time:addAnchor(AnchorTop, "parent", AnchorTop)
    time:addAnchor(AnchorLeft, "parent", AnchorLeft)
    time:setMarginLeft(225)
    time:setMarginTop(7)
	time:setFont('verdana-11px-rounded')

    if itemtime - os.time() > 0 then
       time:setText(os.date("%X", ""..itemtime.."   "))
    else
      time:setText("Expired   ")
    end

    local count = g_ui.createWidget("Label", button)
    count:addAnchor(AnchorTop, "parent", AnchorTop)
    count:addAnchor(AnchorLeft, "parent", AnchorLeft)
    count:setMarginLeft(345)
    count:setMarginTop(7)
    count:setText(""..amount.."   ")
	count:setFont('verdana-11px-rounded')

    local pricee = g_ui.createWidget("Label", button)
    pricee:addAnchor(AnchorTop, "parent", AnchorTop)
    pricee:addAnchor(AnchorLeft, "parent", AnchorLeft)
    pricee:setMarginLeft(430)
    pricee:setMarginTop(7)
    pricee:setText(""..price.."   ")
	pricee:setFont('verdana-11px-rounded')

    registered[count_row] = itemname
    time_list[count_row] = itemtime
    transaction_id_list[count_row] = transaction_id
  end

  cycleEvent(updateTimeSellerProducts, 1000)
  cycleEvent(updateTimeSellerProducts2, 1000)
end)

ProtocolGame.registerExtendedOpcode(114, function(protocol, opcode, buffer) -- destroy items in panel seller
  local param = buffer:explode("@")

  if param[1] == "destroy" then -- panel seller
    products_list2:destroyChildren()

    for i = 1, #registered do
      registered[i] = nil
    end
  
    for i = 1, #time_list do
      time_list[i] = nil
    end

    for i = 1, #transaction_id_list do
      transaction_id_list[i] = nil
    end
  end

  if param[1] == "destroy2" then -- panel buy
    products_list:destroyChildren()

    for i = 1, #registered2 do
      registered2[i] = nil
    end
  end

  if param[1] == "destroy3" then -- panel historic
    products_list5:destroyChildren()
    
    for i = 1, #registered3 do
      registered3[i] = nil
    end
  end

  if param[1] == "destroy4" then -- your offers panel
    products_list4:destroyChildren()
    for i = 1, #registered4 do
      registered4[i] = nil
    end
  end

  if param[1] == "destroy5" then -- offers to you panel
    products_list3:destroyChildren()

    for i = 1, #registered5 do
      registered5[i] = nil
    end
  end
end)

ProtocolGame.registerExtendedOpcode(115, function(protocol, opcode, buffer) -- insert my offers in panel buy
  local param = buffer:explode("@")
  local itemid = tonumber(param[1])
  local itemname = tostring(param[2])
  local itemslotmsg = tostring(param[2])
  local item_seller = tostring(param[3])
  local amount = tonumber(param[4])
  local price = tonumber(param[5])
  local gender = tonumber(param[6])
  local level = tonumber(param[7])
  local ispokemon = tostring(param[8])
  local description = tostring(param[9])
  local count_row = tonumber(param[10])
  local count_row_id = tonumber(param[11])
  local transaction_id = tonumber(param[12])
  local onlyoffers = tonumber(param[13])
  local page_numeration = tonumber(param[14])
  local item_time = tonumber(param[15])
  globalCount_numerationsPage = page_numeration
  if not registered2[count_row] then
    local button = g_ui.createWidget("UIButton", products_list)
    button:setId("button"..count_row)
    button:setSize("454 33")
    button:setBackgroundColor("#1a1314")
    button:setBorderWidth(1)
	  button:setBorderColor("#362a2b")
    button:setMarginTop(2)
    button:setMarginBottom(1)
    button:setMarginLeft(2)
    button:setMarginRight(-454)
    button.onClick = function()
      for i = 1, #registered2 do
        if products_list:getChildById("button"..i) then
          products_list:getChildById("button"..i):setBackgroundColor("#1a1314")
        end
      end

      button:setBackgroundColor("#EFCDF350")

      -- Enable Buy Buttons
      comprarAgora_btn:setEnabled(true)
      comprarAgora_btn.onClick = function()
        buyProduct(itemid, amount, price, transaction_id, onlyoffers)
      end

      fazerOferta_btn:setEnabled(true)
      fazerOferta_btn.onClick = function()
      end

    button.onMouseRelease = function(self, mousePosition, mouseButton) 
       if mouseButton == 2 then
        for i = 1, #registered2 do
          if products_list:getChildById("button"..i) then
            products_list:getChildById("button"..i):setBackgroundColor("#1a1314")
          end
        end
  
        button:setBackgroundColor("#EFCDF350")

        -- Enable Buy Buttons
        comprarAgora_btn:setEnabled(true)
        comprarAgora_btn.onClick = function()
          buyProduct(itemid, amount, price, transaction_id, onlyoffers)
        end

        fazerOferta_btn:setEnabled(true)
        end

          local confirm_button_offer = g_ui.createWidget("Button", makeoffer)
          confirm_button_offer:setMarginTop(140)
          confirm_button_offer:setMarginLeft(287)
          confirm_button_offer:setColor("white")
          confirm_button_offer:setSize("86 24")
          confirm_button_offer:setText("Confirmar")
          confirm_button_offer.onClick = function()

             -- Disable Buy Buttons
            comprarAgora_btn:setEnabled(false)
            comprarAgora_btn.onClick = function() end

            fazerOferta_btn:setEnabled(false)
            fazerOferta_btn.onClick = function() end
        end

        local menu = g_ui.createWidget("PopupMenu")

       end
    end

    local numeration = g_ui.createWidget("Label", button)
    numeration:addAnchor(AnchorTop, "parent", AnchorTop)
    numeration:addAnchor(AnchorLeft, "parent", AnchorLeft)
    numeration:setMarginLeft(5)
    numeration:setMarginTop(7)
    numeration:setText(""..count_row.."   ")

	local item = g_ui.createWidget("Item", button)
	item:setSize("27 27")
	item:addAnchor(AnchorTop, "parent", AnchorTop)
	item:addAnchor(AnchorLeft, "parent", AnchorLeft)
	item:setMarginLeft(40)
	item:setMarginTop(2)
	if itemname and string.find(itemname, "%[L%]") then
		item:setImageSource("/images/game/slots/rarity-purple")
	elseif itemname and string.find(itemname, "%[R%]") then
		item:setImageSource("/images/game/slots/rarity-orange")
	elseif itemname and string.find(itemname, "%[N%]") then
		item:setImageSource("/images/game/slots/rarity-green")
	end
	item:setVirtual(true)
	item:setItemId(itemid)

	item.onMouseRelease = function(widget, mousePos, mouseButton)
		if mouseButton == MouseLeftButton then
			displayErrorBox(tr, itemslotmsg)
		end
	end

    local name = g_ui.createWidget("Label", button)
    name:addAnchor(AnchorTop, "parent", AnchorTop)
    name:addAnchor(AnchorLeft, "parent", AnchorLeft)
	local maxCharacters = 15
	if string.len(itemname) > maxCharacters then
		itemname = string.sub(itemname, 1, maxCharacters) .. "..."
	end
	name:setMarginLeft(82)
	name:setMarginTop(7)
	name:setFont('verdana-11px-rounded')
	name:setText(""..itemname.."   ")

	local seller = g_ui.createWidget("Label", button)
	seller:addAnchor(AnchorTop, "parent", AnchorTop)
	seller:addAnchor(AnchorLeft, "parent", AnchorLeft)
	seller:setText(""..item_seller.."  ")
	local widgetWidth = seller:getTextSize().width
	seller:setMarginLeft((button:getWidth() - widgetWidth) / 2)
	seller:setFont('verdana-11px-rounded')
	seller:setMarginTop(7)

    local count = g_ui.createWidget("Label", button)
    count:addAnchor(AnchorTop, "parent", AnchorTop)
    count:addAnchor(AnchorLeft, "parent", AnchorLeft)
    count:setMarginLeft(345)
    count:setMarginTop(7)
	count:setFont('verdana-11px-rounded')
    count:setText(""..amount.."   ")

    local pricee = g_ui.createWidget("Label", button)
    pricee:addAnchor(AnchorTop, "parent", AnchorTop)
    pricee:addAnchor(AnchorLeft, "parent", AnchorLeft)
    pricee:setMarginLeft(430)
	pricee:setFont('verdana-11px-rounded')
    pricee:setMarginTop(7)
    
    pricee:setText(""..abreviateNumber(price).."   ")

    registered2[count_row] = itemname
  end

  cycleEvent(updateTimeSellerProducts, 1000)
  cycleEvent(updateTimeSellerProducts2, 1000)
end)

ProtocolGame.registerExtendedOpcode(116, function(protocol, opcode, buffer) -- insert market options
  local param = buffer:split("@")
  local option = tostring(param[1])

  if not options_list[option] then
    category:addOption(option)
    options_list[option] = option
  end

  category.onOptionChange = function(self, value)
    if not g_game.isOnline() then
      return
    end

    g_game.getProtocolGame():sendExtendedOpcode(118, value.."@")
  end
end)

ProtocolGame.registerExtendedOpcode(118, function(protocol, opcode, buffer) -- insert market item in window offer items
  local param = buffer:split("@")
  local item_id = tostring(param[1])
  local description = tostring(param[2])
  local amount = tonumber(param[3])

  if description == "" then
    description = tostring(amount)
  end

  if not makeoffer then
    return
  end

  for i = 1, 8 do
    local panel = makeoffer:getChildById("panel")
    local item = panel:getChildById("item"..i)
    if not item:getItem() then
      item:setVirtual(true)
      item:setItemId(item_id)
      break
    end
  end
end)

ProtocolGame.registerExtendedOpcode(119, function(protocol, opcode, buffer) -- insert market item in your offers
  local param = buffer:explode("@")
  local item_id = tonumber(param[1])
  local item_name = tostring(param[2])
  local item_seller = tostring(param[3])
  local count_row = tonumber(param[4])
  local description = tostring(param[5])
  local transaction_id = tonumber(param[6])
-- offer baixo
  if not registered4[count_row] then
    local button = g_ui.createWidget("UIButton", products_list4)
    button:setId("button"..count_row)
    button:setSize("454 33")
    button:setBackgroundColor("#1a1314")
    button:setBorderWidth(1)
	button:setBorderColor("#362a2b")
    button:setMarginTop(2)
    button:setMarginBottom(1)
    button:setMarginLeft(2)
    button:setMarginRight(-456)
    button.onClick = function()
      for i = 1, #registered do
        if products_list4:getChildById("button"..i) then
          products_list4:getChildById("button"..i):setBackgroundColor("#1a1314")
        end
      end

      button:setBackgroundColor("#EFCDF350")
    end

    button.onMouseRelease = function(self, mousePosition, mouseButton) 
       if mouseButton == 2 then
        for i = 1, #registered do
          if products_list4:getChildById("button"..i) then
            products_list4:getChildById("button"..i):setBackgroundColor("#1a1314")
          end
        end
  
        button:setBackgroundColor("#EFCDF350")
      end
    end

    local numeration = g_ui.createWidget("Label", button)
    numeration:addAnchor(AnchorTop, "parent", AnchorTop)
    numeration:addAnchor(AnchorLeft, "parent", AnchorLeft)
    numeration:setMarginLeft(5)
    numeration:setMarginTop(7)
    numeration:setText(count_row)

	local item = g_ui.createWidget("Item", button)
	item:setSize("27 27")
	item:addAnchor(AnchorTop, "parent", AnchorTop)
	item:addAnchor(AnchorLeft, "parent", AnchorLeft)
	item:setMarginLeft(40)
	item:setMarginTop(2)
	if itemname and string.find(itemname, "%[L%]") then
		item:setImageSource("/images/game/slots/rarity-purple")
	elseif itemname and string.find(itemname, "%[R%]") then
		item:setImageSource("/images/game/slots/rarity-orange")
	elseif itemname and string.find(itemname, "%[N%]") then
		item:setImageSource("/images/game/slots/rarity-green")
	end
	item:setVirtual(true)
	item:setItemId(itemid)

	item.onMouseRelease = function(widget, mousePos, mouseButton)
		if mouseButton == MouseLeftButton then
			displayErrorBox(tr, itemslotmsg)
		end
	end

    local name = g_ui.createWidget("Label", button)
    name:addAnchor(AnchorTop, "parent", AnchorTop)
    name:addAnchor(AnchorLeft, "parent", AnchorLeft)
	local maxCharacters = 15
	if string.len(itemname) > maxCharacters then
		itemname = string.sub(itemname, 1, maxCharacters) .. "..."
	end
	name:setMarginLeft(82)
	name:setMarginTop(7)
	name:setText(""..itemname.."   ")
	name:setFont('verdana-11px-rounded')


    local seller = g_ui.createWidget("Label", button)
    seller:addAnchor(AnchorTop, "parent", AnchorTop)
    seller:addAnchor(AnchorLeft, "parent", AnchorLeft)
    seller:setMarginLeft(225)
    seller:setMarginTop(7)
    seller:setText(""..item_seller.."   ")
	seller:setFont('verdana-11px-rounded')

    local offer_btn = g_ui.createWidget("Button", button)
    offer_btn:setSize("62 20")
    offer_btn:addAnchor(AnchorTop, "parent", AnchorTop)
    offer_btn:addAnchor(AnchorLeft, "parent", AnchorLeft)
    offer_btn:setMarginLeft(335)
    offer_btn:setMarginTop(5)
    offer_btn:setColor("white")
    offer_btn:setText("Ver")
    offer_btn.onClick = function()
      if not g_game.isOnline() then
        return
      end

      if makeoffer then
        return
      end
            
      makeoffer = g_ui.createWidget('MakeOfferWindow', rootWidget)
      makeoffer:setText("Suas ofertas")
          
      -- Widgets
      local item_slot = g_ui.createWidget("Item", makeoffer)
      item_slot:addAnchor(AnchorTop, "parent", AnchorTop)
      item_slot:addAnchor(AnchorLeft, "parent", AnchorLeft)
      item_slot:setItemId(item_id)

      local item_name_label = g_ui.createWidget("MakeOfferItemName", item_slot)
      item_name_label:addAnchor(AnchorTop, "parent", AnchorTop)
      item_name_label:addAnchor(AnchorLeft, "parent", AnchorLeft)
      item_name_label:setText(item_name)

      local panel = g_ui.createWidget("MakeOfferPanel", makeoffer)
      panel:setId("panel")
      panel:addAnchor(AnchorTop, "parent", AnchorTop)
      panel:addAnchor(AnchorLeft, "parent", AnchorLeft)

      for i = 1, 8 do
          item_slot_offer = g_ui.createWidget("MakeOfferItem", panel)
          item_slot_offer:setVirtual(true)
          item_slot_offer:setId("item"..i)
          item_slot_offer:setMarginTop(40)
          item_slot_offer:setMarginLeft(10)
      end

      local close_button_offer = g_ui.createWidget("Button", makeoffer)
      close_button_offer:addAnchor(AnchorTop, "parent", AnchorTop)
      close_button_offer:addAnchor(AnchorLeft, "parent", AnchorLeft)
      close_button_offer:setMarginTop(140)
      close_button_offer:setMarginLeft(-2)
      close_button_offer:setColor("white")
      close_button_offer:setSize("86 24")
      close_button_offer:setText("Fechar")
      close_button_offer.onClick = function()
        for it = 1, count_row do
          if products_list:getChildById("button"..it) then
            products_list:getChildById("button"..it):setBackgroundColor("#1a1314")
          end
        end

        for it = 1, count_row do
          if products_list2:getChildById("button"..it) then
            products_list2:getChildById("button"..it):setBackgroundColor("#1a1314")
          end
        end

        for i = 1, #registered4 do
          if products_list4:getChildById("button"..i) then
            products_list4:getChildById("button"..i):setBackgroundColor("#1a1314")
          end
        end

        market:show()
        makeoffer:hide()
        makeoffer = nil
      end

      market:hide()
      g_game.getProtocolGame():sendExtendedOpcode(112, "sendViewOffers".."@"..transaction_id.."@")
    end

    local actioon_btn = g_ui.createWidget("Button", button)
    actioon_btn:setSize("72 20")
    actioon_btn:addAnchor(AnchorTop, "parent", AnchorTop)
    actioon_btn:addAnchor(AnchorLeft, "parent", AnchorLeft)
    actioon_btn:setMarginLeft(412)
    actioon_btn:setMarginTop(5)
    actioon_btn:setColor("white")
    actioon_btn:setText("Cancelar")
    actioon_btn.onClick = function()
      if not g_game.isOnline() then
        return
      end

      g_game.getProtocolGame():sendExtendedOpcode(113, "cancelTheOffer".."@"..transaction_id.."@")
    end

    registered4[count_row] = item_name
  end

  cycleEvent(updateTimeSellerProducts, 1000)
  cycleEvent(updateTimeSellerProducts2, 1000)
end)

ProtocolGame.registerExtendedOpcode(120, function(protocol, opcode, buffer) -- insert market item in offers to me
  local param = buffer:explode("@")
  local item_id = tonumber(param[1])
  local item_name = tostring(param[2])
  local description = tostring(param[3])
  local tempoo = tonumber(param[4])
  local count_row = tonumber(param[5])
  local transaction_id = tonumber(param[6])
--ofert2
  if not registered5[count_row] then
    local button = g_ui.createWidget("UIButton", products_list3)
    button:setId("button"..count_row)
    button:setSize("454 33")
    button:setBackgroundColor("#1a1314")
    button:setBorderWidth(1)
	button:setBorderColor("#362a2b")
    button:setMarginTop(2)
    button:setMarginBottom(1)
    button:setMarginLeft(2)
    button:setMarginRight(-456)
    button.onClick = function()
      for i = 1, #registered do
        if products_list4:getChildById("button"..i) then
          products_list4:getChildById("button"..i):setBackgroundColor("#1a1314")
        end
      end

      button:setBackgroundColor("#EFCDF350")
    end

    button.onMouseRelease = function(self, mousePosition, mouseButton) 
       if mouseButton == 2 then
        for i = 1, #registered do
          if products_list4:getChildById("button"..i) then
            products_list4:getChildById("button"..i):setBackgroundColor("#1a1314")
          end
        end
  
        button:setBackgroundColor("#EFCDF350")
      end
    end

    local numeration = g_ui.createWidget("Label", button)
    numeration:addAnchor(AnchorTop, "parent", AnchorTop)
    numeration:addAnchor(AnchorLeft, "parent", AnchorLeft)
    numeration:setMarginLeft(5)
    numeration:setMarginTop(7)
    numeration:setText(count_row)

    local item = g_ui.createWidget("Item", button)
    item:setSize("27 27")
    item:addAnchor(AnchorTop, "parent", AnchorTop)
    item:addAnchor(AnchorLeft, "parent", AnchorLeft)
    item:setMarginLeft(40)
    item:setMarginTop(2)
	if itemname and string.find(itemname, "%[L%]") then
		item:setImageSource("/images/game/slots/rarity-purple")
	elseif itemname and string.find(itemname, "%[R%]") then
		item:setImageSource("/images/game/slots/rarity-orange")
	elseif itemname and string.find(itemname, "%[N%]") then
		item:setImageSource("/images/game/slots/rarity-green")
	end
    item:setVirtual(true)
    item:setItemId(item_id)

    local name = g_ui.createWidget("Label", button)
    name:addAnchor(AnchorTop, "parent", AnchorTop)
    name:addAnchor(AnchorLeft, "parent", AnchorLeft)
	local maxCharacters = 15
	if string.len(itemname) > maxCharacters then
		itemname = string.sub(itemname, 1, maxCharacters) .. "..."
	end
	name:setMarginLeft(82)
	name:setMarginTop(7)
	name:setText(""..itemname.."   ")
	name:setFont('verdana-11px-rounded')


    local offer_btn = g_ui.createWidget("Button", button)
    offer_btn:setSize("62 20")
    offer_btn:addAnchor(AnchorTop, "parent", AnchorTop)
    offer_btn:addAnchor(AnchorLeft, "parent", AnchorLeft)
    offer_btn:setMarginLeft(240)
    offer_btn:setMarginTop(5)
    offer_btn:setColor("white")
    offer_btn:setText("Ver")
    offer_btn.onClick = function()
      if not g_game.isOnline() then
        return
      end

      if makeoffer then
        return
      end
            
      makeoffer = g_ui.createWidget('MakeOfferWindow', rootWidget)
      makeoffer:setText("Suas ofertas")
          
      -- Widgets
      local item_slot = g_ui.createWidget("Item", makeoffer)
      item_slot:setVirtual(true)
      item_slot:addAnchor(AnchorTop, "parent", AnchorTop)
      item_slot:addAnchor(AnchorLeft, "parent", AnchorLeft)
      item_slot:setItemId(item_id)

      local item_name_label = g_ui.createWidget("MakeOfferItemName", item_slot)
      item_name_label:addAnchor(AnchorTop, "parent", AnchorTop)
      item_name_label:addAnchor(AnchorLeft, "parent", AnchorLeft)
      item_name_label:setText(item_name)

      local panel = g_ui.createWidget("MakeOfferPanel", makeoffer)
      panel:setId("panel")
      panel:addAnchor(AnchorTop, "parent", AnchorTop)
      panel:addAnchor(AnchorLeft, "parent", AnchorLeft)

      for i = 1, 8 do
          item_slot_offer = g_ui.createWidget("MakeOfferItem", panel)
      end

      local close_button_offer = g_ui.createWidget("Button", makeoffer)
      close_button_offer:addAnchor(AnchorTop, "parent", AnchorTop)
      close_button_offer:addAnchor(AnchorLeft, "parent", AnchorLeft)
      close_button_offer:setMarginTop(140)
      close_button_offer:setMarginLeft(-2)
      close_button_offer:setColor("white")
      close_button_offer:setSize("86 24")
      close_button_offer:setText("Fechar")
      close_button_offer.onClick = function()
        for it = 1, count_row do
          if products_list:getChildById("button"..it) then
            products_list:getChildById("button"..it):setBackgroundColor("#1a1314")
          end
        end

        for it = 1, count_row do
          if products_list2:getChildById("button"..it) then
            products_list2:getChildById("button"..it):setBackgroundColor("#1a1314")
          end
        end

        for i = 1, #registered4 do
          if products_list4:getChildById("button"..i) then
            products_list4:getChildById("button"..i):setBackgroundColor("#1a1314")
          end
        end

        market:show()
        makeoffer:hide()
        makeoffer = nil
      end

      g_game.getProtocolGame():sendExtendedOpcode(115, "viewOffersToMe".."@"..transaction_id.."@")
    end

    local cancel_btn = g_ui.createWidget("Button", button)
    cancel_btn:setSize("72 20")
    cancel_btn:addAnchor(AnchorTop, "parent", AnchorTop)
    cancel_btn:addAnchor(AnchorLeft, "parent", AnchorLeft)
    cancel_btn:setMarginLeft(412)
    cancel_btn:setMarginTop(5)
    cancel_btn:setColor("white")
    cancel_btn:setText("Cancelar")
    cancel_btn.onClick = function()
      g_game.getProtocolGame():sendExtendedOpcode(142, "cancelTheOffer".."@"..transaction_id.."@")
    end

    local tempo = g_ui.createWidget("Label", button)
    tempo:setId("time"..count_row)
    tempo:addAnchor(AnchorTop, "parent", AnchorTop)
    tempo:addAnchor(AnchorLeft, "parent", AnchorLeft)
    tempo:setMarginLeft(343)
    tempo:setMarginTop(7)
    
    if tempoo - os.time() > 0 then
      tempo:setText(os.date("%X", tempoo - os.time()))
    else
      tempo:setText("Expired")
    end

    local actioon_btn = g_ui.createWidget("Button", button)
    actioon_btn:setSize("82 23")
    actioon_btn:addAnchor(AnchorTop, "parent", AnchorTop)
    actioon_btn:addAnchor(AnchorLeft, "parent", AnchorLeft)
    actioon_btn:setMarginLeft(267)
    actioon_btn:setMarginTop(10)
    actioon_btn:setColor("white")
    actioon_btn:setText("Confirmar")
    actioon_btn.onClick = function()
      if not g_game.isOnline() then
        return
      end

      if tempoo - os.time() <= 0 then
        displayErrorBox(tr, "Essa oferta nao esta mais disponivel")
        return
      end

      g_game.getProtocolGame():sendExtendedOpcode(116, "confirmTheOffer".."@"..transaction_id.."@")
      g_game.getProtocolGame():sendExtendedOpcode(111, "receiveMarketYourOffers".."@")
      g_game.getProtocolGame():sendExtendedOpcode(114, "receiveMarketOffersToMe".."@")
    end

    time_list2[count_row] = tempoo
    transaction_id_list2[count_row] = transaction_id
    registered5[count_row] = item_name
  end

  cycleEvent(updateTimeSellerProducts, 1000)
  cycleEvent(updateTimeSellerProducts2, 1000)
end)

-- Categoria de Venda
function sellproductCategory()
  g_game.getProtocolGame():sendExtendedOpcode(104, "receiveMyItems")
  g_game.getProtocolGame():sendExtendedOpcode(117, "receiveMyItems")

  -- Aba de Compra
  category_label:hide()
  category:hide()
  search_product:hide()
  search_btn:hide()
  sharp_btn:hide()
  item_btn:hide()
  itemname_btn:hide()
  vendedor_btn:hide()
  quantidade_btn:hide()
  preco_btn:hide()
  products_list:hide()
  products_scrollbar:hide()
  comprarAgora_btn:hide()
  fazerOferta_btn:hide()
  atualizar_btn:hide()
  fechar_btn:hide()

  -- Aba de Venda
  seller_panel:show()
  item_seller:show()
  item_name:show()
  pokemon_gender:show()
  amount_text:show()
  priceperunit_text:show()
  priceperunit_textedit:show()
  select_objectbtn:show()
  seller_btn:show()
  sharp2_btn:show()
  item2_btn:show()
  itemname2_btn:show()
  tempo_btn:show()
  quantidade2_btn:show()
  preco2_btn:show()
  products_list2:show()
  products_scrollbar2:show()
  atualizar2_btn:show()
  fechar2_btn:show()
  amount_scrollbar:show()

  atualizar2_btn.onClick = function()
    if not g_game.isOnline() then
      return
    end

    g_game.getProtocolGame():sendExtendedOpcode(104, "receiveMyItems")
    g_game.getProtocolGame():sendExtendedOpcode(117, "receiveMyItems")

    scheduleEvent(function()
      sellproductCategory()
    end, 40)
  end

  fechar2_btn.onClick = function()
    exibir()
  end

  -- Aba de Ofertas
  hideOffertTab()

  -- Aba de Historico
  products_list5:hide()
  products_scrollbar5:hide()
  fechar4_btn:hide()

  item_seller:setText("")
  item_seller:setItemId(0)
  item_name:setText("")
  pokemon_gender:setImageSource("")
  priceperunit_textedit:setText("")

  amount_scrollbar:setText(1)
  amount_scrollbar:setMaximum(1)
  amount_scrollbar:setMinimum(1)
  amount_scrollbar:setValue(1)

  -- Disable Buy Buttons
  comprarAgora_btn:setEnabled(false)
  comprarAgora_btn.onClick = function() end

  fazerOferta_btn:setEnabled(false)
  fazerOferta_btn.onClick = function() end

  for i = 1, #registered2 do
    if products_list:getChildById("button"..i) then
      products_list:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end

  for i = 1, #registered do
    if products_list2:getChildById("button"..i) then
      products_list2:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end

  for i = 1, #registered3 do
    if products_list3:getChildById("button"..i) then
      products_list3:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end

  for i = 1, #registered4 do
    if products_list4:getChildById("button"..i) then
      products_list4:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end

  if not g_game.isOnline() then
     return
  end

  g_game.getProtocolGame():sendExtendedOpcode(104, "receiveMyItems")
end

-- Categoria de Compra
function buyproductCategory()

  -- Aba de Compra
  category_label:show()
  category:show()
  search_product:show()
  search_btn:show()
search_btn.onClick = function()
    if not g_game.isOnline() then
        return
    end

    local searchText = search_product:getText()
    if searchText == "" then
        return
    end

    g_game.getProtocolGame():sendExtendedOpcode(134, searchText .. "@" .. category:getText() .. "@")
end

-- Manipulador de eventos para a tecla Enter
search_product.onKeyDown = function(widget, keyCode, keyboardModifiers)
    if keyCode == KeyReturn or keyCode == KeyEnter then
        if not g_game.isOnline() then
            return
        end

        local searchText = search_product:getText()
        if searchText == "" then
            return
        end

        g_game.getProtocolGame():sendExtendedOpcode(134, searchText .. "@" .. category:getText() .. "@")
    end
end

  sharp_btn:show()
  item_btn:show()
  itemname_btn:show()
  vendedor_btn:show()
  quantidade_btn:show()
  preco_btn:show()
  products_list:show()
  products_scrollbar:show()
  comprarAgora_btn:show()
  --fazerOferta_btn:show()
  atualizar_btn:show()
  fechar_btn:show()

  atualizar_btn.onClick = function()
  g_game.getProtocolGame():sendExtendedOpcode(191)
    if not g_game.isOnline() then
      return
    end

    products_list2:destroyChildren()
    for i = 1, #registered do
        registered[i] = nil
    end
    
    for i = 1, #time_list do
      time_list[i] = nil
    end
  
    for i = 1, #transaction_id_list do
      transaction_id_list[i] = nil
    end
  
    products_list:destroyChildren()
    for i = 1, #registered2 do
        registered2[i] = nil
    end

    g_game.getProtocolGame():sendExtendedOpcode(104, "receiveMyItems")
    g_game.getProtocolGame():sendExtendedOpcode(117, "receiveMyItems")
  end

  fechar_btn.onClick = function()
    exibir()
  end

  -- Aba de Venda
  seller_panel:hide()
  item_seller:hide()
  item_name:hide()
  pokemon_gender:hide()
  amount_text:hide()
  priceperunit_text:hide()
  priceperunit_textedit:hide()
  select_objectbtn:hide()
  seller_btn:hide()
  sharp2_btn:hide()
  item2_btn:hide()
  itemname2_btn:hide()
  tempo_btn:hide()
  quantidade2_btn:hide()
  preco2_btn:hide()
  products_list2:hide()
  products_scrollbar2:hide()
  atualizar2_btn:hide()
  fechar2_btn:hide()
  amount_scrollbar:hide()

  -- Aba de Ofertas
  hideOffertTab()

  -- Aba de Historico
  products_list5:hide()
  products_scrollbar5:hide()
  fechar4_btn:hide()

  item_seller:setText("")
  item_seller:setItemId(0)
  item_name:setText("")
  pokemon_gender:setImageSource("")
  priceperunit_textedit:setText("")

  amount_scrollbar:setText(1)
  amount_scrollbar:setMaximum(1)
  amount_scrollbar:setMinimum(1)
  amount_scrollbar:setValue(1)

  -- Disable Buy Buttons
  comprarAgora_btn:setEnabled(false)
  fazerOferta_btn:setEnabled(false)

  for i = 1, #registered2 do
    if products_list:getChildById("button"..i) then
      products_list:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end

  for i = 1, #registered do
    if products_list2:getChildById("button"..i) then
      products_list2:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end

  for i = 1, #registered3 do
    if products_list3:getChildById("button"..i) then
      products_list3:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end

  for i = 1, #registered4 do
    if products_list4:getChildById("button"..i) then
      products_list4:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end
end

-- Selecionar objeto
function selectObject()
  mouseGrabberWidget:grabMouse()
  g_mouse.pushCursor('target')
end

function onChooseItemMouseRelease(self, mousePosition, mouseButton)
  local item = nil
  if mouseButton == MouseLeftButton then
    local clickedWidget = modules.game_interface.getRootPanel():recursiveGetChildByPos(mousePosition, false)
    if clickedWidget then
      if clickedWidget:getClassName() == 'UIGameMap' then
        local tile = clickedWidget:getTile(mousePosition)
        if tile then
          local thing = tile:getTopMoveThing()
          if thing and thing:isItem() then
            item = thing
          end
        end
      elseif clickedWidget:getClassName() == 'UIItem' and not clickedWidget:isVirtual() then
        item = clickedWidget:getItem()
      end
    end
  end

  g_mouse.popCursor('target')
  self:ungrabMouse()
  
  local player = g_game.getLocalPlayer()
  if not player then
    return true
  end

if item then
    local ammo = player:getInventoryItem(10)
    if ammo == item then
      g_game.getProtocolGame():sendExtendedOpcode(102, "0".."@")
    else
    displayErrorBox(tr, "O item precisa estar no slot AMMO para ser anunciado no market.")
    end
  end
  return true
end

-- Vender Produto
function sellProduct(itemid, name, gender, level, ispokemon, count, integgerAttribute)
if item_seller:getItemId() == 0 then
  displayErrorBox(tr, "Precisa selecionar um item.")
return false
end
  if tonumber(priceperunit_textedit:getText()) > 999 then
  displayErrorBox(tr, "O valor precisa ser menor que 999 premium points.")
  return false
  end
  if priceperunit_textedit:getText() == "" then
    displayErrorBox(tr, "O valor precisa ser maior que 0.")
  else if not tonumber(priceperunit_textedit:getText()) then
    displayErrorBox(tr, "A Valor precisa ser maior que 0.")
  else if tonumber(priceperunit_textedit:getText()) <= 0 then
    displayErrorBox(tr, "A valor precisa ser maior que 0.")
	else if tonumber(priceperunit_textedit:getText()) > 0 then
      end
    end
  end
 end

  if tonumber(priceperunit_textedit:getText()) and tonumber(priceperunit_textedit:getText()) > 0 then
     local price = tonumber(priceperunit_textedit:getText()) -- preco + taxa
     if not g_game.isOnline() then
        return
     end

	local checked = 0
	g_game.getProtocolGame():sendExtendedOpcode(104, "receiveMyItems")
	g_game.getProtocolGame():sendExtendedOpcode(117, "receiveMyItems")
	
     g_game.getProtocolGame():sendExtendedOpcode(103, itemid.."@"..name.."@"..gender.."@"..level.."@"..ispokemon.."@"
     ..count.."@"..price.."@"..integgerAttribute.."@"..checked.."@")
     amount_scrollbar:setText("1")
     amount_scrollbar:setMaximum(1)
     amount_scrollbar:setMinimum(1)
     amount_scrollbar:setValue(1)

     item_seller:setText("")
     item_seller:setItemId(0)
     item_name:setText("")
     pokemon_gender:setImageSource("")
     priceperunit_textedit:setText("")
  end
  return true
end

-- Atualizar o tempo dos produtos (aba de vendas)
function updateTimeSellerProducts()
  for i = 1, #time_list do
    local button = products_list2:getChildById("button"..i)
    if button then
      local time = button:getChildById("time"..i)
      if time_list[i] - os.time() > 0 then
        time:setText(os.date("%X", time_list[i] - os.time()))
      else
        time:setText("Expired")
      end
    end
  end
end

-- Atualizar o tempo dos produtos (aba de ofertas)
function updateTimeSellerProducts2()
  for i = 1, #time_list2 do
    local button = products_list3:getChildById("button"..i)
    if button then
      local time = button:getChildById("time"..i)
      if time_list2[i] - os.time() > 0 then
        time:setText(os.date("%X", time_list2[i] - os.time()))
      else
        time:setText("Expired")
      end
    end
  end
end

-- Abrir janela de comprar do produto
function buyProduct(id, count, price, transaction_id, onlyoffers)
  if countWindow then
    return
  end

  market:hide()
  countWindow = g_ui.createWidget('CountWindow', rootWidget)
  countWindow:setText("Comprar agora")

  local itembox = countWindow:getChildById('item')
  local scrollbar = countWindow:getChildById('countScrollBar')
  itembox:setItemId(id)
  itembox:setItemCount(count)
  scrollbar:setMaximum(count)
  scrollbar:setMinimum(count)
  scrollbar:setValue(count)

  local spinbox = countWindow:getChildById('spinBox')
  spinbox:setMaximum(count)
  spinbox:setMinimum(count)
  spinbox:setValue(count)
  spinbox:hideButtons()
  spinbox:focus()
  spinbox.firstEdit = true

  local spinBoxValueChange = function(self, value)
    spinbox.firstEdit = false
    scrollbar:setValue(value)
  end
  spinbox.onValueChange = spinBoxValueChange

  local check = function()
    if spinbox.firstEdit then
      spinbox:setValue(spinbox:getMaximum())
      spinbox.firstEdit = false
    end
  end
  g_keyboard.bindKeyPress("Up", function() check() spinbox:up() end, spinbox)
  g_keyboard.bindKeyPress("Down", function() check() spinbox:down() end, spinbox)
  g_keyboard.bindKeyPress("Right", function() check() spinbox:up() end, spinbox)
  g_keyboard.bindKeyPress("Left", function() check() spinbox:down() end, spinbox)
  g_keyboard.bindKeyPress("PageUp", function() check() spinbox:setValue(spinbox:getValue()+10) end, spinbox)
  g_keyboard.bindKeyPress("PageDown", function() check() spinbox:setValue(spinbox:getValue()-10) end, spinbox)

  scrollbar.onValueChange = function(self, value)
    itembox:setItemCount(value)
    spinbox.onValueChange = nil
    spinbox:setValue(value)
    spinbox.onValueChange = spinBoxValueChange
  end

  local okButton = countWindow:getChildById('buttonOk')
  local buyFunc = function()
    if onlyoffers == 0 then
      g_game.getProtocolGame():sendExtendedOpcode(106, price.."@"..transaction_id.."@"..scrollbar:getValue().."@")
	  g_game.getProtocolGame():sendExtendedOpcode(191)
      market:show()
      okButton:getParent():destroy()
      countWindow = nil
    else
      market:show()
      okButton:getParent():destroy()
      countWindow = nil
    end
  end

  local cancelButton = countWindow:getChildById('buttonCancel')
  local cancelFunc = function()
    market:show()
    cancelButton:getParent():destroy()
    countWindow = nil
  end

  countWindow.onEnter = buyFunc
  countWindow.onEscape = cancelFunc

  okButton.onClick = buyFunc
  cancelButton.onClick = cancelFunc
end

-- Mostrar as ofertas que eu fiz e o ofertas que recebi
function offersCategory()

  -- Aba de Compra
  category_label:hide()
  category:hide()
  search_product:hide()
  search_btn:hide()
  sharp_btn:hide()
  item_btn:hide()
  itemname_btn:hide()
  vendedor_btn:hide()
  quantidade_btn:hide()
  preco_btn:hide()
  products_list:hide()
  products_scrollbar:hide()
  comprarAgora_btn:hide()
  fazerOferta_btn:hide()
  atualizar_btn:hide()
  fechar_btn:hide()

  -- Aba de Venda
  seller_panel:hide()
  item_seller:hide()
  item_name:hide()
  pokemon_gender:hide()
  amount_text:hide()
  priceperunit_text:hide()
  priceperunit_textedit:hide()
  select_objectbtn:hide()
  seller_btn:hide()
  sharp2_btn:hide()
  item2_btn:hide()
  itemname2_btn:hide()
  tempo_btn:hide()
  quantidade2_btn:hide()
  preco2_btn:hide()
  products_list2:hide()
  products_scrollbar2:hide()
  atualizar2_btn:hide()
  fechar2_btn:hide()
  amount_scrollbar:hide()

  -- Aba de Ofertas
  showOffertTab()

  -- Aba de Historico
  products_list5:hide()
  products_scrollbar5:hide()
  fechar4_btn:hide()

  item_seller:setText("")
  item_seller:setItemId(0)
  item_name:setText("")
  pokemon_gender:setImageSource("")
  priceperunit_textedit:setText("")

  amount_scrollbar:setText(1)
  amount_scrollbar:setMaximum(1)
  amount_scrollbar:setMinimum(1)
  amount_scrollbar:setValue(1)

  -- Disable Buy Buttons
  comprarAgora_btn:setEnabled(false)
  fazerOferta_btn:setEnabled(false)

  for i = 1, #registered2 do
    if products_list:getChildById("button"..i) then
      products_list:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end

  for i = 1, #registered do
    if products_list2:getChildById("button"..i) then
      products_list2:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end

  for i = 1, #registered3 do
    if products_list3:getChildById("button"..i) then
      products_list3:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end

  for i = 1, #registered4 do
    if products_list4:getChildById("button"..i) then
      products_list4:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end

  if not g_game.isOnline() then
    return
  end

  g_game.getProtocolGame():sendExtendedOpcode(111, "receiveMarketYourOffers".."@")
  g_game.getProtocolGame():sendExtendedOpcode(114, "receiveMarketOffersToMe".."@")
end

-- Mostrar o meu historico de compras do market
function historicCategory()
  -- Aba de Compra
  category_label:hide()
  category:hide()
  search_product:hide()
  search_btn:hide()
  sharp_btn:hide()
  item_btn:hide()
  itemname_btn:hide()
  vendedor_btn:hide()
  quantidade_btn:hide()
  preco_btn:hide()
  products_list:hide()
  products_scrollbar:hide()
  comprarAgora_btn:hide()
  fazerOferta_btn:hide()
  atualizar_btn:hide()
  fechar_btn:hide()

  -- Aba de Venda
  seller_panel:hide()
  item_seller:hide()
  item_name:hide()
  pokemon_gender:hide()
  amount_text:hide()
  priceperunit_text:hide()
  priceperunit_textedit:hide()
  select_objectbtn:hide()
  seller_btn:hide()
  sharp2_btn:hide()
  item2_btn:hide()
  itemname2_btn:hide()
  tempo_btn:hide()
  quantidade2_btn:hide()
  preco2_btn:hide()
  products_list2:hide()
  products_scrollbar2:hide()
  atualizar2_btn:hide()
  fechar2_btn:hide()
  amount_scrollbar:hide()

  -- Aba de Ofertas
  hideOffertTab()

  -- Aba de Historico
  products_list5:show()
  products_scrollbar5:show()
  fechar4_btn:show()
  fechar4_btn.onClick = function()
    exibir()
  end

  item_seller:setText("")
  item_seller:setItemId(0)
  item_name:setText("")
  pokemon_gender:setImageSource("")
  priceperunit_textedit:setText("")

  amount_scrollbar:setText(1)
  amount_scrollbar:setMaximum(1)
  amount_scrollbar:setMinimum(1)
  amount_scrollbar:setValue(1)

  -- Disable Buy Buttons
  comprarAgora_btn:setEnabled(false)
  fazerOferta_btn:setEnabled(false)

  for i = 1, #registered2 do
    if products_list:getChildById("button"..i) then
      products_list:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end

  for i = 1, #registered do
    if products_list2:getChildById("button"..i) then
      products_list2:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end

  for i = 1, #registered3 do
    if products_list3:getChildById("button"..i) then
      products_list3:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end

  for i = 1, #registered4 do
    if products_list4:getChildById("button"..i) then
      products_list4:getChildById("button"..i):setBackgroundColor("#1a1314")
    end
  end

  if not g_game.isOnline() then
    return
  end

  g_game.getProtocolGame():sendExtendedOpcode(107, "receiveMarketHistoric")
end

-- Ocultar a quantidade de widgets da aba de oferta, por que nao deu pra alocar mais widgets na function
function hideOffertTab()

  -- Aba de Ofertas
  offers_tome:hide()
  sharp3_btn:hide()
  item3_btn:hide()
  itemname3_btn:hide()
  offers3_btn:hide()
  tempo3_btn:hide()
  action_btn:hide()
  products_list3:hide()
  products_scrollbar3:hide()
  offer_myoffers:hide()
  products_list4:hide()
  products_scrollbar4:hide()
  sharp4_btn:hide()
  item4_btn:hide()
  itemname4_btn:hide()
  seller3_btn:hide()
  offers4_btn:hide()
  action2_btn:hide()
  atualizar3_btn:hide()
  fechar3_btn:hide()
end

-- Mostrar a quantidade de widgets da aba de oferta, por que nao deu pra alocar mais widgets na function
function showOffertTab()

  -- Aba de Ofertas
  offers_tome:show()
  sharp3_btn:show()
  item3_btn:show()
  itemname3_btn:show()
  offers3_btn:show()
  tempo3_btn:show()
  action_btn:show()
  products_list3:show()
  products_scrollbar3:show()
  offer_myoffers:show()
  products_list4:show()
  products_scrollbar4:show()
  sharp4_btn:show()
  item4_btn:show()
  itemname4_btn:show()
  seller3_btn:show()
  offers4_btn:show()
  action2_btn:show()
  atualizar3_btn:show()
  fechar3_btn:show()

  atualizar3_btn.onClick = function()
    if not g_game.isOnline() then
      return
    end

    g_game.getProtocolGame():sendExtendedOpcode(111, "receiveMarketYourOffers".."@")
    g_game.getProtocolGame():sendExtendedOpcode(114, "receiveMarketOffersToMe".."@")
  end

  fechar3_btn.onClick = function()
    exibir()
  end
end

-- Executar o drop e remover o item da backpack e passar para um dos 8 slots de oferta
function executeDrop(widget, item, transaction_id)
  local container = g_game.getContainer(0)
  for it = 0, container:getCapacity()-1 do
      local item2 = container:getItem(it)
      if item2 == item then
        if not g_game.isOnline() then
          return
        end

        widget:setBorderWidth(0)
        g_game.getProtocolGame():sendExtendedOpcode(110, "executeDrop".."@"..it.."@"..transaction_id.."@")
      end
  end
  return true
end