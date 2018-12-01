--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_poison_dagger = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_poison_dagger:GetTexture()
	return "custom/mana_dagger"
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
		self.potencycooldown = kv.potencycooldown
		self.agiperpotency = kv.agiperpotency
		self.maxdistance = kv.maxdistance
		self.hitdamageperc = kv.hitdamageperc / 100
		self.manaloss = kv.manaloss
		self.durationperpot = kv.durationperpot
		self.manacostperc = kv.manacostperc / 100
		self.dmgpermana = kv.dmgpermana
		self.nomanadmgmult = kv.nomanadmgmult
		self.ticktime = kv.ticktime
		self.bonusagi = kv.bonusagi
		self.bonusmisschance = kv.bonusmisschance
		self.daggerspeed = kv.daggerspeed
		self.stacks = 0
		self:SetStackCount( 0 )
		self:SetDuration( self.cooldown, true )
		self:StartIntervalThink( 0.25 )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_poison_dagger")
	end
end

function modifier_vgmar_i_poison_dagger:GetModifierBonusStats_Agility()
	if IsServer() then
		return self.bonusagi
	else
		return self.clientvalues.bonusagi
	end
end

function modifier_vgmar_i_poison_dagger:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_EVASION_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_poison_dagger:GetModifierEvasion_Constant()
	if IsServer() then
		return self.bonusmisschance
	else
		return self.clientvalues.bonusmisschance
	end
end

function modifier_vgmar_i_poison_dagger:OnOrder(event)
	if IsServer() then
		if event.unit == self:GetParent() then
			if event.order_type == 4 and self:GetStackCount() > 0 and event.target ~= nil then
				if event.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and event.target:IsHero() then
					if (event.unit:GetAbsOrigin() - event.target:GetAbsOrigin()):Length2D() <= self.maxdistance and (event.unit:IsStunned() == false and event.unit:IsHexed() == false and event.unit:IsDisarmed() == false) then
						local target = event.target
						local info = {
							Target = target,
							Source = self:GetParent(),
							Ability = nil,
							EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
							bDodgeable = false,
							bProvidesVision = true,
							iMoveSpeed = self.daggerspeed,
							iVisionRadius = 100,
							iVisionTeamNumber = self:GetParent():GetTeamNumber(),
							iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
						}
						ProjectileManager:CreateTrackingProjectile( info )
						EmitSoundOn("Hero_PhantomAssassin.Dagger.Cast", self:GetParent())
						local traveltime = ((target:GetOrigin() - self:GetParent():GetOrigin()):Length2D())/self.daggerspeed
						self:SetDuration( self.cooldown, true )
						self.stacks = self:GetStackCount()
						self:SetStackCount(0)
						Timers:CreateTimer(traveltime, function()
							if target:IsAlive() then
								local damageTable = {
									victim = target,
									attacker = self:GetParent(),
									damage = self:GetParent():GetAttackDamage() * self.hitdamageperc,
									damage_type = DAMAGE_TYPE_PHYSICAL,
								}
								ApplyDamage(damageTable)
								target:AddNewModifier(self:GetParent(), nil, "modifier_vgmar_i_poison_dagger_debuff", {stacks = self.stacks})
								self.stacks = 0
								EmitSoundOn("Hero_PhantomAssassin.Dagger.Target", target)
							end
						end)
					end
				end
			end
		end
	end
end

function modifier_vgmar_i_poison_dagger:OnTooltip()
	return self.clientvalues.durationperpot * self:GetStackCount()
end

function modifier_vgmar_i_poison_dagger:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local maxstacks = math.floor(parent:GetAgility() / self.agiperpotency)
		if self:GetRemainingTime() <= 0 and self:GetStackCount() < maxstacks and parent:IsAlive() then
			self:SetDuration( self.potencycooldown, true )
			self:SetStackCount( self:GetStackCount() + 1 )
		end
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_i_poison_dagger_debuff = class({})

function modifier_vgmar_i_poison_dagger_debuff:GetTexture()
	return "custom/mana_dagger"
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
		self:SetStackCount(kv.stacks)
		self.duration = provider.durationperpot * self:GetStackCount()
		self.manaloss = provider.manaloss
		self.manacostperc = provider.manacostperc
		self.dmgpermana = provider.dmgpermana
		self.nomanadmgmult = provider.nomanadmgmult
		self.ticktime = provider.ticktime
		self:SetDuration( self.duration, true )
		self:StartIntervalThink( self.ticktime )
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
		if kv.stacks > self:GetStackCount() then
			self:SetStackCount(kv.stacks)
		end
		if (provider.durationperpot * self:GetStackCount()) > self:GetRemainingTime() then
			self.duration = provider.durationperpot * self:GetStackCount()
			self:SetDuration( self.duration, true )
		end
	end
end

function modifier_vgmar_i_poison_dagger_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_EVENT_ON_SPENT_MANA
    }
    return funcs
end

function modifier_vgmar_i_poison_dagger_debuff:OnSpentMana( event )
	if IsServer() then
		if event.unit == self:GetParent() and event.cost > 0 then
			--TODO: Test new mana value
			self:GetParent():ReduceMana(event.cost * (self.manacostperc * self:GetStackCount()))
			local dmg = math.ceil((event.cost + (event.cost * (self.manacostperc * self:GetStackCount()))) * (self.dmgpermana * self:GetStackCount()))
			local damageTable = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = dmg,
				damage_type = DAMAGE_TYPE_MAGICAL,
			}
			StartSoundEvent("Hero_Antimage.ManaBreak", self:GetParent())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), dmg, nil)
			ApplyDamage(damageTable)
		end
	end
end

function modifier_vgmar_i_poison_dagger_debuff:GetModifierProvidesFOWVision()
	if IsServer() then
		if self:GetParent():IsInvisible() == false then
			return 1
		end
		return 0
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
		local parent = self:GetParent()
		local damageTableDoT = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = 10,
			damage_type = DAMAGE_TYPE_MAGICAL,
		}
		ApplyDamage(damageTableDoT)
		if parent:GetMana() >= self.manaloss * self:GetStackCount() then
			parent:ReduceMana(self.manaloss * self:GetStackCount())
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, self:GetParent(), self.manaloss * self:GetStackCount(), nil)
		else
			local mana = parent:GetMana()
			local dmg = ((self.manaloss * self:GetStackCount()) - mana) * self.nomanadmgmult
			local manadamageTableDoT = {
				victim = self:GetParent(),
				attacker = self:GetCaster(),
				damage = dmg,
				damage_type = DAMAGE_TYPE_MAGICAL,
			}
			ApplyDamage(manadamageTableDoT)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), dmg, nil)
			SendOverheadEventMessage(nil, OVERHEAD_ALERT_MANA_LOSS, self:GetParent(), mana, nil)
			parent:ReduceMana(mana)
		end
	end
end