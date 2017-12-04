--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_vampiric_aura_effect = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_vampiric_aura_effect:GetTexture()
	return "custom/vampiric_aura"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_vampiric_aura_effect:IsHidden()
    return false
end

function modifier_vgmar_i_vampiric_aura_effect:IsDebuff()
	return false
end

function modifier_vgmar_i_vampiric_aura_effect:IsPurgable()
	return false
end

function modifier_vgmar_i_vampiric_aura_effect:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_vampiric_aura_effect:OnCreated( kv )
	if IsServer() then
		self.lspercent = self:GetCaster():FindModifierByName("modifier_vgmar_i_vampiric_aura").lspercent
		self.lspercentranged = self:GetCaster():FindModifierByName("modifier_vgmar_i_vampiric_aura").lspercentranged
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_vampiric_aura")
	end
end

function modifier_vgmar_i_vampiric_aura_effect:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_vampiric_aura_effect:OnTooltip()
	if self:GetParent():IsRangedAttacker() then
		return self.clientvalues.lspercentranged
	else
		return self.clientvalues.lspercent
	end
end

function modifier_vgmar_i_vampiric_aura_effect:OnAttackLanded( event )
	if IsServer() then
		if event.attacker == self:GetParent() and event.attacker:IsAlive() and not self:GetParent():IsIllusion() then
			if not self:GetParent():PassivesDisabled() then
				if event.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
					if not (event.target:IsTower() or event.target:IsBuilding()) then
						if event.attacker:IsRangedAttacker() then
							event.attacker:Heal((event.damage * self.lspercentranged) / 100, nil)
						else
							event.attacker:Heal((event.damage * self.lspercent) / 100, nil)
						end
						local particle = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, event.attacker)
						ParticleManager:ReleaseParticleIndex(particle)
					end
				end
			end
		end
	end
end

--------------------------------------------------------------------------------