--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_criticalmastery_visual = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_criticalmastery_visual:GetTexture()
	return "phantom_assassin_coup_de_grace"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_criticalmastery_visual:IsHidden()
    return false
end

function modifier_vgmar_i_criticalmastery_visual:IsPurgable()
	return false
end

function modifier_vgmar_i_criticalmastery_visual:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_criticalmastery_visual:OnCreated( kv )

end

--------------------------------------------------------------------------------