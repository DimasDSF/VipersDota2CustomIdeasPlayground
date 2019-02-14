--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_consumed_aegis = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_consumed_aegis:GetEffectName()
	return "particles/units/heroes/hero_skeletonking/skeletonking_mortalstrike.vpcf"
end

function modifier_vgmar_i_consumed_aegis:GetEffectAttachType()
	return PATTACH_ROOTBONE_FOLLOW
end

function modifier_vgmar_i_consumed_aegis:GetTexture()
	return "custom/kingsaegisreincarnation"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_consumed_aegis:IsHidden()
    return false
end

function modifier_vgmar_i_consumed_aegis:IsDebuff()
	return false
end

function modifier_vgmar_i_consumed_aegis:IsPurgable()
	return false
end

function modifier_vgmar_i_consumed_aegis:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_consumed_aegis:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_consumed_aegis:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_REINCARNATION,
		MODIFIER_EVENT_ON_DEATH
    }
    return funcs
end

function modifier_vgmar_i_consumed_aegis:OnCreated( kv )
	if IsServer() then
		self.aegisduration = kv.aegisduration
		self.reincarnate_time = kv.reincarnate_time
		self.expireregendur = kv.expireregendur
		self:SetDuration(math.max(1,((GameRules.VGMAR.roshandeathtime + self.aegisduration) - GameRules:GetGameTime())), true)
		self:StartIntervalThink(1.0)
	end
end

function modifier_vgmar_i_consumed_aegis:ShouldUseAbilityReincarnation()
	local parent = self:GetParent()
	if self:GetParent():FindAbilityByName("skeleton_king_reincarnation") == nil then
		return true
	end
	if self:GetParent():FindAbilityByName("skeleton_king_reincarnation") ~= nil and parent:FindModifierByName("modifier_skeleton_king_reincarnation_scepter") == nil and (self:GetParent():FindAbilityByName("skeleton_king_reincarnation"):GetCooldownTimeRemaining() > 0 or self:GetParent():FindAbilityByName("skeleton_king_reincarnation"):IsOwnersManaEnough() == false) then
		return true
	end
	return false
end

function modifier_vgmar_i_consumed_aegis:ReincarnateTime()
	return self.reincarnate_time
end

function modifier_vgmar_i_consumed_aegis:OnIntervalThink()
	if IsServer() then
		if self:GetRemainingTime() <= 0 then
			self:GetParent():EmitSound("Aegis.Expire")
			self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_aegis_regen", {duration = self.expireregendur})
			self:Destroy()
		end
	end
end

function modifier_vgmar_i_consumed_aegis:OnDeath( kv )
    if IsServer() then
        -- Only apply if the caster is the unit that died
        if self:GetParent() == kv.unit then
			if self:ShouldUseAbilityReincarnation() then
				local parent = self:GetParent()
				AddFOWViewer(parent:GetTeamNumber(), parent:GetAbsOrigin(), 250, 5, false)
				local instparticle = ParticleManager:CreateParticle("particles/econ/items/dazzle/dazzle_ti6_gold/dazzle_ti6_shallow_grave_gold_glyph.vpcf", PATTACH_ABSORIGIN, parent)
				ParticleManager:SetParticleControl(instparticle, 3, parent:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(instparticle)
				Timers:CreateTimer(self.reincarnate_time*0.98, function()
					local particle = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn_aegis_starfall.vpcf", PATTACH_ABSORIGIN, parent)
					ParticleManager:SetParticleControl(particle, 1, Vector(self.reincarnate_time,0,0))
					ParticleManager:SetParticleControl(particle, 3, parent:GetAbsOrigin())
					ParticleManager:ReleaseParticleIndex(particle)
				end)
				Timers:CreateTimer(FrameTime(), function()
					self:Destroy()
				end)
			end
        end
    end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------