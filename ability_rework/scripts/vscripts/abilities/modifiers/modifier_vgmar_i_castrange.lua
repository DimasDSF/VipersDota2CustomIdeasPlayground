--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_castrange = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_castrange:GetTexture()
	return "custom/items/aether_lens"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_castrange:IsHidden()
    return false
end

function modifier_vgmar_i_castrange:IsPurgable()
	return false
end

function modifier_vgmar_i_castrange:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_castrange:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_castrange:OnCreated(kv) 
	if IsServer() then
		self.range = kv.range
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_castrange")
	end
end

function modifier_vgmar_i_castrange:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
    }
    return funcs
end

function modifier_vgmar_i_castrange:GetModifierManaBonus()
	if IsServer() then
		return self.bonusmana
	else
		return self.clientvalues.bonusmana
	end
end

function modifier_vgmar_i_castrange:GetModifierConstantManaRegen()
	if IsServer() then
		return self.manaregen
	else
		return self.clientvalues.manaregen
	end
end

function modifier_vgmar_i_castrange:GetModifierCastRangeBonusStacking()
	if IsServer() then
		return self.range
	else
		return self.clientvalues.range
	end
end

--------------------------------------------------------------------------------