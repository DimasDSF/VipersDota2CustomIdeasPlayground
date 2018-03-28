--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_essence_shift = class({})

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function modifier_vgmar_i_essence_shift:IsHidden()
    return true
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
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_essence_shift")
	end
end

function modifier_vgmar_i_essence_shift:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_vgmar_i_essence_shift:OnAttackLanded( event )
	if IsServer() then
		if event.attacker == self:GetParent() and not self:GetParent():IsIllusion() then
			if event.target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and event.target:IsRealHero() then
				if self:GetParent():GetPrimaryAttribute() == 0 then
					event.target:AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_target_str", {})
					self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_owner_str", {increaseprimary = self.increaseprimary, increasesecondary = self.increasesecondary, hitsperstackinc = self.hitsperstackinc, duration = self.duration})
				elseif self:GetParent():GetPrimaryAttribute() == 1 then
					event.target:AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_target_agi", {})
					self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_owner_agi", {increaseprimary = self.increaseprimary, increasesecondary = self.increasesecondary, hitsperstackinc = self.hitsperstackinc, duration = self.duration})
				else
					event.target:AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_target_int", {})
					self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_owner_int", {increaseprimary = self.increaseprimary, increasesecondary = self.increasesecondary, hitsperstackinc = self.hitsperstackinc, duration = self.duration})
				end
				local particle_drain_fx = ParticleManager:CreateParticle("particles/econ/items/slark/slark_ti6_blade/slark_ti6_blade_essence_shift.vpcf", PATTACH_ABSORIGIN, event.target)
				ParticleManager:SetParticleControl(particle_drain_fx, 0, event.target:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_drain_fx, 1, self:GetParent():GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_drain_fx, 2, self:GetParent():GetAbsOrigin())
				ParticleManager:SetParticleControl(particle_drain_fx, 3, self:GetParent():GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle_drain_fx)
			end
		end
	end
end

--------------------------------------------------------------------------------
modifier_vgmar_i_essence_shift_owner_str = class({})

function modifier_vgmar_i_essence_shift_owner_str:GetTexture()
	return "custom/essenceshift"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_essence_shift_owner_str:IsHidden()
    return self:GetStackCount() == 0
end

function modifier_vgmar_i_essence_shift_owner_str:IsPurgable()
	return false
end

function modifier_vgmar_i_essence_shift_owner_str:IsDebuff()
	return false
end

function modifier_vgmar_i_essence_shift_owner_str:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_essence_shift_owner_str:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_essence_shift_owner_str:OnCreated(kv) 
	if IsServer() then
		local providerspell = self:GetCaster():FindModifierByName("modifier_vgmar_i_essence_shift")
		self.increaseprimary = kv.increaseprimary
		self.increasesecondary = kv.increasesecondary
		self.hitsperstackinc = kv.hitsperstackinc
		self.duration = kv.duration
		self.hitcount = 0
		self:SetStackCount( math.floor(self.hitcount / self.hitsperstackinc) )
		self:SetDuration( -1, true )
		self:StartIntervalThink( 1 )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_essence_shift")
	end
end

function modifier_vgmar_i_essence_shift_owner_str:OnRefresh(kv)
	if IsServer() then
		self.hitcount = self.hitcount + 1
		self:SetStackCount( math.floor(self.hitcount / self.hitsperstackinc) )
		self:SetDuration( self.duration, true )
	end
end

function modifier_vgmar_i_essence_shift_owner_str:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
    return funcs
end

function modifier_vgmar_i_essence_shift_owner_str:GetModifierBonusStats_Agility()
	if self:GetParent():IsRealHero() then
		if IsServer() then
			return self.increasesecondary * self:GetStackCount()
		else
			return self.clientvalues.increasesecondary * self:GetStackCount()
		end
	end
end

function modifier_vgmar_i_essence_shift_owner_str:GetModifierBonusStats_Intellect()
	if self:GetParent():IsRealHero() then
		if IsServer() then
			return self.increasesecondary * self:GetStackCount()
		else
			return self.clientvalues.increasesecondary * self:GetStackCount()
		end
	end
end

function modifier_vgmar_i_essence_shift_owner_str:GetModifierBonusStats_Strength()
	if self:GetParent():IsRealHero() then
		if IsServer() then
			return self.increaseprimary * self:GetStackCount()
		else
			return self.clientvalues.increaseprimary * self:GetStackCount()
		end
	end
end

function modifier_vgmar_i_essence_shift_owner_str:OnIntervalThink()
	if IsServer() then
		if self:GetRemainingTime() < 1 then
			self:SetDuration( -1, true )
			self.hitcount = 0
			self:SetStackCount( 0 )
		end
	end
end

---------------------------------------------------------------------------

modifier_vgmar_i_essence_shift_owner_agi = class({})

function modifier_vgmar_i_essence_shift_owner_agi:GetTexture()
	return "custom/essenceshift"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_essence_shift_owner_agi:IsHidden()
    return self:GetStackCount() == 0
end

function modifier_vgmar_i_essence_shift_owner_agi:IsPurgable()
	return false
end

function modifier_vgmar_i_essence_shift_owner_agi:IsDebuff()
	return false
