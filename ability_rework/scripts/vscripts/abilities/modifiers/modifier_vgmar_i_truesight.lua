--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_truesight = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_truesight:GetTexture()
	return "custom/items/gem_of_true_sight"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_truesight:IsHidden()
    return false
end

function modifier_vgmar_i_truesight:IsPurgable()
	return false
end

function modifier_vgmar_i_truesight:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_truesight:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_truesight:IsAura() return true end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_truesight:GetModifierAura()  return "modifier_truesight" end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_truesight:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_truesight:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_truesight:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_truesight:GetAuraRadius() return self:GetStackCount() end

function modifier_vgmar_i_truesight:OnCreated(kv)
	self.maxrange = kv.maxrange
	self.minrange = kv.minrange
	self.maxtime = kv.maxtime
	if IsServer() then
		self:SetDuration(kv.maxtime, true)
		self:StartIntervalThink( 1 )
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_truesight_vision", {})
	end
end

function modifier_vgmar_i_truesight:GetEffectName()
	return "particles/econ/events/fall_major_2015/compendium_points_fall_ambient_2015_twinkle.vpcf"
end

function modifier_vgmar_i_truesight:GetEffectAttachType()
	return PATTACH_ROOTBONE_FOLLOW
end

function modifier_vgmar_i_truesight:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end


function modifier_vgmar_i_truesight:OnRespawn(kv)
	if kv.unit == self:GetParent() then
		self:SetDuration(self.maxtime, true)
	end
end

function modifier_vgmar_i_truesight:OnDeath(kv)
	if kv.unit == self:GetParent() then
		self:SetDuration(-1, true)
		self:SetStackCount(0)
	end
end

function modifier_vgmar_i_truesight:OnIntervalThink()
	if IsServer() then
		if self:GetParent():IsAlive() then
			if self:GetRemainingTime() <= 0 then
				self:SetStackCount(self.maxrange)
				self:SetDuration(-1, true)
			else
				local stacks = math.map(math.floor(self:GetRemainingTime()), self.maxtime, 0, self.minrange, self.maxrange)
				self:SetStackCount(stacks)
			end
		end
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_i_truesight_vision = class({})

function modifier_vgmar_i_truesight_vision:IsHidden()
    return true
end

function modifier_vgmar_i_truesight_vision:IsPurgable()
	return false
end

function modifier_vgmar_i_truesight_vision:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_truesight_vision:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_truesight_vision:OnCreated(kv)
	if IsServer() then
		self.provider = self:GetCaster():FindModifierByName("modifier_vgmar_i_truesight")
		self.maxtime = self.provider.maxtime
		self:StartIntervalThink( 1 )
	end
end

function modifier_vgmar_i_truesight_vision:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BONUS_NIGHT_VISION
    }
    return funcs
end

function modifier_vgmar_i_truesight_vision:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		if parent:IsAlive() then
			local nightdaydiff = (parent:GetBaseDayTimeVisionRange()-parent:GetBaseNightTimeVisionRange())
			if self.provider:GetRemainingTime() <= 0 then
				self:SetStackCount(nightdaydiff)
			else
				local scale = math.map(math.floor(self.provider:GetRemainingTime()), self.maxtime, 0, 0, 1)
				self:SetStackCount(scale*nightdaydiff)
			end
		end
	end
end

function modifier_vgmar_i_truesight_vision:GetBonusNightVision()
	return self:GetStackCount()
end