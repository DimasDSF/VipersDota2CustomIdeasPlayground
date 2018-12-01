--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_multishot = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_multishot:GetTexture()
	return "medusa_split_shot"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_multishot:IsHidden()
    return false
end

function modifier_vgmar_i_multishot:IsDebuff()
	return false
end

function modifier_vgmar_i_multishot:IsPurgable()
	return false
end

function modifier_vgmar_i_multishot:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_multishot:DestroyOnExpire()
	return false
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_multishot:OnCreated( kv )
	if IsServer() then
		self.basetargets = kv.basetargets
		self.mainattrpertarget = kv.mainattrpertarget
		self.attrcapenablemodifiers = kv.attrcapenablemodifiers
		self.bonusdamage = kv.bonusdamage
		self.bonusrange = kv.bonusrange
		self:SetDuration(0.1, true)
		self:StartIntervalThink(1)
		self.modifiersstate = false
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_multishot")
	end
end

function modifier_vgmar_i_multishot:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
    }
    return funcs
end

function modifier_vgmar_i_multishot:GetModifierAttackRangeBonus()
	if self:GetParent():IsRangedAttacker() == true then
		if IsServer() then
			return self.bonusrange
		else
			return self.clientvalues.bonusrange
		end
	end
end

function modifier_vgmar_i_multishot:GetModifierBaseAttack_BonusDamage()
	if IsServer() then
		return self.bonusdamage
	else
		return self.clientvalues.bonusdamage
	end
end


function modifier_vgmar_i_multishot:GetAttributeAmount()
	if IsServer() then
		local parent = self:GetParent()
		local attrn = parent:GetPrimaryAttribute()
		if attrn == 0 then
			return parent:GetStrength()
		elseif attrn == 1 then
			return parent:GetAgility()
		elseif attrn == 2 then
			return parent:GetIntellect()
		else
			print("Error in modifier_vgmar_i_multishot!")
			print("Unit: "..parent:GetName().." entindex: "..parent:entindex().." did not return a Primary Attribute")
			return 0
		end
	end
	return 0
end


function modifier_vgmar_i_multishot:OnAttack( event )
	if IsServer() then
		if event.attacker == self:GetParent() and self:GetParent():IsRangedAttacker() == true and self:GetParent():PassivesDisabled() == false then
			if event.attacker:GetTeamNumber() ~= event.target:GetTeamNumber() and event.target == self:GetParent():GetAttackTarget() then
				if self:GetStackCount() > 0 then
					local parent = self:GetParent()
					local targets = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, parent:Script_GetAttackRange() + 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
					local sortedtargets = {}
					--Sorting
					if #targets > 1 then
						for j=1,3 do
							for i=1,#targets do
								if targets[i] ~= event.target then
									if targets[i]:IsHero() and j==1 then
										table.insert(sortedtargets, targets[i])
									elseif targets[i]:IsBuilding() and j==2 then
										table.insert(sortedtargets, targets[i])
									elseif targets[i]:IsHero() == false and targets[i]:IsBuilding() == false and j==3 then
										table.insert(sortedtargets, targets[i])
									end
								end
							end
						end
						if #sortedtargets > 0 then
							for j=1,self:GetStackCount() do
								parent:PerformAttack(sortedtargets[j], self.modifiersstate, self.modifiersstate, true, false, true, false, false)
							end
						end
					end
				end
			end
		end
	end
end

function modifier_vgmar_i_multishot:OnIntervalThink()
	if IsServer() then
		local maxtargets = self.basetargets + (self:GetAttributeAmount() / self.mainattrpertarget)
		local modsenabled = self:GetParent():HasScepter()
		if self:GetStackCount() ~= maxtargets then
			self:SetStackCount(maxtargets)
		end
		if modsenabled ~= self.modifiersstate then
			if modsenabled then
				self:SetDuration(-1, true)
				self.modifiersstate = true
			else
				self:SetDuration(0.1, true)
				self.modifiersstate = false
			end
		end
	end
end