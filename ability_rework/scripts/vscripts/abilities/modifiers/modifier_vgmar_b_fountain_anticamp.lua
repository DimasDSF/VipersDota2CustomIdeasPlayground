--A modifier used as a visualisation for a custom spell

modifier_vgmar_b_fountain_anticamp = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_b_fountain_anticamp:GetTexture()
	return "custom/fountain_anticamp"
end

--------------------------------------------------------------------------------

function modifier_vgmar_b_fountain_anticamp:IsHidden()
	return false
end

function modifier_vgmar_b_fountain_anticamp:IsPurgable()
	return false
end

function modifier_vgmar_b_fountain_anticamp:RemoveOnDeath()
	return false
end

function modifier_vgmar_b_fountain_anticamp:IsAura() return true end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_b_fountain_anticamp:GetModifierAura()  return "modifier_vgmar_b_fountain_anticamp_debuff" end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_b_fountain_anticamp:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_b_fountain_anticamp:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_b_fountain_anticamp:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_b_fountain_anticamp:GetAuraRadius() return self.radius end

function modifier_vgmar_b_fountain_anticamp:OnCreated(kv)
	if IsServer() then
		self.radius = kv.radius
		self.interval = kv.interval
		self.strpertick = kv.strpertick
		self.intpertick = kv.intpertick
		self.agipertick = kv.agipertick
		self.lingerduration = kv.lingerduration
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_b_fountain_anticamp")
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_b_fountain_anticamp_debuff = class({})

function modifier_vgmar_b_fountain_anticamp_debuff:GetTexture()
	return "custom/fountain_anticamp"
end

function modifier_vgmar_b_fountain_anticamp_debuff:IsHidden()
    return false
end

function modifier_vgmar_b_fountain_anticamp_debuff:IsPurgable()
	return false
end

function modifier_vgmar_b_fountain_anticamp_debuff:RemoveOnDeath()
	return false
end

function modifier_vgmar_b_fountain_anticamp_debuff:IsDebuff()
	return true
end

function modifier_vgmar_b_fountain_anticamp_debuff:OnCreated(kv)
	if IsServer() then
		local provider = self:GetCaster():FindModifierByName("modifier_vgmar_b_fountain_anticamp")
		self.interval = provider.interval
		self.strpertick = provider.strpertick
		self.intpertick = provider.intpertick
		self.agipertick = provider.agipertick
		if self:GetParent():HasModifier("modifier_vgmar_b_fountain_anticamp_debuff_lingering") then
			self:SetStackCount(self:GetParent():FindModifierByName("modifier_vgmar_b_fountain_anticamp_debuff_lingering"):GetStackCount())
			self:GetParent():FindModifierByName("modifier_vgmar_b_fountain_anticamp_debuff_lingering"):Destroy()
		end
		self.lingerduration = provider.lingerduration
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_degen_aura_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:StartIntervalThink(self.interval)
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_b_fountain_anticamp")
	end
end

function modifier_vgmar_b_fountain_anticamp_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }
    return funcs
end

function modifier_vgmar_b_fountain_anticamp_debuff:GetModifierBonusStats_Agility()
	if IsServer() then
		return self:GetStackCount() * self.agipertick * -1
	else
		return self:GetStackCount() * self.clientvalues.agipertick * -1
	end
end

function modifier_vgmar_b_fountain_anticamp_debuff:GetModifierBonusStats_Intellect()
	if IsServer() then
		return self:GetStackCount() * self.intpertick * -1
	else
		return self:GetStackCount() * self.clientvalues.intpertick * -1
	end
end

function modifier_vgmar_b_fountain_anticamp_debuff:GetModifierBonusStats_Strength()
	if IsServer() then
		return self:GetStackCount() * self.strpertick * -1
	else
		return self:GetStackCount() * self.clientvalues.strpertick * -1
	end
end

function modifier_vgmar_b_fountain_anticamp_debuff:OnRemoved()
	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
	if IsServer() then
		if self:GetParent() then
			self:GetParent():AddNewModifier(self:GetCaster(), nil, "modifier_vgmar_b_fountain_anticamp_debuff_lingering", {stacks = self:GetStackCount()})
		end
	end
end

function modifier_vgmar_b_fountain_anticamp_debuff:OnIntervalThink()
	self:GetParent():CalculateStatBonus()
	if self:GetParent():IsAlive() then
		self:SetStackCount(self:GetStackCount() + 1)
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_b_fountain_anticamp_debuff_lingering = class({})

function modifier_vgmar_b_fountain_anticamp_debuff_lingering:GetTexture()
	return "custom/fountain_anticamp"
end

function modifier_vgmar_b_fountain_anticamp_debuff_lingering:IsHidden()
    return false
end

function modifier_vgmar_b_fountain_anticamp_debuff_lingering:IsPurgable()
	return false
end

function modifier_vgmar_b_fountain_anticamp_debuff_lingering:RemoveOnDeath()
	return false
end

function modifier_vgmar_b_fountain_anticamp_debuff_lingering:IsDebuff()
	return true
end

function modifier_vgmar_b_fountain_anticamp_debuff_lingering:OnCreated(kv)
	if IsServer() then
		local provider = self:GetCaster():FindModifierByName("modifier_vgmar_b_fountain_anticamp")
		self:SetStackCount(kv.stacks)
		self.strpertick = provider.strpertick
		self.intpertick = provider.intpertick
		self.agipertick = provider.agipertick
		self.lingerduration = provider.lingerduration
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_degen_aura_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:SetDuration(self.lingerduration, true)
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_b_fountain_anticamp")
	end
end

function modifier_vgmar_b_fountain_anticamp_debuff_lingering:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
    }
    return funcs
end

function modifier_vgmar_b_fountain_anticamp_debuff_lingering:GetModifierBonusStats_Agility()
	if IsServer() then
		return self:GetStackCount() * self.agipertick * -1
	else
		return self:GetStackCount() * self.clientvalues.agipertick * -1
	end
end

function modifier_vgmar_b_fountain_anticamp_debuff_lingering:GetModifierBonusStats_Intellect()
	if IsServer() then
		return self:GetStackCount() * self.intpertick * -1
	else
		return self:GetStackCount() * self.clientvalues.intpertick * -1
	end
end

function modifier_vgmar_b_fountain_anticamp_debuff_lingering:GetModifierBonusStats_Strength()
	if IsServer() then
		return self:GetStackCount() * self.strpertick * -1
	else
		return self:GetStackCount() * self.clientvalues.strpertick * -1
	end
end


function modifier_vgmar_b_fountain_anticamp_debuff_lingering:OnRemoved()
	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
end