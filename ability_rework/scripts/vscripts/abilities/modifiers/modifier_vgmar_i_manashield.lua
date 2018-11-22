--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_manashield = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_manashield:GetTexture()
	return "custom/manashield"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_manashield:IsHidden()
    return false
end

function modifier_vgmar_i_manashield:IsDebuff()
	return false
end

function modifier_vgmar_i_manashield:IsPurgable()
	return false
end

function modifier_vgmar_i_manashield:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_manashield:DestroyOnExpire()
	return false
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_manashield:OnCreated( kv )
	if IsServer() then
		--kv
		self.minmana = kv.minmana
		self.lowmana = kv.lowmana
		self.maxtotalmana = kv.maxtotalmana
		self.mindmgfraction = kv.mindmgfraction/100
		self.maxdmgfraction = kv.maxdmgfraction/100
		self.stunradius = kv.stunradius
		self.stunduration = kv.stunduration
		self.stundamage = kv.stundamage
		self.rechargetime = kv.rechargetime
		self.bonusarmor = kv.bonusarmor
		self.bonusint = kv.bonusint
		self:SetDuration(self.rechargetime, true)
		--init
		self.shieldparticle = nil
		self:StartIntervalThink( 0.5 )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_manashield")
	end
end

function modifier_vgmar_i_manashield:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_SPENT_MANA,
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
    return funcs
end

function modifier_vgmar_i_manashield:GetModifierBonusStats_Intellect()
	if IsServer() then
		return self.bonusint
	else
		return self.clientvalues.bonusint
	end
end

function modifier_vgmar_i_manashield:GetModifierPhysicalArmorBonus()
	if IsServer() then
		return self.bonusarmor
	else
		return self.clientvalues.bonusarmor
	end
end

function modifier_vgmar_i_manashield:OnSpentMana( event )
	if IsServer() then
		if event.unit == self:GetParent() then
			local parent = self:GetParent()
			if self.shieldparticle ~= nil then
				if parent:GetMana()/parent:GetMaxMana() < self.minmana then
					ParticleManager:DestroyParticle(self.shieldparticle, false)
					ParticleManager:ReleaseParticleIndex(self.shieldparticle)
					self.shieldparticle = nil
					StartSoundEvent("Hero_Medusa.ManaShield.Off", parent)
					self:SetDuration(0.1, true)
				end
			end
		end
	end
end

function modifier_vgmar_i_manashield:OnTakeDamage( event )
	if IsServer() then
		if event.unit == self:GetParent() and event.attacker:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			local parent = self:GetParent()
			if self.shieldparticle ~= nil then
				if parent:PassivesDisabled() then
					ParticleManager:DestroyParticle(self.shieldparticle, false)
					ParticleManager:ReleaseParticleIndex(self.shieldparticle)
					self.shieldparticle = nil
					StartSoundEvent("Hero_Medusa.ManaShield.Off", parent)
					if self:GetRemainingTime() <= 0 then
						self:SetDuration(0.1, true)
					end
				end
				if parent:GetMana()/parent:GetMaxMana() >= self.minmana then
					local dmgfraction = self.maxdmgfraction
					if self.minmana * parent:GetMaxMana() < self.maxtotalmana then
						dmgfraction = math.mapl(parent:GetMana(), self.minmana * parent:GetMaxMana(), self.maxtotalmana, self.mindmgfraction, self.maxdmgfraction)
					end
					--print("[Mana Shield] Damage Fraction: "..dmgfraction)
					--print("[Mana Shield] Mana Spent: "..event.damage)
					parent:SetHealth(parent:GetHealth() + event.damage * dmgfraction)
					parent:SetMana(parent:GetMana() - (event.damage * dmgfraction))
					StartSoundEvent("Hero_Medusa.ManaShield.Proc", parent)
					if parent:GetMana()/parent:GetMaxMana() < self.lowmana then
						local lowmanapfx = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/am_manaburn_basher_ti_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
						StartSoundEvent("Hero_Antimage.ManaBreak", parent)
						ParticleManager:ReleaseParticleIndex(lowmanapfx)
					end
				end
				if parent:GetMana()/parent:GetMaxMana() < self.minmana then
					local oompfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect_energy.vpcf", PATTACH_ROOTBONE_FOLLOW, self:GetParent())
					local oompfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield_oom.vpcf", PATTACH_ROOTBONE_FOLLOW, self:GetParent())
					local oompfx3 = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/antimage_manavoid_ti_5.vpcf", PATTACH_ROOTBONE_FOLLOW, self:GetParent())
					StartSoundEvent("Hero_Antimage.ManaVoid", parent)
					local enemiesnearby = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, self.stunradius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 1, false)
					if #enemiesnearby > 0 then
						local groundpfx = ParticleManager:CreateParticle("particles/econ/items/zeus/lightning_weapon_fx/zuus_lightning_bolt_castfx_ground2.vpcf", PATTACH_ABSORIGIN, self:GetParent())
						ParticleManager:ReleaseParticleIndex(groundpfx)
						for i=1,#enemiesnearby do
							enemiesnearby[i]:AddNewModifier(parent, nil, "modifier_vgmar_i_manashield_stun", {duration = self.stunduration})
						end
					end
					if event.attacker:IsAlive() and event.attacker:IsBuilding() == false then
						local lightningpfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
						ParticleManager:SetParticleControl(lightningpfx, 0, parent:GetAbsOrigin() + Vector(0,0,50))
						ParticleManager:SetParticleControl(lightningpfx, 1, event.attacker:GetAbsOrigin() + Vector(0,0,50))
						ParticleManager:ReleaseParticleIndex(lightningpfx)
						event.attacker:AddNewModifier(parent, nil, "modifier_vgmar_i_manashield_stun", {duration = self.stunduration})
					end
					ParticleManager:DestroyParticle(self.shieldparticle, false)
					ParticleManager:ReleaseParticleIndex(self.shieldparticle)
					self.shieldparticle = nil
					self:SetDuration(self.rechargetime, true)
					ParticleManager:ReleaseParticleIndex(oompfx1)
					ParticleManager:ReleaseParticleIndex(oompfx2)
					ParticleManager:ReleaseParticleIndex(oompfx3)
				end
			end
		end
	end
