--A modifier used as a visualisation for a custom spell

modifier_vgmar_buildings_destroyed_counter = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_buildings_destroyed_counter:GetTexture()
	return "lone_druid_spirit_bear_demolish"
end

--------------------------------------------------------------------------------

function modifier_vgmar_buildings_destroyed_counter:IsHidden()
	return false
end

function modifier_vgmar_buildings_destroyed_counter:IsPurgable()
	return false
end

function modifier_vgmar_buildings_destroyed_counter:RemoveOnDeath()
	return false
end

function modifier_vgmar_buildings_destroyed_counter:DestroyOnExpire()
	return false
end

function modifier_vgmar_buildings_destroyed_counter:OnCreated(kv)
	if IsServer() then
		self.buildingvaluelist = GameRules.VGMAR.buildingadvantagevaluelist
	end
end

function modifier_vgmar_buildings_destroyed_counter:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_BUILDING_KILLED
    }
    return funcs
end

function modifier_vgmar_buildings_destroyed_counter:OnBuildingKilled(kv)
	if IsServer() then
		if self.buildingvaluelist[kv.target:GetName()] ~= nil then
			if self:GetParent():GetTeamNumber() == 2 then
				local denied = kv.unit:GetTeamNumber() == kv.target:GetTeamNumber()
				local buildingname = kv.target:GetName()
				local buildingvalue = self.buildingvaluelist[buildingname]
				GameRules.VGMAR:OnBuildingDestroyed(kv.unit, denied, kv.target:GetTeamNumber(), buildingname, buildingvalue)
			end
			if kv.target:GetTeamNumber() == self:GetParent():GetTeamNumber() then
				self:SetStackCount(self:GetStackCount() + self.buildingvaluelist[kv.target:GetName()])
			end
		end
	end
end

--------------------------------------------------------------------------------