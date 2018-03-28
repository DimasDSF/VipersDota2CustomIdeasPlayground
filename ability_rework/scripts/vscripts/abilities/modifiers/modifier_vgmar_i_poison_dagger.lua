--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_poison_dagger = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_poison_dagger:GetTexture()
	return "queenofpain_shadow_strike"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_poison_dagger:IsHidden()
    return false
end

function modifier_vgmar_i_poison_dagger:IsDebuff()
	return false
end

function modifier_vgmar_i_poison_dagger:IsPurgable()
	return false
end

function modifier_vgmar_i_poison_dagger:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_poison_dagger:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_poison_dagger:IsPermanent()
	return true
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_poison_dagger:OnCreated( kv )
	if IsServer() then
		self.cooldown = kv.cooldown
		self.maxstacks = kv.maxstacks
		self.aoestacks = kv.aoestacks
		self.minenemiesforaoe = kv.minenemiesforaoe
		self.aoedmgperc = kv.aoedmgperc / 100
		self.damage = kv.damage
		self.aoeradius = kv.aoeradius
		self.initialdamageperc = kv.initialdamageperc / 100
		self.duration = kv.duration
		self.interval = kv.interval
		self:SetStackCount( 0 )
		self:SetDuration( self.cooldown, true )
		self:StartIntervalThink( 0.25 )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_poison_dagger")
	end
end

function modifier_vgmar_i_poison_dagger:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_poison_dagger:OnAttackLanded( event )
	if IsServer() then
		if event.attacker == self:GetParent() then
			if self:GetStackCount() > 0 and self:GetParent():HasModifier("modifier_vgmar_util_multishot_active") == false then
				if event.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and not (event.target:IsTower() or event.target:IsBuilding()) then
					local nearbyenemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.aoeradius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
					local targetent = nil
					if event.target:GetHealth() > event.damage then
						if event.target:FindModifierByName("modifier_vgmar_i_poison_dagger_debuff") == nil or (event.target:FindModifierByName("modifier_vgmar_i_poison_dagger_debuff") and event.target:FindModifierByName("modifier_vgmar_i_poison_dagger_debuff"):GetRemainingTime() < 3/4 * self.duration) then
							targetent = event.target
						end
					else
						for i=1,#nearbyenemies do
							if nearbyenemies[i] ~= event.target and nearbyenemies[i]:IsAlive() then
								targetent = nearbyenemies[i]
								break
							end
						end
					end
					if targetent then
						local targets = {}
						local settozero = false
						local blocksound = false
						table.insert(targets, targetent)
						if self:GetStackCount() >= self.aoestacks and #nearbyenemies > self.minenemiesforaoe then
							for i=1,#nearbyenemies do
								table.insert(targets, nearbyenemies[i])
							end
							if #targets > 1 then
								settozero = true
							end
						end
						for j=1,#targets do
							local info = {
								Target = targets[j],
								Source = self:GetParent(),
								Ability = nil,
								EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
								bDodgeable = false,
								bProvidesVision = true,
								iMoveSpeed = 1000,
								iVisionRadius = 0,
								iVisionTeamNumber = self:GetParent():GetTeamNumber(),
								iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
							}
							ProjectileManager:CreateTrackingProjectile( info )
							if blocksound == false then
								EmitSoundOn("Hero_PhantomAssassin.Dagger.Cast", self:GetParent())
							end
							if #targets > 1 then
								blocksound = true
							end
							local traveltime = ((targets[j]:GetOrigin() - self:GetParent():GetOrigin()):Length2D())/1000
							Timers:CreateTimer(traveltime, function()
								if targets[j]:IsAlive() then
									local aoedmgmult = 1.0
									if #targets > 1 then
										aoedmgmult = self.aoedmgperc
									end
									local damageTable = {
										victim = targets[j],
										attacker = self:GetParent(),
										damage = self:GetParent():GetAttackDamage() * self.initialdamageperc * aoedmgmult,
										damage_type = DAMAGE_TYPE_PHYSICAL,
									}
									ApplyDamage(damageTable)
									targets[j]:AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_poison_dagger_debuff", {})
									EmitSoundOn("Hero_PhantomAssassin.Dagger.Target", targets[j])
								end
							end)
							if settozero == false then
								if (self:GetStackCount() - 1) >= 0 then
									self:SetStackCount(self:GetStackCount() - 1)
								end
								if self:GetRemainingTime() <= 0 then
									self:SetDuration( self.cooldown, true )
								end
							end
						end
						if settozero == true then
							if (self:GetStackCount() - self.aoestacks) >= 0 then
								self:SetStackCount(self:GetStackCount() - self.aoestacks)
							else
								self:SetStackCount(0)
							end
							if self:GetRemainingTime() <= 0 then
								self:SetDuration( self.cooldown, true )
							end
						end
					end
				end
			end
		end
	end
