--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_vampiric_aura = class({})

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function modifier_vgmar_i_vampiric_aura:IsHidden()
    return true
end

function modifier_vgmar_i_vampiric_aura:IsPurgable()
	return false
end

function modifier_vgmar_i_vampiric_aura:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_vampiric_aura:IsPermanent()
	return true
end

function modifier_vgmar_i_vampiric_aura:IsAura() return true end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_vampiric_aura:GetModifierAura()  return "modifier_vgmar_i_vampiric_aura_effect" end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_vampiric_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_vampiric_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_vampiric_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_vampiric_aura:GetAuraRadius() return self.radius end

function modifier_vgmar_i_vampiric_aura:OnCreated(kv) 
	if IsServer() then
		self.radius = kv.radius or 0
		self.lspercent = kv.lspercent
		self.lspercentranged = kv.lspercentranged
	end
end
--------------------------------------------------------------------------------