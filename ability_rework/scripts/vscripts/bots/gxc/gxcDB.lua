-- generic database
----------------------------------------------------------------------------------------------------

local X = {}

----------------------------------------------------------------------------------------------------

-- ["mid"] will become more useful later in the game if they gain a significant gold advantage.
-- ["durable"] has the ability to last longer in teamfights.
-- ["support"] can focus less on amassing gold and items, and more on using their abilities to gain an advantage for the team.
-- ["escape"] has the ability to quickly avoid death.
-- ["nuker"] can quickly kill enemy heroes using high damage spells with low cooldowns.
-- ["pusher"] can quickly siege and destroy towers and barracks at all points of the game.
-- ["disabler"] has a guaranteed disable for one or more of their spells.
-- ["initiator"] good at starting a teamfight.
-- ["jungler"] can farm effectively from neutral creeps inside the jungle early in the game.

X["hero_ability"] = {
	["npc_dota_hero_abaddon"] = {
		["mid"] = 1,
		["durable"] = 2,
		["support"] = 2
	},

	["npc_dota_hero_alchemist"] = {
		["mid"] = 2,
		["durable"] = 2,
		["support"] = 1,
		["nuker"] = 1,
		["disabler"] = 1,
		["initiator"] = 1
	},

	["npc_dota_hero_axe"] = {
		["durable"] = 3,
		["disabler"] = 2,
		["initiator"] = 3,
		["jungler"] = 2
	},

	["npc_dota_hero_beastmaster"] = {
		["durable"] = 2,
		["nuker"] = 1,
		["disabler"] = 2,
		["initiator"] = 2
	},

	["npc_dota_hero_brewmaster"] = {
		["mid"] = 1,
		["durable"] = 2,
		["nuker"] = 1,
		["disabler"] = 2,
		["initiator"] = 3
	},

	["npc_dota_hero_bristleback"] = {
		["mid"] = 2,
		["durable"] = 3,
		["nuker"] = 1,
		["initiator"] = 1
	},

	["npc_dota_hero_centaur"] = {
		["durable"] = 3,
		["escape"] = 1,
		["nuker"] = 1,
		["disabler"] = 1,
		["initiator"] = 3
	},

	["npc_dota_hero_chaos_knight"] = {
		["mid"] = 3,
		["durable"] = 2,
		["pusher"] = 2,
		["disabler"] = 2,
		["initiator"] = 1
	},

	["npc_dota_hero_rattletrap"] = {
		["durable"] = 1,
		["nuker"] = 1,
		["disabler"] = 2,
		["initiator"] = 3
	},

	["npc_dota_hero_doom_bringer"] = {
		["mid"] = 1,
		["durable"] = 2,
		["nuker"] = 1,
		["disabler"] = 2,
		["initiator"] = 2
	},

	["npc_dota_hero_dragon_knight"] = {
		["mid"] = 2,
		["durable"] = 2,
		["nuker"] = 1,
		["pusher"] = 3,
		["disabler"] = 2,
		["initiator"] = 1
	},

	["npc_dota_hero_earth_spirit"] = {
		["durable"] = 1,
		["escape"] = 2,
		["nuker"] = 2,
		["disabler"] = 1,
		["initiator"] = 1
	},

	["npc_dota_hero_earthshaker"] = {
		["support"] = 1,
		["nuker"] = 1,
		["disabler"] = 2,
		["initiator"] = 3
	},

	["npc_dota_hero_elder_titan"] = {
		["durable"] = 1,
		["nuker"] = 1,
		["disabler"] = 1,
		["initiator"] = 2
	},

	["npc_dota_hero_huskar"] = {
		["mid"] = 2,
		["durable"] = 2,
		["initiator"] = 1
	},

	["npc_dota_hero_wisp"] = {
		["support"] = 3,
		["escape"] = 2,
		["nuker"] = 1
	},

	["npc_dota_hero_kunkka"] = {
		["mid"] = 1,
		["durable"] = 1,
		["nuker"] = 1,
		["disabler"] = 1,
		["initiator"] = 1
	},

	["npc_dota_hero_legion_commander"] = {
		["mid"] = 1,
		["durable"] = 1,
		["nuker"] = 1,
		["disabler"] = 2,
		["initiator"] = 1
	},

	["npc_dota_hero_life_stealer"] = {
		["mid"] = 2,
		["durable"] = 2,
		["escape"] = 1,
		["disabler"] = 1,
		["jungler"] = 1
	},

	["npc_dota_hero_lycan"] = {
		["mid"] = 2,
		["durable"] = 1,
		["escape"] = 1,
		["pusher"] = 3,
		["jungler"] = 1
	},

	["npc_dota_hero_magnataur"] = {
		["escape"] = 1,
		["nuker"] = 1,
		["disabler"] = 2,
		["initiator"] = 3
	},

	["npc_dota_hero_night_stalker"] = {
		["mid"] = 1,
		["durable"] = 2,
		["nuker"] = 1,
		["disabler"] = 2,
		["initiator"] = 2
	},

	["npc_dota_hero_omniknight"] = {
		["durable"] = 1,
		["support"] = 2,
		["nuker"] = 1
	},

	["npc_dota_hero_phoenix"] = {
		["support"] = 1,
		["escape"] = 2,
		["nuker"] = 3,
		["disabler"] = 1,
		["initiator"] = 2
	},

	["npc_dota_hero_pudge"] = {
		["durable"] = 2,
		["nuker"] = 1,
		["disabler"] = 2,
		["initiator"] = 2
	},

	["npc_dota_hero_sand_king"] = {
		["escape"] = 2,
		["nuker"] = 2,
		["disabler"] = 2,
		["initiator"] = 3,
		["jungler"] = 1
	},

	["npc_dota_hero_slardar"] = {
		["mid"] = 2,
		["durable"] = 2,
		["escape"] = 1,
		["disabler"] = 1,
		["initiator"] = 2
	},

	["npc_dota_hero_spirit_breaker"] = {
		["mid"] = 1,
		["durable"] = 2,
		["escape"] = 1,
		["disabler"] = 2,
		["initiator"] = 2
	},

	["npc_dota_hero_sven"] = {
		["mid"] = 2,
		["durable"] = 2,
		["nuker"] = 1,
		["disabler"] = 2,
		["initiator"] = 2
	},

	["npc_dota_hero_tidehunter"] = {
		["durable"] = 3,
		["nuker"] = 1,
		["disabler"] = 2,
		["initiator"] = 3
	},

	["npc_dota_hero_shredder"] = {
		["durable"] = 2,
		["escape"] = 2,
		["nuker"] = 2
	},

	["npc_dota_hero_tiny"] = {
		["mid"] = 3,
		["durable"] = 2,
		["nuker"] = 2,
		["pusher"] = 2,
		["disabler"] = 1,
		["initiator"] = 2
	},

	["npc_dota_hero_treant"] = {
		["durable"] = 1,
		["support"] = 3,
		["escape"] = 1,
		["disabler"] = 1,
		["initiator"] = 2
	},

	["npc_dota_hero_tusk"] = {
		["nuker"] = 1,
		["disabler"] = 2,
		["initiator"] = 2
	},

	["npc_dota_hero_abyssal_underlord"] = {
		["durable"] = 1,
		["support"] = 1,
		["escape"] = 2,
		["nuker"] = 1,
		["disabler"] = 1
	},

	["npc_dota_hero_undying"] = {
		["durable"] = 2,
		["support"] = 1,
		["nuker"] = 1,
		["disabler"] = 1
	},

	["npc_dota_hero_skeleton_king"] = {
		["mid"] = 2,
		["durable"] = 3,
		["support"] = 1,
		["disabler"] = 2,
		["initiator"] = 1
	},

	["npc_dota_hero_antimage"] = {
		["mid"] = 3,
		["escape"] = 3,
		["nuker"] = 1
	},

	["npc_dota_hero_arc_warden"] = {
		["mid"] = 3,
		["escape"] = 3,
		["nuker"] = 1
	},

	["npc_dota_hero_bloodseeker"] = {
		["mid"] = 1,
		["nuker"] = 1,
		["disabler"] = 1,
		["initiator"] = 1,
		["jungler"] = 1
	},

	["npc_dota_hero_bounty_hunter"] = {
		["escape"] = 2,
		["nuker"] = 1
	},

	["npc_dota_hero_broodmother"] = {
		["mid"] = 1,
		["escape"] = 3,
		["nuker"] = 1,
		["pusher"] = 3
	},

	["npc_dota_hero_clinkz"] = {
		["mid"] = 2,
		["escape"] = 3,
		["pusher"] = 1
	},

	["npc_dota_hero_drow_ranger"] = {
		["mid"] = 2,
		["pusher"] = 1,
		["disabler"] = 1
	},

	["npc_dota_hero_ember_spirit"] = {
		["mid"] = 2,
		["escape"] = 3,
		["nuker"] = 1,
		["disabler"] = 1,
		["initiator"] = 1
	},

	["npc_dota_hero_faceless_void"] = {
		["mid"] = 2,
		["durable"] = 1,
		["escape"] = 1,
		["disabler"] = 2,
		["initiator"] = 3
	},

	["npc_dota_hero_gyrocopter"] = {
		["mid"] = 3,
		["nuker"] = 1,
		["disabler"] = 1
	},

	["npc_dota_hero_juggernaut"] = {
		["mid"] = 2,
		["escape"] = 1,
		["pusher"] = 1
	},

	["npc_dota_hero_lone_druid"] = {
		["mid"] = 2,
		["durable"] = 1,
		["pusher"] = 3,
		["jungler"] = 1
	},

	["npc_dota_hero_luna"] = {
		["mid"] = 2,
		["nuker"] = 2,
		["pusher"] = 1
	},

	["npc_dota_hero_medusa"] = {
		["mid"] = 3,
		["durable"] = 1,
		["disabler"] = 1
	},

	["npc_dota_hero_meepo"] = {
		["mid"] = 2,
		["escape"] = 2,
		["nuker"] = 2,
		["pusher"] = 1,
		["disabler"] = 1,
		["initiator"] = 1
	},

	["npc_dota_hero_mirana"] = {
		["mid"] = 1,
		["support"] = 1,
		["escape"] = 2,
		["nuker"] = 1,
		["disabler"] = 1
	},

	["npc_dota_hero_monkey_king"] = {
		["mid"] = 2,
		["escape"] = 2,
		["disabler"] = 1,
		["initiator"] = 1
	},

	["npc_dota_hero_morphling"] = {
		["mid"] = 3,
		["durable"] = 2,
		["escape"] = 3,
		["nuker"] = 1,
		["disabler"] = 1
	},

	["npc_dota_hero_naga_siren"] = {
		["mid"] = 3,
		["support"] = 1,
		["escape"] = 1,
		["pusher"] = 2,
		["disabler"] = 2,
		["initiator"] = 1
	},

	["npc_dota_hero_nyx_assassin"] = {
		["escape"] = 1,
		["nuker"] = 2,
		["disabler"] = 2,
		["initiator"] = 2
	},

	["npc_dota_hero_phantom_assassin"] = {
		["mid"] = 3,
		["escape"] = 1
	},

	["npc_dota_hero_phantom_lancer"] = {
		["mid"] = 2,
		["escape"] = 2,
		["nuker"] = 1,
		["pusher"] = 1
	},

	["npc_dota_hero_razor"] = {
		["mid"] = 2,
		["durable"] = 2,
		["nuker"] = 1,
		["pusher"] = 1
	},

	["npc_dota_hero_riki"] = {
		["mid"] = 2,
		["escape"] = 2,
		["disabler"] = 1
	},

	["npc_dota_hero_nevermore"] = {
		["mid"] = 2,
		["nuker"] = 3
	},

	["npc_dota_hero_slark"] = {
		["mid"] = 2,
		["escape"] = 3,
		["nuker"] = 1,
		["disabler"] = 1
	},

	["npc_dota_hero_sniper"] = {
		["mid"] = 3,
		["nuker"] = 1
	},

	["npc_dota_hero_spectre"] = {
		["mid"] = 3,
		["durable"] = 1,
		["escape"] = 1
	},

	["npc_dota_hero_templar_assassin"] = {
		["mid"] = 2,
		["escape"] = 1
	},

	["npc_dota_hero_terrorblade"] = {
		["mid"] = 3,
		["nuker"] = 1,
		["pusher"] = 2
	},

	["npc_dota_hero_troll_warlord"] = {
		["mid"] = 3,
		["durable"] = 1,
		["pusher"] = 2,
		["disabler"] = 1
	},

	["npc_dota_hero_ursa"] = {
		["mid"] = 2,
		["durable"] = 1,
		["disabler"] = 1,
		["jungler"] = 1
	},

	["npc_dota_hero_vengefulspirit"] = {
		["mid"] = 1,
		["support"] = 3,
		["escape"] = 1,
		["nuker"] = 1,
		["pusher"] = 1,
		["disabler"] = 1,
		["initiator"] = 2
	},

	["npc_dota_hero_venomancer"] = {
		["mid"] = 1,
		["support"] = 2,
		["nuker"] = 1,
		["pusher"] = 1,
		["disabler"] = 1,
		["initiator"] = 1
	},

	["npc_dota_hero_viper"] = {
		["mid"] = 1,
		["durable"] = 2,
		["disabler"] = 1,
		["initiator"] = 1
	},

	["npc_dota_hero_weaver"] = {
		["mid"] = 2,
		["escape"] = 3
	},

	["npc_dota_hero_ancient_apparition"] = {
		["support"] = 2,
		["nuker"] = 1,
		["disabler"] = 1
	},

	["npc_dota_hero_bane"] = {
		["durable"] = 1,
		["support"] = 2,
		["nuker"] = 1,
		["disabler"] = 3
	},

	["npc_dota_hero_batrider"] = {
		["escape"] = 1,
		["disabler"] = 2,
		["initiator"] = 3,
		["jungler"] = 2
	},

	["npc_dota_hero_chen"] = {
		["support"] = 2,
		["pusher"] = 2,
		["jungler"] = 3
	},

	["npc_dota_hero_crystal_maiden"] = {
		["support"] = 3,
		["nuker"] = 2,
		["disabler"] = 2,
		["jungler"] = 1
	},

	["npc_dota_hero_dark_seer"] = {
		["escape"] = 1,
		["disabler"] = 1,
		["initiator"] = 1,
		["jungler"] = 1
	},

	["npc_dota_hero_dazzle"] = {
		["support"] = 3,
		["nuker"] = 1,
		["disabler"] = 1
	},

	["npc_dota_hero_death_prophet"] = {
		["mid"] = 1,
		["nuker"] = 1,
		["pusher"] = 3,
		["disabler"] = 1
	},

	["npc_dota_hero_disruptor"] = {
		["support"] = 2,
		["nuker"] = 1,
		["disabler"] = 2,
		["initiator"] = 1
	},

	["npc_dota_hero_enchantress"] = {
		["support"] = 2,
		["durable"] = 1,
		["support"] = 2,
		["pusher"] = 2,
		["disabler"] = 1,
		["jungler"] = 3
	},

	["npc_dota_hero_enigma"] = {
		["pusher"] = 2,
		["disabler"] = 2,
		["initiator"] = 2,
		["jungler"] = 3
	},

	["npc_dota_hero_invoker"] = {
		["mid"] = 1,
		["escape"] = 1,
		["nuker"] = 3,
		["pusher"] = 1,
		["disabler"] = 2
	},

	["npc_dota_hero_jakiro"] = {
		["support"] = 1,
		["nuker"] = 2,
		["pusher"] = 2,
		["disabler"] = 1
	},

	["npc_dota_hero_keeper_of_the_light"] = {
		["support"] = 3,
		["nuker"] = 2,
		["disabler"] = 1,
		["jungler"] = 1
	},

	["npc_dota_hero_leshrac"] = {
		["mid"] = 1,
		["support"] = 1,
		["nuker"] = 3,
		["pusher"] = 3,
		["disabler"] = 1
	},

	["npc_dota_hero_lich"] = {
		["support"] = 3,
		["nuker"] = 2
	},

	["npc_dota_hero_lina"] = {
		["mid"] = 1,
		["support"] = 1,
		["nuker"] = 3,
		["disabler"] = 1
	},

	["npc_dota_hero_lion"] = {
		["support"] = 2,
		["nuker"] = 3,
		["disabler"] = 3,
		["initiator"] = 2
	},

	["npc_dota_hero_furion"] = {
		["mid"] = 1,
		["escape"] = 1,
		["nuker"] = 1,
		["pusher"] = 3,
		["jungler"] = 3
	},

	["npc_dota_hero_necrolyte"] = {
		["mid"] = 1,
		["durable"] = 1,
		["nuker"] = 2,
		["disabler"] = 1
	},

	["npc_dota_hero_ogre_magi"] = {
		["durable"] = 1,
		["support"] = 2,
		["nuker"] = 2,
		["disabler"] = 2,
		["initiator"] = 1
	},

	["npc_dota_hero_oracle"] = {
		["support"] = 3,
		["escape"] = 1,
		["nuker"] = 3,
		["disabler"] = 2,
	},

	["npc_dota_hero_obsidian_destroyer"] = {
		["mid"] = 2,
		["nuker"] = 2,
		["disabler"] = 1
	},

	["npc_dota_hero_puck"] = {
		["escape"] = 3,
		["nuker"] = 2,
		["disabler"] = 3,
		["initiator"] = 3
	},

	["npc_dota_hero_pugna"] = {
		["nuker"] = 2,
		["pusher"] = 2
	},

	["npc_dota_hero_queenofpain"] = {
		["mid"] = 1,
		["escape"] = 3,
		["nuker"] = 3
	},

	["npc_dota_hero_rubick"] = {
		["support"] = 2,
		["nuker"] = 1,
		["disabler"] = 1
	},

	["npc_dota_hero_shadow_demon"] = {
		["support"] = 2,
		["nuker"] = 1,
		["disabler"] = 2,
		["initiator"] = 1
	},

	["npc_dota_hero_shadow_shaman"] = {
		["support"] = 2,
		["nuker"] = 2,
		["pusher"] = 3,
		["disabler"] = 3,
		["initiator"] = 1
	},

	["npc_dota_hero_silencer"] = {
		["mid"] = 1,
		["support"] = 1,
		["nuker"] = 1,
		["disabler"] = 2,
		["initiator"] = 2
	},

	["npc_dota_hero_skywrath_mage"] = {
		["support"] = 2,
		["nuker"] = 3,
		["disabler"] = 1
	},

	["npc_dota_hero_storm_spirit"] = {
		["mid"] = 2,
		["escape"] = 3,
		["nuker"] = 2,
		["disabler"] = 1,
		["initiator"] = 1
	},

	["npc_dota_hero_techies"] = {
		["nuker"] = 3,
		["disabler"] = 1
	},

	["npc_dota_hero_tinker"] = {
		["mid"] = 1,
		["nuker"] = 3,
		["pusher"] = 2
	},

	["npc_dota_hero_visage"] = {
		["durable"] = 1,
		["support"] = 1,
		["nuker"] = 2,
		["pusher"] = 1,
		["disabler"] = 1
	},

	["npc_dota_hero_warlock"] = {
		["support"] = 1,
		["disabler"] = 1,
		["initiator"] = 2
	},

	["npc_dota_hero_windrunner"] = {
		["mid"] = 1,
		["support"] = 1,
		["escape"] = 1,
		["nuker"] = 1,
		["disabler"] = 1
	},

	["npc_dota_hero_winter_wyvern"] = {
		["support"] = 3,
		["nuker"] = 1,
		["disabler"] = 2
	},

	["npc_dota_hero_witch_doctor"] = {
		["support"] = 3,
		["nuker"] = 2,
		["disabler"] = 1
	},

	["npc_dota_hero_zuus"] = {
		["nuker"] = 3
	}
}

