--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_purgefield_visual = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_purgefield_visual:GetTexture()
	return "razor_unstable_current"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_purgefield_visual:IsHidden()
    return false
end

function modifier_vgmar_i_purgefield_visual:IsPurgable()
	return false
end

function modifier_vgmar_i_purgefield_visual:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_purgefield_visual:OnCreated( kv )

end

--------------------------------------------------------------------------------