--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_multidimension_cast = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_multidimension_cast:GetTexture()
	return "obsidian_destroyer_essence_aura"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_multidimension_cast:IsHidden()
    return false
end

function modifier_vgmar_i_multidimension_cast:IsPurgable()
	return false
end

function modifier_vgmar_i_multidimension_cast:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_multidimension_cast:OnCreated(kv) 
	if IsServer() then
		self.multicastchance1 = math.min(100, kv.multicastchance1)
		self.multicastchance2 = math.min(100, kv.multicastchance2)
		self.multicastchance3 = math.min(100, kv.multicastchance3)
		self.multicastchance4 = math.min(100, kv.multicastchance4)
		self.multicastchance5 = math.min(100, kv.multicastchance5)
		self.multicastminint1 = math.max(1, kv.multicastminint1)
		self.multicastminint2 = math.max(1, kv.multicastminint2)
		self.multicastminint3 = math.max(1, kv.multicastminint3)
		self.multicastminint4 = math.max(1, kv.multicastminint4)
		self.multicastminint5 = math.max(1, kv.multicastminint5)
		self.multicastinterval = kv.multicastinterval
		self.multicastpointrange = kv.multicastpointrange
		self.multicastunitrange = kv.multicastunitrange
		self.spellcasts = {}
		self.lastcastordertype = -1
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_multidimension_cast")
	end
end

function modifier_vgmar_i_multidimension_cast:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_multidimension_cast:OnTooltip()
	return self.clientvalues.restoreamount
end

function modifier_vgmar_i_multidimension_cast:OnOrder(event)
	if IsServer() then
		local ability = event.ability
		local tracked_orders = {
			[5] = true,
			[6] = true,
			[8] = true
		}
		if event.unit == self:GetParent() then
			if tracked_orders[event.order_type] then
				if ability and ability:IsToggle() == false and ability:IsItem() == false and (GameRules.VGMAR.md_cast_ignored_abilities[ability:GetName()] == nil or GameRules.VGMAR.md_cast_ignored_abilities[ability:GetName()] ~= true) then
					self.lastcastordertype = event.order_type
				end
			end
		end
	end
end

function modifier_vgmar_i_multidimension_cast:getmcastnum(unit)
	local intellect = unit:GetIntellect()
	if unit:PassivesDisabled() == false then
		local chance = math.random(0, 100)
		if chance < self.multicastchance5 and intellect >= self.multicastminint5 then
			return 5
		elseif chance < self.multicastchance4 and intellect >= self.multicastminint4 then
			return 4
		elseif chance < self.multicastchance3 and intellect >= self.multicastminint3 then
			return 3
		elseif chance < self.multicastchance2 and intellect >= self.multicastminint2 then
			return 2
		elseif chance < self.multicastchance1 and intellect >= self.multicastminint1 then
			return 1
		end
	end
	return 0
end
			
function modifier_vgmar_i_multidimension_cast:OnAbilityExecuted(kv)
	if IsServer() then
		local parent = self:GetParent()
		if kv.unit == parent and parent:PassivesDisabled() == false then
			if kv.ability and kv.ability:IsToggle() == false and kv.ability:IsItem() == false and (GameRules.VGMAR.md_cast_ignored_abilities[kv.ability:GetName()] == nil or GameRules.VGMAR.md_cast_ignored_abilities[kv.ability:GetName()] ~= true) then
				local mcast = self:getmcastnum(parent)
				if mcast > 0 then
					local ability = kv.ability
					local behavior = ability:GetBehavior()
					local tteam = ability:GetAbilityTargetTeam()
					local tflags = ability:GetAbilityTargetFlags()
					local ttype = ability:GetAbilityTargetType()
					if (bit.band(behavior, DOTA_ABILITY_BEHAVIOR_CHANNELLED) == DOTA_ABILITY_BEHAVIOR_CHANNELLED or bit.band(behavior, DOTA_ABILITY_BEHAVIOR_TOGGLE) == DOTA_ABILITY_BEHAVIOR_TOGGLE) == false then
						local targets = {}
						local ctype = 0
						if self.lastcastordertype == 5 and kv.target == nil then
							table.insert(targets, ability:GetCursorPosition())
							ctype = 2
						elseif self.lastcastordertype == 6 or kv.target then
							if kv.target == parent then
								targets = {parent}
							else
								targets = FindUnitsInRadius(parent:GetTeamNumber(), kv.target:GetAbsOrigin(), nil, self.multicastunitrange, tteam, ttype, tflags, FIND_CLOSEST, false)
							end
							ctype = 1
						elseif self.lastcastordertype == 8 then
							targets = {parent}
						end
						if #targets > 0 then
							for i=1, mcast, 1 do
								local tar = table.random(targets)
								local t = {ctype = ctype, ability = ability, target = tar}
								table.insert(self.spellcasts, t)
							end
							self:StartIntervalThink(self.multicastinterval)
						end
					end
				end
			end
		end	
	end
end

function modifier_vgmar_i_multidimension_cast:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local cast = self.spellcasts[1]
		local mcasts = self:getmcastnum(parent)
		if self:GetStackCount() ~= mcasts then
			self:SetStackCount(mcasts)
		end
		if parent:IsStunned() == false and parent:IsHexed() == false and parent:IsSilenced() == false then
			if cast.ctype == 2 then
				local tar = cast.target + RandomVector(math.random(0, self.multicastpointrange))
				parent:SetCursorPosition(tar)
				cast.ability:OnSpellStart()
			elseif cast.ctype == 1 then
				if cast.target:IsAlive() then
					parent:SetCursorCastTarget(cast.target)
					cast.ability:OnSpellStart()
				end
			else
				cast.ability:OnSpellStart()
			end
			table.remove(self.spellcasts, 1)
			if #self.spellcasts < 1 then
				self:StartIntervalThink(-1)
			end
		end
	end
end
--------------------------------------------------------------------------------