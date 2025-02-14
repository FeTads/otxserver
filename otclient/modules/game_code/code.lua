-- Criado por Thalles Vitor --
-- Inserir Codigo no Jogo

local code = g_ui.displayUI("code")
local codeButton = nil

-- Buttons
local eventsButton = code:getChildById("eventos")
local donatesButton = code:getChildById("doacoes")
local othersButton = code:getChildById("outros")
local redeem = code:getChildById("resgatar")

-- Texts
local redeem_code = code:getChildById("inserir_codigo")

function init()
  connect(g_game, {
    --onGameStart = exibir,
    onGameEnd = naoexibir,
  })

  codeButton = modules.client_topmenu.addRightGameToggleButton('codeButton', tr('Resgatar Recompensa'), '/images/topbuttons/code', exibir)
  codeButton:setWidth(34)
  codeButton:setOn(false)

  code:hide()
  g_keyboard.bindKeyDown('Ctrl+U', exibir)
end

function terminate()
  disconnect(g_game, {
    onGameStart = exibir,
    onGameEnd = naoexibir,
  })

  codeButton:setOn(false)
  code:hide()
  g_keyboard.unbindKeyDown('Ctrl+U')
end

function exibir()
  if code:isVisible() then
    code:hide()
  else
    code:show()

    code:setImageSource("images/MAIN.png")
    eventsButton:show()
    donatesButton:show()
    othersButton:show()

    redeem:hide()
    redeem_code:clearText()
    redeem_code:hide()
    redeem.onClick = function() end
  end
end

function naoexibir()
  redeem.onClick = function() end
  redeem_code:clearText()

  code:setImageSource("images/MAIN.png")
  code:hide()
end

-- Aba de eventos
function eventos()
  code:setImageSource("images/eventsWindow.png")

  eventsButton:hide()
  donatesButton:hide()
  othersButton:hide()

  redeem:show()
  redeem.onClick = function() g_game.talk("!codeEventos " ..redeem_code:getText()) redeem_code:clearText() end

  redeem_code:show()
end

-- Aba de doacoes
function doacoes()
  code:setImageSource("images/donatesWindow.png")

  eventsButton:hide()
  donatesButton:hide()
  othersButton:hide()

  redeem:show()
  redeem.onClick = function() g_game.talk("!codeDoacoes "..redeem_code:getText()) redeem_code:clearText() end

  redeem_code:show()
end

-- Aba de outros
function outros()
  code:setImageSource("images/othersWindow.png")

  eventsButton:hide()
  donatesButton:hide()
  othersButton:hide()

  redeem:show()
  redeem.onClick = function() g_game.talk("!codeOutros "..redeem_code:getText()) redeem_code:clearText() end

  redeem_code:show()
end