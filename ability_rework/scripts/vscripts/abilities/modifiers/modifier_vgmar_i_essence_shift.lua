--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_essence_shift = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_essence_shift:GetTexture()
	return "custom/essenceshift"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_essence_shift:IsHidden()
    return false
end

function modifier_vgmar_i_essence_shift:IsPurgable()
	return false
end

function modifier_vgmar_i_essence_shift:IsDebuff()
	return false
end

function modifier_vgmar_i_essence_shift:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_essence_shift:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_essence_shift:OnCreated(kv) 
	if IsServer() then		
		self.reductionprimary = kv.reductionprimary
		self.reductionsecondary = kv.reductionsecondary
		self.increaseprimary = kv.increaseprimary
		self.increasesecondary = kv.increasesecondary
		self.hitsperstackinc = kv.hitsperstackinc
		self.hitsperstackred = kv.hitsperstackred
		self.duration = kv.duration
		self.durationtarget = kv.durationtarget
		self.hitcount = 0
		self:SetStackCount( math.floor(self.hitcount / self.hitsperstackinc) )
		self:SetDuration( -1, true )
		self:StartIntervalThink( 1 )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_essence_shift")
	end
end

function modifier_vgmar_i_essence_shift:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_vgmar_i_essence_shift:GetModifierBonusStats_Agility()
	if self:GetCaster():IsRealHero() then
		if self:GetCaster():GetPrimaryAttribute() == 1 then
			if IsServer() then
				return self.increaseprimary * self:GetStackCount()
			else
				return self.clientvalues.increaseprimary * self:GetStackCount()
			end
		else
			if IsServer() then
				return self.increasesecondary * self:GetStackCount()
			else
				return self.clientvalues.increasesecondary * self:GetStackCount()
			end
		end
	end
end

function modifier_vgmar_i_essence_shift:GetModifierBonusStats_Intellect()
	if self:GetCaster():IsRealHero() then
		if self:GetCaster():GetPrimaryAttribute() == 2 then
			if IsServer() then
				return self.increaseprimary * self:GetStackCount()
			else
				return self.clientvalues.increaseprimary * self:GetStackCount()
			end
		else
			if IsServer() then
				return self.increasesecondary * self:GetStackCount()
			else
				return self.clientvalues.increasesecondary * self:GetStackCount()
			end
		end
	end
end

function modifier_vgmar_i_essence_shift:GetModifierBonusStats_Strength()
	if self:GetCaster():IsRealHero() then
		if self:GetCaster():GetPrimaryAttribute() == 0 then
			if IsServer() then
				return self.increaseprimary * self:GetStackCount()
			else
				return self.clientvalues.increaseprimary * self:GetStackCount()
			end
		else
			if IsServer() then
				return self.increasesecondary * self:GetStackCount()
			else
				return self.clientvalues.increasesecondary * self:GetStackCount()
			end
		end
	end
end

function modifier_vgmar_i_essence_shift:OnAttackLanded( event )
	if IsServer() then
		if event.attacker == self:GetParent() and not self:GetParent():IsIllusion() then
			if event.target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and event.target:IsRealHero() then
				if self:GetParent():GetPrimaryAttribute() == 0 then
					event.target:AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_target_str", {})
				elseif self:GetParent():GetPrimaryAttribute() == 1 then
					event.target:AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_target_agi", {})
				else
					event.target:AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_target_int", {})
				end
				local particle_drain_fx = ParticleManager:CreateParticle("particles/econ/items/slark/slark_ti6_blade/slark_ti6_blade_essence_shift.vpcf", PATTACH_ABSORIGIN, event.target)
				ParticleManager:SetParticleControl(particle_drain_fx, 0, event.target:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_drain_fx, 1, self:GetParent():GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_drain_fx, 2, self:GetParent():GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_drain_fx, 3, self:GetParent():GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_drain_fx)
				self.hitcount = self.hitcount + 1
				self:SetStackCount( math.floor(self.hitcount / self.hitsperstackinc) )
				self:SetDuration( self.duration, true )
			end
		end
	end
end

function modifier_vgmar_i_essence_shift:OnIntervalThink()
	if IsServer() then
		if self:GetRemainingTime() < 1 then
			self:SetDuration( -1, true )
			self.hitcount = 0
			self:SetStackCount( 0 )
		end
	end
end

--------------------------------------------------------------------------------