----------------------------------------------------------------------------------------------------

-- ["carry"]: carry is 'better', mid or few offlane is 'good', most support or offlane is 'bad'.
-- ["mid"]: mid is 'better', carry or few offlane is 'good', most support or offlane is 'bad'.
-- ["offlane"]: offlane or some support is 'better', most mid or the other support is 'good', most carry is 'bad'.
-- ["support"]: support is 'better', few semi-support or most offlane is 'good', most carry or mid is 'bad'.

X["hero_roles"] = {
	["carry"] = {
		"npc_dota_hero_morphling",
		"npc_dota_hero_terrorblade",
		"npc_dota_hero_spectre",
		"npc_dota_hero_troll_warlord",
		"npc_dota_hero_naga_siren",
		"npc_dota_hero_antimage",
		"npc_dota_hero_luna",
		"npc_dota_hero_life_stealer",
		"npc_dota_hero_slark",
		"npc_dota_hero_chaos_knight",
		"npc_dota_hero_faceless_void",
		"npc_dota_hero_phantom_assassin",
		"npc_dota_hero_skeleton_king",
		"npc_dota_hero_sven",
		"npc_dota_hero_phantom_lancer",
		"npc_dota_hero_lone_druid",
		"npc_dota_hero_sniper",
		"npc_dota_hero_drow_ranger",
		"npc_dota_hero_weaver",
		"npc_dota_hero_medusa",
		"npc_dota_hero_arcwarden",
		"npc_dota_hero_clinkz",
		"npc_dota_hero_tiny",
		"npc_dota_hero_huskar",
		"npc_dota_hero_gyrocopter",
		"npc_dota_hero_alchemist",
		"npc_dota_hero_lycan",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_dragon_knight",
		"npc_dota_hero_slardar",
		"npc_dota_hero_bristleback",
		"npc_dota_hero_razor",
		"npc_dota_hero_riki",
		"npc_dota_hero_templar_assassin",
		"npc_dota_hero_nevermore",
		"npc_dota_hero_ember_spirit",
		"npc_dota_hero_ursa",
		"npc_dota_hero_meepo",
		"npc_dota_hero_monkey_king",
		"npc_dota_hero_obsidian_destroyer",
		"npc_dota_hero_storm_spirit",
		"npc_dota_hero_abaddon",
		"npc_dota_hero_legion_commander",
		"npc_dota_hero_kunkka",
		"npc_dota_hero_night_stalker",
		"npc_dota_hero_doom_bringer",
		"npc_dota_hero_spirit_breaker",
		"npc_dota_hero_brewmaster",
		"npc_dota_hero_viper",
		"npc_dota_hero_bloodseeker",
		"npc_dota_hero_mirana",
		"npc_dota_hero_broodmother",
		"npc_dota_hero_tinker",
		"npc_dota_hero_furion",
		"npc_dota_hero_leshrac",
		"npc_dota_hero_death_prophet",
		"npc_dota_hero_silencer",
		"npc_dota_hero_queenofpain",
		"npc_dota_hero_necrolyte",
		"npc_dota_hero_vengefulspirit",
		"npc_dota_hero_invoker",
		"npc_dota_hero_lina",
		"npc_dota_hero_windrunner",

		"npc_dota_hero_elder_titan",
		"npc_dota_hero_shredder",
		"npc_dota_hero_beastmaster",
		"npc_dota_hero_centaur",
		"npc_dota_hero_rattletrap",
		"npc_dota_hero_nyx_assassin",
		"npc_dota_hero_earth_spirit",
		"npc_dota_hero_zuus",
		"npc_dota_hero_techies",
		"npc_dota_hero_tusk",
		"npc_dota_hero_puck",
		"npc_dota_hero_pudge",
		"npc_dota_hero_pugna",
		"npc_dota_hero_axe",
		"npc_dota_hero_sand_king",
		"npc_dota_hero_tidehunter",
		"npc_dota_hero_batrider",
		"npc_dota_hero_enigma",
		"npc_dota_hero_bounty_hunter",
		"npc_dota_hero_magnataur",
		"npc_dota_hero_dark_seer",

		"npc_dota_hero_undying",
		"npc_dota_hero_phoenix",
		"npc_dota_hero_abyssal_underlord",
		"npc_dota_hero_earthshaker",
		"npc_dota_hero_warlock",
		"npc_dota_hero_jakiro",
		"npc_dota_hero_visage",
		"npc_dota_hero_omniknight",
		"npc_dota_hero_venomancer",
		"npc_dota_hero_skywrath_mage",
		"npc_dota_hero_disruptor",
		"npc_dota_hero_rubick",
		"npc_dota_hero_shadow_demon",
		"npc_dota_hero_shadow_shaman",
		"npc_dota_hero_bane",
		"npc_dota_hero_lion",
		"npc_dota_hero_ancient_apparition",
		"npc_dota_hero_chen",
		"npc_dota_hero_ogre_magi",
		"npc_dota_hero_enchantress",
		"npc_dota_hero_treant",
		"npc_dota_hero_wisp",
		"npc_dota_hero_keeper_of_the_light",
		"npc_dota_hero_winter_wyvern",
		"npc_dota_hero_witch_doctor",
		"npc_dota_hero_lich",
		"npc_dota_hero_dazzle",
		"npc_dota_hero_crystal_maiden",
		"npc_dota_hero_oracle"
	},

	["mid"] = {
		"npc_dota_hero_meepo",
		"npc_dota_hero_invoker",
		"npc_dota_hero_nevermore",
		"npc_dota_hero_templar_assassin",
		"npc_dota_hero_tinker",
		"npc_dota_hero_death_prophet",
		"npc_dota_hero_obsidian_destroyer",
		"npc_dota_hero_storm_spirit",
		"npc_dota_hero_queenofpain",
		"npc_dota_hero_dragon_knight",
		"npc_dota_hero_alchemist",
		"npc_dota_hero_tiny",
		"npc_dota_hero_viper",
		"npc_dota_hero_shredder",
		"npc_dota_hero_medusa",
		"npc_dota_hero_gyrocopter",
		"npc_dota_hero_razor",
		"npc_dota_hero_sniper",
		"npc_dota_hero_huskar",
		"npc_dota_hero_ember_spirit",
		"npc_dota_hero_lone_druid",
		"npc_dota_hero_monkey_king",
		"npc_dota_hero_puck",
		"npc_dota_hero_mirana",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_phantom_assassin",
		"npc_dota_hero_arcwarden",
		"npc_dota_hero_legion_commander",
		"npc_dota_hero_bloodseeker",
		"npc_dota_hero_clinkz",
		"npc_dota_hero_ursa",
		"npc_dota_hero_troll_warlord",
		"npc_dota_hero_antimage",
		"npc_dota_hero_magnataur",
		"npc_dota_hero_lina",
		"npc_dota_hero_windrunner",
		"npc_dota_hero_pudge",
		"npc_dota_hero_drow_ranger",

		"npc_dota_hero_venomancer",
		"npc_dota_hero_skywrath_mage",
		"npc_dota_hero_warlock",
		"npc_dota_hero_spectre",
		"npc_dota_hero_naga_siren",
		"npc_dota_hero_chaos_knight",
		"npc_dota_hero_terrorblade",
		"npc_dota_hero_morphling",
		"npc_dota_hero_skeleton_king",
		"npc_dota_hero_life_stealer",
		"npc_dota_hero_slardar",
		"npc_dota_hero_sven",
		"npc_dota_hero_lycan",
		"npc_dota_hero_bristleback",
		"npc_dota_hero_riki",
		"npc_dota_hero_phantom_lancer",
		"npc_dota_hero_slark",
		"npc_dota_hero_weaver",
		"npc_dota_hero_faceless_void",
		"npc_dota_hero_luna",
		"npc_dota_hero_abaddon",
		"npc_dota_hero_kunkka",
		"npc_dota_hero_night_stalker",
		"npc_dota_hero_doom_bringer",
		"npc_dota_hero_spirit_breaker",
		"npc_dota_hero_brewmaster",
		"npc_dota_hero_broodmother",
		"npc_dota_hero_furion",
		"npc_dota_hero_leshrac",
		"npc_dota_hero_silencer",
		"npc_dota_hero_necrolyte",
		"npc_dota_hero_vengefulspirit",

		"npc_dota_hero_elder_titan",
		"npc_dota_hero_beastmaster",
		"npc_dota_hero_centaur",
		"npc_dota_hero_rattletrap",
		"npc_dota_hero_nyx_assassin",
		"npc_dota_hero_earth_spirit",
		"npc_dota_hero_zuus",
		"npc_dota_hero_techies",
		"npc_dota_hero_tusk",
		"npc_dota_hero_pugna",
		"npc_dota_hero_axe",
		"npc_dota_hero_sand_king",
		"npc_dota_hero_tidehunter",
		"npc_dota_hero_batrider",
		"npc_dota_hero_enigma",
		"npc_dota_hero_bounty_hunter",
		"npc_dota_hero_dark_seer",
		"npc_dota_hero_undying",
		"npc_dota_hero_phoenix",
		"npc_dota_hero_abyssal_underlord",
		"npc_dota_hero_earthshaker",
		"npc_dota_hero_jakiro",
		"npc_dota_hero_visage",
		"npc_dota_hero_omniknight",
		"npc_dota_hero_disruptor",
		"npc_dota_hero_rubick",
		"npc_dota_hero_shadow_demon",
		"npc_dota_hero_shadow_shaman",
		"npc_dota_hero_bane",
		"npc_dota_hero_lion",
		"npc_dota_hero_ancient_apparition",
		"npc_dota_hero_chen",
		"npc_dota_hero_ogre_magi",
		"npc_dota_hero_enchantress",
		"npc_dota_hero_treant",
		"npc_dota_hero_wisp",
		"npc_dota_hero_keeper_of_the_light",
		"npc_dota_hero_winter_wyvern",
		"npc_dota_hero_witch_doctor",
		"npc_dota_hero_lich",
		"npc_dota_hero_dazzle",
		"npc_dota_hero_crystal_maiden",
		"npc_dota_hero_oracle"
	},

	["offlane"] = {
		"npc_dota_hero_dark_seer",
		"npc_dota_hero_abyssal_underlord",
		"npc_dota_hero_rattletrap",
		"npc_dota_hero_centaur",
		"npc_dota_hero_slardar",
		"npc_dota_hero_magnataur",
		"npc_dota_hero_nyx_assassin",
		"npc_dota_hero_sand_king",
		"npc_dota_hero_batrider",
		"npc_dota_hero_axe",
		"npc_dota_hero_tidehunter",
		"npc_dota_hero_shredder",
		"npc_dota_hero_doom_bringer",
		"npc_dota_hero_bristleback",
		"npc_dota_hero_brewmaster",
		"npc_dota_hero_razor",
		"npc_dota_hero_legion_commander",
		"npc_dota_hero_mirana",
		"npc_dota_hero_faceless_void",
		"npc_dota_hero_enigma",
		"npc_dota_hero_beastmaster",
		"npc_dota_hero_windrunner",

		"npc_dota_hero_night_stalker",
		"npc_dota_hero_abaddon",
		"npc_dota_hero_kunkka",
		"npc_dota_hero_broodmother",
		"npc_dota_hero_earthshaker",
		"npc_dota_hero_zuus",
		"npc_dota_hero_tusk",
		"npc_dota_hero_earth_spirit",
		"npc_dota_hero_warlock",
		"npc_dota_hero_necrolyte",
		"npc_dota_hero_spirit_breaker",
		"npc_dota_hero_pugna",
		"npc_dota_hero_bounty_hunter",
		"npc_dota_hero_undying",
		"npc_dota_hero_phoenix",
		"npc_dota_hero_jakiro",
		"npc_dota_hero_visage",
		"npc_dota_hero_omniknight",
		"npc_dota_hero_venomancer",
		"npc_dota_hero_skywrath_mage",
		"npc_dota_hero_disruptor",
		"npc_dota_hero_pudge",
		"npc_dota_hero_rubick",
		"npc_dota_hero_shadow_demon",
		"npc_dota_hero_shadow_shaman",
		"npc_dota_hero_bane",
		"npc_dota_hero_lion",
		"npc_dota_hero_ancient_apparition",
		"npc_dota_hero_chen",
		"npc_dota_hero_ogre_magi",
		"npc_dota_hero_enchantress",
		"npc_dota_hero_treant",
		"npc_dota_hero_wisp",
		"npc_dota_hero_keeper_of_the_light",
		"npc_dota_hero_winter_wyvern",
		"npc_dota_hero_witch_doctor",
		"npc_dota_hero_lich",
		"npc_dota_hero_dazzle",
		"npc_dota_hero_crystal_maiden",
		"npc_dota_hero_oracle",
		"npc_dota_hero_riki",
		"npc_dota_hero_lina",
		"npc_dota_hero_vengefulspirit",
		"npc_dota_hero_elder_titan",
		"npc_dota_hero_techies",
		"npc_dota_hero_leshrac",
		"npc_dota_hero_silencer",
		"npc_dota_hero_viper",
		"npc_dota_hero_bloodseeker",
		"npc_dota_hero_drow_ranger",
		"npc_dota_hero_templar_assassin",
		"npc_dota_hero_phantom_lancer",
		"npc_dota_hero_nevermore",
		"npc_dota_hero_lone_druid",
		"npc_dota_hero_slark",
		"npc_dota_hero_ember_spirit",
		"npc_dota_hero_ursa",
		"npc_dota_hero_weaver",
		"npc_dota_hero_luna",
		"npc_dota_hero_monkey_king",
		"npc_dota_hero_obsidian_destroyer",
		"npc_dota_hero_storm_spirit",
		"npc_dota_hero_tinker",
		"npc_dota_hero_furion",

		"npc_dota_hero_tiny",
		"npc_dota_hero_death_prophet",
		"npc_dota_hero_queenofpain",
		"npc_dota_hero_invoker",
		"npc_dota_hero_puck",
		"npc_dota_hero_clinkz",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_dragon_knight",
		"npc_dota_hero_lycan",
		"npc_dota_hero_alchemist",
		"npc_dota_hero_sven",
		"npc_dota_hero_life_stealer",
		"npc_dota_hero_huskar",
		"npc_dota_hero_skeleton_king",
		"npc_dota_hero_gyrocopter",
		"npc_dota_hero_sniper",
		"npc_dota_hero_phantom_assassin",
		"npc_dota_hero_medusa",
		"npc_dota_hero_arcwarden",
		"npc_dota_hero_antimage",
		"npc_dota_hero_naga_siren",
		"npc_dota_hero_troll_warlord",
		"npc_dota_hero_chaos_knight",
		"npc_dota_hero_spectre",
		"npc_dota_hero_terrorblade",
		"npc_dota_hero_morphling",
		"npc_dota_hero_meepo"
	},

	["support"] = {
		"npc_dota_hero_treant",
		"npc_dota_hero_wisp",
		"npc_dota_hero_keeper_of_the_light",
		"npc_dota_hero_winter_wyvern",
		"npc_dota_hero_witch_doctor",
		"npc_dota_hero_lich",
		"npc_dota_hero_dazzle",
		"npc_dota_hero_crystal_maiden",
		"npc_dota_hero_oracle",
		"npc_dota_hero_omniknight",
		"npc_dota_hero_skywrath_mage",
		"npc_dota_hero_disruptor",
		"npc_dota_hero_rubick",
		"npc_dota_hero_shadow_demon",
		"npc_dota_hero_shadow_shaman",
		"npc_dota_hero_bane",
		"npc_dota_hero_lion",
		"npc_dota_hero_ancient_apparition",
		"npc_dota_hero_bounty_hunter",
		"npc_dota_hero_chen",
		"npc_dota_hero_ogre_magi",
		"npc_dota_hero_enchantress",
		"npc_dota_hero_venomancer",
		"npc_dota_hero_undying",
		"npc_dota_hero_phoenix",
		"npc_dota_hero_abyssal_underlord",
		"npc_dota_hero_earthshaker",
		"npc_dota_hero_warlock",
		"npc_dota_hero_jakiro",
		"npc_dota_hero_visage",
		"npc_dota_hero_elder_titan",
		"npc_dota_hero_techies",
		"npc_dota_hero_tusk",
		"npc_dota_hero_pudge",
		"npc_dota_hero_earth_spirit",
		"npc_dota_hero_zuus",
		"npc_dota_hero_pugna",

		"npc_dota_hero_lina",
		"npc_dota_hero_beastmaster",
		"npc_dota_hero_rattletrap",
		"npc_dota_hero_nyx_assassin",
		"npc_dota_hero_enigma",
		"npc_dota_hero_abaddon",
		"npc_dota_hero_windrunner",
		"npc_dota_hero_vengefulspirit",
		"npc_dota_hero_kunkka",
		"npc_dota_hero_night_stalker",
		"npc_dota_hero_spirit_breaker",
		"npc_dota_hero_leshrac",
		"npc_dota_hero_silencer",
		"npc_dota_hero_riki",
		"npc_dota_hero_slardar",
		"npc_dota_hero_batrider",
		"npc_dota_hero_sand_king",
		"npc_dota_hero_doom_bringer",
		"npc_dota_hero_weaver",
		"npc_dota_hero_mirana",
		"npc_dota_hero_naga_siren",

		"npc_dota_hero_centaur",
		"npc_dota_hero_shredder",
		"npc_dota_hero_axe",
		"npc_dota_hero_tidehunter",
		"npc_dota_hero_magnataur",
		"npc_dota_hero_dark_seer",
		"npc_dota_hero_puck",
		"npc_dota_hero_brewmaster",
		"npc_dota_hero_legion_commander",
		"npc_dota_hero_viper",
		"npc_dota_hero_bloodseeker",
		"npc_dota_hero_broodmother",
		"npc_dota_hero_tinker",
		"npc_dota_hero_furion",
		"npc_dota_hero_death_prophet",
		"npc_dota_hero_queenofpain",
		"npc_dota_hero_necrolyte",
		"npc_dota_hero_invoker",
		"npc_dota_hero_skeleton_king",
		"npc_dota_hero_huskar",
		"npc_dota_hero_life_stealer",
		"npc_dota_hero_sven",
		"npc_dota_hero_alchemist",
		"npc_dota_hero_lycan",
		"npc_dota_hero_bristleback",
		"npc_dota_hero_dragon_knight",
		"npc_dota_hero_juggernaut",
		"npc_dota_hero_clinkz",
		"npc_dota_hero_razor",
		"npc_dota_hero_drow_ranger",
		"npc_dota_hero_templar_assassin",
		"npc_dota_hero_phantom_lancer",
		"npc_dota_hero_nevermore",
		"npc_dota_hero_lone_druid",
		"npc_dota_hero_slark",
		"npc_dota_hero_ember_spirit",
		"npc_dota_hero_ursa",
		"npc_dota_hero_meepo",
		"npc_dota_hero_faceless_void",
		"npc_dota_hero_luna",
		"npc_dota_hero_monkey_king",
		"npc_dota_hero_obsidian_destroyer",
		"npc_dota_hero_storm_spirit",
		"npc_dota_hero_gyrocopter",
		"npc_dota_hero_sniper",
		"npc_dota_hero_tiny",
		"npc_dota_hero_phantom_assassin",
		"npc_dota_hero_medusa",
		"npc_dota_hero_arcwarden",
		"npc_dota_hero_antimage",
		"npc_dota_hero_troll_warlord",
		"npc_dota_hero_chaos_knight",
		"npc_dota_hero_spectre",
		"npc_dota_hero_terrorblade",
		"npc_dota_hero_morphling"
	}
}

----------------------------------------------------------------------------------------------------

return X