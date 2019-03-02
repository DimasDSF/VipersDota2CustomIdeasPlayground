modifier_extensions_eventhandler = class({})

function modifier_extensions_eventhandler:IsHidden()
	return true
end

function modifier_extensions_eventhandler:IsPurgable()
	return false
end

function modifier_extensions_eventhandler:RemoveOnDeath()
	return false
end

function modifier_extensions_eventhandler:DestroyOnExpire()
	return false
end

function modifier_extensions_eventhandler:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }
    return funcs
end

function modifier_extensions_eventhandler:OnAttackLanded(event)
	if IsServer() then
		Extensions:Event_OnAttackLanded(event.attacker, event.target, event)
	end
end

function modifier_extensions_eventhandler:OnAttackStart(event)
	if IsServer() then
		Extensions:Event_OnAttackStart(event.attacker, event.target, event)
	end
end

function modifier_extensions_eventhandler:OnTakeDamage(event)
	if IsServer() then
		Extensions:Event_OnDamaged(event.unit, event.attacker, event)
	end
end

function modifier_extensions_eventhandler:OnDeath(event)
	if IsServer() then
		Extensions:Event_OnDeath(event.unit, event.attacker, event)
	end
end

function modifier_extensions_eventhandler:OnAbilityFullyCast(event)
	if IsServer() then
		local unit = event.unit
		if unit then
			local ability = event.ability
			local target = nil
			if event.target then
				target = event.target
			end
			Extensions:Event_OnAbilityCast(unit, ability, target, event)
		end
	end
end