.--[[

-- CASO SAIBA USAR O MODO SIMPLIFICADO, USE ABAIXO, SE NÃO, USE A TABELA PADRÃO

ResetSystem = {
	back_to_level = 8, -- level que vai voltar
	use_back_level = true,
	resets = {},
	incrementToReset = 250, -- qual a diferença de level a cada rr?
	firstResetAt = 1500,	-- qual o level do PRIMEIRO rr
	
	-- incrementToReset se for 250 e firstResetAt = 1000, os resets serão 1000/1250/1500/1750
}

for i = 0, 100 do
	local level = i == 0 and 0 or (i == 1 and ResetSystem.firstResetAt or (i - 1) * ResetSystem.incrementToReset + ResetSystem.firstResetAt)
	local exp_percent = ((i - 1) % 10 == 0 and i ~= 0) and 10 or (i % 10) * 10
	if exp_percent == 0 and i > 0 then exp_percent = 100 end
	local damage_percent = i == 1 and 4 or (i == 0 and 0 or (i * 2 + 2))
	local hpmp_percent = i * 15
	ResetSystem.resets[i] = {needed_level = level, exp_percent = exp_percent, damage_percent = damage_percent, hpmp_percent = hpmp_percent}
end
]]--

ResetSystem = {
	back_to_level = 8, -- level que vai voltar
	use_back_level = true,
	
	resets = {
		[1] =  {needed_level = 1000,  exp_percent = 2,   damage_percent = 2,   hpmp_percent = 10},
		[2] =  {needed_level = 2000,  exp_percent = 4,   damage_percent = 4,   hpmp_percent = 20},
		[3] =  {needed_level = 3000,  exp_percent = 6,   damage_percent = 6,   hpmp_percent = 30},
		[4] =  {needed_level = 4000,  exp_percent = 8,   damage_percent = 8,   hpmp_percent = 40},
		[5] =  {needed_level = 5000,  exp_percent = 10,  damage_percent = 10,  hpmp_percent = 50},
		[6] =  {needed_level = 6000,  exp_percent = 12,  damage_percent = 12,  hpmp_percent = 60},
		[7] =  {needed_level = 7000,  exp_percent = 14,  damage_percent = 14,  hpmp_percent = 70},
		[8] =  {needed_level = 8000,  exp_percent = 16,  damage_percent = 16,  hpmp_percent = 80},
		[9] =  {needed_level = 9000,  exp_percent = 18,  damage_percent = 18,  hpmp_percent = 90},
		[10] = {needed_level = 10000, exp_percent = 20,  damage_percent = 20,  hpmp_percent = 100},
		-- ....
	}
}


function ResetSystem:getCount(pid)
	return getPlayerResets(pid)
end

function ResetSystem:setCount(pid, value)
	setPlayerResets(pid, value)
end

function ResetSystem:addCount(pid)
	self:setCount(pid, self:getCount(pid) + 1)
end

function ResetSystem:getInfo(pid)
	return self.resets[math.min(self:getCount(pid), #self.resets)]
end

function ResetSystem:applyBonuses(pid)
	local bonus = self:getInfo(pid)
	if (bonus and bonus.damage_percent) then
		setPlayerDamageMultiplier(pid, 1.0 + (bonus.damage_percent / 100.0))
	else
		setPlayerDamageMultiplier(pid, 1.0)
	end
end

function ResetSystem:updateHealthAndMana(pid)
	local bonus = self:getInfo(pid)
	if (bonus and bonus.hpmp_percent) then
		local vocationInfo = getVocationInfo(getPlayerVocation(pid))
		if (vocationInfo) then
			local oldMaxHealth = getCreatureMaxHealth(pid)
			local oldMaxMana = getCreatureMaxMana(pid)
			
			local level = getPlayerLevel(pid)
			local totalHealth = (185 - vocationInfo.healthGain * 8) + (vocationInfo.healthGain * level)
			local totalMana = (185 - vocationInfo.manaGain * 8) + (vocationInfo.manaGain * level)
			
			local newMaxHealth = math.floor(totalHealth + (totalHealth * (bonus.hpmp_percent / 100)))
			local newMaxMana = math.floor(totalMana + (totalMana * (bonus.hpmp_percent / 100)))
			setCreatureMaxHealth(pid, newMaxHealth)
			setCreatureMaxMana(pid, newMaxMana)

			if (newMaxHealth > oldMaxHealth) then
				doCreatureAddHealth(pid, newMaxHealth - oldMaxHealth)
			elseif (newMaxHealth < oldMaxHealth) then
				doCreatureAddHealth(pid, 1) -- evita barra bugada
			end

			if (newMaxMana > oldMaxMana) then
				doCreatureAddMana(pid, newMaxMana - oldMaxMana)
			elseif (newMaxMana < oldMaxMana) then
				doCreatureAddMana(pid, 1)
			end
		end
	end
end


function ResetSystem:execute(pid)
	local playerLevel = getPlayerLevel(pid)
	if (playerLevel > self.back_to_level and self.use_back_level) then
		doPlayerAddExperience(pid, getExperienceForLevel(self.back_to_level) - getPlayerExperience(pid))
		playerLevel = self.back_to_level
	end
	self:addCount(pid)
	self:applyBonuses(pid)
	self:updateHealthAndMana(pid)
	local bonus = self:getInfo(pid)
	if (bonus) then
		local message = "Você efetuou seu " .. self:getCount(pid) .. "° reset."
		if (bonus.damage_percent) then
			message = message .. "\n+" .. bonus.damage_percent .. "% de dano"
		end

		if (bonus.hpmp_percent) then
			message = message .. "\n+" .. bonus.hpmp_percent .. "% de vida e mana"
		end

		if (bonus.exp_percent) then
			message = message .. "\n+" .. bonus.exp_percent .. "% de EXP"
		end
		doPlayerSendTextMessage(pid, MESSAGE_EVENT_ADVANCE, message)
	end
end
