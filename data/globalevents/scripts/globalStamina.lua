local addedStamina = mathtime({5, "hour"})

function onTime()
    local players = getPlayersOnline()
    local onlinePlayers = #players
    for i = 1, onlinePlayers do
        local player = players[i]
        if getPlayerStamina(player) < 2520 then
            doPlayerAddStamina(player, addedStamina)
            doPlayerSendTextMessage(player, MESSAGE_INFO_DESCR, "[STAMINA]: Você recebeu 5 horas de stamina do sistema.\nAproveite!")
        end
    end
    db.query(string.format("UPDATE `players` SET `stamina` = `stamina` + %d WHERE `online` = 0 AND `stamina` < 151200000", (addedStamina * 1000)))
    return true
end