local config = {
	loginMessage = getConfigValue('loginMessage'),
	useFragHandler = getBooleanFromString(getConfigValue('useFragHandler'))
}

function onLogin(cid)
	if(getBooleanFromString(getConfigValue('accountManager')) == false) then
		if (getCreatureName(cid) == "Account Manager") then
			return doRemoveCreature(cid, true)
		end
	end

	local loss = getConfigValue('deathLostPercent')
	if(loss ~= nil and getPlayerStorageValue(cid, "bless") ~= 5) then
		doPlayerSetLossPercent(cid, PLAYERLOSS_EXPERIENCE, loss * 10)
	end

	if(getPlayerStorageValue(cid, "death_bless") == 1) then
		local t = {PLAYERLOSS_EXPERIENCE, PLAYERLOSS_SKILLS, PLAYERLOSS_ITEMS, PLAYERLOSS_CONTAINERS}
		for i = 1, #t do
			doPlayerSetLossPercent(cid, t[i], 100)
		end
		setPlayerStorageValue(cid, "death_bless", 0)
	end

	local accountManager = getPlayerAccountManager(cid)
	if(accountManager == MANAGER_NONE) then
		local lastLogin, str = getPlayerLastLoginSaved(cid), config.loginMessage
		if(lastLogin > 0) then
			doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, str)
			str = "Your last visit was on " .. os.date("%a %b %d %X %Y", lastLogin) .. "."
		else
			str = str .. " Please choose your outfit."
			doPlayerSendOutfitWindow(cid)
		end

		doPlayerSendTextMessage(cid, MESSAGE_STATUS_DEFAULT, str)
	elseif(accountManager == MANAGER_NAMELOCK) then
		addEvent(valid(doCreatureSay), 500, cid, "Hello, it appears that your character has been locked for name violating rules, what new name would you like to have?", TALKTYPE_PRIVATE_NP, true, cid)
	elseif(accountManager == MANAGER_ACCOUNT) then
		addEvent(valid(doCreatureSay), 500, cid, "Hello, type {account} to manage your account. If you would like to start over, type {cancel} anywhere.", TALKTYPE_PRIVATE_NP, true, cid)
	else
		addEvent(valid(doCreatureSay), 500, cid, "Hello, type {account} to create an account or {recover} to recover an account.", TALKTYPE_PRIVATE_NP, true, cid)
	end
	

	if(not isPlayerGhost(cid)) then
		doSendMagicEffect(getCreaturePosition(cid), CONST_ME_TELEPORT)
	end

	registerCreatureEvent(cid, "Idle")
	registerCreatureEvent(cid, "Mail")
	if(getPlayerOperatingSystem(cid) >= CLIENTOS_OTCLIENT_LINUX) then
		registerCreatureEvent(cid, "ExtendedOpcode")
	end

	registerCreatureEvent(cid, "ReportBug")
	if(config.useFragHandler) then
		registerCreatureEvent(cid, "SkullCheck")
	end

	registerCreatureEvent(cid, "decayOnDepotThrow")
	registerCreatureEvent(cid, "decayOnDepotTrade")
	registerCreatureEvent(cid, "fragarea")
	registerCreatureEvent(cid, "houseProtectTrash")
	registerCreatureEvent(cid, "GuildEvents")
	registerCreatureEvent(cid, "AdvanceSave")
	registerCreatureEvent(cid, "recordIp")
	registerCreatureEvent(cid, "partyAndGuildProtection")
	registerCreatureEvent(cid, "PlayerTrade")
	registerCreatureEvent(cid, "deathchannel")
	
	-- market system
	registerCreatureEvent(cid, "MarketRCItem")
	registerCreatureEvent(cid, "MarketSDItem")
	registerCreatureEvent(cid, "MarketISItem")
	registerCreatureEvent(cid, "MarketSCItem")
	registerCreatureEvent(cid, "MarketIMItem")
	registerCreatureEvent(cid, "MarketCLItem")
	registerCreatureEvent(cid, "MarketCPItem")
	registerCreatureEvent(cid, "MarketIBItem")
	registerCreatureEvent(cid, "MarketSBItem")
	registerCreatureEvent(cid, "MarketRBItem")
	registerCreatureEvent(cid, "MarketIHItem")
	registerCreatureEvent(cid, "MarketSHItem")
	registerCreatureEvent(cid, "MarketSMItem")
	registerCreatureEvent(cid, "MarketRMItem")
	registerCreatureEvent(cid, "MarketSMCI")
	registerCreatureEvent(cid, "MarketRUMO")
	registerCreatureEvent(cid, "MarketSMYO")
	registerCreatureEvent(cid, "MarketRMOS")
	registerCreatureEvent(cid, "MarketSOC")
	registerCreatureEvent(cid, "MarketSOCBUYER")
	registerCreatureEvent(cid, "MarketSOTY")
	registerCreatureEvent(cid, "MarketROTY")
	registerCreatureEvent(cid, "MarketSMVOTY")
	registerCreatureEvent(cid, "MarketCMOTME")
	registerCreatureEvent(cid, "MarketRALLMO")
	registerCreatureEvent(cid, "MarketRCO")
	registerCreatureEvent(cid, "MarketRRITP")
	registerCreatureEvent(cid, "MarketSearch")

    -- Shop System
	registerCreatureEvent(cid, "ShopReceive")
	
	-- Autoloot System
	doPlayerOpenChannel(cid, 15)  --channel_death
	doPlayerOpenChannel(cid, 0x10)  --loot channel

	return true
end
