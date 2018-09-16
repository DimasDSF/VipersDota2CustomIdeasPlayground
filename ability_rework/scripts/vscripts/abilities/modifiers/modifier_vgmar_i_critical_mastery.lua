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
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_critical_mastery:OnAttackStart(kv)
	if IsServer() then
		if kv.attacker == self:GetParent() and kv.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and kv.target:IsBuilding() == false and kv.target:IsOther() == false then
			if math.random(0,100) <= self.critchance then
				kv.attacker:AddNewModifier(kv.attacker, self, "modifier_vgmar_i_critical_mastery_active", {critdmgpercentage = self.critdmgpercentage})
			end
		end
	end
end

function modifier_vgmar_i_critical_mastery:OnTooltip()
	return self.clientvalues.critdmgpercentage
end

------------------------------------------------------------------------------------

modifier_vgmar_i_critical_mastery_active = class({})

function modifier_vgmar_i_critical_mastery_active:IsHidden()
    return true
end

function modifier_vgmar_i_critical_mastery_active:IsDebuff()
	return false
end

function modifier_vgmar_i_critical_mastery_active:IsPurgable()
	return false
end

function modifier_vgmar_i_critical_mastery_active:RemoveOnDeath()
	return true
end

function modifier_vgmar_i_critical_mastery_active:OnCreated( kv )
	if IsServer() then
		self.critdmgpercentage = kv.critdmgpercentage
	end
end

function modifier_vgmar_i_critical_mastery_active:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end

function modifier_vgmar_i_critical_mastery_active:GetModifierPreAttack_CriticalStrike(kv)
	if kv.attacker == self:GetParent() and kv.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and kv.target:IsBuilding() == false and kv.target:IsOther() == false then
		return self.critdmgpercentage
	end
end

function modifier_vgmar_i_critical_mastery_active:OnAttackLanded(kv)
	if kv.attacker == self:GetParent() and kv.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() and kv.target:IsBuilding() == false and kv.target:IsOther() == false then
		local particle = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf"
		local soundevnt = "Hero_PhantomAssassin.CoupDeGrace"
		if kv.target:GetClassname() == "npc_dota_creep_siege" then
			particle = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_mechanical.vpcf"
			soundevnt = "Hero_PhantomAssassin.CoupDeGrace.Mech"
		else
			StartSoundEvent("Hero_PhantomAssassin.Spatter", kv.target)
		end
		local pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, kv.attacker)
		local aAO = kv.attacker:GetOrigin()
		local tAO = kv.target:GetOrigin()
		local AtTV = (tAO-aAO):Normalized()
		ParticleManager:SetParticleControlEnt( pfx, 0, kv.target, PATTACH_POINT_FOLLOW, "attach_hitloc", kv.target:GetOrigin(), true )
		ParticleManager:SetParticleControl( pfx, 1, kv.target:GetOrigin() )
		ParticleManager:SetParticleControlForward( pfx, 1, -AtTV )
		ParticleManager:SetParticleControlEnt( pfx, 10, kv.target, PATTACH_ABSORIGIN_FOLLOW, nil, kv.target:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( pfx )
		StartSoundEvent(soundevnt, kv.target)
	end
end
--------------------------------------------------------------------------------