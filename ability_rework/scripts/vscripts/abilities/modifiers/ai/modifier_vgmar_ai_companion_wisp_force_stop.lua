--A modifier used as a visualisation for a custom spell

modifier_vgmar_ai_companion_wisp_force_stop = class({})

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function modifier_vgmar_ai_companion_wisp_force_stop:GetTexture()
	return "custom/aithinking"
end

function modifier_vgmar_ai_companion_wisp_force_stop:IsHidden()
    return false
end

function modifier_vgmar_ai_companion_wisp_force_stop:IsPurgable()
	return false
end

function modifier_vgmar_ai_companion_wisp_force_stop:RemoveOnDeath()
	return false
end

function modifier_vgmar_ai_companion_wisp_force_stop:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_vgmar_ai_companion_wisp_force_stop:OnCreated( kv )
	if IsServer() then
		self:SetDuration( kv.duration, true )
	end
end

function modifier_vgmar_ai_companion_wisp_force_stop:OnRefresh( kv )
	if IsServer() then
		local higherduration = kv.duration
		if self:GetRemainingTime() > kv.duration then
			higherduration = self:GetRemainingTime()
		else
			higherduration = kv.duration
		end
		self:SetDuration( higherduration, true )
	end
end

--------------------------------------------------------------------------------