--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_scorching_light = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_scorching_light:GetTexture()
	return "custom/scorching_light"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_scorching_light:IsHidden()
	return false
end

function modifier_vgmar_i_scorching_light:IsPurgable()
	return false
end

function modifier_vgmar_i_scorching_light:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_scorching_light:IsAura() return true end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_scorching_light:GetModifierAura()  return "modifier_vgmar_i_scorching_light_debuff" end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_scorching_light:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_scorching_light:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_scorching_light:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_scorching_light:GetAuraRadius() return self.radius end

function modifier_vgmar_i_scorching_light:AllowIllusionDuplicate() return true end

function modifier_vgmar_i_scorching_light:OnCreated(kv)
	if IsServer() then
		if self:GetParent():IsIllusion() then
			local illusionvaluesfkup = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_scorching_light")
			self.radius = illusionvaluesfkup.radius
			self.interval = illusionvaluesfkup.interval
			self.initialdamage = illusionvaluesfkup.initialdamage
			self.damageincpertick = illusionvaluesfkup.damageincpertick
			self.maxdamage = illusionvaluesfkup.maxdamage
			self.missrate = illusionvaluesfkup.missrate
			self.visiondelay = illusionvaluesfkup.visiondelay
			self.visioninterval = illusionvaluesfkup.visioninterval
			self.maxillusionstacks = illusionvaluesfkup.maxillusionstacks
			self.lingerduration = illusionvaluesfkup.lingerduration
		else
			self.radius = kv.radius
			self.interval = kv.interval
			self.initialdamage = kv.initialdamage
			self.damageincpertick = kv.damageincpertick
			self.maxdamage = kv.maxdamage
			self.missrate = kv.missrate
			self.visiondelay = kv.visiondelay
			self.visioninterval = kv.visioninterval
			self.maxillusionstacks = kv.maxillusionstacks
			self.lingerduration = kv.lingerduration
		end
		local particle = ParticleManager:CreateParticle("particles/item/radiance/radiance_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(particle, 2, Vector(255,195,27))
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_scorching_light")
	end
end

function modifier_vgmar_i_scorching_light:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_scorching_light:OnTooltip()
	if IsServer() then
		return self.radius
	else
		return self.clientvalues.radius
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_i_scorching_light_debuff = class({})

function modifier_vgmar_i_scorching_light_debuff:GetTexture()
	return "custom/scorching_light"
end

function modifier_vgmar_i_scorching_light_debuff:IsHidden()
    return false
end

function modifier_vgmar_i_scorching_light_debuff:IsPurgable()
	return false
end

function modifier_vgmar_i_scorching_light_debuff:RemoveOnDeath()
	return true
end

function modifier_vgmar_i_scorching_light_debuff:IsDebuff()
	return true
end

function modifier_vgmar_i_scorching_light_debuff:OnCreated(kv)
	if IsServer() then
		local provider = self:GetCaster():FindModifierByName("modifier_vgmar_i_scorching_light")
		if self:GetParent():HasModifier("modifier_vgmar_i_scorching_light_debuff_lingering") then
			self:SetStackCount(self:GetParent():FindModifierByName("modifier_vgmar_i_scorching_light_debuff_lingering"):GetStackCount())
			self:GetParent():FindModifierByName("modifier_vgmar_i_scorching_light_debuff_lingering"):Destroy()
		end
		self.interval = provider.interval
		self.initialdamage = provider.initialdamage
		self.damageincpertick = provider.damageincpertick
		self.maxdamage = provider.maxdamage
		self.missrate = provider.missrate
		self.visiondelay = provider.visiondelay
		self.lingerduration = provider.lingerduration
		self.maxillusionstacks = provider.maxillusionstacks
		self.particle = ParticleManager:CreateParticle("particles/item/radiance/radiance_victim.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:StartIntervalThink(self.interval)
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_scorching_light")
	end
end

function modifier_vgmar_i_scorching_light_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_scorching_light_debuff:OnTooltip()
	if IsServer() then
		return self.initialdamage + math.min(self.maxdamage, self.damageincpertick * self:GetStackCount())
	else
		return self.clientvalues.initialdamage + math.min(self.clientvalues.maxdamage, self.clientvalues.damageincpertick * self:GetStackCount())
	end
end

function modifier_vgmar_i_scorching_light_debuff:GetModifierMiss_Percentage()
	if IsServer() then
		return self.missrate
	else
		return self.clientvalues.missrate
	end
end

function modifier_vgmar_i_scorching_light_debuff:GetModifierProvidesFOWVision()
	if IsServer() then
		if self:GetParent():IsInvisible() == false and self:GetParent():IsRealHero() and not self:GetCaster():IsIllusion() then
			if self:GetStackCount() * self.interval >= self.visiondelay then
				return 1
			end
		end
		return 0
	end
end

function modifier_vgmar_i_scorching_light_debuff:OnRemoved()
	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
	if IsServer() then
		if self:GetParent() then
			self:GetParent():AddNewModifier(self:GetCaster(), nil, "modifier_vgmar_i_scorching_light_debuff_lingering", {stacks = self:GetStackCount()})
		end
	end
end

function modifier_vgmar_i_scorching_light_debuff:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	ParticleManager:SetParticleControl(self.particle, 1, caster:GetAbsOrigin())
	local startcolor = {27, 255, 65}
	local endcolor = {255, 27, 27}
	local clampedstackcount = math.clamp(1, self:GetStackCount() * self.interval, self.visiondelay)
	local curcolor = {
		math.map(clampedstackcount, 1, self.visiondelay, startcolor[1], endcolor[1]),
		math.map(clampedstackcount, 1, self.visiondelay, startcolor[2], endcolor[2]),
		math.map(clampedstackcount, 1, self.visiondelay, startcolor[3], endcolor[3])
	}
	ParticleManager:SetParticleControl(self.particle, 2, Vector(curcolor[1],curcolor[2],curcolor[3]))
	local damage = self.initialdamage + math.min(self.maxdamage, self.damageincpertick * self:GetStackCount())
	ApplyDamage({victim = parent, attacker = caster, ability = nil, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
	if caster:IsIllusion() then
		if self:GetStackCount() < self.maxillusionstacks then
			self:SetStackCount(self:GetStackCount() + 1)
		end
	else
		self:SetStackCount(self:GetStackCount() + 1)
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_i_scorching_light_debuff_lingering = class({})

function modifier_vgmar_i_scorching_light_debuff_lingering:GetTexture()
	return "custom/scorching_light"
end

function modifier_vgmar_i_scorching_light_debuff_lingering:IsHidden()
    return false
end

function modifier_vgmar_i_scorching_light_debuff_lingering:IsPurgable()
	return false
end

function modifier_vgmar_i_scorching_light_debuff_lingering:RemoveOnDeath()
	return true
end

function modifier_vgmar_i_scorching_light_debuff_lingering:IsDebuff()
	return true
end

function modifier_vgmar_i_scorching_light_debuff_lingering:OnCreated(kv)
	if IsServer() then
		local provider = self:GetCaster():FindModifierByName("modifier_vgmar_i_scorching_light")
		self:SetStackCount(kv.stacks)
		self.interval = provider.interval
		self.initialdamage = provider.initialdamage
		self.damageincpertick = provider.damageincpertick
		self.maxdamage = provider.maxdamage
		self.missrate = provider.missrate
		self.visiondelay = provider.visiondelay
		self.lingerduration = provider.lingerduration
		self.particle = ParticleManager:CreateParticle("particles/item/radiance/radiance_victim.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:StartIntervalThink(self.interval)
		self:SetDuration(self.lingerduration, true)
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_scorching_light")
	end
end

function modifier_vgmar_i_scorching_light_debuff_lingering:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_scorching_light_debuff_lingering:OnTooltip()
	if IsServer() then
		return self.initialdamage + math.min(self.maxdamage, self.damageincpertick * self:GetStackCount())
	else
		return self.clientvalues.initialdamage + math.min(self.clientvalues.maxdamage, self.clientvalues.damageincpertick * self:GetStackCount())
	end
end

function modifier_vgmar_i_scorching_light_debuff_lingering:GetModifierMiss_Percentage()
	if IsServer() then
		return self.missrate
	else
		return self.clientvalues.missrate
	end
end

function modifier_vgmar_i_scorching_light_debuff_lingering:GetModifierProvidesFOWVision()
	if IsServer() then
		if self:GetParent():IsInvisible() == false and self:GetParent():IsRealHero() and not self:GetCaster():IsIllusion() then
			if self:GetStackCount() * self.interval >= self.visiondelay then
				return 1
			end
		end
		return 0
	end
end

function modifier_vgmar_i_scorching_light_debuff_lingering:OnRemoved()
	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
end

function modifier_vgmar_i_scorching_light_debuff_lingering:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	ParticleManager:SetParticleControl(self.particle, 1, Vector(parent:GetAbsOrigin().x, parent:GetAbsOrigin().y, 100))
	local startcolor = {27, 255, 65}
	local endcolor = {255, 27, 27}
	local clampedstackcount = math.clamp(1, self:GetStackCount() * self.interval, self.visiondelay)
	local curcolor = {
		math.map(clampedstackcount, 1, self.visiondelay, startcolor[1], endcolor[1]),
		math.map(clampedstackcount, 1, self.visiondelay, startcolor[2], endcolor[2]),
		math.map(clampedstackcount, 1, self.visiondelay, startcolor[3], endcolor[3])
	}
	ParticleManager:SetParticleControl(self.particle, 2, Vector(curcolor[1],curcolor[2],curcolor[3]))
	local damage = self.initialdamage + math.min(self.maxdamage, self.damageincpertick * self:GetStackCount())
	ApplyDamage({victim = parent, attacker = caster, ability = nil, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end