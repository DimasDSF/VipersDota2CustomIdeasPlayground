--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_kingsaegis_cooldown = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_kingsaegis_cooldown:GetTexture()
	return "skeleton_king_reincarnation"
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

function modifier_vgmar_i_kingsaegis_cooldown:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_kingsaegis_cooldown:OnCreated( kv )
	self.cooldown = 0
	if IsServer() then
		self:StartIntervalThink( 0.5 )
	end
end

function modifier_vgmar_i_kingsaegis_cooldown:OnIntervalThink()
	local parent = self:GetCaster()
	local ability = parent:FindAbilityByName("aegis_king_reincarnation")
	self.cooldown = ability:GetCooldownTime()
	if IsServer() then
		if self.cooldown == 0 then
			if not parent:HasModifier("modifier_vgmar_i_kingsaegis_active") then
				parent:AddNewModifier(parent, nil, "modifier_vgmar_i_kingsaegis_active", {})
			end
		elseif self.cooldown ~= 0 then
			if parent:HasModifier("modifier_vgmar_i_kingsaegis_active") then
				parent:RemoveModifierByName("modifier_vgmar_i_kingsaegis_active")
			end
		end
		self:StartIntervalThink( 0.5 )
		self:SetStackCount( self.cooldown )
	end
end

--------------------------------------------------------------------------------