--A modifier used as a visualisation for a custom spell

modifier_bsl_eventhandler = class({})

--------------------------------------------------------------------------------

function modifier_bsl_eventhandler:IsHidden()
	return true
end

function modifier_bsl_eventhandler:IsPurgable()
	return false
end

function modifier_bsl_eventhandler:RemoveOnDeath()
	return false
end

function modifier_bsl_eventhandler:DestroyOnExpire()
	return false
end

function modifier_bsl_eventhandler:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }
    return funcs
end

function modifier_bsl_eventhandler:OnAttackLanded(kv)
	if IsServer() then
		if kv.attacker:IsHero() then
			if BotSupportLib:IsHeroBotControlled(kv.attacker) then
				BotSupportLib:OnAttackLanded(kv.attacker, kv.target, kv)
			end
		end
	end
end

function modifier_bsl_eventhandler:OnAttackStart(kv)
	if IsServer() then
		if kv.attacker:IsHero() then
			if BotSupportLib:IsHeroBotControlled(kv.attacker) then
				BotSupportLib:OnAttackStart(kv.attacker, kv.target, kv)
			end
		end
	end
end

function modifier_bsl_eventhandler:OnTakeDamage(kv)
	if IsServer() then
		if kv.unit:IsHero() then
			BotSupportLib:OnDamaged(kv.unit, kv.attacker, kv)
		end
	end
end

function modifier_bsl_eventhandler:OnDeath(kv)
	if IsServer() then
		if kv.attacker then
			if kv.attacker:IsRealHero() or kv.unit:GetClassname() == "npc_dota_ward_base" or kv.unit:GetClassname() == "npc_dota_ward_base_truesight" then
				BotSupportLib:OnKilledUnit(kv.attacker, kv.unit, kv)
			end
		end
		if kv.unit then
			if kv.unit:IsRealHero() then
				BotSupportLib:OnDeath(kv.unit, kv.attacker, kv)
			end
		end
	end
end

function modifier_bsl_eventhandler:OnAbilityFullyCast(kv)
	if IsServer() then
		local unit = kv.unit
		if unit then
			if unit:IsHero() then
				local ability = kv.ability
				local target = nil
				if kv.target then
					target = kv.target
				end
				if BotSupportLib:IsHeroBotControlled(unit) then
					BotSupportLib:OnAbilityCast(unit, ability, target, kv)
				else
					BotSupportLib:OnPlayerAbilityCast(unit, ability, target, kv)
				end
			end
		end
	end
end

--------------------------------------------------------------------------------