--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_spellshield_cooldown = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_spellshield_cooldown:GetTexture()
	return "antimage_spell_shield"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_spellshield_cooldown:IsHidden()
    return false
end

function modifier_vgmar_i_spellshield_cooldown:IsDebuff()
	return false
end

function modifier_vgmar_i_spellshield_cooldown:IsPurgable()
	return false
end

function modifier_vgmar_i_spellshield_cooldown:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_spellshield_cooldown:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 0.5 )
	end
end

function modifier_vgmar_i_spellshield_cooldown:OnIntervalThink()
	local parent = self:GetCaster()
	local ability = parent:FindAbilityByName("vgmar_i_spellshield")
	local cooldown = ability:GetCooldownTime()
	if IsServer() then
		--self:StartIntervalThink( 0.5 )
		self:SetStackCount( cooldown )
	end
end

--------------------------------------------------------------------------------