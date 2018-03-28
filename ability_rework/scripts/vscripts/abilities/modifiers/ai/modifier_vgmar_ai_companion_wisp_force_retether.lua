--A modifier used as a visualisation for a custom spell

modifier_vgmar_ai_companion_wisp_force_retether = class({})

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function modifier_vgmar_ai_companion_wisp_force_retether:IsHidden()
    return true
end

function modifier_vgmar_ai_companion_wisp_force_retether:IsPurgable()
	return false
end

function modifier_vgmar_ai_companion_wisp_force_retether:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_vgmar_ai_companion_wisp_force_retether:OnCreated( kv )
	if IsServer() then
		local ownerhero = EntIndexToHScript(kv.ownerindex)
		if self:GetCaster():HasModifier("modifier_wisp_tether") then
			if self:GetCaster():FindAbilityByName("vgmar_ca_wisp_overcharge"):GetToggleState() ~= false then
				self:GetCaster():CastAbilityToggle(self:GetCaster():FindAbilityByName("vgmar_ca_wisp_overcharge"), kv.ownerid)
			end
			self:GetCaster():RemoveModifierByName("modifier_wisp_tether")
			ownerhero:RemoveModifierByName("modifier_wisp_tether_haste")
			self:GetCaster():FindAbilityByName("vgmar_ca_wisp_tether"):EndCooldown()
			ownerhero:RemoveModifierByName("modifier_wisp_overcharge")
			self:GetCaster():CastAbilityOnTarget(ownerhero, self:GetCaster():FindAbilityByName("vgmar_ca_wisp_tether"), kv.ownerid)
		end
	end
	self:Destroy()
end

--------------------------------------------------------------------------------