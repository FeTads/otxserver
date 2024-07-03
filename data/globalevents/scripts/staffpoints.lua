local config = {
    days = {"Wednesday"}, -- dias que serão adicionados os pontos
    staff = {
        {"[TUTOR] Teste", 10} -- nick do staff, quantidade de pp
    }
}

function onTime()
    if isInArray(config.days, os.date("%A")) then
        local count = #config.staff
        if count > 0 then
            local notfound = ""
            for i = 1, count do
                local t = config.staff[i]
                local playerName, points = t[1], t[2]
                local playerGUID = getPlayerGUIDByName(playerName)
                if playerGUID then
                    local pid = getCreatureByName(playerName)
                    if isPlayer(pid) then
                        doPlayerSendTextMessage(pid, MESSAGE_INFO_DESCR, "Você recebeu "..points.." ponto"..(points > 1 and "s" or "").." por seu trabalho como membro da staff.")
                    end
                    db.query(string.format("UPDATE `accounts` INNER JOIN `players` ON `accounts`.`id` = `players`.`account_id` SET `premium_points` = `premium_points` + %d WHERE `players`.`id` = %d", points, playerGUID))
                else
                    notfound = notfound .. playerName .. "/"
                end
            end           
            if notfound ~= "" then
                print("Membros da Staff nao encontrados: "..string.sub(notfound, 1, -2))
            end
        end
    end
    return true
end
