--A modifier used as a visualisation for a custom spell

modifier_bsl_execute_order_processor = class({})

--------------------------------------------------------------------------------

function modifier_bsl_execute_order_processor:IsHidden()
    return true
end

function modifier_bsl_execute_order_processor:IsPurgable()
	return false
end

function modifier_bsl_execute_order_processor:RemoveOnDeath()
	return false
end

function modifier_bsl_execute_order_processor:DestroyOnExpire()
	return true
end

function modifier_bsl_execute_order_processor:OnCreated(kv)
	if IsServer() then
		--init
		local parent = self:GetParent()
		--
		--Table Values
		self.unitindex = parent:entindex()
		self.ordertype = kv.ordertype
		self.tindex = kv.tindex
		self.aindex = kv.aindex
		self.pos = kv.pos
		self.queue = kv.queue
		--
		--Keep Trying until success or timeout
		self.force = kv.force
		self.timeout = kv.timeout
		self.cancelondeath = kv.cancelondeath
		--
		self.interval = kv.interval or 0.5

		self:StartIntervalThink(self.interval)
		if self.timeout then
			self:SetDuration(self.timeout, true)
		end
	end
end

function modifier_bsl_execute_order_processor:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_bsl_execute_order_processor:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST
    }
    return funcs
end

function modifier_bsl_execute_order_processor:OnAbilityFullyCast( event )
	if IsServer() then
		if event.unit == self:GetParent() then
			local parent = self:GetParent()
			local ability = event.ability
			if ability ~= nil then
				local targetability = EntIndexToHScript(self.aindex)
				if targetability and ability == targetability then
					self:Destroy()
				end
			end
		end
	end
end

function modifier_bsl_execute_order_processor:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local moveorders = {
			DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			DOTA_UNIT_ORDER_ATTACK_MOVE
		}
		local attackorders = {
			DOTA_UNIT_ORDER_MOVE_TO_TARGET,
			DOTA_UNIT_ORDER_ATTACK_TARGET
		}
		if self.cancelondeath and parent:IsAlive() == false then
			self:Destroy() end
		end
		if self.force and self.aindex == nil and (self.pos ~= nil or self.tindex ~= nil) then
			if moveorders[self.ordertype] ~= nil then
				local distance = (parent:GetAbsOrigin() - self.pos):Length2D()
				if distance < 200 then self:Destroy() end
				if not GridNav:CanFindPath(parent:GetAbsOrigin(), self.pos) then self:Destroy() end
			elseif attackorders[self.ordertype] ~= nil then
				local target = EntIndexToHScript(self.tindex)
				if not target:IsAlive() then self:Destroy() end
				if not parent:CanEntityBeSeenByMyTeam(target) then self:Destroy() end
			end
		end
		if self.aindex then
			local ability = EntIndexToHScript(self.aindex)
			if not BotSupportLib:GetAbilityCastConditions(parent, ability) then
				self:Destroy()
			end
		end
		local order = {
			UnitIndex = self.unitindex,
			OrderType = self.ordertype,
			TargetIndex = self.tindex,
			AbilityIndex = self.aindex,
			Position = self.pos,
			Queue = self.queue
		}
		ExecuteOrderFromTable(order)
		if not self.force then self:Destroy() end
	end
end

--------------------------------------------------------------------------------