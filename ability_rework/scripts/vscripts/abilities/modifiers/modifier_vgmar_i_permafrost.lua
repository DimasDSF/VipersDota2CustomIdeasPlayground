--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_permafrost = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_permafrost:GetTexture()
	return "custom/permafrost"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_permafrost:IsHidden()
	return false
end

function modifier_vgmar_i_permafrost:IsPurgable()
	return false
end

function modifier_vgmar_i_permafrost:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_permafrost:IsAura() return true end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_permafrost:GetModifierAura()  return "modifier_vgmar_i_permafrost_debuff" end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_permafrost:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_permafrost:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_permafrost:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_permafrost:GetAuraRadius() return self.radius end

function modifier_vgmar_i_permafrost:OnCreated(kv)
	if IsServer() then
		self.radius = kv.radius
		self.interval = kv.interval
		self.attackspeedperstack = kv.attackspeedperstack
		self.movespeedperstack = kv.movespeedperstack
		self.maxstacks = kv.maxstacks
		self.freezedmg = kv.freezedmg
		self.bonusarmor = kv.bonusarmor
		self.bonusint = kv.bonusint
		self.lingerduration = kv.lingerduration
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_permafrost")
	end
end

function modifier_vgmar_i_permafrost:GetEffectName()
	return "particles/econ/events/winter_major_2016/radiant_fountain_regen_wm_lvl2_a5.vpcf"
end

function modifier_vgmar_i_permafrost:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_vgmar_i_permafrost:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_armor.vpcf"
end

function modifier_vgmar_i_permafrost:StatusEffectPriority()
	return 15
end

function modifier_vgmar_i_permafrost:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
    return funcs
end

function modifier_vgmar_i_permafrost:OnTooltip()
	if IsServer() then
		return self.radius
	else
		return self.clientvalues.radius
	end
end

function modifier_vgmar_i_permafrost:GetModifierBonusStats_Intellect()
	if IsServer() then
		return self.bonusint
	else
		return self.clientvalues.bonusint
	end
end

function modifier_vgmar_i_permafrost:GetModifierPhysicalArmorBonus()
	if IsServer() then
		return self.bonusarmor
	else
		return self.clientvalues.bonusarmor
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_i_permafrost_debuff = class({})

function modifier_vgmar_i_permafrost_debuff:GetTexture()
	return "custom/permafrost"
end

function modifier_vgmar_i_permafrost_debuff:IsHidden()
    return false
end

function modifier_vgmar_i_permafrost_debuff:IsPurgable()
	return false
end

function modifier_vgmar_i_permafrost_debuff:RemoveOnDeath()
	return true
end

function modifier_vgmar_i_permafrost_debuff:IsDebuff()
	return true
end

function modifier_vgmar_i_permafrost_debuff:OnCreated(kv)
	if IsServer() then
		local provider = self:GetCaster():FindModifierByName("modifier_vgmar_i_permafrost")
		self.interval = provider.interval
		self.attackspeedperstack = provider.attackspeedperstack
		self.movespeedperstack = provider.movespeedperstack
		self.maxstacks = provider.maxstacks
		self.freezedmg = provider.freezedmg
		self.lingerduration = provider.lingerduration
		if self:GetParent():HasModifier("modifier_vgmar_i_permafrost_debuff_lingering") then
			self:SetStackCount(self:GetParent():FindModifierByName("modifier_vgmar_i_permafrost_debuff_lingering"):GetStackCount())
			self:GetParent():FindModifierByName("modifier_vgmar_i_permafrost_debuff_lingering"):Destroy()
		else
			self:SetStackCount(1)
		end
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_frozen_sigil_status_ice.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:StartIntervalThink(self.interval)
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_permafrost")
	end
end

function modifier_vgmar_i_permafrost_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
    return funcs
end

function modifier_vgmar_i_permafrost_debuff:GetModifierMoveSpeedBonus_Constant()
	if IsServer() then
		return self.movespeedperstack * self:GetStackCount()
	else
		return self.clientvalues.movespeedperstack * self:GetStackCount()
	end
end

function modifier_vgmar_i_permafrost_debuff:GetModifierAttackSpeedBonus_Constant()
	if IsServer() then
		return self.attackspeedperstack * self:GetStackCount()
	else
		return self.clientvalues.attackspeedperstack * self:GetStackCount()
	end
end

function modifier_vgmar_i_permafrost_debuff:OnRemoved()
	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
	if IsServer() then
		if self:GetParent() then
			self:GetParent():AddNewModifier(self:GetCaster(), nil, "modifier_vgmar_i_permafrost_debuff_lingering", {stacks = self:GetStackCount()})
		end
	end
end

function modifier_vgmar_i_permafrost_debuff:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	StartSoundEvent("Hero_Ancient_Apparition.IceBlastRelease.Tick", parent)
	if self:GetStackCount()+1 <= self.maxstacks then
		self:SetStackCount(self:GetStackCount() + 1)
	else
		if IsServer() then
			ApplyDamage({victim = parent, attacker = caster, ability = nil, damage = self.freezedmg, damage_type = DAMAGE_TYPE_MAGICAL})
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.freezedmg, nil)
		end
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_i_permafrost_debuff_lingering = class({})

function modifier_vgmar_i_permafrost_debuff_lingering:GetTexture()
	return "custom/permafrost"
end

function modifier_vgmar_i_permafrost_debuff_lingering:IsHidden()
    return false
end

function modifier_vgmar_i_permafrost_debuff_lingering:IsPurgable()
	return false
end

function modifier_vgmar_i_permafrost_debuff_lingering:RemoveOnDeath()
	return true
end

function modifier_vgmar_i_permafrost_debuff_lingering:IsDebuff()
	return true
end

function modifier_vgmar_i_permafrost_debuff_lingering:OnCreated(kv)
	if IsServer() then
		local provider = self:GetCaster():FindModifierByName("modifier_vgmar_i_permafrost")
		self:SetStackCount(kv.stacks)
		self.interval = provider.interval
		self.attackspeedperstack = provider.attackspeedperstack
		self.movespeedperstack = provider.movespeedperstack
		self.lingerduration = provider.lingerduration
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_frozen_sigil_status_ice.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:SetDuration(self.lingerduration, true)
		self:StartIntervalThink(self.interval)
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_permafrost")
	end
end

function modifier_vgmar_i_permafrost_debuff_lingering:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
    }
    return funcs
end

function modifier_vgmar_i_permafrost_debuff_lingering:GetModifierMoveSpeedBonus_Constant()
	if IsServer() then
		return self.movespeedperstack * self:GetStackCount()
	else
		return self.clientvalues.movespeedperstack * self:GetStackCount()
	end
end

function modifier_vgmar_i_permafrost_debuff_lingering:GetModifierAttackSpeedBonus_Constant()
	if IsServer() then
		return self.attackspeedperstack * self:GetStackCount()
	else
		return self.clientvalues.attackspeedperstack * self:GetStackCount()
	end
end

function modifier_vgmar_i_permafrost_debuff_lingering:OnRemoved()
	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
end

function modifier_vgmar_i_permafrost_debuff_lingering:OnIntervalThink()
	StartSoundEvent("Hero_Ancient_Apparition.IceBlastRelease.Tick", self:GetParent())
end