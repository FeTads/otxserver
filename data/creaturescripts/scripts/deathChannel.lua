local msg = {
	[1] = "foi jogar no vasco",
	[2] = "ficou até AFK",
	[3] = "tropeçou e foi de base",
	[4] = "foi visitar o Papa no Vaticano",
	[5] = "parou na Série D do campeonato",
	[6] = "virou tapete de boate",
	[7] = "começou upar pra trás",
	[8] = "tropeçou em uma casca de banana",
	[9] = "ficou sem dedo",
}

function onDeath(cid, corpse, deathList)
    if(not isPlayer(cid)) then
        return true
    end
	
	if getConfigValue('displayDeathChannelMessages') ~= true then return true end
	
	local str = "o jogador "..getPlayerName(cid).." ["..getPlayerLevel(cid).."] " ..(getConfigValue('resetSystemEnable') and ("["..getPlayerResets(cid).."] ") or " ")  ..msg[math.random(1, #msg)].." após morrer para: "
	local attacker = ''
	local monster = false
    for _, target in ipairs(deathList) do
		if isCreature(target) and isPlayer(target) then	
			attacker = attacker..getCreatureName(target).." ["..getPlayerLevel(target).."] "..(getConfigValue('resetSystemEnable') and ("["..getPlayerResets(cid).."] ") or " ")..(_ < #deathList and ", " or ".")
		elseif isCreature(target) and isMonster(target) then
			attacker = attacker..getCreatureName(target)..(_ < #deathList and ", " or ".")
		end
		if _ == 1 and isMonster(target) then
			attacker = getCreatureName(target)
			monster = true
			break
		end
	end
	
	str = str..(monster and ("o monster "..attacker..".") or attacker)
	for _, pid in ipairs(getPlayersOnline()) do
		doPlayerSendChannelMessage(pid, '', str, TALKTYPE_CHANNEL_ORANGE, 0xF)
	end
	
    return true
end