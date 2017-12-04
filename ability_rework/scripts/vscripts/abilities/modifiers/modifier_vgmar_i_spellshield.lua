--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_spellshield = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_spellshield:GetTexture()
	return "antimage_spell_shield"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_spellshield:IsHidden()
    return false
end

function modifier_vgmar_i_spellshield:IsDebuff()
	return false
end

function modifier_vgmar_i_spellshield:IsPurgable()
	return false
end

function modifier_vgmar_i_spellshield:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_spellshield:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_spellshield:IsPermanent()
	return true
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_spellshield:OnCreated( kv )
	if IsServer() then
		self.cooldown = kv.cooldown
		self.maxstacks = kv.maxstacks
		self.resistance = kv.resistance
		self:SetStackCount( 0 )
		self:SetDuration( self.cooldown, true )
		self:StartIntervalThink( 0.25 )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_spellshield")
	end
end

function modifier_vgmar_i_spellshield:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_spellshield:GetModifierMagicalResistanceBonus()
	if IsServer() then
		return self.resistance
	else
		return self.clientvalues.resistance
	end
end

function modifier_vgmar_i_spellshield:OnAbilityFullyCast( event )
	if IsServer() then
		if event.unit == self:GetCaster() then
			local hAbility = event.ability
			if hAbility ~= nil then
				if hAbility:GetName() == "item_refresher" or hAbility:GetName() == "item_refresher_shard" then
					self:SetStackCount( 2 )
					self:SetDuration( 0, true)
				end
			end
		end
	end
end

function modifier_vgmar_i_spellshield:OnTooltip()
	return self.clientvalues.cooldown
end

function modifier_vgmar_i_spellshield:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		if self:GetRemainingTime() <= 0 and self:GetStackCount() < self.maxstacks then
			if self:GetStackCount() + 1 < self.maxstacks then
				self:SetDuration( self.cooldown, true )
			end
			self:SetStackCount( self:GetStackCount() + 1 )
		end
		
		if self:GetStackCount() >= 1 then
			if not parent:HasModifier("modifier_vgmar_i_spellshield_active") then
				parent:AddNewModifier(parent, nil, "modifier_vgmar_i_spellshield_active", {})
			end
		end
	end
end

--------------------------------------------------------------------------------