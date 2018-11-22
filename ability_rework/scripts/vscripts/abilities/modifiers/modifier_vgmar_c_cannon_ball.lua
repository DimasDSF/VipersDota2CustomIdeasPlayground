--A modifier used as a visualisation for a custom spell

modifier_vgmar_c_cannon_ball = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_c_cannon_ball:GetTexture()
	return "faceless_void_time_lock"
end

--------------------------------------------------------------------------------

function modifier_vgmar_c_cannon_ball:IsHidden()
    return false
end

function modifier_vgmar_c_cannon_ball:IsDebuff()
	return false
end

function modifier_vgmar_c_cannon_ball:IsPurgable()
	return false
end

function modifier_vgmar_c_cannon_ball:IsPermanent()
	return true
end

function modifier_vgmar_c_cannon_ball:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function modifier_vgmar_c_cannon_ball:OnCreated( kv )
	if IsServer() then
		self.damageperlevel = kv.damageperlevel
		self.stunduration = kv.stunduration
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_c_cannon_ball")
	end
end

function modifier_vgmar_c_cannon_ball:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED
    }
    return funcs
end

function modifier_vgmar_c_cannon_ball:OnAttackLanded(kv)
	if IsServer() then
		if kv.attacker == self:GetParent() and kv.target:IsRealUnit(false) then
			kv.target:AddNewModifier(kv.attacker, self, "modifier_vgmar_c_cannon_ball_stun", {duration = self.stunduration})
			ApplyDamage({victim = kv.target, attacker = kv.attacker, ability = nil, damage = self.damageperlevel*self:GetParent():GetLevel(), damage_type = DAMAGE_TYPE_MAGICAL})
			--SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, kv.target, self.damageperlevel*self:GetParent():GetLevel(), nil)
			kv.target:EmitSound("Hero_FacelessVoid.TimeLockImpact")
		end
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_c_cannon_ball_stun = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_c_cannon_ball_stun:GetTexture()
	return "faceless_void_time_lock"
end

--------------------------------------------------------------------------------

function modifier_vgmar_c_cannon_ball_stun:IsHidden()
    return false
end

function modifier_vgmar_c_cannon_ball_stun:IsDebuff()
	return true
end

function modifier_vgmar_c_cannon_ball_stun:IsPurgable()
	return true
end

function modifier_vgmar_c_cannon_ball_stun:RemoveOnDeath()
	return true
end

function modifier_vgmar_c_cannon_ball_stun:DestroyOnExpire()
	return true
end

function modifier_vgmar_c_cannon_ball_stun:GetEffectName()
	return "particles/generic_gameplay/generic_stunned.vpcf"
end

function modifier_vgmar_c_cannon_ball_stun:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end


function modifier_vgmar_c_cannon_ball_stun:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }
    return funcs
end

function modifier_vgmar_c_cannon_ball_stun:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_vgmar_c_cannon_ball_stun:GetActivityTranslationModifiers()
	return "stunned"
end

function modifier_vgmar_c_cannon_ball_stun:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end