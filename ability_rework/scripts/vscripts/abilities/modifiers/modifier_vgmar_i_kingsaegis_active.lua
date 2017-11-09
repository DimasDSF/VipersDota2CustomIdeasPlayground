--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_kingsaegis_active = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_kingsaegis_active:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/skeletonking_mortalstrike.vpcf"
end

function modifier_vgmar_i_kingsaegis_active:GetEffectAttachType()
	return PATTACH_ROOTBONE_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_kingsaegis_active:IsHidden()
    return true
end

function modifier_vgmar_i_kingsaegis_active:IsDebuff()
	return false
end

function modifier_vgmar_i_kingsaegis_active:IsPurgable()
	return false
end

function modifier_vgmar_i_kingsaegis_active:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------