--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_cdreduction = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_cdreduction:GetTexture()
	return "custom/items/octarine"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_cdreduction:IsHidden()
    return false
end

function modifier_vgmar_i_cdreduction:IsPurgable()
	return false
end

function modifier_vgmar_i_cdreduction:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_cdreduction:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_cdreduction:OnCreated(kv) 
	if IsServer() then
		self.percentage = kv.percentage
		self.bonusmana = kv.bonusmana
		self.bonushealth = kv.bonushealth
		self.intbonus = kv.intbonus
		self.regslot = kv.registryslot
		self.spelllifestealcreep = kv.spelllifestealcreep
		self.spelllifestealhero = kv.spelllifestealhero
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_cdreduction")
	end
end

function modifier_vgmar_i_cdreduction:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING,
    }
    return funcs
end

function modifier_vgmar_i_cdreduction:GetModifierBonusStats_Intellect()
	if IsServer() then
		return self.intbonus
	else
		return self.clientvalues.intbonus
	end
end

function modifier_vgmar_i_cdreduction:GetModifierHealthBonus()
	if IsServer() then
		return self.bonushealth
	else
		return self.clientvalues.bonushealth
	end
end

function modifier_vgmar_i_cdreduction:GetModifierManaBonus()
	if IsServer() then
		return self.bonusmana
	else
		return self.clientvalues.bonusmana
	end
end

function modifier_vgmar_i_cdreduction:GetModifierPercentageCooldownStacking()
	if not IsServer() then
		return self.clientvalues.percentage
	else
		return self.percentage
	end
end

function modifier_vgmar_i_cdreduction:OnTakeDamage(event)
	if IsServer() and event.attacker == self:GetCaster() and event.inflictor then
  
		if self:GetParent():IsIllusion() or self:GetParent():IsClone() or self:GetParent():IsTempestDouble() then
			return
		end

		local damage_flags = event.damage_flags
    
		if bit.band(damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then
			return nil
		end
		if bit.band(damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION then
			return nil
		end

		local healFactor = self.spelllifestealhero * 0.01
		if not event.unit:IsHero() then
			healFactor = self.spelllifestealcreep * 0.01
		end
		local heal = healFactor * event.damage
    
		if self:GetCaster():GetHealth() > 0 then 
			self:GetCaster():Heal(heal,nil)
			ParticleManager:CreateParticle("particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		end
	end
end

--------------------------------------------------------------------------------