end

function modifier_vgmar_i_poison_dagger:OnTooltip()
	return self.clientvalues.cooldown
end

function modifier_vgmar_i_poison_dagger:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		if self:GetRemainingTime() <= 0 and self:GetStackCount() < self.maxstacks then
			if self:GetStackCount() + 1 < self.maxstacks then
				self:SetDuration( self.cooldown, true )
			end
			self:SetStackCount( self:GetStackCount() + 1 )
		end
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_i_poison_dagger_debuff = class({})

function modifier_vgmar_i_poison_dagger_debuff:GetTexture()
	return "queenofpain_shadow_strike"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_poison_dagger_debuff:IsHidden()
    return false
end

function modifier_vgmar_i_poison_dagger_debuff:IsDebuff()
	return true
end

function modifier_vgmar_i_poison_dagger_debuff:IsPurgable()
	return true
end

function modifier_vgmar_i_poison_dagger_debuff:RemoveOnDeath()
	return true
end

function modifier_vgmar_i_poison_dagger_debuff:DestroyOnExpire()
	return true
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_poison_dagger_debuff:OnCreated( kv )
	if IsServer() then
		local provider = self:GetCaster():FindModifierByName("modifier_vgmar_i_poison_dagger")
		self.damage = provider.damage
		self.duration = provider.duration
		self.interval = provider.interval
		self:SetDuration( self.duration, true )
		self:StartIntervalThink( self.interval )
		self.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_queenofpain/queen_shadow_strike_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self.particle2 = ParticleManager:CreateParticle("particles/items2_fx/orb_of_venom.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		--ParticleManager:SetParticleControl(self.particle, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
		ParticleManager:SetParticleControlForward(self.particle, 0, self:GetParent():GetForwardVector())
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_poison_dagger")
	end
end

function modifier_vgmar_i_poison_dagger_debuff:OnRefresh( kv )
	if IsServer() then
		local provider = self:GetCaster():FindModifierByName("modifier_vgmar_i_poison_dagger")
		self.duration = provider.duration
		self:SetDuration( self.duration, true )
	end
end

function modifier_vgmar_i_poison_dagger_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_poison_dagger_debuff:OnTooltip()
	if IsClient() then
		return (self.clientvalues.damage * ((math.floor(self:GetRemainingTime())) / self.clientvalues.interval))
	else
		return (self.damage * ((math.floor(self:GetRemainingTime())) / self.interval))
	end
end

function modifier_vgmar_i_poison_dagger_debuff:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
		self.particle = nil
		ParticleManager:DestroyParticle(self.particle2, true)
		ParticleManager:ReleaseParticleIndex(self.particle2)
		self.particle2 = nil
	end
end

function modifier_vgmar_i_poison_dagger_debuff:OnIntervalThink()
	if IsServer() then
		local damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_POISON_DAMAGE, self:GetParent(), self.damage, nil)
		ApplyDamage(damageTable)
	end
end