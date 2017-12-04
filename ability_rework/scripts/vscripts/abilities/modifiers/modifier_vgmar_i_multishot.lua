--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_multishot = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_multishot:GetTexture()
	return "medusa_split_shot"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_multishot:IsHidden()
    return false
end

function modifier_vgmar_i_multishot:IsDebuff()
	return false
end

function modifier_vgmar_i_multishot:IsPurgable()
	return false
end

function modifier_vgmar_i_multishot:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_multishot:DestroyOnExpire()
	return false
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_multishot:OnCreated( kv )
	if IsServer() then
		self.stackscap = kv.stackscap
		self.shotspercap = kv.shotspercap
		self.attackduration = kv.attackduration
		self.bonusrange = kv.bonusrange
		self:SetDuration( -1, true )
		self.enemies = {}
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_multishot")
	end
end

function modifier_vgmar_i_multishot:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_multishot:OnTooltip()
	return self.clientvalues.shotspercap
end

function modifier_vgmar_i_multishot:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() == true then
		if IsServer() then
			return self.bonusrange
		else
			return self.clientvalues.bonusrange
		end
	end
end

function modifier_vgmar_i_multishot:OnAttack( event )
	if IsServer() then
		if event.attacker == self:GetParent() and self:GetParent():IsRangedAttacker() == true then
			if event.attacker:GetTeamNumber() ~= event.target:GetTeamNumber() then
				if self:GetParent():FindModifierByName("modifier_vgmar_i_multishot_attack") == nil then
					self:SetStackCount(self:GetStackCount() + 1)
				end
				if self:GetStackCount() >= self.stackscap and self:GetParent():FindModifierByName("modifier_vgmar_i_multishot_attack") == nil then
					self.enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():GetAttackRange() + 400, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
					self:SetStackCount( 0 )
					self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_multishot_attack", {})
				end
			end
		end
	end
end

--------------------------------------------------------------------------------