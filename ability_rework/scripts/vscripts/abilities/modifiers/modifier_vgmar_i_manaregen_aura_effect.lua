--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_manaregen_aura_effect = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_manaregen_aura_effect:GetTexture()
	return "custom/manaregenaura"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_manaregen_aura_effect:IsHidden()
    return false
end

function modifier_vgmar_i_manaregen_aura_effect:IsPurgable()
	return false
end

function modifier_vgmar_i_manaregen_aura_effect:RemoveOnDeath()
	return true
end

function modifier_vgmar_i_manaregen_aura_effect:OnCreated(kv) 
	if IsServer() then
		local provider = self:GetCaster()
		local aura = provider:FindModifierByName("modifier_vgmar_i_manaregen_aura")
		self.regenself = aura.regenself
		self.regenallies = aura.regenallies
		self.bonusmanaself = aura.bonusmanaself
		self.bonusmanaallies = aura.bonusmanaallies
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_manaregen_aura")
	end
end

function modifier_vgmar_i_manaregen_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
    }
    return funcs
end


function modifier_vgmar_i_manaregen_aura_effect:GetModifierConstantManaRegen()
	if not IsServer() then
		if self:GetParent() == self:GetCaster() then
			return self.clientvalues.regenself
		else
			return self.clientvalues.regenallies
		end
	else
		if self:GetParent() == self:GetCaster() then
			return self.regenself
		else
			return self.regenallies
		end
	end
end

function modifier_vgmar_i_manaregen_aura_effect:GetModifierManaBonus()
	if IsServer() then
		if self:GetParent() == self:GetCaster() then
			return self.bonusmanaself
		else
			return self.bonusmanaallies
		end
	end
end
--------------------------------------------------------------------------------