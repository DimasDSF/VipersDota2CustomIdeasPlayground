--A modifier used as a visualisation for a custom spell

modifier_vgmar_crai_courier_shield = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_crai_courier_shield:IsHidden()
    return true
end

function modifier_vgmar_crai_courier_shield:IsPurgable()
	return false
end

function modifier_vgmar_crai_courier_shield:RemoveOnDeath()
	return false
end

function modifier_vgmar_crai_courier_shield:OnCreated(kv)
	if IsServer() then
		--init
		self.ability = self:GetParent():FindAbilityByName("courier_shield")
		--kv
		self.maxattentiondistance = 250
		if kv.maxattentiondistance > 250 then
			self.maxattentiondistance = kv.maxattentiondistance
		end
		self.minadmult = kv.minadmult
		self.maxadmult = kv.maxadmult
		self.startattackchance = kv.startattackchance
		self.hitattackchance = kv.hitattackchance
	end
end

function modifier_vgmar_crai_courier_shield:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_TAKEDAMAGE
    }
    return funcs
end

function modifier_vgmar_crai_courier_shield:GetShieldStatusActive()
	if IsServer() then
		if self.ability ~= nil then
			local shieldlevel = self.ability:GetLevel()
			local shieldcooldown = self.ability:GetCooldownTimeRemaining()
			if shieldlevel > 0 and shieldcooldown <= 0 then
				return true
			else
				return false
			end
		else
			self.ability = self:GetParent():FindAbilityByName("courier_shield")
			return false
		end
	end
end

function modifier_vgmar_crai_courier_shield:GetAttentionChance(baseChance)
	local nearesthero = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.maxattentiondistance, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)[1]
	if nearesthero ~= nil then
		local distance = (self:GetParent():GetAbsOrigin() - nearesthero:GetAbsOrigin()):Length2D()
		return math.floor(math.clamp(0, math.mapl(distance, 200, self.maxattentiondistance, self.maxadmult, self.minadmult) * baseChance, 100))
	end
	return math.floor(self.minadmult * baseChance)
end

function modifier_vgmar_crai_courier_shield:OnAttackStart(event)
	if IsServer() then
		if event.target == self:GetParent() then
			if self:GetShieldStatusActive() and event.attacker:IsInvisible() == false then
				if math.random(0,100) <= self:GetAttentionChance(self.startattackchance) then
					self.ability:CastAbility()
				end
			end
		end
	end
end

function modifier_vgmar_crai_courier_shield:OnTakeDamage(event)
	if IsServer() then
		if event.unit == self:GetParent() then
			if self:GetShieldStatusActive() then
				if math.random(0,100) <= self:GetAttentionChance(self.hitattackchance) then
					self.ability:CastAbility()
				end
			end
		end
	end
end

--------------------------------------------------------------------------------