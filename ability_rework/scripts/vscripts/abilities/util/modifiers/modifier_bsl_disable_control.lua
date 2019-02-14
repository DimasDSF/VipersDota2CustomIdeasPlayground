modifier_bsl_disable_control = class({})

function modifier_bsl_disable_control:CheckState()
  local state = {
      [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
  }

  return state
end

function modifier_bsl_disable_control:IsHidden()
    return true
end

function modifier_bsl_disable_control:RemoveOnDeath()
	return false
end

function modifier_bsl_disable_control:IsPurgable()
	return false
end

function modifier_bsl_disable_control:DestroyOnExpire()
	return true
end

function modifier_bsl_disable_control:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end