--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_kingsaegis_cooldown = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_kingsaegis_cooldown:GetTexture()
	return "custom/kingsaegisreincarnation"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_kingsaegis_cooldown:IsHidden()
    return false
end

function modifier_vgmar_i_kingsaegis_cooldown:IsDebuff()
	return false
end

function modifier_vgmar_i_kingsaegis_cooldown:IsPurgable()
	return false
end

function modifier_vgmar_i_kingsaegis_cooldown:IsPermanent()
	return true
end

function modifier_vgmar_i_kingsaegis_cooldown:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_kingsaegis_cooldown:OnCreated( kv )
	if IsServer() then
		self.cooldown = kv.cooldown
		self.reincarnate_time = kv.reincarnate_time
		self:SetStackCount( 0 )
		self:StartIntervalThink( 1 )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_kingsaegis_cooldown")
	end
end

function modifier_vgmar_i_kingsaegis_cooldown:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_kingsaegis_cooldown:OnAbilityFullyCast( event )
	if IsServer() then
		if event.unit == self:GetCaster() then
			local hAbility = event.ability
			if hAbility ~= nil then
				if hAbility:GetName() == "item_refresher" or hAbility:GetName() == "item_refresher_shard" then
					self:SetStackCount( 0 )
				end
			end
		end
	end
end

function modifier_vgmar_i_kingsaegis_cooldown:OnTooltip()
	return self.clientvalues.cooldown
end

function modifier_vgmar_i_kingsaegis_cooldown:OnIntervalThink()
	local parent = self:GetParent()
	if IsServer() then
		if self:GetStackCount() == 0 then
			if not parent:HasModifier("modifier_vgmar_i_kingsaegis_active") then
				parent:AddNewModifier(parent, nil, "modifier_vgmar_i_kingsaegis_active", {})
			end
		elseif self:GetStackCount() ~= 0 then
			if parent:HasModifier("modifier_vgmar_i_kingsaegis_active") then
				parent:RemoveModifierByName("modifier_vgmar_i_kingsaegis_active")
			end
		end
		if self:GetStackCount() > 0 then
			if self:GetStackCount() - 1 >= 0 then
				self:SetStackCount( self:GetStackCount() - 1 )
			end
		end
	end
end

--------------------------------------------------------------------------------