--A modifier used as a visualisation for a custom spell

modifier_vgmar_util_all_vision = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_util_all_vision:GetTexture()
	return "custom/items/gem_of_true_sight"
end

--------------------------------------------------------------------------------

function modifier_vgmar_util_all_vision:IsHidden()
    return false
end

function modifier_vgmar_util_all_vision:IsPurgable()
	return false
end

function modifier_vgmar_util_all_vision:RemoveOnDeath()
	return false
end

function modifier_vgmar_util_all_vision:DestroyOnExpire()
	return false
end

function modifier_vgmar_util_all_vision:IsDebuff()
	return true
end

function modifier_vgmar_util_all_vision:OnCreated(kv)
	if IsServer() then
		self:StartIntervalThink( 1 )
	end
end

function modifier_vgmar_util_all_vision:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
    }
    return funcs
end

function modifier_vgmar_util_all_vision:GetModifierProvidesFOWVision()
	return 1
end

function modifier_vgmar_util_all_vision:GetPriority()
  return MODIFIER_PRIORITY_HIGH
end

function modifier_vgmar_util_all_vision:CheckState()
	local state = {
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

function modifier_vgmar_util_all_vision:OnIntervalThink()
	if IsServer() then
		if Convars:GetInt("vgmar_enable_full_vision") == 0 then
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------