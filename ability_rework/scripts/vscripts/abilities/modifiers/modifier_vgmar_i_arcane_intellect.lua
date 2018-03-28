--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_arcane_intellect = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_arcane_intellect:GetTexture()
	return "custom/arcaneintellect"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_arcane_intellect:IsHidden()
    return false
end

function modifier_vgmar_i_arcane_intellect:IsPurgable()
	return false
end

function modifier_vgmar_i_arcane_intellect:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_arcane_intellect:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_arcane_intellect:OnCreated(kv) 
	if IsServer() then
		self.percentage = kv.percentage
		self.multpercast = kv.multpercast
		self.bonusint = kv.bonusint
		self.caststacks = 0
		self:StartIntervalThink( 0.5 )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_arcane_intellect")
	end
end

function modifier_vgmar_i_arcane_intellect:OnIntervalThink()
	self:SetStackCount( math.floor(((self.percentage/100) * self:GetParent():GetIntellect()) + math.floor(self.caststacks)) )
end

function modifier_vgmar_i_arcane_intellect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_arcane_intellect:OnTooltip()
	return 1/self.clientvalues.multpercast
end

function modifier_vgmar_i_arcane_intellect:GetModifierBonusStats_Intellect()
	if IsServer() then
		return self.bonusint
	else
		return self.clientvalues.bonusint
	end
end

function modifier_vgmar_i_arcane_intellect:OnAbilityFullyCast( kv )
	if IsServer() then
		if kv.unit == self:GetParent() then
			if kv.ability and kv.ability:IsToggle() == false and kv.ability:IsItem() == false and (GameRules.VGMAR.arcaneintignoredabilities[kv.ability:GetName()] == nil or GameRules.VGMAR.arcaneintignoredabilities[kv.ability:GetName()] ~= true) then
				if kv.ability:GetCooldown(kv.ability:GetLevel()) > 3 or GameRules.VGMAR.arcaneintignoredabilities[kv.ability:GetName()] == false then
					self.caststacks = self.caststacks + self.multpercast
				end
			end
		end
	end
end

function modifier_vgmar_i_arcane_intellect:GetModifierSpellAmplify_Percentage()
	return self:GetStackCount()
end


--------------------------------------------------------------------------------