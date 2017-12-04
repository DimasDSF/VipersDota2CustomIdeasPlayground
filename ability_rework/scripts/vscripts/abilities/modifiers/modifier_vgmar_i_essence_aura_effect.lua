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
		self.restorechance = aura.restorechance
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
			local ignoredabilities = {
				nyx_assassin_burrow = true,
				nyx_assassin_unburrow = true,
				spectre_reality = true,
				techies_focused_detonate = true,
				furion_teleportation = true,
				life_stealer_consume = true,
				life_stealer_assimilate_eject = true,
				winter_wyvern_arctic_burn = true,
				invoker_quas = true,
				invoker_wex = true,
				invoker_exort = true,
				shadow_demon_shadow_poison_release = true,
				alchemist_unstable_concoction_throw = true,
				ancient_apparition_ice_blast_release = true,
				bane_nightmare_end = true,
				bloodseeker_bloodrage = true,
				centaur_double_edge = true,
				clinkz_searing_arrows = true,
				doom_bringer_infernal_blade = true,
				drow_ranger_trueshot = true,
				earth_spirit_stone_caller = true,
				elder_titan_return_spirit = true,
				ember_spirit_fire_remnant = true,
				enchantress_impetus = true,
				huskar_burning_spear = true,
				huskar_life_break = true,
				jakiro_liquid_fire = true,
				kunkka_tidebringer = true,
				lone_druid_true_form = true,
				lone_druid_true_form_druid = true,
				monkey_king_tree_dance = true,
				monkey_king_mischief = true,
				monkey_king_untransform = true,
				monkey_king_primal_spring_early = true,
				phoenix_sun_ray_toggle_move = true,
				phoenix_icarus_dive_stop = true,
				phoenix_launch_fire_spirit = true,
				phoenix_sun_ray_stop = true,
				puck_phase_shift = true,
				puck_ethereal_jaunt = true,
				rubick_telekinesis_land = true,
				shadow_demon_shadow_poison_release = true,
				silencer_glaives_of_wisdom = true,
				slardar_sprint = true,
				spirit_breaker_empowering_haste = true,
				techies_minefield_sign = true,
				templar_assassin_trap = true,
				tiny_toss_tree = true,
				life_stealer_control = true
			}
			if kv.ability and kv.ability:IsToggle() == false and kv.ability:IsItem() == false and (ignoredabilities[kv.ability:GetName()] == nil or ignoredabilities[kv.ability:GetName()] ~= true) then
				if math.random(0, 100) <= self.restorechance then
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