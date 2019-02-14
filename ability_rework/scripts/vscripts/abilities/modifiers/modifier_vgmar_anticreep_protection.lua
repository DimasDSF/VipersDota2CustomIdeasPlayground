modifier_vgmar_anticreep_protection = class({})

--------------------------------------------------------------------------------
function modifier_vgmar_anticreep_protection:GetTexture()
	return "custom/anticreep_prot"
end
--------------------------------------------------------------------------------

function modifier_vgmar_anticreep_protection:IsHidden()
	return false
end

function modifier_vgmar_anticreep_protection:IsPurgable()
	return false
end

function modifier_vgmar_anticreep_protection:DestroyOnExpire()
	return false
end

function modifier_vgmar_anticreep_protection:OnCreated(kv)
	if IsServer() then
		--kv
		self.radius = kv.radius
		self.strikeinterval = kv.strikeinterval
		self.activeduration = kv.activeduration
		self.dmgpercentpercreep = kv.dmgpercentpercreep
		self.goldbountyperc = kv.goldbountyperc/100
		--init
		self.striketimestamp = -1
		self.particle1 = nil
		self.particle1_1 = nil
		self.particle2 = nil
		self.cpsactive = false
		self:StartIntervalThink(0.5)
		self:SetDuration(-1, true)
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_anticreep_protection")
	end
end

function modifier_vgmar_anticreep_protection:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_anticreep_protection:OnTooltip()
	if IsServer() then
		return self.dmgpercentpercreep
	else
		return self.clientvalues.dmgpercentpercreep
	end
end

function modifier_vgmar_anticreep_protection:GetModifierProvidesFOWVision()
	if IsServer() then
		if self.cpsactive then
			return 1
		end
		return 0
	end
end

function modifier_vgmar_anticreep_protection:OnAttacked(kv)
	if IsServer() then
		if kv.target == self:GetParent() then
			local parent = self:GetParent()
			if GameRules:GetGameTime() > self.striketimestamp + self.strikeinterval then
				self.striketimestamp = GameRules:GetGameTime()
				local enemyheroes = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)
				if #enemyheroes < 1 then
					if self:GetRemainingTime() > 0 and self.cpsactive then
						local creeps = FindUnitsInRadius(parent:GetTeamNumber(), parent:GetOrigin(), nil, self.radius + 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, FIND_CLOSEST, false)
						local selectedcreeps = {}
						for i=1,#creeps do
							if creeps[i]:IsDominated() == false and creeps[i]:GetClassname() == "npc_dota_creep_lane" or creeps[i]:GetClassname() == "npc_dota_creep_siege" then
								table.insert(selectedcreeps, creeps[i])
							end
						end
						if #selectedcreeps > 0 then
							for j=1,#selectedcreeps do
								local creeppfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_static_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, selectedcreeps[j])
								ParticleManager:SetParticleControl(creeppfx,0,selectedcreeps[j]:GetAbsOrigin())
								local dmg = (selectedcreeps[j]:GetMaxHealth()/100) * (#selectedcreeps * self.dmgpercentpercreep)
								ApplyDamage({attacker = parent, victim = selectedcreeps[j], ability = nil, damage = dmg, damage_type = DAMAGE_TYPE_PURE})
							end
							EmitSoundOn("sounds/weapons/hero/zuus/static_field.vsnd", parent)
							parent:EmitSound("Hero_Zuus.ArcLightning.Cast")
							self:SetDuration(self.activeduration, true)
						end
					else
						--creating status particles
						--RainStorm
						if self.particle1 == nil then
							self.particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_rain_storm.vpcf", PATTACH_WORLDORIGIN, parent)
						end
						ParticleManager:SetParticleControl(self.particle1, 0, parent:GetAbsOrigin() + Vector(0,0,200))
						ParticleManager:SetParticleControl(self.particle1, 2, parent:GetAbsOrigin() + Vector(0,0,200))
						if self.particle1_1 == nil then
							self.particle1_1 = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_rain_storm.vpcf", PATTACH_WORLDORIGIN, parent)
						end
						ParticleManager:SetParticleControl(self.particle1_1, 0, parent:GetAbsOrigin() + Vector(0,0,200))
						ParticleManager:SetParticleControl(self.particle1_1, 2, parent:GetAbsOrigin() + Vector(0,0,200))
						--Orb
						if self.particle2 == nil then
							self.particle2 = ParticleManager:CreateParticle("particles/econ/items/outworld_devourer/od_shards_exile_gold/od_shards_exile_prison_top_orb_gold.vpcf", PATTACH_WORLDORIGIN, parent)
						end
						ParticleManager:SetParticleControl(self.particle2, 0, parent:GetAbsOrigin() + Vector(0,0,350))
						--Lightning
						parent:EmitSound("Hero_Razor.Storm.Cast")
						parent:EmitSound("Hero_Razor.Storm.Loop")
						local particle3 = ParticleManager:CreateParticle("particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf", PATTACH_POINT_FOLLOW, parent)
						ParticleManager:SetParticleControl(particle3, 0, parent:GetAbsOrigin() + Vector(0,0,400))
						parent:EmitSound("Hero_Zuus.LightningBolt")
						ParticleManager:ReleaseParticleIndex(particle3)
						--Activating
						self:SetDuration(self.activeduration, true)
						self.cpsactive = true
					end
				end
			end
		end
	end
end

function modifier_vgmar_anticreep_protection:OnDeath(kv)
	if IsServer() then
		if kv.attacker == self:GetParent() then
			local direheroes = GameRules.VGMAR.direheroes
			local endgold = math.ceil((kv.unit:GetGoldBounty() * self.goldbountyperc)/#direheroes)
			for i,v in ipairs(direheroes) do
				v:ModifyGold(endgold, false, 0)
			end
		end
	end
end

function modifier_vgmar_anticreep_protection:OnIntervalThink()
	if IsServer() then
		if self:GetRemainingTime() <= 0 then
			if self.cpsactive then
				if self.particle1 ~= nil then
					ParticleManager:DestroyParticle(self.particle1, false)
					ParticleManager:ReleaseParticleIndex(self.particle1)
					self.particle1 = nil
				end
				if self.particle1_1 ~= nil then
					ParticleManager:DestroyParticle(self.particle1_1, false)
					ParticleManager:ReleaseParticleIndex(self.particle1_1)
					self.particle1_1 = nil
				end
				if self.particle2 ~= nil then
					ParticleManager:DestroyParticle(self.particle2, false)
					ParticleManager:ReleaseParticleIndex(self.particle2)
					self.particle2 = nil
				end
				self:GetParent():StopSound("Hero_Razor.Storm.Loop")
				self:SetDuration(-1, true)
				self.cpsactive = false
			end
		end
	end
end