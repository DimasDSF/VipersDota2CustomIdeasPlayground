modifier_extensions_dummy_timer = class({})

function modifier_extensions_dummy_timer:IsHidden()
	return true
end

function modifier_extensions_dummy_timer:IsPurgable()
	return false
end

function modifier_extensions_dummy_timer:RemoveOnDeath()
	return false
end

function modifier_extensions_dummy_timer:DestroyOnExpire()
	return true
end

function modifier_extensions_dummy_timer:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end