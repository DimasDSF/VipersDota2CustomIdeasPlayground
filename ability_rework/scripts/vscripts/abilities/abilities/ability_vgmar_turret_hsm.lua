ability_vgmar_turret_hsm = class({})

function ability_vgmar_turret_hsm:OnProjectileHit(target, location)
	local caster = self:GetCaster()
	if target ~= nil and ( not target:IsInvulnerable() ) then
		EmitSoundOn("Hero_Tinker.Heat-Seeking_Missile.Impact", target)
		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_missle_explosion.vpcf", PATTACH_ABSORIGIN, target)
		ParticleManager:ReleaseParticleIndex(pfx)
		local values = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_b_hsmissile")
		local targets = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, values.splashradius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		ApplyDamage({
			victim = target,
			attacker = caster,
			ability = self,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage = values.dmg
		})
		for _, unit in ipairs(targets) do
			if unit ~= target then
				ApplyDamage({
					victim = unit,
					attacker = caster,
					ability = self,
					damage_type = DAMAGE_TYPE_MAGICAL,
					damage = values.dmgsplash
				})
			end
		end
	end
	return true
end
