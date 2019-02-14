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
		self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_buff", {increaseprimary = self.increaseprimary, increasesecondary = self.increasesecondary, hitsperstackinc = self.hitsperstackinc, duration = self.duration})
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
		if event.attacker == self:GetParent() and not self:GetParent():IsIllusion() and self:GetParent():PassivesDisabled() == false then
			if event.target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and event.target:IsRealHero() and event.target:IsAlive() then
				--[[if self:GetParent():GetPrimaryAttribute() == 0 then
					event.target:AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_target_str", {})
					self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_owner_str", {increaseprimary = self.increaseprimary, increasesecondary = self.increasesecondary, hitsperstackinc = self.hitsperstackinc, duration = self.duration})
				elseif self:GetParent():GetPrimaryAttribute() == 1 then
					event.target:AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_target_agi", {})
					self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_owner_agi", {increaseprimary = self.increaseprimary, increasesecondary = self.increasesecondary, hitsperstackinc = self.hitsperstackinc, duration = self.duration})
				else
					event.target:AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_target_int", {})
					self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_owner_int", {increaseprimary = self.increaseprimary, increasesecondary = self.increasesecondary, hitsperstackinc = self.hitsperstackinc, duration = self.duration})
				end--]]
				event.target:AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_debuff", {})
				self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_essence_shift_buff", {increaseprimary = self.increaseprimary, increasesecondary = self.increasesecondary, hitsperstackinc = self.hitsperstackinc, duration = self.duration})
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


modifier_vgmar_i_essence_shift_buff = class({})

function modifier_vgmar_i_essence_shift_buff:GetTexture()
	return "custom/essenceshift_agility"
end

function modifier_vgmar_i_essence_shift_buff:IsHidden()
	return self:GetStackCount() == 0
end

function modifier_vgmar_i_essence_shift_buff:IsPurgable()
	return false
end

function modifier_vgmar_i_essence_shift_buff:IsDebuff()
	return false
end

