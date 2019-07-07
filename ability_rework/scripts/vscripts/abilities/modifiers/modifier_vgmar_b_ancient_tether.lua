--A modifier used as a visualisation for a custom spell

modifier_vgmar_b_ancient_tether = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_b_ancient_tether:GetTexture()
	return "custom/companion_wisp_tether"
end

--------------------------------------------------------------------------------

function modifier_vgmar_b_ancient_tether:IsHidden()
    return false
end

function modifier_vgmar_b_ancient_tether:IsDebuff()
	return false
end

function modifier_vgmar_b_ancient_tether:IsPurgable()
	return false
end

function modifier_vgmar_b_ancient_tether:DestroyOnExpire()
	return false
end

function modifier_vgmar_b_ancient_tether:RemoveOnDeath()
	return false
end

function modifier_vgmar_b_ancient_tether:OnCreated( kv )
	if IsServer() then
		self.damagereducion = kv.damagereducion
		self.healthregen = kv.healthregen
		self.manaregen = kv.manaregen
		self.bonusas = kv.bonusas
		self.ancient = self:GetCaster()
		self.ancientsoundmod = self.ancient:FindModifierByName("modifier_vgmar_b_ancient_tether_counter")
		self.ancientsoundmod:IncrementStackCount()
		if Extensions:IsVisibleToTeam(self:GetParent(), "radiant") then
			EmitSoundOn("Hero_Wisp.Tether.Target", self:GetParent())
		end
		self.particle = ParticleManager:CreateParticle("particles/econ/items/wisp/wisp_tether_ti7.vpcf", PATTACH_POINT, self.ancient)
		ParticleManager:SetParticleControlEnt(self.particle, 0, self.ancient, PATTACH_POINT_FOLLOW, "attach_hitloc", self.ancient:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(self.particle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		self:AddParticle(self.particle, true, false, 0, false, false)
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_b_ancient_tether")
	end
end

function modifier_vgmar_b_ancient_tether:OnRemoved()
	if IsServer() then
		self.ancientsoundmod:DecrementStackCount()
		if Extensions:IsVisibleToTeam(self:GetParent(), "radiant") then
			EmitSoundOn("Hero_Wisp.Tether.Stop", self:GetParent())
		end
	end
end

function modifier_vgmar_b_ancient_tether:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
    return funcs
end

function modifier_vgmar_b_ancient_tether:GetModifierConstantHealthRegen()
	if IsServer() then
		return self.healthregen
	else
		return self.clientvalues.healthregen
	end
end

function modifier_vgmar_b_ancient_tether:GetModifierConstantManaRegen()
	if IsServer() then
		return self.manaregen
	else
		return self.clientvalues.manaregen
	end
end

function modifier_vgmar_b_ancient_tether:GetModifierIncomingDamage_Percentage()
	if IsServer() then
		return self.extrahealperc
	else
		return self.clientvalues.extrahealperc
	end
end

function modifier_vgmar_b_ancient_tether:GetModifierAttackSpeedBonus_Constant()
	if IsServer() then
		return self.bonusas
	else
		return self.clientvalues.bonusas
	end
end
--------------------------------------------------------------------------------

modifier_vgmar_b_ancient_tether_counter = class({})

function modifier_vgmar_b_ancient_tether_counter:IsHidden()
    return true
end

function modifier_vgmar_b_ancient_tether_counter:IsDebuff()
	return false
end

function modifier_vgmar_b_ancient_tether_counter:IsPurgable()
	return false
end

function modifier_vgmar_b_ancient_tether_counter:DestroyOnExpire()
	return false
end

function modifier_vgmar_b_ancient_tether_counter:RemoveOnDeath()
	return false
end

function modifier_vgmar_b_ancient_tether_counter:OnCreated(kv)
	if IsServer() then
		self.soundon = false
		self:StartIntervalThink(1)
	end
end

function modifier_vgmar_b_ancient_tether_counter:OnIntervalThink()
	if IsServer() then
		if self:GetStackCount() > 0 and self.soundon == false then
			EmitSoundOn("Hero_Wisp.Tether", self:GetParent())
			self.soundon = true
		elseif self:GetStackCount() <= 0 and self.soundon then
			StopSoundOn("Hero_Wisp.Tether", self:GetParent())
			self.soundon = false
		end
	end
end

--------------------------------------------------------------------------------