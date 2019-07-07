modifier_vgmar_ward_container_observer = class({})

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function modifier_vgmar_ward_container_observer:IsHidden()
    return self:GetStackCount() < 1
end

function modifier_vgmar_ward_container_observer:GetTexture()
	return "item_ward_observer"
end

function modifier_vgmar_ward_container_observer:IsPurgable()
	return false
end

function modifier_vgmar_ward_container_observer:IsDebuff()
	return false
end

function modifier_vgmar_ward_container_observer:RemoveOnDeath()
	return false
end

function modifier_vgmar_ward_container_observer:DestroyOnExpire()
	return false
end

function modifier_vgmar_ward_container_observer:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + (kv.stack or 0))
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_ward_container_sentry = class({})

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function modifier_vgmar_ward_container_sentry:IsHidden()
    return self:GetStackCount() < 1
end

function modifier_vgmar_ward_container_sentry:GetTexture()
	return "item_ward_sentry"
end

function modifier_vgmar_ward_container_sentry:IsPurgable()
	return false
end

function modifier_vgmar_ward_container_sentry:IsDebuff()
	return false
end

function modifier_vgmar_ward_container_sentry:RemoveOnDeath()
	return false
end

function modifier_vgmar_ward_container_sentry:DestroyOnExpire()
	return false
end

function modifier_vgmar_ward_container_sentry:OnCreated(kv)
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + (kv.stack or 0))
	end
end