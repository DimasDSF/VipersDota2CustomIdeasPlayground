--A modifier used as a visualisation for a custom spell

modifier_vgmar_b_last_resort_armor = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_b_last_resort_armor:GetTexture()
	return "custom/last_resort_armor"
end

--------------------------------------------------------------------------------

function modifier_vgmar_b_last_resort_armor:IsHidden()
    return false
end

function modifier_vgmar_b_last_resort_armor:IsPurgable()
	return false
end

function modifier_vgmar_b_last_resort_armor:RemoveOnDeath()
	return false
end

function modifier_vgmar_b_last_resort_armor:DestroyOnExpire()
	return false
end

function modifier_vgmar_b_last_resort_armor:OnCreated(kv) 
	if IsServer() then
		self.dur = kv.dur
		self.reductiontick = kv.reductiontick
		self.reductionpertick = kv.reductionpertick
		self.armor_per_stack = kv.armor_per_stack
		self.bonus_regen = kv.bonus_regen
		self.expiring = false
		self:SetStackCount(kv.start_stacks)
		self:StartIntervalThink(1)
		self:SetDuration(self.dur, true)
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_b_last_resort_armor")
	end
end

function modifier_vgmar_b_last_resort_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_b_last_resort_armor:CheckState()
	local state = {
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}

	return state
end

function modifier_vgmar_b_last_resort_armor:GetEffectName()
	return "particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff.vpcf"
end

function modifier_vgmar_b_last_resort_armor:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_vgmar_b_last_resort_armor:OnIntervalThink()
	if IsServer() then
		if self:GetRemainingTime() <= 0 then
			if self.expiring == false then
				self.expiring = true
				self:StartIntervalThink(self.reductiontick)
			else
				if self:GetStackCount() - self.reductionpertick > 0 then
					self:SetStackCount(self:GetStackCount() - self.reductionpertick)
				else
					self:Destroy()
				end
			end
		end
	end
end

function modifier_vgmar_b_last_resort_armor:OnTooltip()
	if IsServer() then
		return (math.max(0,self:GetRemainingTime()) + ((self:GetStackCount()/self.reductionpertick)*self.reductiontick))
	else
		return (math.max(0,self:GetRemainingTime()) + ((self:GetStackCount()/self.clientvalues.reductionpertick)*self.clientvalues.reductiontick))
	end
end

function modifier_vgmar_b_last_resort_armor:GetModifierPhysicalArmorBonus()
	if IsServer() then
		return self.armor_per_stack * self:GetStackCount()
	else
		return self.clientvalues.armor_per_stack * self:GetStackCount()
	end
end

function modifier_vgmar_b_last_resort_armor:GetModifierConstantHealthRegen()
	if self:GetRemainingTime() > 0 then
		if IsServer() then
			return self.bonus_regen
		else
			return self.clientvalues.bonus_regen
		end
	end
end

--------------------------------------------------------------------------------