function modifier_vgmar_i_essence_shift_buff:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_essence_shift_buff:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_essence_shift_buff:OnCreated(kv)
	if IsServer() then
		self.increaseprimary = kv.increaseprimary
		self.increasesecondary = kv.increasesecondary
		self.hitsperstackinc = kv.hitsperstackinc
		self.duration = kv.duration
		self.hittable = {}
		self:SetStackCount( math.floor(#self.hittable / self.hitsperstackinc) )
		self:SetDuration( -1, true )
		self:StartIntervalThink( 1 )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_essence_shift")
	end
end

function modifier_vgmar_i_essence_shift_buff:OnRefresh(kv)
	if IsServer() then
		table.insert(self.hittable, 1, GameRules:GetGameTime())
	end
end

function modifier_vgmar_i_essence_shift_buff:OnIntervalThink()
	if IsServer() then
		if #self.hittable > 0 then
			--Removing Expired Hit Records
			local startcount = #self.hittable
			for i=#self.hittable, 1, -1 do
				if self.hittable[i] + self.duration > GameRules:GetGameTime() then
					break
				else
					table.remove(self.hittable, i)
				end
			end
			self:SetStackCount(math.floor(#self.hittable/self.hitsperstackinc))
			
			local dur = -1
			if self.hittable[#self.hittable] ~= nil then
				dur = (self.hittable[#self.hittable] + self.duration - GameRules:GetGameTime())
			end
			if startcount ~= #self.hittable then
				self:SetDuration( dur, true )
			end
			self:StartIntervalThink( 0.2 )
		else
			self:StartIntervalThink( 1 )
		end
	end
	self:GetParent():CalculateStatBonus()
end

function modifier_vgmar_i_essence_shift_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
    }
    return funcs
end

function modifier_vgmar_i_essence_shift_buff:GetModifierBonusStats_Strength()
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute() == 0 then
			return self.increaseprimary * self:GetStackCount()
		else
			return self.increasesecondary * self:GetStackCount()
		end
	end
end

function modifier_vgmar_i_essence_shift_buff:GetModifierBonusStats_Agility()
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute() == 1 then
			return self.increaseprimary * self:GetStackCount()
		else
			return self.increasesecondary * self:GetStackCount()
		end
	end
end

function modifier_vgmar_i_essence_shift_buff:GetModifierBonusStats_Intellect()
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute() == 2 then
			return self.increaseprimary * self:GetStackCount()
		else
			return self.increasesecondary * self:GetStackCount()
		end
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_i_essence_shift_debuff = class({})

function modifier_vgmar_i_essence_shift_debuff:GetTexture()
	return "custom/essenceshift_strength"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_essence_shift_debuff:IsHidden()
    return false
end

function modifier_vgmar_i_essence_shift_debuff:IsPurgable()
	return false
end

function modifier_vgmar_i_essence_shift_debuff:IsDebuff()
	return true
end

function modifier_vgmar_i_essence_shift_debuff:RemoveOnDeath()
	return true
end

function modifier_vgmar_i_essence_shift_debuff:DestroyOnExpire()
	return true
end

function modifier_vgmar_i_essence_shift_debuff:OnCreated(kv) 
	if IsServer() then
		local provider = self:GetCaster()
		local essenceshift = provider:FindModifierByName("modifier_vgmar_i_essence_shift")
		self.reductionprimary = essenceshift.reductionprimary
		self.reductionsecondary = essenceshift.reductionsecondary
		self.hitsperstackred = essenceshift.hitsperstackred
		self.hittable = {}
		self:SetStackCount( math.floor(#self.hittable / self.hitsperstackred) )
		self.durationtarget = essenceshift.durationtarget
		self:SetDuration( self.durationtarget, true )
		self:StartIntervalThink( 0.2 )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_essence_shift")
	end
end

function modifier_vgmar_i_essence_shift_debuff:OnRefresh(kv)
	if IsServer() then
		table.insert(self.hittable, 1, GameRules:GetGameTime())
	end
end

function modifier_vgmar_i_essence_shift_debuff:OnIntervalThink()
	if IsServer() then
		if #self.hittable > 0 then
			--Removing Expired Hit Records
			local startcount = #self.hittable
			for i=#self.hittable, 1, -1 do
				if self.hittable[i] + self.durationtarget > GameRules:GetGameTime() then
					break
				else
					table.remove(self.hittable, i)
				end
			end
			if #self.hittable < 1 then
				self:Destroy()
			end
			self:SetStackCount(math.floor(#self.hittable/self.hitsperstackred))
			
			if startcount ~= #self.hittable then
				self:SetDuration( (self.hittable[#self.hittable] + self.durationtarget - GameRules:GetGameTime()), true )
			end
		end
	end
	self:GetParent():CalculateStatBonus()
end

function modifier_vgmar_i_essence_shift_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
    }
    return funcs
end

function modifier_vgmar_i_essence_shift_debuff:GetModifierBonusStats_Strength()
	if IsServer() then
		if self:GetCaster():GetPrimaryAttribute() == 0 then
			return -self.reductionprimary * self:GetStackCount()
		else
			return -self.reductionsecondary * self:GetStackCount()
		end
	end
end

function modifier_vgmar_i_essence_shift_debuff:GetModifierBonusStats_Agility()
	if IsServer() then
		if self:GetCaster():GetPrimaryAttribute() == 1 then
			return -self.reductionprimary * self:GetStackCount()
		else
			return -self.reductionsecondary * self:GetStackCount()
		end
	end
end

function modifier_vgmar_i_essence_shift_debuff:GetModifierBonusStats_Intellect()
	if IsServer() then
		if self:GetCaster():GetPrimaryAttribute() == 2 then
			return -self.reductionprimary * self:GetStackCount()
		else
			return -self.reductionsecondary * self:GetStackCount()
		end
	end
end

---------------------------------------------------------------------------
---------------------------------------------------------------------------