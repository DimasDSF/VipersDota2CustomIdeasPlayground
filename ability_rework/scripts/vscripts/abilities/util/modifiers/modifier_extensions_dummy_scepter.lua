modifier_extensions_dummy_scepter = class({})

function modifier_extensions_dummy_scepter:IsHidden()
	return true
end

function modifier_extensions_dummy_scepter:IsPurgable()
	return false
end

function modifier_extensions_dummy_scepter:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_IS_SCEPTER
    }
    return funcs
end

function modifier_extensions_dummy_scepter:GetModifierScepter(event)
	return true
end