end

function modifier_vgmar_i_essence_shift_owner_agi:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_essence_shift_owner_agi:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_essence_shift_owner_agi:OnCreated(kv) 
	if IsServer() then
		local providerspell = self:GetCaster():FindModifierByName("modifier_vgmar_i_essence_shift")
		self.increaseprimary = kv.increaseprimary
		self.increasesecondary = kv.increasesecondary
		self.hitsperstackinc = kv.hitsperstackinc
		self.duration = kv.duration
		self.hitcount = 0
		self:SetStackCount( math.floor(self.hitcount / self.hitsperstackinc) )
		self:SetDuration( -1, true )
		self:StartIntervalThink( 1 )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_essence_shift")
	end
end

function modifier_vgmar_i_essence_shift_owner_agi:OnRefresh(kv)
	if IsServer() then
		self.hitcount = self.hitcount + 1
		self:SetStackCount( math.floor(self.hitcount / self.hitsperstackinc) )
		self:SetDuration( self.duration, true )
	end
end

function modifier_vgmar_i_essence_shift_owner_agi:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
    return funcs
end

function modifier_vgmar_i_essence_shift_owner_agi:GetModifierBonusStats_Agility()
	if self:GetParent():IsRealHero() then
		if IsServer() then
			return self.increaseprimary * self:GetStackCount()
		else
			return self.clientvalues.increaseprimary * self:GetStackCount()
		end
	end
end

function modifier_vgmar_i_essence_shift_owner_agi:GetModifierBonusStats_Intellect()
	if self:GetParent():IsRealHero() then
		if IsServer() then
			return self.increasesecondary * self:GetStackCount()
		else
			return self.clientvalues.increasesecondary * self:GetStackCount()
		end
	end
end

function modifier_vgmar_i_essence_shift_owner_agi:GetModifierBonusStats_Strength()
	if self:GetParent():IsRealHero() then
		if IsServer() then
			return self.increasesecondary * self:GetStackCount()
		else
			return self.clientvalues.increasesecondary * self:GetStackCount()
		end
	end
end

function modifier_vgmar_i_essence_shift_owner_agi:OnIntervalThink()
	if IsServer() then
		if self:GetRemainingTime() < 1 then
			self:SetDuration( -1, true )
			self.hitcount = 0
			self:SetStackCount( 0 )
		end
	end
end

---------------------------------------------------------------------------

modifier_vgmar_i_essence_shift_owner_int = class({})

function modifier_vgmar_i_essence_shift_owner_int:GetTexture()
	return "custom/essenceshift"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_essence_shift_owner_int:IsHidden()
    return self:GetStackCount() == 0
end

function modifier_vgmar_i_essence_shift_owner_int:IsPurgable()
	return false
end

function modifier_vgmar_i_essence_shift_owner_int:IsDebuff()
	return false
end

function modifier_vgmar_i_essence_shift_owner_int:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_essence_shift_owner_int:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_essence_shift_owner_int:OnCreated(kv) 
	if IsServer() then
		local providerspell = self:GetCaster():FindModifierByName("modifier_vgmar_i_essence_shift")
		self.increaseprimary = kv.increaseprimary
		self.increasesecondary = kv.increasesecondary
		self.hitsperstackinc = kv.hitsperstackinc
		self.duration = kv.duration
		self.hitcount = 0
		self:SetStackCount( math.floor(self.hitcount / self.hitsperstackinc) )
		self:SetDuration( -1, true )
		self:StartIntervalThink( 1 )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_essence_shift")
	end
end

function modifier_vgmar_i_essence_shift_owner_int:OnRefresh(kv)
	if IsServer() then
		self.hitcount = self.hitcount + 1
		self:SetStackCount( math.floor(self.hitcount / self.hitsperstackinc) )
		self:SetDuration( self.duration, true )
	end
end

function modifier_vgmar_i_essence_shift_owner_int:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
    return funcs
end

function modifier_vgmar_i_essence_shift_owner_int:GetModifierBonusStats_Agility()
	if self:GetParent():IsRealHero() then
		if IsServer() then
			return self.increasesecondary * self:GetStackCount()
		else
			return self.clientvalues.increasesecondary * self:GetStackCount()
		end
	end
end

function modifier_vgmar_i_essence_shift_owner_int:GetModifierBonusStats_Intellect()
	if self:GetParent():IsRealHero() then
		if IsServer() then
			return self.increaseprimary * self:GetStackCount()
		else
			return self.clientvalues.increaseprimary * self:GetStackCount()
		end
	end
end

function modifier_vgmar_i_essence_shift_owner_int:GetModifierBonusStats_Strength()
	if self:GetParent():IsRealHero() then
		if IsServer() then
			return self.increasesecondary * self:GetStackCount()
		else
			return self.clientvalues.increasesecondary * self:GetStackCount()
		end
	end
end

function modifier_vgmar_i_essence_shift_owner_int:OnIntervalThink()
	if IsServer() then
		if self:GetRemainingTime() < 1 then
			self:SetDuration( -1, true )
			self.hitcount = 0
			self:SetStackCount( 0 )
		end
	end
end

---------------------------------------------------------------------------