local combat_types = {
	[1] = {cond = CONDITION_FREEZING, effect = CONST_ME_ICEATTACK, anim = CONST_ANI_ICE, damage = COMBAT_ICEDAMAGE},
	[2] = {cond = CONDITION_FIRE, effect = CONST_ME_FIREATTACK, anim = CONST_ANI_FIRE, damage = COMBAT_FIREDAMAGE},
	[3] = {cond = CONDITION_POISON, effect = CONST_ME_SMALLPLANTS, anim = CONST_ANI_EARTH, damage = COMBAT_EARTHDAMAGE},
	[4] = {cond = CONDITION_ENERGY, effect = CONST_ME_ENERGYHIT, anim = CONST_ANI_ENERGY, damage = COMBAT_ENERGYDAMAGE},
	[5] = {effect = CONST_ME_HOLYDAMAGE, anim = CONST_ANI_CAKE, damage = COMBAT_HOLYDAMAGE},
	[6] = {cond = CONDITION_CURSED, effect = CONST_ME_MORTAREA, anim = CONST_ANI_SUDDENDEATH, damage = COMBAT_DEATHDAMAGE},

	default = {damage = COMBAT_HOLYDAMAGE},
}

local config = {
	storage = 101010,
	block_armor = false,
	condition_rounds = 0,
	condition_value = 0,
	condition_time = 2000,
}

local weapons = {
	[12799] = {extraDano = 50},
	[12758] = {extraDano = 100},
	[12768] = {extraDano = 200},
	[12795] = {extraDano = 150},
}

for key, combat in pairs(combat_types) do
	combat.object = createCombatObject()

	setCombatParam(combat.object, COMBAT_PARAM_TYPE, combat.damage or COMBAT_PHYSICALDAMAGE)
	setCombatParam(combat.object, COMBAT_PARAM_EFFECT, combat.effect or CONST_ME_NONE)
	setCombatParam(combat.object, COMBAT_PARAM_DISTANCEEFFECT, combat.anim or CONST_ANI_NONE)
	setCombatParam(combat.object, COMBAT_PARAM_BLOCKARMOR, config.block_armor and 1 or 0)

	function onGetFormulaValues(cid, level, skill, attack, factor)
		local arma = getPlayerWeaponHand(cid)
		local extra = ((arma ~= 0) and (weapons[arma.itemid] and weapons[arma.itemid].extraDano or 0) or 0)
		return -(((skill*2 + (level/5))+(2*extra))*2), -(((skill*2 + (level/2.5))+(2*extra))*3)		--minimo, maximo solo
	end
	setCombatCallback(combat.object, CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

	if combat.cond then
		local condition = createConditionObject(combat.cond)
		setConditionParam(condition, CONDITION_PARAM_DELAYED, 1)
		addDamageCondition(condition, config.condition_rounds, config.condition_time, config.condition_value)
		setCombatCondition(combat.object, condition)
	end
end

local function find_combat(id)
	return combat_types[id] or false
end

function onUseWeapon(cid, var)
	local combat = find_combat(getCreatureStorage(cid, config.storage))

	if not combat then
		if getDistanceBetween(getThingPosition(cid), getThingPosition(var.number)) > 1 then
			return false
		end

		combat = combat_types.default
	end

	return doCombat(cid, combat.object, var)
end