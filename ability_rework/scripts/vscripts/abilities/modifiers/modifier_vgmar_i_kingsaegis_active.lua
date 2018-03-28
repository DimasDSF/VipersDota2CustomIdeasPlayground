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

function modifier_vgmar_i_kingsaegis_active:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_REINCARNATION,
		MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end

function modifier_vgmar_i_kingsaegis_active:ShouldUseAbilityReincarnation()
	local parent = self:GetParent()
	if self:GetParent():FindAbilityByName("skeleton_king_reincarnation") == nil then
		return true
	end
	if self:GetParent():FindAbilityByName("skeleton_king_reincarnation") ~= nil and parent:FindModifierByName("modifier_skeleton_king_reincarnation_scepter") == nil and (self:GetParent():FindAbilityByName("skeleton_king_reincarnation"):GetCooldownTimeRemaining() > 0 or self:GetParent():FindAbilityByName("skeleton_king_reincarnation"):IsOwnersManaEnough() == false) then
		return true
	end
	return false
end

function modifier_vgmar_i_kingsaegis_active:ReincarnateTime()
	if IsServer() then
		local parent = self:GetParent()
		local reincanrate_modifier = parent:FindModifierByName("modifier_vgmar_i_kingsaegis_cooldown")
		if self:ShouldUseAbilityReincarnation() and reincanrate_modifier:GetStackCount() == 0 then
			reincanrate_modifier:SetStackCount(reincanrate_modifier.cooldown)
			AddFOWViewer(parent:GetTeamNumber(), parent:GetAbsOrigin(), 250, 5, false)
			local instparticle = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold_glyph.vpcf", PATTACH_ABSORIGIN, parent)
			--ParticleManager:SetParticleControl(instparticle, 1, Vector(reincanrate_modifier.reincarnate_time,0,0))
			ParticleManager:SetParticleControl(instparticle, 3, parent:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(instparticle)
			Timers:CreateTimer(reincanrate_modifier.reincarnate_time - reincanrate_modifier.reincarnate_time / 20, function()
				local particle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_aegis_starfall.vpcf", PATTACH_ABSORIGIN, parent)
				ParticleManager:SetParticleControl(particle, 1, Vector(reincanrate_modifier.reincarnate_time,0,0))
				ParticleManager:SetParticleControl(particle, 3, parent:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(particle)
			end)
			return reincanrate_modifier.reincarnate_time
		end
	end
end

function modifier_vgmar_i_kingsaegis_active:OnDeath( kv )
    if IsServer() then
        -- Only apply if the caster is the unit that died
        if self:GetParent() == kv.unit then
			local reincanrate_modifier = self:GetParent():FindModifierByName("modifier_vgmar_i_kingsaegis_cooldown")
			if self:ShouldUseAbilityReincarnation() and reincanrate_modifier:GetStackCount() == 0 then
				Timers:CreateTimer(FrameTime(), function()
					self:Destroy()
				end)
			end
        end
    end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------