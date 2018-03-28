--Purges Specific spells from dominated creeps

modifier_vgmar_util_creep_ability_updater = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_util_creep_ability_updater:GetTexture()
	return "abyssal_underlord_dark_rift"
end

--------------------------------------------------------------------------------

function modifier_vgmar_util_creep_ability_updater:IsHidden()
    return true
end

function modifier_vgmar_util_creep_ability_updater:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_vgmar_util_creep_ability_updater:OnCreated( kv )
	if IsServer() then
		self.abilitiesupdate = {}
		if kv.name ~= nil then
			local abil = {name = kv.name, uptype = kv.uptype, updaylvl = kv.updaylvl, upnightlvl = kv.upnightlvl}
			table.insert(self.abilitiesupdate, abil)
			self:StartIntervalThink( 2 )
		end
	end
end

function modifier_vgmar_util_creep_ability_updater:OnRefresh( kv )
	if IsServer() then
		if kv.name ~= nil then
			local abil = {name = kv.name, uptype = kv.uptype, updaylvl = kv.updaylvl, upnightlvl = kv.upnightlvl}
			table.insert(self.abilitiesupdate, abil)
		end
	end
end

--------------------------------------------------------------------------------
function modifier_vgmar_util_creep_ability_updater:IntervalThink()
	if IsServer() then
		if #self.abilitiesupdate > 0 then
			local parent = self:GetParent()
			for i=1,#self.abilitiesupdate do
				local ability = parent:FindAbilityByName(self.abilitiesupdate[i].name)
				if ability then
					if self.abilitiesupdate[i].uptype == 1 then
						if GameRules:IsDaytime() then
							if ability:GetLevel() ~= self.abilitiesupdate[i].updaylvl then
								ability:SetLevel(self.abilitiesupdate[i].updaylvl)
							end
						else
							if ability:GetLevel() ~= self.abilitiesupdate[i].upnightlvl then
								ability:SetLevel(self.abilitiesupdate[i].upnightlvl)
							end
						end
					end
				end
			end
		else
			self:Destroy()
		end
	end
end