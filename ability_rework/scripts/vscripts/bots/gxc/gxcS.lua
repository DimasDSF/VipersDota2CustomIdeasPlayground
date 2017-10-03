-- generic skill for ability level up
----------------------------------------------------------------------------------------------------

local X = {}

----------------------------------------------------------------------------------------------------

X["hero_ability_level_up"] = {
	["npc_dota_hero_abaddon"] = {
		["talentTree"] = {
			"special_bonus_attack_damage_25",
			"special_bonus_exp_boost_20",
			"special_bonus_mp_200",
			"special_bonus_armor_5",
			"special_bonus_movement_speed_25",
			"special_bonus_cooldown_reduction_15",
			"special_bonus_strength_25",
			"special_bonus_unique_abaddon"
		},

		["abilityTable"] = {
			"abaddon_aphotic_shield",
			"abaddon_frostmourne",
			"abaddon_aphotic_shield",
			"abaddon_frostmourne",
			"abaddon_aphotic_shield",
			"abaddon_borrowed_time",

			"abaddon_aphotic_shield",
			"abaddon_frostmourne",
			"abaddon_frostmourne",
			"special_bonus_attack_damage_25",
			"abaddon_death_coil",
			"abaddon_borrowed_time",

			"abaddon_death_coil",
			"abaddon_death_coil",
			"special_bonus_armor_5",
			"abaddon_death_coil",
			"abaddon_borrowed_time",

			"special_bonus_cooldown_reduction_15",
			"special_bonus_unique_abaddon"
		},

		["abilityTable1"] = {
			"abaddon_aphotic_shield",
			"abaddon_frostmourne",
			"abaddon_aphotic_shield",
			"abaddon_frostmourne",
			"abaddon_aphotic_shield",
			"abaddon_borrowed_time",

			"abaddon_aphotic_shield",
			"abaddon_frostmourne",
			"abaddon_frostmourne",
			"special_bonus_attack_damage_25",
			"abaddon_death_coil",
			"abaddon_borrowed_time",

			"abaddon_death_coil",
			"abaddon_death_coil",
			"special_bonus_armor_5",
			"abaddon_death_coil",
			"abaddon_borrowed_time",

			"special_bonus_cooldown_reduction_15",
			"special_bonus_unique_abaddon"
		},

		["abilityTable3"] = {
			"abaddon_frostmourne",
			"abaddon_aphotic_shield",
			"abaddon_aphotic_shield",
			"abaddon_frostmourne",
			"abaddon_aphotic_shield",
			"abaddon_borrowed_time",

			"abaddon_aphotic_shield",
			"abaddon_frostmourne",
			"abaddon_frostmourne",
			"special_bonus_attack_damage_25",
			"abaddon_death_coil",
			"abaddon_borrowed_time",

			"abaddon_death_coil",
			"abaddon_death_coil",
			"special_bonus_armor_5",
			"abaddon_death_coil",
			"abaddon_borrowed_time",

			"special_bonus_cooldown_reduction_15",
			"special_bonus_unique_abaddon"
		},

		["abilityTable5"] = {
			"abaddon_aphotic_shield",
			"abaddon_frostmourne",
			"abaddon_death_coil",
			"abaddon_death_coil",
			"abaddon_death_coil",
			"abaddon_borrowed_time",

			"abaddon_death_coil",
			"abaddon_aphotic_shield",
			"abaddon_aphotic_shield",
			"special_bonus_exp_boost_20",
			"abaddon_aphotic_shield",
			"abaddon_borrowed_time",

			"abaddon_frostmourne",
			"abaddon_frostmourne",
			"special_bonus_mp_200",
			"abaddon_frostmourne",
			"abaddon_borrowed_time",

			"special_bonus_cooldown_reduction_15",
			"special_bonus_unique_abaddon"
		}
	},

	["npc_dota_hero_antimage"] = {
		["talentTree"] = {
			"special_bonus_hp_150",
			"special_bonus_attack_damage_20",
			"special_bonus_attack_speed_20",
			"special_bonus_unique_antimage",
			"special_bonus_evasion_15",
			"special_bonus_all_stats_10",
			"special_bonus_agility_25",
			"special_bonus_unique_antimage_2"
		},

		["abilityTable"] = {
			"antimage_blink",
			"antimage_mana_break",
			"antimage_blink",
			"antimage_spell_shield",
			"antimage_spell_shield",
			"antimage_mana_void",

			"antimage_blink",
			"antimage_blink",
			"antimage_spell_shield",
			"special_bonus_attack_damage_20",
			"antimage_spell_shield",
			"antimage_mana_void",

			"antimage_mana_break",
			"antimage_mana_break",
			"special_bonus_unique_antimage",
			"antimage_mana_break",
			"antimage_mana_void",

			"special_bonus_all_stats_10",
			"special_bonus_unique_antimage_2"
		}
	},

	["npc_dota_hero_axe"] = {
		["talentTree"] = {
			"special_bonus_strength_6",
			"special_bonus_mp_regen_3",
			"special_bonus_attack_damage_75",
			"special_bonus_hp_250",
			"special_bonus_hp_regen_25",
			"special_bonus_movement_speed_35",
			"special_bonus_armor_15",
			"special_bonus_unique_axe"
		},

		["abilityTable"] = {
			"axe_counter_helix",
			"axe_berserkers_call",
			"axe_counter_helix",
			"axe_berserkers_call",
			"axe_counter_helix",
			"axe_culling_blade",

			"axe_counter_helix",
			"axe_berserkers_call",
			"axe_berserkers_call",
			"special_bonus_mp_regen_3",
			"axe_battle_hunger",
			"axe_culling_blade",

			"axe_battle_hunger",
			"axe_battle_hunger",
			"special_bonus_hp_250",
			"axe_battle_hunger",
			"axe_culling_blade",

			"special_bonus_hp_regen_25",
			"special_bonus_armor_15"
		}
	},

	["npc_dota_hero_bane"] = {
		["talentTree"] = {
			"special_bonus_armor_6",
			"special_bonus_mp_200",
			"special_bonus_hp_250",
			"special_bonus_exp_boost_25",
			"special_bonus_unique_bane_1",
			"special_bonus_cast_range_175",
			"special_bonus_movement_speed_75",
			"special_bonus_unique_bane_2"
		},

		["abilityTable"] = {
			"bane_nightmare",
			"bane_brain_sap",
			"bane_brain_sap",
			"bane_nightmare",
			"bane_brain_sap",
			"bane_fiends_grip",

			"bane_brain_sap",
			"bane_nightmare",
			"bane_nightmare",
			"special_bonus_mp_200",
			"bane_enfeeble",
			"bane_fiends_grip",

			"bane_enfeeble",
			"bane_enfeeble",
			"special_bonus_exp_boost_25",
			"bane_enfeeble",
			"bane_fiends_grip",

			"special_bonus_unique_bane_1",
			"special_bonus_unique_bane_2"
		}
	},

	["npc_dota_hero_bloodseeker"] = {
		["talentTree"] = {
			"special_bonus_attack_damage_25",
			"special_bonus_hp_200",
			"special_bonus_attack_speed_30",
			"special_bonus_unique_bloodseeker_2",
			"special_bonus_unique_bloodseeker_3",
			"special_bonus_all_stats_10",
			"special_bonus_unique_bloodseeker",
			"special_bonus_lifesteal_30"
		},

		["abilityTable"] = {
			"bloodseeker_bloodrage",
			"bloodseeker_thirst",
			"bloodseeker_blood_bath",
			"bloodseeker_blood_bath",
			"bloodseeker_blood_bath",
			"bloodseeker_rupture",

			"bloodseeker_blood_bath",
			"bloodseeker_thirst",
			"bloodseeker_thirst",
			"special_bonus_attack_damage_25",
			"bloodseeker_thirst",
			"bloodseeker_rupture",

			"bloodseeker_bloodrage",
			"bloodseeker_bloodrage",
			"special_bonus_attack_speed_30",
			"bloodseeker_bloodrage",
			"bloodseeker_rupture",

			"special_bonus_all_stats_10",
			"special_bonus_lifesteal_30"
		}
	},

	["npc_dota_hero_bounty_hunter"] = {
		["talentTree"] = {
			"special_bonus_hp_175",
			"special_bonus_exp_boost_20",
			"special_bonus_attack_speed_40",
			"special_bonus_movement_speed_15",
			"special_bonus_unique_bounty_hunter_2",
			"special_bonus_attack_damage_120",
			"special_bonus_evasion_25",
			"special_bonus_unique_bounty_hunter"
		},

		["abilityTable"] = {
			"bounty_hunter_wind_walk",
			"bounty_hunter_jinada",
			"bounty_hunter_shuriken_toss",
			"bounty_hunter_shuriken_toss",
			"bounty_hunter_jinada",
			"bounty_hunter_track",

			"bounty_hunter_jinada",
			"bounty_hunter_jinada",
			"bounty_hunter_shuriken_toss",
			"special_bonus_exp_boost_20",
			"bounty_hunter_shuriken_toss",
			"bounty_hunter_track",

			"bounty_hunter_wind_walk",
			"bounty_hunter_wind_walk",
			"special_bonus_movement_speed_15",
			"bounty_hunter_wind_walk",
			"bounty_hunter_track",

			"special_bonus_attack_damage_120",
			"special_bonus_unique_bounty_hunter"
		}
	},

	["npc_dota_hero_bristleback"] = {
		["talentTree"] = {
			"special_bonus_strength_7",
			"special_bonus_mp_regen_2",
			"special_bonus_hp_200",
			"special_bonus_unique_bristleback",
			"special_bonus_attack_speed_45",
			"special_bonus_respawn_reduction_35",
			"special_bonus_hp_regen_25",
			"special_bonus_unique_bristleback_2"
		},

		["abilityTable"] = {
			"bristleback_quill_spray",
			"bristleback_bristleback",
			"bristleback_viscous_nasal_goo",
			"bristleback_quill_spray",
			"bristleback_quill_spray",
			"bristleback_warpath",

			"bristleback_quill_spray",
			"bristleback_bristleback",
			"bristleback_bristleback",
			"special_bonus_mp_regen_2",
			"bristleback_bristleback",
			"bristleback_warpath",

			"bristleback_viscous_nasal_goo",
			"bristleback_viscous_nasal_goo",
			"special_bonus_unique_bristleback",
			"bristleback_viscous_nasal_goo",
			"bristleback_warpath",

			"special_bonus_attack_speed_45",
			"special_bonus_hp_regen_25"
		}
	},

	["npc_dota_hero_chaos_knight"] = {
		["talentTree"] = {
			"special_bonus_attack_speed_15",
			"special_bonus_intelligence_8",
			"special_bonus_movement_speed_20",
			"special_bonus_strength_10",
			"special_bonus_gold_income_20",
			"special_bonus_all_stats_12",
			"special_bonus_cooldown_reduction_20",
			"special_bonus_unique_chaos_knight"
		},

		["abilityTable"] = {
			"chaos_knight_chaos_bolt",
			"chaos_knight_reality_rift",
			"chaos_knight_chaos_bolt",
			"chaos_knight_reality_rift",
			"chaos_knight_chaos_bolt",
			"chaos_knight_reality_rift",

			"chaos_knight_chaos_bolt",
			"chaos_knight_reality_rift",
			"chaos_knight_chaos_strike",
			"special_bonus_attack_speed_15",
			"chaos_knight_phantasm",
			"chaos_knight_phantasm",

			"chaos_knight_chaos_strike",
			"chaos_knight_chaos_strike",
			"special_bonus_strength_10",
			"chaos_knight_chaos_strike",
			"chaos_knight_phantasm",

			"special_bonus_all_stats_12",
			"special_bonus_unique_chaos_knight"
		}
	},

	["npc_dota_hero_crystal_maiden"] = {
		["talentTree"] = {
			"special_bonus_magic_resistance_15",
			"special_bonus_attack_damage_60",
			"special_bonus_cast_range_125",
			"special_bonus_hp_250",
			"special_bonus_gold_income_20",
			"special_bonus_respawn_reduction_35",
			"special_bonus_unique_crystal_maiden_1",
			"special_bonus_unique_crystal_maiden_2"
		},

		["abilityTable"] = {
			"crystal_maiden_frostbite",
			"crystal_maiden_brilliance_aura",
			"crystal_maiden_crystal_nova",
			"crystal_maiden_brilliance_aura",
			"crystal_maiden_frostbite",
			"crystal_maiden_freezing_field",

			"crystal_maiden_brilliance_aura",
			"crystal_maiden_frostbite",
			"crystal_maiden_brilliance_aura",
			"special_bonus_attack_damage_60",
			"crystal_maiden_frostbite",
			"crystal_maiden_freezing_field",

			"crystal_maiden_crystal_nova",
			"crystal_maiden_crystal_nova",
			"special_bonus_hp_250",
			"crystal_maiden_crystal_nova",
			"crystal_maiden_freezing_field",

			"special_bonus_gold_income_20",
			"special_bonus_unique_crystal_maiden_1"
		}
	},

	["npc_dota_hero_dazzle"] = {
		["talentTree"] = {
			"special_bonus_intelligence_10",
			"special_bonus_hp_125",
			"special_bonus_cast_range_100",
			"special_bonus_attack_damage_60",
			"special_bonus_movement_speed_25",
			"special_bonus_respawn_reduction_30",
			"special_bonus_unique_dazzle_1",
			"special_bonus_unique_dazzle_2"
		},

		["abilityTable"] = {
			"dazzle_shadow_wave",
			"dazzle_shallow_grave",
			"dazzle_shadow_wave",
			"dazzle_shallow_grave",
			"dazzle_poison_touch",
			"dazzle_shadow_wave",

			"dazzle_shadow_wave",
			"dazzle_weave",
			"dazzle_shallow_grave",
			"special_bonus_intelligence_10",
			"dazzle_shallow_grave",
			"dazzle_weave",

			"dazzle_poison_touch",
			"dazzle_poison_touch",
			"special_bonus_cast_range_100",
			"dazzle_poison_touch",
			"dazzle_weave",

			"special_bonus_respawn_reduction_30",
			"special_bonus_unique_dazzle_1"
		}
	},

	["npc_dota_hero_death_prophet"] = {
		["talentTree"] = {
			"special_bonus_spell_amplify_4",
			"special_bonus_magic_resistance_8",
			"special_bonus_unique_death_prophet_2",
			"special_bonus_cast_range_100",
			"special_bonus_cooldown_reduction_10",
			"special_bonus_movement_speed_25",
			"special_bonus_hp_400",
			"special_bonus_unique_death_prophet"
		},

		["abilityTable"] = {
			"death_prophet_carrion_swarm",
			"death_prophet_spirit_siphon",
			"death_prophet_carrion_swarm",
			"death_prophet_spirit_siphon",
			"death_prophet_carrion_swarm",
			"death_prophet_exorcism",

			"death_prophet_carrion_swarm",
			"death_prophet_silence",
			"death_prophet_spirit_siphon",
			"special_bonus_spell_amplify_4",
			"death_prophet_spirit_siphon",
			"death_prophet_exorcism",

			"death_prophet_silence",
			"death_prophet_silence",
			"special_bonus_unique_death_prophet_2",
			"death_prophet_silence",
			"death_prophet_exorcism",

			"special_bonus_cooldown_reduction_10",
			"special_bonus_unique_death_prophet"
		}
	},

	["npc_dota_hero_dragon_knight"] = {
		["talentTree"] = {
			"special_bonus_strength_7",
			"special_bonus_attack_speed_20",
			"special_bonus_exp_boost_35",
			"special_bonus_attack_damage_40",
			"special_bonus_gold_income_20",
			"special_bonus_hp_300",
			"special_bonus_movement_speed_60",
			"special_bonus_unique_dragon_knight"
		},

		["abilityTable"] = {
			"dragon_knight_dragon_tail",
			"dragon_knight_dragon_blood",
			"dragon_knight_breathe_fire",
			"dragon_knight_breathe_fire",
			"dragon_knight_breathe_fire",
			"dragon_knight_elder_dragon_form",

			"dragon_knight_breathe_fire",
			"dragon_knight_dragon_blood",
			"dragon_knight_dragon_blood",
			"special_bonus_attack_speed_20",
			"dragon_knight_dragon_blood",
			"dragon_knight_elder_dragon_form",

			"dragon_knight_dragon_tail",
			"dragon_knight_dragon_tail",
			"special_bonus_exp_boost_35",
			"dragon_knight_dragon_tail",
			"dragon_knight_elder_dragon_form",

			"special_bonus_gold_income_20",
			"special_bonus_unique_dragon_knight"
		}
	},

	["npc_dota_hero_drow_ranger"] = {
		["talentTree"] = {
			"special_bonus_movement_speed_15",
			"special_bonus_all_stats_5",
			"special_bonus_hp_175",
			"special_bonus_attack_speed_20",
			"special_bonus_unique_drow_ranger_1",
			"special_bonus_strength_14",
			"special_bonus_unique_drow_ranger_2",
			"special_bonus_unique_drow_ranger_3"
		},

		["abilityTable"] = {
			"drow_ranger_trueshot",
			"drow_ranger_frost_arrows",
			"drow_ranger_frost_arrows",
			"drow_ranger_wave_of_silence",
			"drow_ranger_frost_arrows",
			"drow_ranger_marksmanship",

			"drow_ranger_frost_arrows",
			"drow_ranger_trueshot",
			"drow_ranger_trueshot",
			"special_bonus_all_stats_5",
			"drow_ranger_trueshot",
			"drow_ranger_marksmanship",

			"drow_ranger_wave_of_silence",
			"drow_ranger_wave_of_silence",
			"special_bonus_attack_speed_20",
			"drow_ranger_wave_of_silence",
			"drow_ranger_marksmanship",

			"special_bonus_unique_drow_ranger_1",
			"special_bonus_unique_drow_ranger_3"
		}
	},

	["npc_dota_hero_earthshaker"] = {
		["talentTree"] = {
			"special_bonus_strength_8",
			"special_bonus_mp_250",
			"special_bonus_movement_speed_20",
			"special_bonus_attack_damage_50",
			"special_bonus_unique_earthshaker_2",
			"special_bonus_respawn_reduction_35",
			"special_bonus_hp_600",
			"special_bonus_unique_earthshaker"
		},

		["abilityTable"] = {
			"earthshaker_fissure",
			"earthshaker_enchant_totem",
			"earthshaker_aftershock",
			"earthshaker_fissure",
			"earthshaker_fissure",
			"earthshaker_echo_slam",

			"earthshaker_fissure",
			"earthshaker_aftershock",
			"earthshaker_aftershock",
			"special_bonus_mp_250",
			"earthshaker_aftershock",
			"earthshaker_echo_slam",

			"earthshaker_enchant_totem",
			"earthshaker_enchant_totem",
			"special_bonus_attack_damage_50",
			"earthshaker_enchant_totem",
			"earthshaker_echo_slam",

			"special_bonus_respawn_reduction_35",
			"special_bonus_unique_earthshaker"
		}
	},

	["npc_dota_hero_jakiro"] = {
		["talentTree"] = {
			"special_bonus_exp_boost_20",
			"special_bonus_spell_amplify_8",
			"special_bonus_cast_range_125",
			"special_bonus_unique_jakiro_2",
			"special_bonus_attack_range_400",
			"special_bonus_gold_income_25",
			"special_bonus_respawn_reduction_50",
			"special_bonus_unique_jakiro"
		},

		["abilityTable"] = {
			"jakiro_ice_path",
			"jakiro_dual_breath",
			"jakiro_ice_path",
			"jakiro_dual_breath",
			"jakiro_ice_path",
			"jakiro_macropyre",

			"jakiro_ice_path",
			"jakiro_dual_breath",
			"jakiro_dual_breath",
			"special_bonus_spell_amplify_8",
			"jakiro_liquid_fire",
			"jakiro_macropyre",

			"jakiro_liquid_fire",
			"jakiro_liquid_fire",
			"special_bonus_unique_jakiro_2",
			"jakiro_liquid_fire",
			"jakiro_macropyre",

			"special_bonus_attack_range_400",
			"special_bonus_unique_jakiro"
		}
	},

	["npc_dota_hero_juggernaut"] = {
		["talentTree"] = {
			"special_bonus_hp_175",
			"special_bonus_attack_damage_20",
			"special_bonus_attack_speed_20",
			"special_bonus_armor_7",
			"special_bonus_movement_speed_20",
			"special_bonus_all_stats_8",
			"special_bonus_agility_20",
			"special_bonus_unique_juggernaut"
		},

		["abilityTable"] = {
			"juggernaut_blade_fury",
			"juggernaut_blade_dance",
			"juggernaut_blade_fury",
			"juggernaut_healing_ward",
			"juggernaut_blade_fury",
			"juggernaut_omni_slash",

			"juggernaut_blade_fury",
			"juggernaut_blade_dance",
			"juggernaut_healing_ward",
			"special_bonus_attack_damage_20",
			"juggernaut_blade_dance",
			"juggernaut_omni_slash",

			"juggernaut_blade_dance",
			"juggernaut_healing_ward",
			"special_bonus_attack_speed_20",
			"juggernaut_healing_ward",
			"juggernaut_omni_slash",

			"special_bonus_all_stats_8",
			"special_bonus_agility_20"
		}
	},

	["npc_dota_hero_kunkka"] = {
		["talentTree"] = {
			"special_bonus_attack_damage_25",
			"special_bonus_unique_kunkka_2",
			"special_bonus_hp_regen_15",
			"special_bonus_movement_speed_15",
			"special_bonus_hp_300",
			"special_bonus_gold_income_20",
			"special_bonus_magic_resistance_35",
			"special_bonus_unique_kunkka"
		},

		["abilityTable"] = {
			"kunkka_tidebringer",
			"kunkka_torrent",
			"kunkka_tidebringer",
			"kunkka_x_marks_the_spot",
			"kunkka_tidebringer",
			"kunkka_ghostship",

			"kunkka_tidebringer",
			"kunkka_torrent",
			"kunkka_torrent",
			"special_bonus_unique_kunkka_2",
			"kunkka_torrent",
			"kunkka_ghostship",

			"kunkka_x_marks_the_spot",
			"kunkka_x_marks_the_spot",
			"special_bonus_hp_regen_15",
			"kunkka_x_marks_the_spot",
			"kunkka_ghostship",

			"special_bonus_gold_income_20",
			"special_bonus_unique_kunkka"
		}
	},

	["npc_dota_hero_lich"] = {
		["talentTree"] = {
			"special_bonus_hp_125",
			"special_bonus_movement_speed_15",
			"special_bonus_cast_range_125",
			"special_bonus_unique_lich_3",
			"special_bonus_attack_damage_150",
			"special_bonus_gold_income_20",
			"special_bonus_unique_lich_1",
			"special_bonus_unique_lich_2"
		},

		["abilityTable"] = {
			"lich_dark_ritual",
			"lich_frost_nova",
			"lich_dark_ritual",
			"lich_frost_nova",
			"lich_frost_armor",
			"lich_chain_frost",

			"lich_frost_nova",
			"lich_dark_ritual",
			"lich_frost_nova",
			"special_bonus_hp_125",
			"lich_dark_ritual",
			"lich_chain_frost",

			"lich_frost_armor",
			"lich_frost_armor",
			"special_bonus_unique_lich_3",
			"lich_frost_armor",
			"lich_chain_frost",

			"special_bonus_attack_damage_150",
			"special_bonus_unique_lich_2"
		}
	},

	["npc_dota_hero_lina"] = {
		["talentTree"] = {
			"special_bonus_unique_lina_3",
			"special_bonus_respawn_reduction_25",
			"special_bonus_attack_damage_40",
			"special_bonus_cast_range_125",
			"special_bonus_spell_amplify_6",
			"special_bonus_attack_range_150",
			"special_bonus_unique_lina_1",
			"special_bonus_unique_lina_2"
		},

		["abilityTable"] = {
			"lina_light_strike_array",
			"lina_dragon_slave",
			"lina_dragon_slave",
			"lina_light_strike_array",
			"lina_dragon_slave",
			"lina_laguna_blade",

			"lina_dragon_slave",
			"lina_light_strike_array",
			"lina_light_strike_array",
			"special_bonus_unique_lina_3",
			"lina_fiery_soul",
			"lina_laguna_blade",

			"lina_fiery_soul",
			"lina_fiery_soul",
			"special_bonus_attack_damage_40",
			"lina_fiery_soul",
			"lina_laguna_blade",

			"special_bonus_spell_amplify_6",
			"special_bonus_unique_lina_1"
		}
	},

	["npc_dota_hero_lion"] = {
		["talentTree"] = {
			"special_bonus_respawn_reduction_25",
			"special_bonus_attack_damage_45",
			"special_bonus_unique_lion_2",
			"special_bonus_gold_income_15",
			"special_bonus_magic_resistance_20",
			"special_bonus_spell_amplify_8",
			"special_bonus_all_stats_20",
			"special_bonus_unique_lion"
		},

		["abilityTable"] = {
			"lion_impale",
			"lion_voodoo",
			"lion_impale",
			"lion_mana_drain",
			"lion_impale",
			"lion_finger_of_death",

			"lion_impale",
			"lion_mana_drain",
			"lion_mana_drain",
			"special_bonus_respawn_reduction_25",
			"lion_mana_drain",
			"lion_finger_of_death",

			"lion_voodoo",
			"lion_voodoo",
			"special_bonus_gold_income_15",
			"lion_voodoo",
			"lion_finger_of_death",

			"special_bonus_magic_resistance_20",
			"special_bonus_all_stats_20"
		}
	},

	["npc_dota_hero_luna"] = {
		["talentTree"] = {
			"special_bonus_attack_damage_15",
			"special_bonus_movement_speed_15",
			"special_bonus_hp_150",
			"special_bonus_unique_luna_1",
			"special_bonus_attack_speed_25",
			"special_bonus_magic_resistance_10",
			"special_bonus_all_stats_15",
			"special_bonus_unique_luna_2"
		},

		["abilityTable"] = {
			"luna_lunar_blessing",
			"luna_lucent_beam",
			"luna_lucent_beam",
			"luna_moon_glaive",
			"luna_lucent_beam",
			"luna_eclipse",

			"luna_lucent_beam",
			"luna_moon_glaive",
			"luna_moon_glaive",
			"special_bonus_attack_damage_15",
			"luna_moon_glaive",
			"luna_eclipse",

			"luna_lunar_blessing",
			"luna_lunar_blessing",
			"special_bonus_unique_luna_1",
			"luna_lunar_blessing",
			"luna_eclipse",

			"special_bonus_attack_speed_25",
			"special_bonus_all_stats_15"
		}
	},

	["npc_dota_hero_necrolyte"] = {
		["talentTree"] = {
			"special_bonus_attack_damage_40",
			"special_bonus_strength_6",
			"special_bonus_all_stats_6",
			"special_bonus_movement_speed_20",
			"special_bonus_spell_amplify_5",
			"special_bonus_magic_resistance_10",
			"special_bonus_hp_400",
			"special_bonus_unique_necrophos"
		},

		["abilityTable"] = {
			"necrolyte_death_pulse",
			"necrolyte_heartstopper_aura",
			"necrolyte_death_pulse",
			"necrolyte_heartstopper_aura",
			"necrolyte_death_pulse",
			"necrolyte_reapers_scythe",

			"necrolyte_death_pulse",
			"necrolyte_heartstopper_aura",
			"necrolyte_heartstopper_aura",
			"special_bonus_attack_damage_40",
			"necrolyte_sadist",
			"necrolyte_reapers_scythe",

			"necrolyte_sadist",
			"necrolyte_sadist",
			"special_bonus_all_stats_6",
			"necrolyte_sadist",
			"necrolyte_reapers_scythe",

			"special_bonus_spell_amplify_5",
			"special_bonus_unique_necrophos"
		}
	},

	["npc_dota_hero_nevermore"] = {
		["talentTree"] = {
			"special_bonus_movement_speed_15",
			"special_bonus_attack_speed_20",
			"special_bonus_spell_amplify_6",
			"special_bonus_hp_175",
			"special_bonus_lifesteal_15",
			"special_bonus_unique_nevermore_1",
			"special_bonus_attack_range_150",
			"special_bonus_unique_nevermore_2"
		},

		["abilityTable"] = {
			"nevermore_necromastery",
			"nevermore_shadowraze1",
			"nevermore_necromastery",
			"nevermore_shadowraze1",
			"nevermore_necromastery",
			"nevermore_shadowraze1",

			"nevermore_necromastery",
			"nevermore_shadowraze1",
			"nevermore_requiem",
			"special_bonus_attack_speed_20",
			"nevermore_dark_lord",
			"nevermore_requiem",

			"nevermore_dark_lord",
			"nevermore_dark_lord",
			"special_bonus_hp_175",
			"nevermore_dark_lord",
			"nevermore_requiem",

			"special_bonus_unique_nevermore_1",
			"special_bonus_attack_range_150"
		}
	},

	["npc_dota_hero_obsidian_destroyer"] = {
		["talentTree"] = {
			"special_bonus_mp_250",
			"special_bonus_movement_speed_10",
			"special_bonus_armor_5",
			"special_bonus_attack_speed_20",
			"special_bonus_intelligence_15",
			"special_bonus_hp_275",
			"special_bonus_unique_outworld_devourer",
			"special_bonus_spell_amplify_8"
		},

		["abilityTable"] = {
			"obsidian_destroyer_astral_imprisonment",
			"obsidian_destroyer_essence_aura",
			"obsidian_destroyer_astral_imprisonment",
			"obsidian_destroyer_essence_aura",
			"obsidian_destroyer_astral_imprisonment",
			"obsidian_destroyer_arcane_orb",

			"obsidian_destroyer_astral_imprisonment",
			"obsidian_destroyer_sanity_eclipse",
			"obsidian_destroyer_essence_aura",
			"special_bonus_mp_250",
			"obsidian_destroyer_essence_aura",
			"obsidian_destroyer_sanity_eclipse",

			"obsidian_destroyer_arcane_orb",
			"obsidian_destroyer_arcane_orb",
			"special_bonus_attack_speed_20",
			"obsidian_destroyer_arcane_orb",
			"obsidian_destroyer_sanity_eclipse",

			"special_bonus_intelligence_15",
			"special_bonus_spell_amplify_8"
		}
	},

	["npc_dota_hero_ogre_magi"] = {
		["talentTree"] = {
			"special_bonus_gold_income_10",
			"special_bonus_cast_range_100",
			"special_bonus_attack_damage_50",
			"special_bonus_magic_resistance_8",
			"special_bonus_hp_250",
			"special_bonus_movement_speed_25",
			"special_bonus_spell_amplify_15",
			"special_bonus_unique_ogre_magi"
		},

		["abilityTable"] = {
			"ogre_magi_fireblast",
			"ogre_magi_ignite",
			"ogre_magi_bloodlust",
			"ogre_magi_ignite",
			"ogre_magi_bloodlust",
			"ogre_magi_multicast",

			"ogre_magi_ignite",
			"ogre_magi_bloodlust",
			"ogre_magi_ignite",
			"special_bonus_gold_income_10",
			"ogre_magi_bloodlust",
			"ogre_magi_multicast",

			"ogre_magi_fireblast",
			"ogre_magi_fireblast",
			"special_bonus_attack_damage_50",
			"ogre_magi_fireblast",
			"ogre_magi_multicast",

			"special_bonus_hp_250",
			"special_bonus_unique_ogre_magi"
		}
	},

	["npc_dota_hero_omniknight"] = {
		["talentTree"] = {
			"special_bonus_gold_income_10",
			"special_bonus_exp_boost_20",
			"special_bonus_cast_range_75",
			"special_bonus_strength_8",
			"special_bonus_attack_damage_100",
			"special_bonus_mp_regen_6",
			"special_bonus_unique_omniknight_1",
			"special_bonus_unique_omniknight_2"
		},

		["abilityTable"] = {
			"omniknight_purification",
			"omniknight_repel",
			"omniknight_purification",
			"omniknight_degen_aura",
			"omniknight_purification",
			"omniknight_guardian_angel",

			"omniknight_purification",
			"omniknight_repel",
			"omniknight_degen_aura",
			"special_bonus_gold_income_10",
			"omniknight_repel",
			"omniknight_guardian_angel",

			"omniknight_degen_aura",
			"omniknight_repel",
			"special_bonus_cast_range_75",
			"omniknight_degen_aura",
			"omniknight_guardian_angel",

			"special_bonus_attack_damage_100",
			"special_bonus_unique_omniknight_1"
		}
	},

	["npc_dota_hero_oracle"] = {
		["talentTree"] = {
			"special_bonus_respawn_reduction_20",
			"special_bonus_exp_boost_20",
			"special_bonus_hp_200",
			"special_bonus_gold_income_10",
			"special_bonus_movement_speed_25",
			"special_bonus_intelligence_20",
			"special_bonus_cast_range_250",
			"special_bonus_unique_oracle"
		},

		["abilityTable"] = {
			"oracle_fates_edict",
			"oracle_purifying_flames",
			"oracle_purifying_flames",
			"oracle_fortunes_end",
			"oracle_purifying_flames",
			"oracle_false_promise",

			"oracle_purifying_flames",
			"oracle_fates_edict",
			"oracle_fortunes_end",
			"special_bonus_exp_boost_20",
			"oracle_fates_edict",
			"oracle_false_promise",

			"oracle_fortunes_end",
			"oracle_fates_edict",
			"special_bonus_gold_income_10",
			"oracle_fortunes_end",
			"oracle_false_promise",

			"special_bonus_intelligence_20",
			"special_bonus_cast_range_250"
		}
	},

	["npc_dota_hero_phantom_assassin"] = {
		["talentTree"] = {
			"special_bonus_hp_150",
			"special_bonus_attack_damage_15",
			"special_bonus_lifesteal_10",
			"special_bonus_movement_speed_20",
			"special_bonus_attack_speed_35",
			"special_bonus_all_stats_10",
			"special_bonus_agility_25",
			"special_bonus_unique_phantom_assassin"
		},

		["abilityTable"] = {
			"phantom_assassin_stifling_dagger",
			"phantom_assassin_phantom_strike",
			"phantom_assassin_stifling_dagger",
			"phantom_assassin_blur",
			"phantom_assassin_stifling_dagger",
			"phantom_assassin_coup_de_grace",

			"phantom_assassin_stifling_dagger",
			"phantom_assassin_phantom_strike",
			"phantom_assassin_phantom_strike",
			"special_bonus_attack_damage_15",
			"phantom_assassin_phantom_strike",
			"phantom_assassin_coup_de_grace",

			"phantom_assassin_blur",
			"phantom_assassin_blur",
			"special_bonus_lifesteal_10",
			"phantom_assassin_blur",
			"phantom_assassin_coup_de_grace",

			"special_bonus_all_stats_10",
			"special_bonus_agility_25"
		}
	},

	["npc_dota_hero_pudge"] = {
		["talentTree"] = {
			"special_bonus_strength_8",
			"special_bonus_mp_regen_2",
			"special_bonus_armor_5",
			"special_bonus_movement_speed_15",
			"special_bonus_gold_income_25",
			"special_bonus_respawn_reduction_40",
			"special_bonus_unique_pudge_1",
			"special_bonus_unique_pudge_2"
		},

		["abilityTable"] = {
			"pudge_rot",
			"pudge_meat_hook",
			"pudge_meat_hook",
			"pudge_rot",
			"pudge_meat_hook",
			"pudge_dismember",

			"pudge_meat_hook",
			"pudge_rot",
			"pudge_rot",
			"special_bonus_mp_regen_2",
			"pudge_flesh_heap",
			"pudge_dismember",

			"pudge_flesh_heap",
			"pudge_flesh_heap",
			"special_bonus_movement_speed_15",
			"pudge_flesh_heap",
			"pudge_dismember",

			"special_bonus_gold_income_25",
			"special_bonus_unique_pudge_1"
		}
	},

	["npc_dota_hero_razor"] = {
		["talentTree"] = {
			"special_bonus_movement_speed_15",
			"special_bonus_agility_10",
			"special_bonus_unique_razor_2",
			"special_bonus_cast_range_150",
			"special_bonus_hp_275",
			"special_bonus_attack_speed_30",
			"special_bonus_attack_range_175",
			"special_bonus_unique_razor"
		},

		["abilityTable"] = {
			"razor_plasma_field",
			"razor_unstable_current",
			"razor_plasma_field",
			"razor_static_link",
			"razor_plasma_field",
			"razor_eye_of_the_storm",

			"razor_plasma_field",
			"razor_unstable_current",
			"razor_static_link",
			"special_bonus_agility_10",
			"razor_unstable_current",
			"razor_eye_of_the_storm",

			"razor_static_link",
			"razor_unstable_current",
			"special_bonus_unique_razor_2",
			"razor_static_link",
			"razor_eye_of_the_storm",

			"special_bonus_attack_speed_30",
			"special_bonus_attack_range_175"
		}
	},

	["npc_dota_hero_sand_king"] = {
		["talentTree"] = {
			"special_bonus_magic_resistance_10",
			"special_bonus_armor_5",
			"special_bonus_unique_sand_king_2",
			"special_bonus_respawn_reduction_30",
			"special_bonus_hp_350",
			"special_bonus_gold_income_20",
			"special_bonus_hp_regen_50",
			"special_bonus_unique_sand_king"
		},

		["abilityTable"] = {
			"sandking_burrowstrike",
			"sandking_sand_storm",
			"sandking_burrowstrike",
			"sandking_sand_storm",
			"sandking_burrowstrike",
			"sandking_epicenter",

			"sandking_burrowstrike",
			"sandking_caustic_finale",
			"sandking_caustic_finale",
			"special_bonus_armor_5",
			"sandking_sand_storm",
			"sandking_epicenter",

			"sandking_sand_storm",
			"sandking_caustic_finale",
			"special_bonus_unique_sand_king_2",
			"sandking_caustic_finale",
			"sandking_epicenter",

			"special_bonus_gold_income_20",
			"special_bonus_hp_regen_50"
		}
	},

	["npc_dota_hero_skeleton_king"] = {
		["talentTree"] = {
			"special_bonus_attack_damage_15",
			"special_bonus_intelligence_10",
			"special_bonus_movement_speed_15",
			"special_bonus_unique_wraith_king_3",
			"special_bonus_attack_speed_40",
			"special_bonus_strength_20",
			"special_bonus_unique_wraith_king_1",
			"special_bonus_unique_wraith_king_2"
		},

		["abilityTable"] = {
			"skeleton_king_hellfire_blast",
			"skeleton_king_vampiric_aura",
			"skeleton_king_mortal_strike",
			"skeleton_king_vampiric_aura",
			"skeleton_king_mortal_strike",
			"skeleton_king_reincarnation",

			"skeleton_king_vampiric_aura",
			"skeleton_king_mortal_strike",
			"skeleton_king_vampiric_aura",
			"special_bonus_attack_damage_15",
			"skeleton_king_mortal_strike",
			"skeleton_king_reincarnation",

			"skeleton_king_hellfire_blast",
			"skeleton_king_hellfire_blast",
			"special_bonus_movement_speed_15",
			"skeleton_king_hellfire_blast",
			"skeleton_king_reincarnation",

			"special_bonus_attack_speed_40",
			"special_bonus_unique_wraith_king_2"
		}
	},

	["npc_dota_hero_skywrath_mage"] = {
		["talentTree"] = {
			"special_bonus_hp_125",
			"special_bonus_intelligence_7",
			"special_bonus_attack_damage_75",
			"special_bonus_gold_income_15",
			"special_bonus_movement_speed_20",
			"special_bonus_magic_resistance_15",
			"special_bonus_mp_regen_14",
			"special_bonus_unique_skywrath"
		},

		["abilityTable"] = {
			"skywrath_mage_arcane_bolt",
			"skywrath_mage_concussive_shot",
			"skywrath_mage_arcane_bolt",
			"skywrath_mage_ancient_seal",
			"skywrath_mage_arcane_bolt",
			"skywrath_mage_mystic_flare",

			"skywrath_mage_arcane_bolt",
			"skywrath_mage_concussive_shot",
			"skywrath_mage_ancient_seal",
			"special_bonus_hp_125",
			"skywrath_mage_concussive_shot",
			"skywrath_mage_mystic_flare",

			"skywrath_mage_ancient_seal",
			"skywrath_mage_concussive_shot",
			"special_bonus_gold_income_15",
			"skywrath_mage_ancient_seal",
			"skywrath_mage_mystic_flare",

			"special_bonus_movement_speed_20",
			"special_bonus_unique_skywrath"
		}
	},

	["npc_dota_hero_slardar"] = {
		["talentTree"] = {
			"special_bonus_hp_regen_6",
			"special_bonus_mp_175",
			"special_bonus_hp_225",
			"special_bonus_attack_speed_25",
			"special_bonus_attack_damage_35",
			"special_bonus_armor_7",
			"special_bonus_strength_20",
			"special_bonus_unique_slardar"
		},

		["abilityTable"] = {
			"slardar_slithereen_crush",
			"slardar_bash",
			"slardar_slithereen_crush",
			"slardar_sprint",
			"slardar_sprint",
			"slardar_amplify_damage",

			"slardar_slithereen_crush",
			"slardar_sprint",
			"slardar_slithereen_crush",
			"special_bonus_mp_175",
			"slardar_sprint",
			"slardar_amplify_damage",

			"slardar_bash",
			"slardar_bash",
			"special_bonus_hp_225",
			"slardar_bash",
			"slardar_amplify_damage",

			"special_bonus_armor_7",
			"special_bonus_strength_20"
		}
	},

	["npc_dota_hero_sniper"] = {
		["talentTree"] = {
			"special_bonus_mp_regen_5",
			"special_bonus_attack_speed_15",
			"special_bonus_unique_sniper_1",
			"special_bonus_hp_200",
			"special_bonus_armor_8",
			"special_bonus_cooldown_reduction_25",
			"special_bonus_attack_range_100",
			"special_bonus_unique_sniper_2"
		},

		["abilityTable"] = {
			"sniper_shrapnel",
			"sniper_headshot",
			"sniper_shrapnel",
			"sniper_take_aim",
			"sniper_shrapnel",
			"sniper_assassinate",

			"sniper_shrapnel",
			"sniper_take_aim",
			"sniper_take_aim",
			"special_bonus_attack_speed_15",
			"sniper_take_aim",
			"sniper_assassinate",

			"sniper_headshot",
			"sniper_headshot",
			"special_bonus_unique_sniper_1",
			"sniper_headshot",
			"sniper_assassinate",

			"special_bonus_cooldown_reduction_25",
			"special_bonus_unique_sniper_2"
		}
	},

	["npc_dota_hero_sven"] = {
		["talentTree"] = {
			"special_bonus_strength_6",
			"special_bonus_mp_200",
			"special_bonus_movement_speed_20",
			"special_bonus_all_stats_8",
			"special_bonus_attack_speed_30",
			"special_bonus_evasion_15",
			"special_bonus_attack_damage_65",
			"special_bonus_unique_sven"
		},

		["abilityTable"] = {
			"sven_storm_bolt",
			"sven_warcry",
			"sven_warcry",
			"sven_great_cleave",
			"sven_great_cleave",
			"sven_gods_strength",

			"sven_great_cleave",
			"sven_great_cleave",
			"sven_warcry",
			"special_bonus_strength_6",
			"sven_warcry",
			"sven_gods_strength",

			"sven_storm_bolt",
			"sven_storm_bolt",
			"special_bonus_all_stats_8",
			"sven_storm_bolt",
			"sven_gods_strength",

			"special_bonus_attack_speed_30",
			"special_bonus_unique_sven"
		}
	},

	["npc_dota_hero_tidehunter"] = {
		["talentTree"] = {
			"special_bonus_attack_damage_50",
			"special_bonus_hp_150",
			"special_bonus_armor_7",
			"special_bonus_exp_boost_35",
			"special_bonus_mp_regen_6",
			"special_bonus_strength_15",
			"special_bonus_cooldown_reduction_20",
			"special_bonus_unique_tidehunter"
		},

		["abilityTable"] = {
			"tidehunter_anchor_smash",
			"tidehunter_kraken_shell",
			"tidehunter_anchor_smash",
			"tidehunter_kraken_shell",
			"tidehunter_kraken_shell",
			"tidehunter_ravage",

			"tidehunter_gush",
			"tidehunter_anchor_smash",
			"tidehunter_anchor_smash",
			"special_bonus_attack_damage_50",
			"tidehunter_kraken_shell",
			"tidehunter_ravage",

			"tidehunter_gush",
			"tidehunter_gush",
			"special_bonus_armor_7",
			"tidehunter_gush",
			"tidehunter_ravage",

			"special_bonus_strength_15",
			"special_bonus_cooldown_reduction_20"
		}
	},

	["npc_dota_hero_tinker"] = {
		["talentTree"] = {
			"special_bonus_intelligence_8",
			"special_bonus_armor_6",
			"special_bonus_hp_225",
			"special_bonus_spell_amplify_4",
			"special_bonus_cast_range_75",
			"special_bonus_magic_resistance_15",
			"special_bonus_spell_lifesteal_20",
			"special_bonus_unique_tinker"
		},

		["abilityTable"] = {
			"tinker_laser",
			"tinker_march_of_the_machines",
			"tinker_heat_seeking_missile",
			"tinker_march_of_the_machines",
			"tinker_march_of_the_machines",
			"tinker_rearm",

			"tinker_march_of_the_machines",
			"tinker_heat_seeking_missile",
			"tinker_heat_seeking_missile",
			"special_bonus_intelligence_8",
			"tinker_heat_seeking_missile",
			"tinker_rearm",

			"tinker_laser",
			"tinker_laser",
			"special_bonus_spell_amplify_4",
			"tinker_laser",
			"tinker_rearm",

			"special_bonus_cast_range_75",
			"special_bonus_spell_lifesteal_20"
		}
	},

	["npc_dota_hero_tiny"] = {
		["talentTree"] = {
			"special_bonus_strength_6",
			"special_bonus_intelligence_12",
			"special_bonus_attack_damage_45",
			"special_bonus_movement_speed_20",
			"special_bonus_attack_speed_25",
			"special_bonus_mp_regen_14",
			"special_bonus_cooldown_reduction_20",
			"special_bonus_unique_tiny"
		},

		["abilityTable"] = {
			"tiny_avalanche",
			"tiny_toss",
			"tiny_avalanche",
			"tiny_toss",
			"tiny_avalanche",
			"tiny_toss",

			"tiny_avalanche",
			"tiny_toss",
			"tiny_grow",
			"special_bonus_strength_6",
			"tiny_craggy_exterior",
			"tiny_grow",

			"tiny_craggy_exterior",
			"tiny_craggy_exterior",
			"special_bonus_attack_damage_45",
			"tiny_craggy_exterior",
			"tiny_grow",

			"special_bonus_attack_speed_25",
			"special_bonus_cooldown_reduction_20"
		}
	},

	["npc_dota_hero_undying"] = {
		["talentTree"] = {
			"special_bonus_respawn_reduction_30",
			"special_bonus_gold_income_15",
			"special_bonus_exp_boost_35",
			"special_bonus_hp_300",
			"special_bonus_unique_undying",
			"special_bonus_movement_speed_25",
			"special_bonus_armor_15",
			"special_bonus_unique_undying_2"
		},

		["abilityTable"] = {
			"undying_decay",
			"undying_tombstone",
			"undying_tombstone",
			"undying_soul_rip",
			"undying_tombstone",
			"undying_flesh_golem",

			"undying_tombstone",
			"undying_soul_rip",
			"undying_soul_rip",
			"special_bonus_gold_income_15",
			"undying_soul_rip",
			"undying_flesh_golem",

			"undying_decay",
			"undying_decay",
			"special_bonus_exp_boost_35",
			"undying_decay",
			"undying_flesh_golem",

			"special_bonus_unique_undying",
			"special_bonus_unique_undying_2"
		}
	},

	["npc_dota_hero_vengefulspirit"] = {
		["talentTree"] = {
			"special_bonus_magic_resistance_8",
			"special_bonus_attack_speed_25",
			"special_bonus_all_stats_8",
			"special_bonus_unique_vengeful_spirit_1",
			"special_bonus_attack_damage_65",
			"special_bonus_movement_speed_35",
			"special_bonus_unique_vengeful_spirit_2",
			"special_bonus_unique_vengeful_spirit_3"
		},

		["abilityTable"] = {
			"vengefulspirit_magic_missile",
			"vengefulspirit_wave_of_terror",
			"vengefulspirit_magic_missile",
			"vengefulspirit_wave_of_terror",
			"vengefulspirit_magic_missile",
			"vengefulspirit_nether_swap",

			"vengefulspirit_magic_missile",
			"vengefulspirit_command_aura",
			"vengefulspirit_wave_of_terror",
			"special_bonus_attack_speed_25",
			"vengefulspirit_command_aura",
			"vengefulspirit_nether_swap",

			"vengefulspirit_command_aura",
			"vengefulspirit_command_aura",
			"special_bonus_all_stats_8",
			"vengefulspirit_wave_of_terror",
			"vengefulspirit_nether_swap",

			"special_bonus_attack_damage_65",
			"special_bonus_unique_vengeful_spirit_2"
		}
	},

	["npc_dota_hero_viper"] = {
		["talentTree"] = {
			"special_bonus_attack_damage_15",
			"special_bonus_hp_150",
			"special_bonus_strength_7",
			"special_bonus_agility_14",
			"special_bonus_armor_7",
			"special_bonus_attack_range_75",
			"special_bonus_unique_viper_1",
			"special_bonus_unique_viper_2"
		},

		["abilityTable"] = {
			"viper_poison_attack",
			"viper_nethertoxin",
			"viper_poison_attack",
			"viper_corrosive_skin",
			"viper_corrosive_skin",
			"viper_viper_strike",

			"viper_corrosive_skin",
			"viper_corrosive_skin",
			"viper_poison_attack",
			"special_bonus_attack_damage_15",
			"viper_poison_attack",
			"viper_viper_strike",

			"viper_nethertoxin",
			"viper_nethertoxin",
			"special_bonus_agility_14",
			"viper_nethertoxin",
			"viper_viper_strike",

			"special_bonus_armor_7",
			"special_bonus_unique_viper_1"
		}
	},

	["npc_dota_hero_warlock"] = {
		["talentTree"] = {
			"special_bonus_exp_boost_20",
			"special_bonus_all_stats_6",
			"special_bonus_cast_range_150",
			"special_bonus_unique_warlock_3",
			"special_bonus_hp_350",
			"special_bonus_respawn_reduction_30",
			"special_bonus_unique_warlock_1",
			"special_bonus_unique_warlock_2"
		},

		["abilityTable"] = {
			"warlock_shadow_word",
			"warlock_fatal_bonds",
			"warlock_shadow_word",
			"warlock_upheaval",
			"warlock_shadow_word",
			"warlock_rain_of_chaos",

			"warlock_shadow_word",
			"warlock_fatal_bonds",
			"warlock_upheaval",
			"special_bonus_exp_boost_20",
			"warlock_fatal_bonds",
			"warlock_rain_of_chaos",

			"warlock_fatal_bonds",
			"warlock_upheaval",
			"special_bonus_unique_warlock_3",
			"warlock_upheaval",
			"warlock_rain_of_chaos",

			"special_bonus_respawn_reduction_30",
			"special_bonus_unique_warlock_2"
		}
	},

	["npc_dota_hero_windrunner"] = {
		["talentTree"] = {
			"special_bonus_mp_regen_4",
			"special_bonus_unique_windranger_2",
			"special_bonus_movement_speed_40",
			"special_bonus_intelligence_20",
			"special_bonus_spell_amplify_15",
			"special_bonus_magic_resistance_20",
			"special_bonus_attack_range_100",
			"special_bonus_unique_windranger"
		},

		["abilityTable"] = {
			"windrunner_windrun",
			"windrunner_shackleshot",
			"windrunner_powershot",
			"windrunner_powershot",
			"windrunner_powershot",
			"windrunner_shackleshot",

			"windrunner_powershot",
			"windrunner_shackleshot",
			"windrunner_shackleshot",
			"special_bonus_unique_windranger_2",
			"windrunner_focusfire",
			"windrunner_focusfire",

			"windrunner_windrun",
			"windrunner_windrun",
			"special_bonus_movement_speed_40",
			"windrunner_windrun",
			"windrunner_focusfire",

			"special_bonus_magic_resistance_20",
			"special_bonus_unique_windranger"
		}
	},

	["npc_dota_hero_witch_doctor"] = {
		["talentTree"] = {
			"special_bonus_hp_200",
			"special_bonus_exp_boost_25",
			"special_bonus_attack_damage_90",
			"special_bonus_respawn_reduction_40",
			"special_bonus_armor_8",
			"special_bonus_magic_resistance_15",
			"special_bonus_unique_witch_doctor_1",
			"special_bonus_unique_witch_doctor_2"
		},

		["abilityTable"] = {
			"witch_doctor_paralyzing_cask",
			"witch_doctor_maledict",
			"witch_doctor_paralyzing_cask",
			"witch_doctor_maledict",
			"witch_doctor_paralyzing_cask",
			"witch_doctor_death_ward",

			"witch_doctor_paralyzing_cask",
			"witch_doctor_maledict",
			"witch_doctor_maledict",
			"special_bonus_exp_boost_25",
			"witch_doctor_voodoo_restoration",
			"witch_doctor_death_ward",

			"witch_doctor_voodoo_restoration",
			"witch_doctor_voodoo_restoration",
			"special_bonus_attack_damage_90",
			"witch_doctor_voodoo_restoration",
			"witch_doctor_death_ward",

			"special_bonus_armor_8",
			"special_bonus_unique_witch_doctor_2"
		}
	},

	["npc_dota_hero_zuus"] = {
		["talentTree"] = {
			"special_bonus_mp_regen_2",
			"special_bonus_hp_175",
			"special_bonus_armor_5",
			"special_bonus_magic_resistance_10",
			"special_bonus_movement_speed_35",
			"special_bonus_respawn_reduction_40",
			"special_bonus_cast_range_200",
			"special_bonus_unique_zeus"
		},

		["abilityTable"] = {
			"zuus_arc_lightning",
			"zuus_lightning_bolt",
			"zuus_static_field",
			"zuus_lightning_bolt",
			"zuus_lightning_bolt",
			"zuus_thundergods_wrath",

			"zuus_lightning_bolt",
			"zuus_arc_lightning",
			"zuus_arc_lightning",
			"special_bonus_hp_175",
			"zuus_arc_lightning",
			"zuus_thundergods_wrath",

			"zuus_static_field",
			"zuus_static_field",
			"special_bonus_armor_5",
			"zuus_static_field",
			"zuus_thundergods_wrath",

			"special_bonus_respawn_reduction_40",
			"special_bonus_cast_range_200"
		}
	}
}

----------------------------------------------------------------------------------------------------

return X