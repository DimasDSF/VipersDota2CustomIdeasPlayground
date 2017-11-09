--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_truesight = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_truesight:GetTexture()
	return "custom/gem_of_true_sight"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_truesight:IsHidden()
    return false
end

function modifier_vgmar_i_truesight:IsPurgable()
	return false
end

function modifier_vgmar_i_truesight:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_truesight:IsAura() return true end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_truesight:GetModifierAura()  return "modifier_truesight" end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_truesight:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_truesight:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_truesight:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_truesight:GetAuraRadius() return self.radius end

function modifier_vgmar_i_truesight:OnCreated(kv) 
	self.radius = kv.radius or 0
end

--------------------------------------------------------------------------------