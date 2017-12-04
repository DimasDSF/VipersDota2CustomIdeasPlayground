--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_attackrange = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_attackrange:GetTexture()
	return "custom/items/dragon_lance"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_attackrange:IsHidden()
    return false
end

function modifier_vgmar_i_attackrange:IsPurgable()
	return false
end

function modifier_vgmar_i_attackrange:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_attackrange:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_attackrange:AllowIllusionDuplicate()
	return true
end

function modifier_vgmar_i_attackrange:OnCreated(kv) 
	if IsServer() then
		self.range = kv.range
		self.bonusstr = kv.bonusstr
		self.bonusagi = kv.bonusagi
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_attackrange")
	end
end

function modifier_vgmar_i_attackrange:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
    }
    return funcs
end

function modifier_vgmar_i_attackrange:GetModifierBonusStats_Strength()
	if IsServer() then
		return self.bonusstr
	else
		return self.clientvalues.bonusstr
	end
end

function modifier_vgmar_i_attackrange:GetModifierBonusStats_Agility()
	if IsServer() then
		return self.bonusagi
	else
		return self.clientvalues.bonusagi
	end
end

function modifier_vgmar_i_attackrange:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() == true then
		if IsServer() then
			return self.range
		else
			return self.clientvalues.range
		end
	end
end

--------------------------------------------------------------------------------