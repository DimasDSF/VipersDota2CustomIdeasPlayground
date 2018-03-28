--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_essence_aura = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_essence_aura:GetTexture()
	return "obsidian_destroyer_essence_aura"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_essence_aura:IsHidden()
    return true
end

function modifier_vgmar_i_essence_aura:IsPurgable()
	return false
end

function modifier_vgmar_i_essence_aura:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_essence_aura:IsAura() return true end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_essence_aura:GetModifierAura()  return "modifier_vgmar_i_essence_aura_effect" end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_essence_aura:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_essence_aura:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_essence_aura:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
----------------------------------------------------------------------------------------------------------
function modifier_vgmar_i_essence_aura:GetAuraRadius() return self.radius end

function modifier_vgmar_i_essence_aura:GetAuraEntityReject(entity)
	if entity:FindAbilityByName("obsidian_destroyer_essence_aura") ~= nil then
		return true
	end
	return false
end

function modifier_vgmar_i_essence_aura:OnCreated(kv) 
	if IsServer() then
		self.radius = kv.radius or 0
		self.bonusmana = kv.bonusmana
		self.restorechance = kv.restorechance
		self.restoreamount = kv.restoreamount
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_essence_aura")
	end
end

function modifier_vgmar_i_essence_aura:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_BONUS,
    }
    return funcs
end

function modifier_vgmar_i_essence_aura:GetModifierManaBonus()
	if IsServer() then
		return self.bonusmana
	else
		return self.clientvalues.bonusmana
	end
end
--------------------------------------------------------------------------------