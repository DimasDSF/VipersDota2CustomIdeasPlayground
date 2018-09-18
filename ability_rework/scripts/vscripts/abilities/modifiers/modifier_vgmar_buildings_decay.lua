--A modifier used as a visualisation for a custom spell

modifier_vgmar_buildings_decay = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_buildings_decay:GetTexture()
	return "alchemist_acid_spray"
end

--------------------------------------------------------------------------------

function modifier_vgmar_buildings_decay:IsDebuff()
	return true
end

function modifier_vgmar_buildings_decay:IsHidden()
	return false
end

function modifier_vgmar_buildings_decay:IsPurgable()
	return false
end

function modifier_vgmar_buildings_decay:RemoveOnDeath()
	return false
end

function modifier_vgmar_buildings_decay:DestroyOnExpire()
	return true
end

function modifier_vgmar_buildings_decay:OnCreated(kv)
	if IsServer() then
		self.durrange = GameRules.VGMAR.buildingdecaydurrange
		self.dur = math.random(self.durrange[1], self.durrange[2])
		self:GetParent():SetBaseHealthRegen(0.0)
		self.health = self:GetParent():GetHealth()
		self:SetDuration(self.dur, true)
		self:StartIntervalThink(1)
	end
end

function modifier_vgmar_buildings_decay:OnIntervalThink()
	local health = math.mapl(self:GetRemainingTime()/self:GetDuration(), 0.01, 1, 1, self.health)
	self:GetParent():EmitSound("Hero_Alchemist.AcidSpray.Damage")
	self:GetParent():SetHealth(math.ceil(health))
end

function modifier_vgmar_buildings_decay:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_vgmar_buildings_decay:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

function modifier_vgmar_buildings_decay:OnRemoved()
	if IsServer() then
		if self:GetParent():IsAlive() then
			self:GetParent():ForceKill(false)
		end
	end
end

--------------------------------------------------------------------------------