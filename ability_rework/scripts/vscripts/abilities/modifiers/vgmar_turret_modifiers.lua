--All Modifiers used by Base Defence Turrets

--------------------------------------------------------------
modifier_vgmar_b_laser_miss = class({})
--------------------------------------------------------------
function modifier_vgmar_b_laser_miss:OnCreated(kv)
	self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_b_laser")
end

function modifier_vgmar_b_laser_miss:OnRefresh(kv)
	self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_b_laser")
end

function modifier_vgmar_b_laser_miss:DeclareFunctions()
	return {MODIFIER_PROPERTY_MISS_PERCENTAGE}
end

function modifier_vgmar_b_laser_miss:GetModifierMiss_Percentage()
	return self.clientvalues.misschance
end

function modifier_vgmar_b_laser_miss:GetEffectName()
	return "particles/units/heroes/hero_tinker/tinker_laser_debuff.vpcf"
end
--------------------------------------------------------------
--Turret Controller
--------------------------------------------------------------
modifier_vgmar_b_turret_ai = class({})
--------------------------------------------------------------

function modifier_vgmar_b_turret_ai:GetTexture()
	return "custom/ai"
end

function modifier_vgmar_b_turret_ai:IsHidden()
    return false
end

function modifier_vgmar_b_turret_ai:IsPurgable()
	return false
end

function modifier_vgmar_b_turret_ai:RemoveOnDeath()
	return false
end

function modifier_vgmar_b_turret_ai:DestroyOnExpire()
	return false
end

function modifier_vgmar_b_turret_ai:IsPermanent()
	return true
end

function modifier_vgmar_b_turret_ai:OnCreated(kv)
	if IsServer() then
		self.minlasertargets = kv.minlasertargets
		self.minmissiletargets = kv.minmissiletargets
		self.maxmissiletargets = kv.maxmissiletargets
		self.maxattackrate = kv.maxattackrate --0.10
		self.minattackrate = kv.minattackrate --1.5
		self.maxattackstacks = kv.maxattackstacks
		self.lasercd = kv.lasercd
		self.hsmcd = kv.hsmcd
		self.missilecooldown = 0
		self.lasercooldown = 0
		self.laser = self:GetParent():FindAbilityByName("ability_vgmar_turret_laser")
		self.hsm = self:GetParent():FindAbilityByName("ability_vgmar_turret_hsm")
		self.ammomod = self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_vgmar_b_turret_ammo", {maxammo = kv.maxammo, reloadtime = kv.reloadtime})
		self.lasercdmod = self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_vgmar_b_laser_cd", {})
		self.hsmcdmod = self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_vgmar_b_hsm_cd", {})
		if self.laser and self.laser:GetLevel() ~= 1 then
			self.laser:SetLevel(1)
		end
		if self.hsm and self.hsm:GetLevel() ~= 1 then
			self.hsm:SetLevel(1)
		end
		self:StartIntervalThink(0.5)
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_b_turret_ai")
	end
end

