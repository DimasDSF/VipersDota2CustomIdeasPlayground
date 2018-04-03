--A modifier used as a visualisation for a custom spell

modifier_vgmar_i_essence_aura_effect = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_i_essence_aura_effect:GetTexture()
	return "obsidian_destroyer_essence_aura"
end

--------------------------------------------------------------------------------

function modifier_vgmar_i_essence_aura_effect:IsHidden()
    return false
end

function modifier_vgmar_i_essence_aura_effect:IsPurgable()
	return false
end

function modifier_vgmar_i_essence_aura_effect:RemoveOnDeath()
	return true
end

function modifier_vgmar_i_essence_aura_effect:OnCreated(kv) 
	if IsServer() then
		local provider = self:GetCaster()
		local aura = provider:FindModifierByName("modifier_vgmar_i_essence_aura")
		self.restorechancemax = math.min(100, aura.restorechancemax)
		self.restorechancemin = math.max(0, aura.restorechancemin)
		self.restoremax = aura.restoremax
		self.restoremin = aura.restoremin
		self.restoreamount = aura.restoreamount
	else
		self.clientvalues = CustomNetTables:GetTableValue("client_side_ability_values", "modifier_vgmar_i_essence_aura")
	end
end

function modifier_vgmar_i_essence_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_TOOLTIP
    }
    return funcs
end

function modifier_vgmar_i_essence_aura_effect:OnTooltip()
	return self.clientvalues.restoreamount
end

function modifier_vgmar_i_essence_aura_effect:OnAbilityExecuted(kv)
	if IsServer() then
		local parent = self:GetParent()
		if kv.unit == parent then
			if kv.ability and kv.ability:IsToggle() == false and kv.ability:IsItem() == false and (GameRules.VGMAR.essenceauraignoredabilities[kv.ability:GetName()] == nil or GameRules.VGMAR.essenceauraignoredabilities[kv.ability:GetName()] ~= true) then
				local restorechance = math.scale(self.restorechancemax, math.map(math.clamp(self.restoremin, parent:GetMana()/parent:GetMaxMana(), self.restoremax), self.restoremin, self.restoremax, 0, 1), self.restorechancemin)
				--print("self.restorechancemax: "..self.restorechancemax.." self.restorechancemin: "..self.restorechancemin.." self.restoremin: "..self.restoremin.." self.restoremax: "..self.restoremax.." restorechance: "..restorechance)
				if math.random(0, 100) <= restorechance then
					local restoredmana = math.floor((parent:GetMaxMana() / 100) * self.restoreamount)
					if parent:GetMana() + restoredmana > parent:GetMaxMana() then
						parent:SetMana(parent:GetMaxMana())
					else
						parent:SetMana(parent:GetMana()+restoredmana)
					end
					local prt = ParticleManager:CreateParticle('particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_essence_effect.vpcf', PATTACH_ABSORIGIN_FOLLOW, parent)
					ParticleManager:ReleaseParticleIndex(prt)
					EmitSoundOn('Hero_ObsidianDestroyer.EssenceAura', parent)
				end
			end
		end	
	end
end
--------------------------------------------------------------------------------