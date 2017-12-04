--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_spellshield_active = class({})

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function modifier_vgmar_i_spellshield_active:IsHidden()
    return true
end

function modifier_vgmar_i_spellshield_active:IsDebuff()
	return false
end

function modifier_vgmar_i_spellshield_active:IsPurgable()
	return false
end

function modifier_vgmar_i_spellshield_active:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_spellshield_active:OnCreated( kv )
	if IsServer() then
		self.cooldown = self:GetParent():FindModifierByName("modifier_vgmar_i_spellshield").cooldown
	end
end

function modifier_vgmar_i_spellshield_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSORB_SPELL
    }
    return funcs
end

function modifier_vgmar_i_spellshield_active:GetAbsorbSpell()
	if IsServer() then
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf", PATTACH_ROOTBONE_FOLLOW, self:GetParent())
		local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf" , PATTACH_ROOTBONE_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(pfx)
		ParticleManager:ReleaseParticleIndex(pfx2)
		EmitSoundOn("Hero_Antimage.SpellShield.Block", self:GetParent())
		EmitSoundOn("Hero_Antimage.SpellShield.Reflect", self:GetParent())
		self:GetParent():FindModifierByName("modifier_vgmar_i_spellshield"):SetStackCount( self:GetParent():FindModifierByName("modifier_vgmar_i_spellshield"):GetStackCount() - 1 )
		self:GetParent():FindModifierByName("modifier_vgmar_i_spellshield"):SetDuration( self.cooldown, true )
		if self:GetParent():FindModifierByName("modifier_vgmar_i_spellshield"):GetStackCount() < 1 then
			self:Destroy()
		end
		return 1
	end
end

--------------------------------------------------------------------------------