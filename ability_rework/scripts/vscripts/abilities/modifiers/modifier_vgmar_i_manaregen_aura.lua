--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_manaregen_aura = class({})

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function modifier_vgmar_i_manaregen_aura:IsHidden()
    return true
end

function modifier_vgmar_i_manaregen_aura:IsPurgable()
	return false
end

function modifier_vgmar_i_manaregen_aura:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_manaregen_aura:IsAura() return true end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_manaregen_aura:GetModifierAura()  return "modifier_vgmar_i_manaregen_aura_effect" end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_manaregen_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_manaregen_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_manaregen_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_manaregen_aura:GetAuraRadius() return self.radius end

function modifier_vgmar_i_manaregen_aura:OnCreated(kv) 
	self.radius = kv.radius or 0
	self.bonusmanaself = kv.bonusmanaself
	self.bonusmanaallies = kv.bonusmanaallies
	self.regenself = kv.regenself
	self.regenallies = kv.regenallies
end
--------------------------------------------------------------------------------