-- [[ script make by FeeTads ]] --
	-- [[ support on discord: FeeTads / FeeTads#0246]] --
	-- [[ TibiaKing Scripts FeeTads ]] --

local config = {
	-- [action id bau]
	[16780] = {
		broadcastToAll = true,
		questName = "[Initial Quest]",
		storage = 222333,				-- storage que sinaliza o finalizar da quest
		neededLevel = 8,
		reward = {{2160, 100}, {6544, 2}},	-- recompensa e quantidade ex: { {2160, 10}, {2148, 50} }  se atente ao {} > {{}}
		isAccountStorage = false,		-- caso vc queira que a storage seja adicionada na conta tbm // mais nenhum char da acc faz a quest
		---------------------------------------------------------------------------------------------------
		storageIsATimer = false,		-- a storage é de timer? tipo 24h pra usar de novo?
		storageTimer = 0,				-- timer pra storage em minutos  // caso não vá usar deixe 0
		---------------------------------------------------------------------------------------------------
		rewardIsStorage = false,		-- a recompensa da quest é dar outra storage, tipo liberar acesso?
		whatStorage = -1,				--  Qual storage vai ser dada?
		thisStorageIsATimer = false,		-- essa storage é timer?
		valueTimer = 60,				-- em minutos //60*1 = 1hora / 60*5 = 5 horas
		-- [[ CASO NÃO SEJA UMA STORAGE DE TIMER ]] --
		valueStorage = 1,	-- qual valor ele vai receber na storage de recompensa?
		-------------------
		storageIncrementable = false,	-- a storage é pra somar? tipo storage atual + 5
		muchIncrement = 0,				-- incrementar mais quanto na storage //caso n use deixe 0
		---------------------------------------------------------------------------------------------------
		rewardSummonMonster = false,		-- a recompensa sumona algum bixo?
		summonName = "",					-- digite o nome do monstro //tanto faz ser maiusculo ou não
		positToSummon = {x=1000,y=1000,z=7},
		---------------------------------------------------------------------------------------------------
		rewardRecoveryStamina = false,	-- o bau recupera stamina?
		recoveryTime = 60,    		-- quantos minutos / 10h = 60*10
		---------------------------------------------------------------------------------------------------
		rewardTeleportTemple = false,	-- ao clicar no bau manda pro templo?
	},
}

local function giverRewardByConfig(cid, timerQuest, questId)
	local giveR = giveRewardTable(cid, questId.reward)
	if giveR == "notTable" then
		return true
	end
	if giveR then
		if timerQuest then
			setPlayerStorageValue(cid, questId.storage, os.time()+questId.storageTimer*60)
			if questId.isAccountStorage then
				setAccountStorageValue(getPlayerAccountId(cid), questId.storage, os.time()+questId.storageTimer*60)
			end
		else
			setPlayerStorageValue(cid, questId.storage, 1)
			if questId.isAccountStorage then
				setAccountStorageValue(getPlayerAccountId(cid), questId.storage, 1)
			end
		end
	else
		doPlayerSendTextMessage(cid, MESSAGE_FIRST, "Please have cap or slot in backpack to receive this items!")
		return true
	end
	-------------------------------------------------------------------------------------------------------------
	if questId.rewardIsStorage then
		if questId.thisStorageIsATimer then
			setPlayerStorageValue(cid, questId.whatStorage, os.time()+questId.valueTimer*60)
		else
			if questId.storageIncrementable then
				local sto = getPlayerStorageValue(cid, questId.whatStorage)
				setPlayerStorageValue(cid, questId.whatStorage, sto + questId.muchIncrement)
			else
				local valueS = questId.valueStorage ~= -1 and questId.valueStorage or 1
				setPlayerStorageValue(cid, questId.whatStorage, valueS)
			end
		end
	end
	-------------------------------------------------------------------------------------------------------------
	if questId.rewardSummonMonster then
		doCreateMonster(string.lower(questId.summonName), questId.positToSummon, false, true)
	end
	-------------------------------------------------------------------------------------------------------------
	if questId.rewardRecoveryStamina then
		local currentStamina = getPlayerStamina(params.cid)
		doPlayerSetStamina(params.cid, currentStamina + questId.recoveryTime)
	end
end

function onUse(cid, item, frompos, itemEx, topos)
	
	local questId = config[item.actionid]
	if not questId then
		local posit = getCreaturePosition(cid)
		doPlayerSendTextMessage(cid, MESSAGE_FIRST, "error! please contact and administrador with message 'please check questAllInOne/.lua \n pos: {x = "..posit.x.." y = "..posit.y.." z = "..posit.z.."}'")
		return true
	end
	
	if getPlayerLevel(cid) < questId.neededLevel then
		doPlayerSendCancel(cid, "You need level "..questId.neededLevel.." to complete.")
		return true
	end
	
	if questId.storageIsATimer then
		if getPlayerStorageValue(cid, questId.storage) > os.time() then
			doPlayerSendCancel(cid, "You need wait "..getTimeString(getPlayerStorageValue(cid, questId.storage)-os.time()).." to get again.")
			return true
		end
		if questId.isAccountStorage and getAccountStorageValue(getPlayerAccountId(cid), questId.storage) > os.time() then
			doPlayerSendCancel(cid, "You need wait "..getTimeString(getAccountStorageValue(getPlayerAccountId(cid), questId.storage)-os.time()).." to get again.")
			return true
		end
	else
		if getPlayerStorageValue(cid, questId.storage) ~= -1 then
			doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Você já completou essa quest!")
			return true
		end
		if questId.isAccountStorage and getAccountStorageValue(getPlayerAccountId(cid), questId.storage) ~= -1 then
			doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "Essa conta já completou essa quest!")
			return true
		end
	end
	
	giverRewardByConfig(cid, questId.storageIsATimer, questId)
		
	if questId.rewardTeleportTemple then
		doTeleportThing(cid, getTownTemplePosition(getPlayerTown(cid)), false, true)
	end
	if questId.questName and questId.questName ~= "" and broadcastToAll then
		doBroadcastMessage("O jogador "..getPlayerName(cid).." completou a quest "..questId.questName.." Parabéns.", MESSAGE_FIRST)
	end
	
	return true
end