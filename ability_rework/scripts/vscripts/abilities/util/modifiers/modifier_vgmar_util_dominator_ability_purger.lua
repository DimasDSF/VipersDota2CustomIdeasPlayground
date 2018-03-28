--Purges Specific spells from dominated creeps

modifier_vgmar_util_dominator_ability_purger = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_util_dominator_ability_purger:GetTexture()
	return "abyssal_underlord_dark_rift"
end

--------------------------------------------------------------------------------

function modifier_vgmar_util_dominator_ability_purger:IsHidden()
    return false
end

function modifier_vgmar_util_dominator_ability_purger:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_vgmar_util_dominator_ability_purger:OnCreated( kv )
	if IsServer() then
		self.removemode = kv.remove_mode
		self.abilitiesforremoval = {}
		self.modifiersforremoval = {}
		if kv.ability ~= nil then
			if kv.abilityismod == 1 then
				table.insert(self.modifiersforremoval, kv.ability)
			else
				table.insert(self.abilitiesforremoval, kv.ability)
			end
		end
	end
end

function modifier_vgmar_util_dominator_ability_purger:OnRefresh( kv )
	if IsServer() then
		if kv.ability ~= nil then
			if kv.abilityismod == 1 then
				table.insert(self.modifiersforremoval, kv.ability)
			else
				table.insert(self.abilitiesforremoval, kv.ability)
			end
		end
	end
end

--------------------------------------------------------------------------------
function modifier_vgmar_util_dominator_ability_purger:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DOMINATED
    }
end

function modifier_vgmar_util_dominator_ability_purger:OnDominated( kv )
	local parent = self:GetParent()
	
	if parent:FindModifierByName("modifier_vgmar_util_creep_ability_updater") then
		parent:FindModifierByName("modifier_vgmar_util_creep_ability_updater"):Destroy()
	end
	for i=1,#self.abilitiesforremoval do
		if parent:FindAbilityByName(self.abilitiesforremoval[i]) then
			if self.removemode == 1 then
				parent:RemoveAbility(self.abilitiesforremoval[i])
			else
				parent:FindAbilityByName(self.abilitiesforremoval[i]):SetLevel( 0 )
			end
		end
	end
	for i=1,#self.modifiersforremoval do
		if parent:FindModifierByName(self.modifiersforremoval[i]) then
			parent:FindModifierByName(self.modifiersforremoval[i]):Destroy()
		end
	end

	self:Destroy()
	
end