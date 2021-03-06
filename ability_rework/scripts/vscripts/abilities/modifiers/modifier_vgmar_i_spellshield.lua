--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_spellshield = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_spellshield:GetTexture()
	return "antimage_spell_shield"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_spellshield:IsHidden()
    return false
end

function modifier_vgmar_i_spellshield:IsDebuff()
	return false
end

function modifier_vgmar_i_spellshield:IsPurgable()
	return false
end

function modifier_vgmar_i_spellshield:RemoveOnDeath()
	return false
end

function modifier_vgmar_i_spellshield:DestroyOnExpire()
	return false
end

function modifier_vgmar_i_spellshield:IsPermanent()
	return true
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_spellshield:OnCreated( kv )
	if IsServer() then
		self.cooldown = kv.cooldown
		self.maxstacks = kv.maxstacks
		self.resistance = kv.resistance
		self:SetStackCount( 0 )
		self:SetDuration( self.cooldown, true )
		self:StartIntervalThink( 0.25 )
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_spellshield")
	end
end

function modifier_vgmar_i_spellshield:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_spellshield:GetModifierMagicalResistanceBonus()
	if IsServer() then
		return self.resistance
	else
		return self.clientvalues.resistance
	end
end

function modifier_vgmar_i_spellshield:OnAbilityFullyCast( event )
	if IsServer() then
		if event.unit == self:GetCaster() then
			local hAbility = event.ability
			if hAbility ~= nil then
				if hAbility:GetName() == "item_refresher" or hAbility:GetName() == "item_refresher_shard" then
					self:SetStackCount( 2 )
					self:SetDuration( 0, true)
				end
			end
		end
	end
end

function modifier_vgmar_i_spellshield:OnTooltip()
	return self.clientvalues.cooldown
end

function modifier_vgmar_i_spellshield:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
		if self:GetStackCount() > 0 then
			local ignorestun = false
			local ignoreroot = false
			local ignoresilence = false
			for k,v in pairs(GameRules.VGMAR.spellshieldpurgeignore) do
				if parent:FindModifierByName(k) ~= nil then
					ignorestun = ignorestun or v.stun
					ignoreroot = ignoreroot or v.root
					ignoresilence = ignoresilence or v.silence
				end
			end
			if (((parent:IsHexed()) or (parent:IsSilenced() and ignoresilence == false) or (parent:IsStunned() and ignorestun == false) or (parent:IsRooted() and ignoreroot == false)) and parent:PassivesDisabled() == false) then
				self:SetStackCount( self:GetStackCount() - 1 )
				if self:GetRemainingTime() <= 0 then
					self:SetDuration( self.cooldown, true )
				end
				local pfx = ParticleManager:CreateParticle("particles/items4_fx/combo_breaker_spell.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
				ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin() + Vector(0,0,0))
				ParticleManager:SetParticleControl(pfx, 1, self:GetParent():GetAbsOrigin() + Vector(0,0,70))
				local pfx2 = ParticleManager:CreateParticle("particles/econ/items/outworld_devourer/od_shards_exile/od_shards_exile_prison_end.vpcf" , PATTACH_ROOTBONE_FOLLOW, self:GetParent())
				ParticleManager:ReleaseParticleIndex(pfx)
				ParticleManager:ReleaseParticleIndex(pfx2)
				EmitSoundOn("Item.LotusOrb.Destroy", self:GetParent())
				EmitSoundOn("DOTA_Item.Nullifier.Slow", self:GetParent())
				parent:Purge(false, true, false, true, false)
				if self:GetStackCount() < 1 and parent:HasModifier("modifier_vgmar_i_spellshield_active") then
					parent:FindModifierByName("modifier_vgmar_i_spellshield_active"):Destroy()
				end
			end
		end
		if self:GetRemainingTime() <= 0 and self:GetStackCount() < self.maxstacks and parent:PassivesDisabled() == false then
			if self:GetStackCount() + 1 < self.maxstacks then
				self:SetDuration( self.cooldown, true )
			end
			self:SetStackCount( self:GetStackCount() + 1 )
		end
		
		if self:GetStackCount() >= 1 and parent:PassivesDisabled() == false then
			if not parent:HasModifier("modifier_vgmar_i_spellshield_active") then
				parent:AddNewModifier(parent, nil, "modifier_vgmar_i_spellshield_active", {})
			end
		end
	end
end

--------------------------------------------------------------------------------

modifier_vgmar_i_spellshield_active = class({})

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function modifier_vgmar_i_spellshield_active:IsHidden()
    return true
end

function modifier_vgmar_i_spellshield_active:IsDebuff()
	return false
end

function modifier_vgmar_i_spellshield_active:IsPurgable()
	return false
end

function modifier_vgmar_i_spellshield_active:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function modifier_vgmar_i_spellshield_active:OnCreated( kv )
	if IsServer() then
		self.cooldown = self:GetParent():FindModifierByName("modifier_vgmar_i_spellshield").cooldown
	end
end

function modifier_vgmar_i_spellshield_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ABSORB_SPELL
    }
    return funcs
end

function modifier_vgmar_i_spellshield_active:GetAbsorbSpell(kv)
	if IsServer() then
		if self:GetParent():PassivesDisabled() == false then
			if kv.ability:GetCaster():GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
				local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield.vpcf", PATTACH_ROOTBONE_FOLLOW, self:GetParent())
				local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_antimage/antimage_spellshield_reflect.vpcf" , PATTACH_ROOTBONE_FOLLOW, self:GetParent())
				ParticleManager:ReleaseParticleIndex(pfx)
				ParticleManager:ReleaseParticleIndex(pfx2)
				EmitSoundOn("Item.LotusOrb.Target", self:GetParent())
				EmitSoundOn("Hero_Antimage.Counterspell.Target", self:GetParent())
				Extensions:CastAbilityThroughADummy(kv.ability, self:GetParent(), kv.ability:GetCaster())
				self:GetParent():FindModifierByName("modifier_vgmar_i_spellshield"):SetStackCount( self:GetParent():FindModifierByName("modifier_vgmar_i_spellshield"):GetStackCount() - 1 )
				if self:GetParent():FindModifierByName("modifier_vgmar_i_spellshield"):GetRemainingTime() <= 0 then
					self:GetParent():FindModifierByName("modifier_vgmar_i_spellshield"):SetDuration( self.cooldown, true )
				end
				if self:GetParent():FindModifierByName("modifier_vgmar_i_spellshield"):GetStackCount() < 1 then
					self:Destroy()
				end
				return 1
			end
		else
			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------