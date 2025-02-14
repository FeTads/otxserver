local donate = g_ui.displayUI("donate")
local reward = donate:getChildById("reward")
local reward2 = donate:getChildById("reward2")
local timeEnd = donate:getChildById("timeEnd")
local globalDonationGoalCount = donate:getChildById("globalDonationGoalCount")
local personalDonationGoalCount = donate:getChildById("personalDonationGoalCount")
local chest1 = donate:getChildById("chest1")
local chest2 = donate:getChildById("chest2")
local chest3 = donate:getChildById("chest3")
local chest1_value = donate:getChildById("chest1_value")
local chest2_value = donate:getChildById("chest2_value")
local chest3_value = donate:getChildById("chest3_value")
local progressBarDonateGoal = donate:getChildById("progressBarDonateGoal")
local progressBarDonatePersonal = donate:getChildById("progressBarDonatePersonal")
local progressBarDonateGoalIMG_KING = donate:getChildById("progressBarDonateGoalIMG_KING")
local donateBtn

local DONATE_GOAL_OPCODE = 25

function init()
    connect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd
    })

    ProtocolGame.registerExtendedOpcode(DONATE_GOAL_OPCODE, sendGoalInfo)
    donateBtn = modules.client_topmenu.addRightGameToggleButton('Donation Goal', tr('Donation GOal'), '/images/topbuttons/chest', exibir, false, 1)

    donateBtn:setOn(false)
    donate:hide()
    g_keyboard.bindKeyDown("Shift+F", exibir)
end

function terminate()
    disconnect(g_game, {
        onGameStart = onGameStart,
        onGameEnd = onGameEnd
    })
    donate:hide()
    donateBtn:setOn(false)
    ProtocolGame.unregisterExtendedOpcode(DONATE_GOAL_OPCODE)
end

function onGameStart()
    donate:hide()
    donateBtn:setOn(false)
	g_game.getProtocolGame():sendExtendedOpcode(DONATE_GOAL_OPCODE, json.encode{protocol = "info"})
end

function onGameEnd()
    donate:hide()
    donateBtn:setOn(false)
end

function exibir()
    if not g_game.isOnline() then return end

    donateBtn:setOn(not donateBtn:isOn())
    donate:setVisible(donateBtn:isOn())

    if donate:isVisible() then
        g_game.getProtocolGame():sendExtendedOpcode(DONATE_GOAL_OPCODE, json.encode{protocol = "info"})
		donateBtn:setOn(true)
		donate:show()
    end
end

function sendGoalInfo(protocol, opcode, buffer)
    local receive = json.decode(buffer)
		
	desc1 = receive.DonationGoalPersonal.rewardOne.desc
	desc2 = receive.DonationGoalPersonal.rewardTwo.desc
	desc3 = receive.DonationGoalPersonal.rewardThree.desc
	
	rewardOneName = receive.DonationGoalPersonal.rewardOneName
	rewardTwoName = receive.DonationGoalPersonal.rewardTwoName
	rewardThreeName = receive.DonationGoalPersonal.rewardThreeName
	
	RewardGlobal = receive.RewardGlobal.desc		
		
		
    local data = {
        spriteId = tonumber(receive.spriteId),
        rewardType = tostring(receive.rewardType),
        endTime = tostring(receive.endTime),
		endTimeString = tostring(receive.endTimeString),
        goalDonationGlobal = tonumber(receive.goalDonationGlobal),
        goalDonation = tonumber(receive.goalDonation),
        personalDonationGoal = tonumber(receive.personalDonationGoal),
        personalDonation = tonumber(receive.personalDonation),
        goalDonationPercent = tonumber(receive.goalDonationPercent),
        personalDonationPercent = tonumber(receive.personalDonationPercent),
        chest1value = tonumber(receive.chest1),
        chest2value = tonumber(receive.chest2),
        chest3value = tonumber(receive.chest3),
		chestglobal = tonumber(receive.global),
		globalName = receive.globalName
    }

    updateUI(data)
end

function updateUI(data)
    if data.rewardType == "item" then
        reward:setVisible(true)
        reward:setItemId(data.spriteId)
        reward2:setVisible(false)
		reward:setTooltip(data.globalName)
    else
        reward2:setVisible(true)
        reward2:setOutfit({type = data.spriteId})
        reward:setVisible(false)
    end
	
	timeEnd:setText(data.endTimeString)

    globalDonationGoalCount:setText("R$" .. data.goalDonationGlobal .. ",00/R$" .. data.goalDonation .. ",00")
    personalDonationGoalCount:setText("R$" .. data.personalDonationGoal .. ",00/R$" .. data.personalDonation .. ",00")
	progressBarDonateGoalIMG_KING:setTooltip(RewardGlobal)
	
    chest1:setOn(false)
    chest2:setOn(false)
    chest3:setOn(false)
    chest1_value:setText("R$" .. string.format("%d", data.personalDonation / 3) .. ",00")
    chest2_value:setText("R$" .. string.format("%d", data.personalDonation / 2) .. ",00")
    chest3_value:setText("R$" .. string.format("%d", data.personalDonation) .. ",00")
	
	chest1:setTooltip(rewardOneName)
	chest2:setTooltip(rewardTwoName)
	chest3:setTooltip(rewardThreeName)

    configureChests(data)
    configureProgressBar(data)
end

function configureChests(data)
    if data.goalDonationPercent >= 10 then
        if data.chestglobal == 0 then
            progressBarDonateGoalIMG_KING:setOn(true)
            progressBarDonateGoalIMG_KING.onClick = function()
			g_game.getProtocolGame():sendExtendedOpcode(DONATE_GOAL_OPCODE, json.encode{protocol = "collectGoal"})
            end
        elseif data.chestglobal == 1 then
			progressBarDonateGoalIMG_KING:setOn(false)
            progressBarDonateGoalIMG_KING:setImageSource('images/complet')
        end
    end

    if data.personalDonationPercent >= 10 then
        if data.chest1value == 0 then
            chest1:setOn(true)
            chest1.onClick = function()
                g_game.getProtocolGame():sendExtendedOpcode(DONATE_GOAL_OPCODE, json.encode{protocol = "collectChest1"})
            end
        elseif data.chest1value == 1 then
			chest1:setOn(false)
            donate:getChildById("chest1"):setImageSource('images/complet')
        end
    end

    if data.personalDonationPercent >= 45 then
        if data.chest2value == 0 then
            chest2:setOn(true)
            chest2.onClick = function()
                g_game.getProtocolGame():sendExtendedOpcode(DONATE_GOAL_OPCODE, json.encode{protocol = "collectChest2"})
            end
        elseif data.chest2value == 1 then
			chest2:setOn(false)
            donate:getChildById("chest2"):setImageSource('images/complet')
        end
    end

    if data.personalDonationPercent >= 92 then
        if data.chest3value == 0 then
            chest3:setOn(true)
            chest3.onClick = function()
                g_game.getProtocolGame():sendExtendedOpcode(DONATE_GOAL_OPCODE, json.encode{protocol = "collectChest3"})
            end
        elseif data.chest3value == 1 then
			chest3:setOn(false)
            donate:getChildById("chest3"):setImageSource('images/complet')
        end
    end
end

function configureProgressBar(data)
    progressBarDonateGoal:setPercent(data.goalDonationPercent)
    progressBarDonatePersonal:setPercent(data.personalDonationPercent)
end