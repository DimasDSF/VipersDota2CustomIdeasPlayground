--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_essence_shift_target_int = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_essence_shift_target_int:GetTexture()
	return "custom/essenceshift_intellect"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_essence_shift_target_int:IsHidden()
    return false
end

function modifier_vgmar_i_essence_shift_target_int:IsPurgable()
	return false
end

function modifier_vgmar_i_essence_shift_target_int:IsDebuff()
	return true
end

function modifier_vgmar_i_essence_shift_target_int:RemoveOnDeath()
	return true
end

function modifier_vgmar_i_essence_shift_target_int:DestroyOnExpire()
	return true
end

function modifier_vgmar_i_essence_shift_target_int:OnCreated(kv) 
	if IsServer() then
		local provider = self:GetCaster()
		local essenceshift = provider:FindModifierByName("modifier_vgmar_i_essence_shift")
		self.reductionprimary = essenceshift.reductionprimary
		self.reductionsecondary = essenceshift.reductionsecondary
		self.hitsperstackred = essenceshift.hitsperstackred
		self.hitcount = 1
		self.durationtarget = essenceshift.durationtarget
		self:SetStackCount( math.floor(self.hitcount / self.hitsperstackred) )
		self:SetDuration( self.durationtarget, true )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_essence_shift")
	end
end

function modifier_vgmar_i_essence_shift_target_int:OnRefresh(kv)
	if IsServer() then
		self.hitcount = self.hitcount + 1
		self:SetStackCount( math.floor(self.hitcount / self.hitsperstackred) )
		self:SetDuration( self.durationtarget, true )
	end
end

function modifier_vgmar_i_essence_shift_target_int:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
    }
    return funcs
end

function modifier_vgmar_i_essence_shift_target_int:GetModifierBonusStats_Agility()
	if self:GetCaster():IsRealHero() then
		if IsServer() then
			return self.reductionsecondary * self:GetStackCount() * -1
		else
			return self.clientvalues.reductionsecondary * self:GetStackCount() * -1
		end
	end
end

function modifier_vgmar_i_essence_shift_target_int:GetModifierBonusStats_Intellect()
	if self:GetCaster():IsRealHero() then
		if IsServer() then
			return self.reductionprimary * self:GetStackCount() * -1
		else
			return self.clientvalues.reductionprimary * self:GetStackCount() * -1
		end
	end
end

function modifier_vgmar_i_essence_shift_target_int:GetModifierBonusStats_Strength()
	if self:GetCaster():IsRealHero() then
		if IsServer() then
			return self.reductionsecondary * self:GetStackCount() * -1
		else
			return self.clientvalues.reductionsecondary * self:GetStackCount() * -1
		end
	end
end
--------------------------------------------------------------------------------