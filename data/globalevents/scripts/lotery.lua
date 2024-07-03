function onThink()
    local players = getPlayersOnline()
    local cid = players[math.random(1,#players)]
    if isPlayer(cid) then
        local q = db.getResult("SELECT premium_points FROM accounts WHERE id = '"..getPlayerAccountId(cid).."'")
        local a = q:getDataInt("premium_points")
        q:free()
        local points = tonumber(a) + 10
        doBroadcastMessage("[Sistema De Loteria]: O jogador "..getCreatureName(cid).." foi sorteado e recebeu 10 premium points no site para comprar itens na shop! Proximo sorteio ocorrera dentro de 4 horas, para participar basta permanecer online!")
        db.query("UPDATE accounts SET premium_points = '"..points.."' WHERE id = '"..getPlayerAccountId(cid).."'")
    end
    return true
end
