--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_midas_greed = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_midas_greed:GetTexture()
	return "alchemist_goblins_greed"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_midas_greed:IsHidden()
    return false
end

function modifier_vgmar_i_midas_greed:IsPurgable()
	return false
end

function modifier_vgmar_i_midas_greed:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_midas_greed:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_midas_greed:OnCreated(kv)
	if IsServer() then
		self.min_bonus_gold = kv.min_bonus_gold
		self.count_per_kill = kv.count_per_kill
		self.reduction_per_tick = kv.reduction_per_tick
		self.bonus_gold_cap = kv.bonus_gold_cap
		self.stack_duration = kv.stack_duration
		self.reduction_duration = kv.reduction_duration
		self.killsperstack = kv.killsperstack
		self.killscount = 0
		self.midasusestacks = kv.midasusestacks
		self:SetStackCount( self.min_bonus_gold )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_midas_greed")
	end
end

function modifier_vgmar_i_midas_greed:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_midas_greed:OnIntervalThink()
	if self:GetRemainingTime() < 1 then
		local reduced_stack = self.killscount - self.reduction_per_tick * self.killsperstack
		-- If the reduced stack would set the stack lower than the base bonus gold, restrict it
		if reduced_stack > self.min_bonus_gold then
			self.killscount = reduced_stack
			self:SetDuration( self.reduction_duration, true )
			self:StartIntervalThink( self.reduction_duration )
		else
			self.killscount = self.min_bonus_gold * self.killsperstack
			self:SetDuration(-1, true)
			self:StartIntervalThink( -1 )
		end
	end
	self:SetStackCount( math.floor(self.killscount / self.killsperstack) )
end

function modifier_vgmar_i_midas_greed:OnTooltip()
	return self.clientvalues.killsperstack
end

function modifier_vgmar_i_midas_greed:OnAbilityFullyCast( event )
	if IsServer() then
		if event.unit == self:GetCaster() then
			local hAbility = event.ability
			if hAbility ~= nil then
				if hAbility:GetName() == "item_hand_of_midas" then
					if self.killscount < self.bonus_gold_cap * self.killsperstack then
						self.killscount = self.killscount + self.killsperstack * self.midasusestacks
						self:SetStackCount( math.floor(self.killscount / self.killsperstack) )
					end
				end
			end
		end
	end
end

function modifier_vgmar_i_midas_greed:OnDeath(kv)
	if IsServer() then
		if kv.attacker == self:GetCaster() and kv.unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
			local player = self:GetCaster():GetPlayerOwner()	
			
			self:GetCaster():ModifyGold(self:GetStackCount(), false, 0)
			
			if self:GetStackCount() > 0 then
				--Coins
				local goldparticle = ParticleManager:CreateParticleForPlayer( "particles/units/heroes/hero_alchemist/alchemist_lasthit_coins.vpcf", PATTACH_ABSORIGIN, kv.unit, player )
				ParticleManager:SetParticleControl( goldparticle, 0, kv.unit:GetAbsOrigin() )
				ParticleManager:SetParticleControl( goldparticle, 1, kv.unit:GetAbsOrigin() )
				--Text
				local digits = string.len(self:GetStackCount()) + 1
				local particle = ParticleManager:CreateParticleForPlayer( "particles/units/heroes/hero_alchemist/alchemist_lasthit_msg_gold.vpcf", PATTACH_ABSORIGIN, kv.unit, player )
				ParticleManager:SetParticleControl(particle, 1, Vector(0, self:GetStackCount(), 0))
				ParticleManager:SetParticleControl(particle, 2, Vector(2, digits, 0))
				ParticleManager:SetParticleControl(particle, 3, Vector(255, 200, 33))
			end
			
			if self.killscount < self.bonus_gold_cap * self.killsperstack then
				self.killscount = self.killscount + self.count_per_kill
				self:SetStackCount( math.floor(self.killscount / self.killsperstack) )
				self:SetDuration( self.stack_duration, true )
				self:StartIntervalThink( self.stack_duration )
			else
				self:SetStackCount( math.floor(self.killscount / self.killsperstack) )
				self:SetDuration( self.stack_duration, true )
				self:StartIntervalThink( self.stack_duration )
			end
		end
	end
end
--------------------------------------------------------------------------------