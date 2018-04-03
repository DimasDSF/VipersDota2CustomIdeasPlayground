--A modifier used as a visualisation for a custom spell

modifier_vgmar_courier_burst = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_courier_burst:GetTexture()
	return "courier_burst"
end

--------------------------------------------------------------------------------

function modifier_vgmar_courier_burst:IsHidden()
	return false
end

function modifier_vgmar_courier_burst:IsPurgable()
	return false
end

function modifier_vgmar_courier_burst:RemoveOnDeath()
	return false
end

function modifier_vgmar_courier_burst:DestroyOnExpire()
	return false
end

function modifier_vgmar_courier_burst:OnCreated(kv)
	if IsServer() then
		--var
		self.distanceperlevel = kv.distanceperlevel
		self.msperlevel = kv.msperlevel
		self.rechargepertickperlevel = kv.rechargepertickperlevel
		self.rechargedelay = kv.rechargedelay
		self.rechargedelayperlvl = kv.rechargedelayperlvl
		self.ticktime = kv.ticktime
		self.basems = kv.basems
		self.maxcharge = kv.maxcharge
		--init
		self.level = 1
		self.charge = 0
		self.position = nil
		self.lastmovementtimestamp = GameRules:GetGameTime()
		--func
		self:SetStackCount(self.level)
		self:StartIntervalThink(self.ticktime)
		--Charge Indicator
		self.chargeind = self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_vgmar_courier_burst_charge", {})
	end
end

function modifier_vgmar_courier_burst:OnRefresh(kv)
	if IsServer() then
		self.level = kv.level
		self:SetStackCount(self.level)
	end
end

function modifier_vgmar_courier_burst:OnIntervalThink()
	local parent = self:GetParent()
	if IsServer() then
		if self.chargeind then
			local charge = (self.charge/self.maxcharge) * 100
			if self.chargeind:GetStackCount() ~= math.floor(charge) then
				self.chargeind:SetStackCount(math.floor(charge))
			end
		end
		if self.charge > 0 then
			local movespeed = self.msperlevel*self:GetStackCount() + self.basems
			if parent:HasModifier("modifier_vgmar_courier_burst_effect") == false or (parent:HasModifier("modifier_vgmar_courier_burst_effect") and parent:FindModifierByName("modifier_vgmar_courier_burst_effect"):GetStackCount() ~= movespeed) then
				parent:AddNewModifier(parent, nil, "modifier_vgmar_courier_burst_effect", {ms=movespeed})
			end
		end
		if self.charge <= 0 and parent:HasModifier("modifier_vgmar_courier_burst_effect") then
			parent:FindModifierByName("modifier_vgmar_courier_burst_effect"):Destroy()
		end
		if self.lastmovementtimestamp + (self.rechargedelay - self.rechargedelayperlvl * self:GetStackCount()) < GameRules:GetGameTime() then
			if self:GetRemainingTime() ~= -1 then
				self:SetDuration(-1, true)
			end
			if self.charge + self:GetStackCount() * self.rechargepertickperlevel <= self.maxcharge then
				self.charge = self.charge + self:GetStackCount() * self.rechargepertickperlevel
			elseif self.charge ~= self.maxcharge then
				self.charge = self.maxcharge
			end
		end
	end
end

function modifier_vgmar_courier_burst:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_UNIT_MOVED
    }
    return funcs
end

function modifier_vgmar_courier_burst:OnUnitMoved(kv)
	if IsServer() then
		if self:GetParent() == kv.unit then
			local pos = self:GetParent():GetAbsOrigin()
			if self.pos then
				local dist = (self.pos - pos):Length2D()
				if dist > 0 then
					self:SetDuration(self.rechargedelay, true)
					if self.charge - (dist / (self.distanceperlevel * self:GetStackCount())) > 0 then
						self.charge = self.charge - (dist / (self.distanceperlevel * self:GetStackCount()))
					elseif self.charge - (dist / (self.distanceperlevel * self:GetStackCount())) <= 0 and self.charge ~= 0 then
						self.charge = 0
					end
				end
			end
			self.pos = pos
			self.lastmovementtimestamp = GameRules:GetGameTime()
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_vgmar_courier_burst_charge = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_courier_burst_charge:GetTexture()
	return "courier_burst"
end

--------------------------------------------------------------------------------

function modifier_vgmar_courier_burst_charge:IsHidden()
	return false
end

function modifier_vgmar_courier_burst_charge:IsPurgable()
	return false
end

function modifier_vgmar_courier_burst_charge:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

modifier_vgmar_courier_burst_effect = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_courier_burst_effect:OnCreated(kv)
	if IsServer() then
		self.ms = kv.ms
		self:SetStackCount(self.ms)
	end
end

function modifier_vgmar_courier_burst_effect:OnRefresh(kv)
	if IsServer() then
		self.ms = kv.ms
		self:SetStackCount(self.ms)
	end
end

function modifier_vgmar_courier_burst_effect:IsHidden()
	return true
end

function modifier_vgmar_courier_burst_effect:IsPurgable()
	return false
end

function modifier_vgmar_courier_burst_effect:RemoveOnDeath()
	return false
end

function modifier_vgmar_courier_burst_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE
    }
    return funcs
end

function modifier_vgmar_courier_burst_effect:GetModifierMoveSpeed_Max( params )
	return self:GetStackCount()
end

function modifier_vgmar_courier_burst_effect:GetModifierMoveSpeed_Limit( params )
	return self:GetStackCount()
end

function modifier_vgmar_courier_burst_effect:GetModifierMoveSpeed_Absolute()
	return self:GetStackCount()
end