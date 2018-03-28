--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_thirst = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_thirst:GetTexture()
	return "bloodseeker_thirst"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_thirst:IsHidden()
	return self:GetStackCount() <= 0
end

function modifier_vgmar_i_thirst:IsPurgable()
	return false
end

function modifier_vgmar_i_thirst:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_thirst:IsAura() return true end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_thirst:GetModifierAura()  return "modifier_vgmar_i_thirst_debuff" end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_thirst:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_thirst:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_thirst:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_thirst:GetAuraRadius() return self.radius end

function modifier_vgmar_i_thirst:OnCreated(kv)
	if IsServer() then
		self.radius = kv.radius
		self.threshold = kv.threshold / 100
		self.visionthreshold = kv.visionthreshold / 100
		self.visionrange = kv.visionrange
		self.visionduration = kv.visionduration
		self.giverealvision = kv.giverealvision
		self.givemodelvision = kv.givemodelvision
		self.msperstack = kv.msperstack
		self.maxbasems = kv.maxbasems
		self.maxperhero = kv.maxperhero
		self.particle = nil
		
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_thirst")
	end
	self:StartIntervalThink(0.2)
end

function modifier_vgmar_i_thirst:OnIntervalThink()
	local parent = self:GetParent()
	if IsServer() then
		local aurarecievers = {}
		if GameRules.VGMAR:FindAuraChildren(self) ~= nil then
			aurarecievers = GameRules.VGMAR:FindAuraChildren(self)
		end
		local stacks = 0
		if aurarecievers ~= nil then
			for i=1,#aurarecievers do
				stacks = stacks + math.min(self.maxperhero, aurarecievers[i]:GetStackCount())
			end
		end
		if self:GetStackCount() ~= stacks then
			self:SetStackCount(stacks)
		end
		if self:GetStackCount() > 0 then
			if self.particle == nil then
				self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_thirst_owner.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			end
		else
			if self.particle ~= nil then
				ParticleManager:DestroyParticle(self.particle, false)
				ParticleManager:ReleaseParticleIndex(self.particle)
				self.particle = nil
			end
		end
	end
end

function modifier_vgmar_i_thirst:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_thirst:GetModifierMoveSpeed_Max( params )
    if IsServer() then
		if self:GetStackCount() <= 0 then
			return self.maxbasems
		else
			return self.maxbasems + (self:GetStackCount() * self.msperstack)
		end
	else
		if self:GetStackCount() <= 0 then
			return self.clientvalues.maxbasems
		else
			return self.clientvalues.maxbasems + (self:GetStackCount() * self.clientvalues.msperstack)
		end
	end
end

function modifier_vgmar_i_thirst:GetModifierMoveSpeed_Limit( params )
	if IsServer() then
		if self:GetStackCount() <= 0 then
			return self.maxbasems
		else
			return self.maxbasems + (self:GetStackCount() * self.msperstack)
		end
	else
		if self:GetStackCount() <= 0 then
			return self.clientvalues.maxbasems
		else
			return self.clientvalues.maxbasems + (self:GetStackCount() * self.clientvalues.msperstack)
		end
	end
end

function modifier_vgmar_i_thirst:GetModifierMoveSpeedBonus_Constant()
	if IsServer() then
		return self:GetStackCount() * self.msperstack
	else
		return self:GetStackCount() * self.clientvalues.msperstack
	end
end

function modifier_vgmar_i_thirst:OnTooltip()
	if IsServer() then
		return self.radius
	else
		return self.clientvalues.radius
	end
end


--------------------------------------------------------------------------------

modifier_vgmar_i_thirst_debuff = class({})

function modifier_vgmar_i_thirst_debuff:GetTexture()
	return "bloodseeker_thirst"
end

function modifier_vgmar_i_thirst_debuff:IsHidden()
    return self:GetStackCount() <= 0
end

function modifier_vgmar_i_thirst_debuff:IsPurgable()
	return false
end

function modifier_vgmar_i_thirst_debuff:RemoveOnDeath()
	return true
end

function modifier_vgmar_i_thirst_debuff:IsDebuff()
	return true
end

function modifier_vgmar_i_thirst_debuff:OnCreated(kv)
	if IsServer() then
		self.threshold = self:GetCaster():FindModifierByName("modifier_vgmar_i_thirst").threshold
		self.visionthreshold = self:GetCaster():FindModifierByName("modifier_vgmar_i_thirst").visionthreshold
		self.visionrange = self:GetCaster():FindModifierByName("modifier_vgmar_i_thirst").visionrange
		self.visionduration = self:GetCaster():FindModifierByName("modifier_vgmar_i_thirst").visionduration
		self.giverealvision = self:GetCaster():FindModifierByName("modifier_vgmar_i_thirst").giverealvision
		self.givemodelvision = self:GetCaster():FindModifierByName("modifier_vgmar_i_thirst").givemodelvision
		self.particle = nil
		self:StartIntervalThink(0.1)
	end
end

function modifier_vgmar_i_thirst_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
    }
    return funcs
end

function modifier_vgmar_i_thirst_debuff:GetModifierProvidesFOWVision()
	if IsServer() then
		if self.givemodelvision == 1 and self:GetParent():IsInvisible() == false then
			if self:GetStackCount() >= self.visionthreshold then
				return 1
			end
		end
		return 0
	end
end

function modifier_vgmar_i_thirst_debuff:OnRemoved()
	if self.particle ~= nil then
		ParticleManager:DestroyParticle(self.particle, false)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
	end
end

function modifier_vgmar_i_thirst_debuff:OnIntervalThink()
	local parent = self:GetParent()
	local caster = self:GetCaster()
	if parent:GetHealth()/parent:GetMaxHealth() <= self.threshold then
		local stacks = (self.threshold - parent:GetHealth()/parent:GetMaxHealth()) * 100
		self:SetStackCount(stacks)
	else
		if self:GetStackCount() > 0 then
			self:SetStackCount(0)
		end
	end
	if self:GetStackCount() > 0 then
		if parent:IsInvisible() == false then
			if parent:GetHealth()/parent:GetMaxHealth() <= self.visionthreshold and self.giverealvision == 1 then
				AddFOWViewer(caster:GetTeam(), parent:GetAbsOrigin(), self.visionrange, self.visionduration, false)
			end
			if self.particle == nil then
				self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_bloodseeker/bloodseeker_vision.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			end
		end
	else
		if self.particle ~= nil then
			ParticleManager:DestroyParticle(self.particle, false)
			ParticleManager:ReleaseParticleIndex(self.particle)
			self.particle = nil
		end
	end
end