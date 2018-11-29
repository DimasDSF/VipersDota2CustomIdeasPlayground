--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_greatcleave = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_greatcleave:GetTexture()
	return "custom/greatcleave"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_greatcleave:IsHidden()
    return false
end

function modifier_vgmar_i_greatcleave:IsDebuff()
	return false
end

function modifier_vgmar_i_greatcleave:IsPurgable()
	return false
end

function modifier_vgmar_i_greatcleave:IsPermanent()
	return true
end

function modifier_vgmar_i_greatcleave:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_greatcleave:OnCreated( kv )
	if IsServer() then
		self.cleaveperc = kv.cleaveperc
		self.cleavestartrad = kv.cleavestartrad
		self.cleaveendrad = kv.cleaveendrad
		self.cleaveradius = kv.cleaveradius
		self.bonusdamage = kv.bonusdamage
		self.manaregen = kv.manaregen
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_greatcleave")
	end
end

function modifier_vgmar_i_greatcleave:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_greatcleave:OnTooltip()
	return self.clientvalues.cleaveperc
end

function modifier_vgmar_i_greatcleave:GetModifierConstantManaRegen()
	if not IsServer() then
		return self.clientvalues.manaregen
	else
		return self.manaregen
	end
end

function modifier_vgmar_i_greatcleave:GetModifierBaseAttack_BonusDamage()
	if self:GetParent():IsRangedAttacker() == false then
		if IsServer() then
			return self.bonusdamage
		else
			return self.clientvalues.bonusdamage
		end
	end
end

function modifier_vgmar_i_greatcleave:OnAttackLanded( event )
	if IsServer() then
		if event.attacker == self:GetParent() and not self:GetParent():IsIllusion() then
			if self:GetParent():IsRangedAttacker() == false and not self:GetParent():PassivesDisabled() then
				if event.target:IsRealUnit(false) then
					if event.target:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
						local cleaveDamage = ( self.cleaveperc * event.damage ) / 100
						local particle = nil
						local dist = (self:GetParent():GetAbsOrigin() - event.target:GetAbsOrigin()):Length2D()
						if cleaveDamage < 400 then
							particle = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave.vpcf"
						elseif cleaveDamage >= 400 and cleaveDamage < 1500 then
							particle = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_crit.vpcf"
						elseif cleaveDamage >= 1500 and cleaveDamage < 3000 then
							particle = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength.vpcf"
						elseif cleaveDamage >= 3000 then
							particle = "particles/econ/items/sven/sven_ti7_sword/sven_ti7_sword_spell_great_cleave_gods_strength_crit.vpcf"
						end
						local direction = (event.target:GetAbsOrigin() - event.attacker:GetAbsOrigin()):Normalized()
						local damageInfo = {
							damage = cleaveDamage,
							type = DAMAGE_TYPE_PHYSICAL
						}
						Extensions:DoCleaveAttackPositional(self:GetParent(), event.target, event.target:GetAbsOrigin(), direction, true, damageInfo, self.cleavestartrad, self.cleaveendrad, self.cleaveradius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, particle)
						self:GetParent():EmitSound("DOTA_Item.BattleFury")
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------