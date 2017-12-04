--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_critical_mastery = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_critical_mastery:GetTexture()
	return "phantom_assassin_coup_de_grace"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_critical_mastery:IsHidden()
    return false
end

function modifier_vgmar_i_critical_mastery:IsDebuff()
	return false
end

function modifier_vgmar_i_critical_mastery:IsPurgable()
	return false
end

function modifier_vgmar_i_critical_mastery:IsPermanent()
	return true
end

function modifier_vgmar_i_critical_mastery:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_critical_mastery:OnCreated( kv )
	if IsServer() then
		self.critdmgpercentage = kv.critdmgpercentage
		self.critchance = kv.critchance
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_critical_mastery")
	end
end

function modifier_vgmar_i_critical_mastery:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_critical_mastery:OnTooltip()
	return self.clientvalues.critdmgpercentage
end

function modifier_vgmar_i_critical_mastery:GetModifierPreAttack_CriticalStrike(kv)
	if IsServer() then
		if kv.attacker == self:GetParent() then
			if kv.target:IsBuilding() then 
				return end
			if kv.target:GetTeamNumber() == self:GetParent():GetTeamNumber() then
				return end
			if math.random(0,100) <= self.critchance then
				self.crit = true
				return self.critdmgpercentage
			end
		end
	end
end

function modifier_vgmar_i_critical_mastery:OnAttackLanded(kv)
	if self.crit == true and kv.attacker == self:GetParent() then
		local particle = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
		local soundevnt = "Hero_PhantomAssassin.CoupDeGrace"
		if kv.target:GetClassname() == "npc_dota_creep_siege" then
			particle = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_mechanical.vpcf"
			soundevnt = "Hero_PhantomAssassin.CoupDeGrace.Mech"
		else
			StartSoundEvent("Hero_PhantomAssassin.Spatter", kv.target)
		end
		local pfx = ParticleManager:CreateParticle(particle, PATTACH_POINT, kv.attacker)
		ParticleManager:SetParticleControl(pfx, 0, kv.target:GetAbsOrigin() + Vector(0,0,50))
		ParticleManager:SetParticleControl(pfx, 1, kv.target:GetAbsOrigin() + Vector(0,0,50))
		
		local line = kv.attacker:GetAbsOrigin() - kv.target:GetAbsOrigin()
		
		local damagepower = math.min(math.max(kv.damage / 2000, 0.5), 0.8)
		local circlecap = (Vector(line.x, line.y, 0)/line:Length2D())*2
		ParticleManager:SetParticleControlOrientation(pfx,0,circlecap*damagepower, Vector(0,0,0), Vector(0,0,0))
		ParticleManager:SetParticleControlOrientation(pfx,1,circlecap*damagepower, Vector(0,0,0), Vector(0,0,0))
		ParticleManager:ReleaseParticleIndex(pfx)
		StartSoundEvent(soundevnt, kv.target)
		self.crit = false
	end
end
--------------------------------------------------------------------------------