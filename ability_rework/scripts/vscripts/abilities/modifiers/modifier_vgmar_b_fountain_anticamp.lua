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
function modifier_vgmar_b_fountain_anticamp:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_DEAD + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_b_fountain_anticamp:GetAuraRadius() return self.radius end

function modifier_vgmar_b_fountain_anticamp:OnCreated(kv)
	if IsServer() then
		self.radius = kv.radius
		self.interval = kv.interval
		self.strpertick = kv.strpertick
		self.intpertick = kv.intpertick
		self.agipertick = kv.agipertick
		self.disablepassivestick = kv.disablepassivestick
		self.silencetick = kv.silencetick
		self.blindnessendtick = kv.blindnessendtick
		self.blindnessrange = kv.blindnessrange
		self.lingerduration = kv.lingerduration
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_b_fountain_anticamp")
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_b_fountain_anticamp_debuff_break = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_b_fountain_anticamp_debuff_break:GetTexture()
	return "custom/fountain_anticamp"
end

function modifier_vgmar_b_fountain_anticamp_debuff_break:IsHidden()
    return false
end

function modifier_vgmar_b_fountain_anticamp_debuff_break:IsPurgable()
	return false
end

function modifier_vgmar_b_fountain_anticamp_debuff_break:RemoveOnDeath()
	return false
end

function modifier_vgmar_b_fountain_anticamp_debuff_break:IsDebuff()
	return true
end

