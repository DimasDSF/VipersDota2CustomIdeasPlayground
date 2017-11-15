--A modifier used as a visualisation for a custom spell

modifier_vgmar_ai_companion_respawntime = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_ai_companion_respawntime:GetTexture()
	return "custom/airespawn"
end

--------------------------------------------------------------------------------

function modifier_vgmar_ai_companion_respawntime:IsHidden()
    return false
end

function modifier_vgmar_ai_companion_respawntime:IsPurgable()
	return false
end

function modifier_vgmar_ai_companion_respawntime:RemoveOnDeath()
	return false
end

function modifier_vgmar_ai_companion_respawntime:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_vgmar_ai_companion_respawntime:OnCreated( kv )
	if IsServer() then
		self:SetDuration( kv.respawntime, true )
		self:StartIntervalThink( 1 )
	end
end

function modifier_vgmar_ai_companion_respawntime:OnIntervalThink()
	if IsServer() then
		self:SetStackCount(self:GetRemainingTime())
	end
end

--------------------------------------------------------------------------------