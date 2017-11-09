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
	self.removemode = kv.remove_mode
	self.abilitiesforremoval = {}
	if kv.ability1 ~= nil then
		table.insert(self.abilitiesforremoval, kv.ability1)
	end
	if kv.ability2 ~= nil then 
		table.insert(self.abilitiesforremoval, kv.ability2)
	end
	if kv.ability3 ~= nil then
		table.insert(self.abilitiesforremoval, kv.ability3)
	end
	if kv.ability4 ~= nil then 
		table.insert(self.abilitiesforremoval, kv.ability4)
	end
	if kv.ability5 ~= nil then
		table.insert(self.abilitiesforremoval, kv.ability5)
	end
	if kv.ability6 ~= nil then 
		table.insert(self.abilitiesforremoval, kv.ability6)
	end
	if kv.ability7 ~= nil then
		table.insert(self.abilitiesforremoval, kv.ability7)
	end
	if kv.ability8 ~= nil then 
		table.insert(self.abilitiesforremoval, kv.ability8)
	end
	if kv.ability9 ~= nil then
		table.insert(self.abilitiesforremoval, kv.ability9)
	end
	if kv.ability10 ~= nil then 
		table.insert(self.abilitiesforremoval, kv.ability10)
	end
end

--------------------------------------------------------------------------------
function modifier_vgmar_util_dominator_ability_purger:DeclareFunctions()
	return {
        MODIFIER_EVENT_ON_DOMINATED
    }
end

function modifier_vgmar_util_dominator_ability_purger:OnDominated( kv )
	local parent = self:GetCaster()
		
	for i=1,#self.abilitiesforremoval do
		if parent:FindAbilityByName(self.abilitiesforremoval[i]) then
			if self.removemode == 1 then
				parent:RemoveAbility(self.abilitiesforremoval[i])
			else
				parent:FindAbilityByName(self.abilitiesforremoval[i]):SetLevel( 0 )
			end
		end
	end
	self:Destroy()
	
end