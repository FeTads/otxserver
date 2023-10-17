function onSay(cid, words, param, channel)
	local useEmoteSpells = getConfigValue('emoteSpells')
	if useEmoteSpells ~= true then
		return doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "EmoteSpells system are Disabled by Admin!")
	end
	if getPlayerStorageValue(cid, 666) > os.time() then return true end
	setPlayerStorageValue(cid, 666, os.time()+2)
	local msg = string.lower(param)
	if msg ~= "" then
		if msg == "on" then
			setPlayerStorageValue(cid, 35001, tonumber(1))
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Emote Spells ON: Message Spells Yellow Actived!")
		elseif msg == "off" then
			setPlayerStorageValue(cid, 35001, tonumber(0))
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Emote Spells OFF: Message Spells Orange Actived!")
		elseif msg == "none" then
			setPlayerStorageValue(cid, 35001, tonumber(2))
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Emote Spells NONE: Message Spells Disabled!")
		end
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "[EmoteSpells]: EmoteSpells Changes.")
	elseif msg == "" then
		local sto = tonumber(getPlayerStorageValue(cid, 35001))
		if sto == -1 then sto = 0 end
		if sto == 0 then
			setPlayerStorageValue(cid, 35001, tonumber(1))
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Emote Spells ON: Message Spells Yellow Actived!")
		elseif sto == 1 then
			setPlayerStorageValue(cid, 35001, tonumber(2))
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Emote Spells NONE: Message Spells Disabled!")
		elseif sto == 2 then
			setPlayerStorageValue(cid, 35001, tonumber(0))
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, "Emote Spells OFF: Message Spells Orange Actived!")
		end
		doPlayerSendTextMessage(cid, MESSAGE_INFO_DESCR, "[EmoteSpells]: EmoteSpells Changes.")
	end	
	return true
end