function modifier_vgmar_b_fountain_anticamp_debuff_break:OnCreated(kv)
	if IsServer() then
		local breakstartparticle = ParticleManager:CreateParticle("particles/items3_fx/silver_edge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(breakstartparticle, false, false, 0, false, false)
		StartSoundEvent("DOTA_Item.SilverEdge.Target", self:GetParent())
		self:StartIntervalThink( 1 )
	end
end

function modifier_vgmar_b_fountain_anticamp_debuff_break:CheckState()
	local state = {
	[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}

	return state
end

function modifier_vgmar_b_fountain_anticamp_debuff_break:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_vgmar_b_fountain_anticamp_debuff") == false and parent:HasModifier("modifier_vgmar_b_fountain_anticamp_debuff_lingering") == false then
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_b_fountain_anticamp_debuff_silence = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_b_fountain_anticamp_debuff_silence:GetTexture()
	return "custom/fountain_anticamp"
end

function modifier_vgmar_b_fountain_anticamp_debuff_silence:IsHidden()
    return false
end

function modifier_vgmar_b_fountain_anticamp_debuff_silence:IsPurgable()
	return false
end

function modifier_vgmar_b_fountain_anticamp_debuff_silence:RemoveOnDeath()
	return false
end

function modifier_vgmar_b_fountain_anticamp_debuff_silence:IsDebuff()
	return true
end

function modifier_vgmar_b_fountain_anticamp_debuff_silence:OnCreated(kv)
	if IsServer() then
		--"particles/econ/items/storm_spirit/storm_spirit_orchid_hat/storm_orchid_silenced.vpcf"
		local silencestartparticle = ParticleManager:CreateParticle("particles/items2_fx/orchid.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(silencestartparticle, false, false, 0, false, false)
		StartSoundEvent("DOTA_Item.Orchid.Activate", self:GetParent())
		self:StartIntervalThink( 1 )
	end
end

function modifier_vgmar_b_fountain_anticamp_debuff_silence:CheckState()
	local state = {
	[MODIFIER_STATE_SILENCED] = true,
	}

	return state
end

function modifier_vgmar_b_fountain_anticamp_debuff_silence:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_vgmar_b_fountain_anticamp_debuff") == false and parent:HasModifier("modifier_vgmar_b_fountain_anticamp_debuff_lingering") == false then
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_b_fountain_anticamp_debuff_blindness = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_b_fountain_anticamp_debuff_blindness:IsHidden()
    return true
end

function modifier_vgmar_b_fountain_anticamp_debuff_blindness:IsPurgable()
	return false
end

function modifier_vgmar_b_fountain_anticamp_debuff_blindness:RemoveOnDeath()
	return false
end

function modifier_vgmar_b_fountain_anticamp_debuff_blindness:IsDebuff()
	return true
end

function modifier_vgmar_b_fountain_anticamp_debuff_blindness:OnCreated(kv)
	if IsServer() then
		local provider = self:GetCaster():FindModifierByName("modifier_vgmar_b_fountain_anticamp")
		self.blindnessendtick = provider.blindnessendtick
		self.blindnessrange = provider.blindnessrange
		self.stacks = self:GetParent():FindModifierByName("modifier_vgmar_b_fountain_anticamp_debuff"):GetStackCount()
		self:StartIntervalThink( 1 )
		
	end
end

function modifier_vgmar_b_fountain_anticamp_debuff_blindness:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION
    }
    return funcs
end

function modifier_vgmar_b_fountain_anticamp_debuff_blindness:GetFixedDayVision()
	return self:GetStackCount()
end

function modifier_vgmar_b_fountain_anticamp_debuff_blindness:GetFixedNightVision()
	return self:GetStackCount()
end

function modifier_vgmar_b_fountain_anticamp_debuff_blindness:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		if parent:HasModifier("modifier_vgmar_b_fountain_anticamp_debuff") == false and parent:HasModifier("modifier_vgmar_b_fountain_anticamp_debuff_lingering") == false then
			self:Destroy()
		else
			if parent:HasModifier("modifier_vgmar_b_fountain_anticamp_debuff") then
				self.stacks = self:GetParent():FindModifierByName("modifier_vgmar_b_fountain_anticamp_debuff"):GetStackCount()
			elseif parent:HasModifier("modifier_vgmar_b_fountain_anticamp_debuff_lingering") then
				self.stacks = self:GetParent():FindModifierByName("modifier_vgmar_b_fountain_anticamp_debuff_lingering"):GetStackCount()
			end
			local dvision = parent:GetBaseDayTimeVisionRange()
			local nvision = parent:GetBaseNightTimeVisionRange()
			if GameRules:IsDaytime() then
				self:SetStackCount(math.mapl(self.stacks, 1, self.blindnessendtick, dvision, self.blindnessrange))
			else
				self:SetStackCount(math.mapl(self.stacks, 1, self.blindnessendtick, nvision, self.blindnessrange))
			end
		end
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
		self.disablepassivestick = provider.disablepassivestick
		self.silencetick = provider.silencetick
		if self:GetParent():HasModifier("modifier_vgmar_b_fountain_anticamp_debuff_lingering") then
			self:SetStackCount(self:GetParent():FindModifierByName("modifier_vgmar_b_fountain_anticamp_debuff_lingering"):GetStackCount())
			self:GetParent():FindModifierByName("modifier_vgmar_b_fountain_anticamp_debuff_lingering"):Destroy()
		end
		self.lingerduration = provider.lingerduration
		--"particles/units/heroes/hero_omniknight/omniknight_degen_aura_debuff.vpcf"
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:StartIntervalThink(self.interval)
		if self:GetParent():HasModifier("modifier_vgmar_b_fountain_anticamp_debuff_blindness") == false then
			self:GetParent():AddNewModifier(self:GetCaster(), nil, "modifier_vgmar_b_fountain_anticamp_debuff_blindness", {})
		end
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_b_fountain_anticamp")
	end
end

function modifier_vgmar_b_fountain_anticamp_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING
    }
    return funcs
end

function modifier_vgmar_b_fountain_anticamp_debuff:GetModifierPercentageCooldownStacking()
	return self:GetStackCount() * -1
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
	if IsServer() then
		if self:GetParent():IsAlive() and (self:GetParent():IsInvulnerable() == false and self:GetParent():IsOutOfGame() == false) then
			self:SetStackCount(self:GetStackCount() + 1)
			if self:GetStackCount() >= self.disablepassivestick and self:GetParent():HasModifier("modifier_vgmar_b_fountain_anticamp_debuff_break") == false then
				self:GetParent():AddNewModifier(self:GetCaster(), nil, "modifier_vgmar_b_fountain_anticamp_debuff_break", {})
			end
			if self:GetStackCount() >= self.silencetick and self:GetParent():HasModifier("modifier_vgmar_b_fountain_anticamp_debuff_silence") == false then
				self:GetParent():AddNewModifier(self:GetCaster(), nil, "modifier_vgmar_b_fountain_anticamp_debuff_silence", {})
			end
		end
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
		self.strpertick = provider.strpertick
		self.intpertick = provider.intpertick
		self.agipertick = provider.agipertick
		self:SetStackCount(kv.stacks)
		self.lingerduration = provider.lingerduration
		--"particles/units/heroes/hero_omniknight/omniknight_degen_aura_debuff.vpcf"
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether_slow.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:SetDuration(self.lingerduration, true)
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_b_fountain_anticamp")
	end
end

function modifier_vgmar_b_fountain_anticamp_debuff_lingering:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE_STACKING
    }
    return funcs
end

function modifier_vgmar_b_fountain_anticamp_debuff_lingering:GetModifierPercentageCooldownStacking()
	return self:GetStackCount() * -1
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