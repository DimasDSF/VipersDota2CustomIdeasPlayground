--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_spellamp = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_spellamp:GetTexture()
	return "custom/items/trident"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_spellamp:IsHidden()
    return false
end

function modifier_vgmar_i_spellamp:IsPurgable()
	return false
end

function modifier_vgmar_i_spellamp:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_spellamp:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_spellamp:OnCreated(kv) 
	if IsServer() then
		self.percentage = kv.percentage
		self.costpercentage = kv.costpercentage
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_spellamp")
	end
end

function modifier_vgmar_i_spellamp:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }
    return funcs
end

function modifier_vgmar_i_spellamp:GetModifierBonusStats_Intellect()
	if IsServer() then
		return self.bonusint
	else
		return self.clientvalues.bonusint
	end
end

function modifier_vgmar_i_spellamp:GetModifierPercentageManacost()
	if not IsServer() then
		return self.clientvalues.costpercentage
	else
		return self.costpercentage
	end
end

function modifier_vgmar_i_spellamp:GetModifierSpellAmplify_Percentage()
	if not IsServer() then
		return self.clientvalues.percentage
	else
		return self.percentage
	end
end


--------------------------------------------------------------------------------