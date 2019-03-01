modifier_bsl_disable_control = class({})

function modifier_bsl_disable_control:CheckState()
  local state = {
      [MODIFIER_STATE_COMMAND_RESTRICTED] = true,
  }

  return state
end

--TODO: Add conditional auto-removal
--All configured via creation kv
--On Damaged > 5%HP
--On Hit by enemy hero
--On Hit by enemy creep
--On Enemy hero nearby
--On Enemy Creep Nearby
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