function modifier_vgmar_b_turret_ai:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		local function curtime() return GameRules:GetDOTATime(false, false) end
		local enemycreeps = {}
		local enemyheroes = {}
		for _, unit in ipairs( FindUnitsInRadius(parent:GetTeamNumber(), parent:GetAbsOrigin(), nil, parent:Script_GetAttackRange() + 10, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)) do
			if unit:IsHero() then
				table.insert(enemyheroes, unit)
			else
				table.insert(enemycreeps, unit)
			end
		end
		if (#enemycreeps + #enemyheroes) > 0 then
			--Laser Logic
			if curtime() > self.lasercooldown then
				if #enemyheroes > 0 and ((#enemycreeps + #enemyheroes) >= self.minlasertargets) then
					parent:SetCursorCastTarget(enemyheroes[1])
					self.lasercooldown = curtime() + self.lasercd
					self.lasercdmod:SetDuration(self.lasercd, true)
					self.laser:OnSpellStart()
				end
			end
			--HSM Logic
			if curtime() > self.missilecooldown then
				if #enemyheroes >= self.minmissiletargets then
					local targets = {}
					for i=1,math.min(self.maxmissiletargets, #enemyheroes) do
						if enemyheroes[i]:IsAlive() then
							table.insert(targets, enemyheroes[i])
						end
					end
					EmitSoundOn("Hero_Tinker.Heat-Seeking_Missile", parent)
					for _, target in ipairs(targets) do
						local proj = {
							Target = target,
							Source = parent,
							Ability = self.hsm,
							EffectName = "particles/units/heroes/hero_tinker/tinker_missile.vpcf",
							iMoveSpeed = 700,
							vSourceLoc= parent:GetAbsOrigin(),
							bDrawsOnMinimap = false,
							bDodgeable = false,
							bIsAttack = false,
							bVisibleToEnemies = true,
							bReplaceExisting = false,
							flExpireTime = GameRules:GetGameTime() + 10,
							bProvidesVision = false,
							iVisionRadius = 100,
							iVisionTeamNumber = parent:GetTeamNumber(),
							iSourceAttachment = 0
						}
						ProjectileManager:CreateTrackingProjectile(proj)
					end
					self.missilecooldown = curtime() + self.hsmcd
					self.hsmcdmod:SetDuration(self.hsmcd, true)
				end
			end
		end
		--AutoAttack Logic
		if parent:GetAttackTarget() ~= nil then
			if self:GetStackCount() + 1 <= self.maxattackstacks then
				self:IncrementStackCount()
			end
		else
			if self:GetStackCount() - 1 >= 0 and self:GetRemainingTime() <= 0 then
				self:DecrementStackCount()
			end
		end
	end
end

function modifier_vgmar_b_turret_ai:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK
    }
    return funcs
end

function modifier_vgmar_b_turret_ai:GetModifierBaseAttackTimeConstant()
	if IsServer() then
		return self.minattackrate - ((self.minattackrate - self.maxattackrate)/self.maxattackstacks)*self:GetStackCount()
	else
		return self.clientvalues.minattackrate - ((self.clientvalues.minattackrate - self.clientvalues.maxattackrate)/self.clientvalues.maxattackstacks)*self:GetStackCount()
	end
end

function modifier_vgmar_b_turret_ai:OnAttack(event)
	if event.attacker == self:GetParent() then
		self:SetDuration(3, true)
	end
end

--------------------------------------------------------------
modifier_vgmar_b_turret_ammo = class({})
--------------------------------------------------------------

function modifier_vgmar_b_turret_ammo:GetTexture()
	return "gyrocopter_flak_cannon"
end

function modifier_vgmar_b_turret_ammo:IsHidden()
    return false
end

function modifier_vgmar_b_turret_ammo:IsPurgable()
	return false
end

function modifier_vgmar_b_turret_ammo:RemoveOnDeath()
	return false
end

function modifier_vgmar_b_turret_ammo:DestroyOnExpire()
	return false
end

function modifier_vgmar_b_turret_ammo:IsPermanent()
	return true
end

function modifier_vgmar_b_turret_ammo:OnCreated(kv)
	if IsServer() then
		self.maxammo = kv.maxammo
		self.reloadtime = kv.reloadtime
		self.disarmed = false
		self:SetStackCount(self.maxammo)
		self:StartIntervalThink(1.0)
	end
end

function modifier_vgmar_b_turret_ammo:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK
	}
	
	return funcs
end

function modifier_vgmar_b_turret_ammo:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = self.disarmed,
	}
 
	return state
end

function modifier_vgmar_b_turret_ammo:OnIntervalThink()
	if IsServer() then
		if self:GetStackCount() <= 0 and self:GetRemainingTime() <= 0 then
			self:SetStackCount(self.maxammo)
			self:SetDuration(-1, true)
			EmitSoundOn("Hero_Tinker.Rearm", self:GetParent())
			self.disarmed = false
		end
	end
end

function modifier_vgmar_b_turret_ammo:OnAttack(event)
	if event.attacker == self:GetParent() then
		if self:GetStackCount() > 0 then
			self:DecrementStackCount()
		end
		if self:GetStackCount() < 1 then
			self.disarmed = true
			EmitSoundOn("Hero_Tinker.RearmStart", self:GetParent())
			self:SetDuration(self.reloadtime, true)
		end
	end
end
--------------------------------------------------------------

modifier_vgmar_b_laser_cd = class({})

function modifier_vgmar_b_laser_cd:GetTexture()
	return "tinker_laser"
end

function modifier_vgmar_b_laser_cd:IsHidden()
    return self:GetRemainingTime() <= 0
end

function modifier_vgmar_b_laser_cd:IsPurgable()
	return false
end

function modifier_vgmar_b_laser_cd:RemoveOnDeath()
	return false
end

function modifier_vgmar_b_laser_cd:DestroyOnExpire()
	return false
end

function modifier_vgmar_b_laser_cd:IsPermanent()
	return true
end

--------------------------------------------------------------

modifier_vgmar_b_hsm_cd = class({})

function modifier_vgmar_b_hsm_cd:GetTexture()
	return "tinker_heat_seeking_missile"
end

function modifier_vgmar_b_hsm_cd:IsHidden()
    return self:GetRemainingTime() <= 0
end

function modifier_vgmar_b_hsm_cd:IsPurgable()
	return false
end

function modifier_vgmar_b_hsm_cd:RemoveOnDeath()
	return false
end

function modifier_vgmar_b_hsm_cd:DestroyOnExpire()
	return false
end

function modifier_vgmar_b_hsm_cd:IsPermanent()
	return true
end

--------------------------------------------------------------

modifier_vgmar_b_turret_invulnerability = class({})

function modifier_vgmar_b_turret_invulnerability:IsHidden()
    return true
end

function modifier_vgmar_b_turret_invulnerability:IsPurgable()
	return false
end

function modifier_vgmar_b_turret_invulnerability:DestroyOnExpire()
	return true
end

function modifier_vgmar_b_turret_invulnerability:CheckState()
	local state = {
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
 
	return state
end