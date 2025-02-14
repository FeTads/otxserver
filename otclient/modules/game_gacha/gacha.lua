keywindowshow = nil
buttongacha = nil
deadWindow = g_ui.displayUI('gacha')
local key = deadWindow:getChildById("key")
local key2 = deadWindow:getChildById("key2")
local key3 = deadWindow:getChildById("key3")
local keyaccept = deadWindow:getChildById("keyaccept")
local keyaccept2 = deadWindow:getChildById("keyaccept2")
local back = deadWindow:getChildById("back")
local Text = deadWindow:getChildById("Text")
-- local Text2 = deadWindow:getChildById("Text2")
local gacha = deadWindow:getChildById("gacha")
local gacha3 = deadWindow:getChildById("gacha3")

function init()
  ProtocolGame.registerExtendedOpcode(193, opcodeHandler)
  ProtocolGame.registerExtendedOpcode(194, opcodeHandler)
  connect(g_game, { onGameEnd = onGameEnd })
  keyaccept:hide()
  keyaccept2:hide()
  key:hide()
  key2:hide()
  key3:hide()
  back:hide()
  deadWindow:hide()
  g_keyboard.bindKeyDown("Escape", hide)
  buttongacha = modules.client_topmenu.addRightGameToggleButton('Gacha', tr('Gacha'), '/images/topbuttons/skills', show, false, 1)
  buttongacha:setOn(false)
end

function terminate()
  disconnect(g_game, { onGameEnd = onGameEnd })
  deadWindow:destroy()
end

function onGameEnd()
  if deadWindow:isVisible() then
    deadWindow:hide()
  end
end

function show()
  deadWindow:show()
  deadWindow:raise()
  deadWindow:focus()
end

function jogar3x()
	scheduleEvent(function ()
		g_game.talk("!gatcha")
	end, 100)
	scheduleEvent(function ()
		g_game.talk("!gatcha")
	end, 6000)
	scheduleEvent(function ()
		g_game.talk("!gatcha")
	end, 12000)
end

function hide()
	if deadWindow:isVisible() then
	  deadWindow:hide()
	end
end

function incrementMarginLeft(widget, start, stop, step, delay, callback)
    local margin = start
    local function increment()
        if (step > 0 and margin <= stop) or (step < 0 and margin >= stop) then
            widget:setMarginLeft(tostring(margin))
            margin = margin + step
            scheduleEvent(increment, delay)
        else
            if callback then
                callback()  -- Chama a função de callback ao final do processo
            end
        end
    end
    increment()
end

function table.find(table, value)
    for index, v in ipairs(table) do
        if v == value then
            return index
        end
    end
    return nil
end

function split(str, sep)
    local fields = {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

local rewardToImageMap = {
    [2149] = "images/layoutanya/gachateste1",
    [2150] = "images/layoutanya/gachateste",
    [2152] = "images/layoutanya/gachateste2"
}

local defaultFailureImage = "images/layoutanya/gachateste3"

function opcodeHandler(protocol, opcode, buffer)
    if opcode == 193 then
        local data = split(buffer, ",")
        local attempts = tonumber(data[1])
        local count = tonumber(data[2])
        local rewardId = tonumber(data[3])
        local finalImage = rewardToImageMap[rewardId] or defaultFailureImage
        if attempts then
            if Text then
                Text:setText("Tentativas: " .. attempts)
            end
				-- Text2:setText("Tickets: "..count)
        end
        if rewardId then
            -- Prepara as imagens para animação cíclica
            local images = {rewardToImageMap[2149], rewardToImageMap[2150], rewardToImageMap[2152], defaultFailureImage}

            scheduleEvent(function ()
                -- gacha:setImageSource("images/jogar")
                -- gacha:setMarginTop("240")
            end, 150)
            scheduleEvent(function ()
                -- gacha:setImageSource("images/jogar2")
                -- gacha:setMarginTop("68")
                inicia()
            end, 270)

            function inicia()
                -- key:show()
                -- key:setMarginLeft("100")
                -- incrementMarginLeft(key, 158, 366, 10, 10, function()
                    -- key:hide()
                -- end)
                -- key3:show()
                -- key3:setMarginLeft("329")
                -- incrementMarginLeft(key3, 575, 366, -10, 10, function()
                    -- key3:hide()
                    -- key2:hide()
                    keyaccept2:show()
                -- end)

                cycleImageSources(keyaccept2, images, 100, 5000, finalImage)
            end
        end
    end
    if opcode == 194 then
        local data = split(buffer, ",")
        local attempts = tonumber(data[1])
        local count = tonumber(data[2])
        local rewardIds = {tonumber(data[3]), tonumber(data[4]), tonumber(data[5])} -- Assegure-se de que são três IDs

        if Text then
            Text:setText("Tentativas: " .. attempts)
        end
			-- Text2:setText("Tickets: "..count)

        local images = {rewardToImageMap[2149], rewardToImageMap[2150], rewardToImageMap[2152], defaultFailureImage}

        for i, key in ipairs({key, key2, key3}) do
            local finalImage = rewardToImageMap[rewardIds[i]] or defaultFailureImage
			keyaccept2:hide()
			key:show()
			key:setMarginLeft(158)
			key2:show()
			key2:setMarginLeft(366)
			key3:show()
			key3:setMarginLeft(575)
            scheduleEvent(function()
                cycleImageSources(key, images, 100, 5000, finalImage)
            end, 500 * (i - 1))
        end
    end
end

function cycleImageSources(widget, imageSources, interval, duration, finalImage)
    local index = 1
    local totalCycles = duration / interval
    local cycleCount = 0

    local function changeImage()
        if cycleCount < totalCycles then
            widget:setImageSource(imageSources[index])
            index = index + 1
            if index > #imageSources then
                index = 1  -- Reinicia o índice se passar do número de imagens
            end
            cycleCount = cycleCount + 1
            scheduleEvent(changeImage, interval)
        else
            -- Garante que a última imagem seja a da recompensa ou a de falha
            widget:setImageSource(finalImage)
        end
    end

    changeImage()
end