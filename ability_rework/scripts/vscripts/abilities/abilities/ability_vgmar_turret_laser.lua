ability_vgmar_turret_laser = class({})

function ability_vgmar_turret_laser:OnAbilityPhaseStart()
	EmitSoundOn("Hero_Tinker.LaserAnim", self:GetCaster())
	return true
end

function ability_vgmar_turret_laser:OnAbilityPhaseInterrupted()
	StopSoundOn("Hero_Tinker.LaserAnim", self:GetCaster())
end

function ability_vgmar_turret_laser:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	EmitSoundOn("Hero_Tinker.Laser", caster)
	self.values = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_b_laser")
	
	self:FireLaser(target)
	
	
	local function BounceLaser(caster, startTarget, bRange)
		local laserTargets = FindUnitsInRadius(caster:GetTeamNumber(), startTarget:GetAbsOrigin(), nil, bRange * 4, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		endlaserTargets = {}
		for _, unit in ipairs(laserTargets) do
			if unit ~= startTarget then
				table.insert(endlaserTargets, unit)
			end
		end
		local oldTarget = startTarget
		for _, unit in ipairs(endlaserTargets) do
			if (unit:GetAbsOrigin() - oldTarget:GetAbsOrigin()):Length2D() <= bRange then
				self:FireLaser(unit, oldTarget)
				oldTarget = unit
			end
		end
	end
	BounceLaser(caster, target, self.values.bounce_range)
end

function ability_vgmar_turret_laser:FireLaser(target, oldTarget)
	local caster = self:GetCaster()
	
	local laserdamage = self.values.laser_damage
	local blindduration = self.values.laser_miss_duration

	ApplyDamage({
		victim = target,
		attacker = caster,
		ability = self,
		damage_type = DAMAGE_TYPE_PURE,
		damage = laserdamage
	})
	EmitSoundOn("Hero_Tinker.LaserImpact", target)
	target:AddNewModifier(caster, self, "modifier_vgmar_b_laser_miss", {duration = blindduration})
	
	local owner = oldTarget or caster
	local FX = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_laser.vpcf", PATTACH_POINT_FOLLOW, owner)

	ParticleManager:SetParticleControlEnt(FX, 9, owner, PATTACH_POINT_FOLLOW, "attach_hitloc", owner:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(FX, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	
	ParticleManager:ReleaseParticleIndex(FX)
end
