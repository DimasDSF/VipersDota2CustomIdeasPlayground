--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_atrophy = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_atrophy:GetTexture()
	return "abyssal_underlord_atrophy_aura"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_atrophy:IsHidden()
    return false
end

function modifier_vgmar_i_atrophy:IsPurgable()
	return false
end

function modifier_vgmar_i_atrophy:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_atrophy:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_atrophy:IsPermanent()
	return true
end

function modifier_vgmar_i_atrophy:OnCreated(kv)
	if IsServer() then
		self.radius = kv.radius
		self.dmgpercreep = kv.dmgpercreep
		self.dmgperhero = kv.dmgperhero
		self.stack_duration = kv.stack_duration
		self.stack_duration_scepter = kv.stack_duration_scepter
		self.max_stacks = kv.max_stacks
		self:SetStackCount(kv.initial_stacks)
	end
end

function modifier_vgmar_i_atrophy:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
    return funcs
end

function modifier_vgmar_i_atrophy:OnDeath(kv)
	if IsServer() then
		if kv.unit:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() and kv.unit:IsBuilding() == false and ((kv.unit:GetAbsOrigin() - self:GetCaster():GetAbsOrigin()):Length2D() <= self.radius or kv.attacker == self:GetCaster()) then
			local damage = 1
			if kv.unit:IsRealHero() then
				damage = self.dmgperhero
			else
				damage = self.dmgpercreep
			end
			
			if self:GetStackCount() + damage < self.max_stacks then
				self:SetStackCount( self:GetStackCount() + damage )
			else
				self:SetStackCount(self.max_stacks)
			end
			
			local st_duration = self.stack_duration
			if self:GetCaster():HasScepter() then
				st_duration = self.stack_duration_scepter
			end
			if st_duration > 0 then
				self:SetDuration( st_duration, true )
				self:StartIntervalThink( 2 )
				Timers:CreateTimer(st_duration, function()
					local reduced_stack = self:GetStackCount() - damage

					-- If the reduced stack would set the stack lower than the base bonus gold, restrict it
					if reduced_stack > 0 then
						self:SetStackCount( reduced_stack )
					else
						self:SetStackCount( 0 )
						self:SetDuration( -1, true )
					end
				end)
			else
				self:SetDuration( -1, true )
			end
		end
	end
end

function modifier_vgmar_i_atrophy:OnIntervalThink()
	if self:GetRemainingTime() == 0 then
		self:SetDuration( -1, true )
		self:StartIntervalThink( -1 )
	end
end

function modifier_vgmar_i_atrophy:GetModifierBaseAttack_BonusDamage()
	return self:GetStackCount()
end
--------------------------------------------------------------------------------