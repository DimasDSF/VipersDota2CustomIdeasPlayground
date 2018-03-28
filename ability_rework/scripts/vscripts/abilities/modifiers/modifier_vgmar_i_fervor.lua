--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_fervor = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_fervor:GetTexture()
	return "troll_warlord_fervor"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_fervor:IsHidden()
    return ( self:GetStackCount() == 0 )
end

function modifier_vgmar_i_fervor:IsDebuff()
	return false
end

function modifier_vgmar_i_fervor:IsPurgable()
	return false
end

function modifier_vgmar_i_fervor:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_fervor:OnCreated( kv )
	if IsServer() then
		self.maxstacks = kv.maxstacks
		self.asperstack = kv.asperstack
		self.lasttar = nil
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_fervor")
	end
end

function modifier_vgmar_i_fervor:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_fervor:OnTooltip()
	return self.clientvalues.asperstack * self:GetStackCount()
end

function modifier_vgmar_i_fervor:OnAttack( event )
	if IsServer() then
		if event.attacker == self:GetCaster() then
			if self:GetParent():HasModifier("modifier_vgmar_util_multishot_active") == false then
				if event.target == self.lasttar then
					if self:GetStackCount() + 1 <= self.maxstacks then
						self:SetStackCount(self:GetStackCount() + 1)
					end
				else
					self.lasttar = event.target
					self:SetStackCount(1)
				end
			end
		end
	end
end

function modifier_vgmar_i_fervor:GetModifierAttackSpeedBonus_Constant()
	if IsServer() then
		return self.asperstack * self:GetStackCount()
	else
		return self.clientvalues.asperstack * self:GetStackCount()
	end
end

--------------------------------------------------------------------------------