end

function modifier_vgmar_i_manashield:OnAbilityFullyCast( event )
	if IsServer() then
		if event.unit == self:GetParent() then
			local hAbility = event.ability
			if hAbility ~= nil then
				if hAbility:GetName() == "item_refresher" or hAbility:GetName() == "item_refresher_shard" then
					if self:GetRemainingTime() > 0 then
						self:SetDuration(0.1, true)
					end
				end
			end
		end
	end
end

function modifier_vgmar_i_manashield:OnIntervalThink()
	local parent = self:GetParent()
	if parent:GetMana()/parent:GetMaxMana() >= self.minmana and self.shieldparticle == nil and self:GetRemainingTime() <= 0 and parent:IsAlive() and parent:PassivesDisabled() == false then
		self.shieldparticle = ParticleManager:CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		StartSoundEvent("Hero_Medusa.ManaShield.On", parent)
		self:SetDuration(-1, true)
	elseif self.shieldparticle ~= nil and parent:PassivesDisabled() then
		ParticleManager:DestroyParticle(self.shieldparticle, false)
		ParticleManager:ReleaseParticleIndex(self.shieldparticle)
		self.shieldparticle = nil
		StartSoundEvent("Hero_Medusa.ManaShield.Off", parent)
		if self:GetRemainingTime() <= 0 then
			self:SetDuration(0.1, true)
		end
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_i_manashield_stun = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_manashield_stun:GetTexture()
	return "custom/manashield"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_manashield_stun:IsHidden()
    return false
end

function modifier_vgmar_i_manashield_stun:IsDebuff()
	return true
end

function modifier_vgmar_i_manashield_stun:IsPurgable()
	return true
end

function modifier_vgmar_i_manashield_stun:RemoveOnDeath()
	return true
end

function modifier_vgmar_i_manashield_stun:DestroyOnExpire()
	return true
end

function modifier_vgmar_i_manashield_stun:OnCreated()
	if IsServer() then
		local provider = self:GetCaster():FindModifierByName("modifier_vgmar_i_manashield")
		self.stundamage = provider.stundamage
		self.particle = ParticleManager:CreateParticle("particles/econ/courier/courier_platinum_roshan/platinum_roshan_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.particle, 16, Vector(1,0,0))
		ParticleManager:SetParticleControl(self.particle, 2, Vector(170,230,255))
		ParticleManager:SetParticleControl(self.particle, 15, Vector(170,230,255))
		self:AddParticle(self.particle, true, false, 0, false, false)
	end
end

function modifier_vgmar_i_manashield_stun:OnRemoved()
	if IsServer() then
		ApplyDamage({victim = self:GetParent(), attacker = self:GetCaster(), ability = nil, damage = self.stundamage, damage_type = DAMAGE_TYPE_MAGICAL})
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, self:GetParent(), self.stundamage, nil)
	end
end

function modifier_vgmar_i_manashield_stun:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
    }
    return funcs
end

function modifier_vgmar_i_manashield_stun:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

function modifier_vgmar_i_manashield_stun:GetActivityTranslationModifiers()
	return "stunned"
end

function modifier_vgmar_i_manashield_stun:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end