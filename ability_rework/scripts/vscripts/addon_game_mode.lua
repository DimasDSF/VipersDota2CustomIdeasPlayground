local RADIANT_TEAM_MAX_PLAYERS = 1
local DIRE_TEAM_MAX_PLAYERS = 8
local RUNE_SPAWN_TIME = 120
local VGMAR_DEBUG = true
local VGMAR_GIVE_DEBUG_ITEMS = true
local VGMAR_BOT_FILL = true
local VGMAR_LOG_BALANCE = false
local VGMAR_LOG_BALANCE_INTERVAL = 120
--///////////////////////////////////////////
--/////////////WORKSHOP_FUCKOVER/////////////
--Change to true before releasing to workshop
--///////////////////////////////////////////
local WORKSHOP_FUCKOVER = true

if VGMAR == nil then
	VGMAR = class({})
end

require('libraries/timers')
require('libraries/heronames')
require('libraries/heroabilityslots')
require('libraries/loglib')
require('libraries/extensions')

function Precache( ctx )
	--Precaching Custom Ability sounds (and all used heros' sounds :fp:)
	
	PrecacheUnitByNameSync("npc_dota_hero_wisp", ctx)
	
	--Warning! Hero Names should be in internal format ex. OD is obsidian_destroyer
	local herosoundprecachelist = {
		"tusk",
		"faceless_void",
		"kunkka",
		"obsidian_destroyer",
		"phantom_assassin",
		"antimage",
		"razor",
		"wisp",
		"zuus"
	}
	
	for i=1,#herosoundprecachelist do
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_"..herosoundprecachelist[i]..".vsndevts", ctx)
	end
	
end

function Activate()
	GameRules.VGMAR = VGMAR()
	GameRules.VGMAR:Init()
end

function VGMAR:Init()
	AbilitySlotsLib:Init()
	LogLib:Init()
	self.n_players_radiant = 0
	self.n_players_dire = 0
	self.istimescalereset = 0
	self.direcourieruplevel = 1
	self.radiantcourieruplevel = 1
	self.radiantcourierlvldown = false
	self.direcourierlvldown = false
	self.radiantcourierlvlup = false
	self.direcourierlvlup = false
	self.lastrunetype = -1
	self.currunenum = 1
	self.removedrunenum = math.random(1,2)
	self.botsInLateGameMode = false
	self.backdoorstatustable = {}
	self.backdoortimertable = {}
	self.couriergiven = false
	self.direcourierup2given = false
	self.direcourierup3given = false
	self.direcourierup4given = false
	self.customitemsreminderfinished = false
	self.companionheroes = {}
	self.playercompanionsnum = {}
	self.ItemKVs = {}
	self.direancientfailsafetimestamp = 0
	self.auramodifieraffectedlist = {}
	self.balancelogprinttimestamp = 0
	self.towerskilleddire = 0
	self.towerskilledrad = 0
	self.direthronedefparticle1 = nil
	self.direthronedefparticle2 = nil
	self.direthronedefparticletimestamp = 0
	self.direthronedefparticlesactive = false
	self.direthrone = nil
	
	local itemskvnum = 0
	local itemscustomkvnum = 0
	local itemskverrornum = 0
	local itemscustomkverrornum = 0
	for k,v in pairs(LoadKeyValues("scripts/npc/items.txt")) do
		if k and v and k~="Version" then
			if v["ID"] then
				--print("Adding Item: "..k.." With ID: "..v["ID"].." from items.txt")
				itemskvnum = itemskvnum + 1
				self.ItemKVs[v["ID"]] = k
			else
				itemskverrornum = itemskverrornum + 1
				print("Item: "..k.."Has no ID!!!")
			end
		end
	end
	for k,v in pairs(LoadKeyValues("scripts/npc/npc_items_custom.txt")) do
		if k and v and k~="Version" then
			if v["ID"] then
				--print("Adding Item: "..k.." With ID: "..v["ID"].." from items_custom.txt")
				itemscustomkvnum = itemscustomkvnum + 1
				self.ItemKVs[v["ID"]] = k
			else
				print("Item: "..k.."Has no ID!!!")
			end
		end
	end
	print("Added "..itemskvnum.." Items and "..itemscustomkvnum.." Custom Items to KVTable")
	if itemskverrornum > 0 or itemscustomkverrornum > 0 then
		print("Encountered Errors: items.txt: "..itemskverrornum.." item_custom.txt: "..itemscustomkverrornum)
	end
	
	--CustomAbilitiesValues
	--For ClientSide
	self:InitNetTables()
	
	LinkLuaModifier("modifier_vgmar_util_dominator_ability_purger", "abilities/util/modifiers/modifier_vgmar_util_dominator_ability_purger.lua", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_util_creep_ability_updater", "abilities/util/modifiers/modifier_vgmar_util_creep_ability_updater", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_deathskiss_visual", "abilities/modifiers/modifier_vgmar_i_deathskiss_visual", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_spellshield", "abilities/modifiers/modifier_vgmar_i_spellshield", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_kingsaegis_cooldown", "abilities/modifiers/modifier_vgmar_i_kingsaegis_cooldown", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_kingsaegis_active", "abilities/modifiers/modifier_vgmar_i_kingsaegis_active", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_criticalmastery_visual", "abilities/modifiers/modifier_vgmar_i_criticalmastery_visual", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_purgefield_visual", "abilities/modifiers/modifier_vgmar_i_purgefield_visual", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_truesight", "abilities/modifiers/modifier_vgmar_i_truesight", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_ai_companion_wisp", "abilities/modifiers/ai/modifier_vgmar_ai_companion_wisp", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_ai_companion_respawntime", "abilities/modifiers/ai/modifier_vgmar_ai_companion_respawntime", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_ai_companion_wisp_force_retether", "abilities/modifiers/ai/modifier_vgmar_ai_companion_wisp_force_retether", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_ai_companion_midas_usage", "abilities/modifiers/ai/modifier_vgmar_ai_companion_midas_usage", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_ai_companion_wisp_force_stop", "abilities/modifiers/ai/modifier_vgmar_ai_companion_wisp_force_stop", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_fervor", "abilities/modifiers/modifier_vgmar_i_fervor", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_cdreduction", "abilities/modifiers/modifier_vgmar_i_cdreduction", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_midas_greed", "abilities/modifiers/modifier_vgmar_i_midas_greed", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_spellamp", "abilities/modifiers/modifier_vgmar_i_spellamp", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_castrange", "abilities/modifiers/modifier_vgmar_i_castrange", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_attackrange", "abilities/modifiers/modifier_vgmar_i_attackrange", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_essence_aura", "abilities/modifiers/modifier_vgmar_i_essence_aura", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_essence_aura_effect", "abilities/modifiers/modifier_vgmar_i_essence_aura_effect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_atrophy", "abilities/modifiers/modifier_vgmar_i_atrophy", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_greatcleave", "abilities/modifiers/modifier_vgmar_i_greatcleave", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_ogre_tester", "abilities/modifiers/modifier_vgmar_i_ogre_tester", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_manaregen_aura", "abilities/modifiers/modifier_vgmar_i_manaregen_aura", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_manaregen_aura_effect", "abilities/modifiers/modifier_vgmar_i_manaregen_aura_effect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_spellshield_active", "abilities/modifiers/modifier_vgmar_i_spellshield_active", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_vampiric_aura", "abilities/modifiers/modifier_vgmar_i_vampiric_aura", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_vampiric_aura_effect", "abilities/modifiers/modifier_vgmar_i_vampiric_aura_effect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_essence_shift", "abilities/modifiers/modifier_vgmar_i_essence_shift", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_essence_shift_owner_str", "abilities/modifiers/modifier_vgmar_i_essence_shift", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_essence_shift_owner_agi", "abilities/modifiers/modifier_vgmar_i_essence_shift", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_essence_shift_owner_int", "abilities/modifiers/modifier_vgmar_i_essence_shift", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_essence_shift_target_agi", "abilities/modifiers/modifier_vgmar_i_essence_shift_target_agi", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_essence_shift_target_str", "abilities/modifiers/modifier_vgmar_i_essence_shift_target_str", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_essence_shift_target_int", "abilities/modifiers/modifier_vgmar_i_essence_shift_target_int", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_deathskiss", "abilities/modifiers/modifier_vgmar_i_deathskiss", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_deathskiss_active", "abilities/modifiers/modifier_vgmar_i_deathskiss", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_critical_mastery", "abilities/modifiers/modifier_vgmar_i_critical_mastery", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_critical_mastery_active", "abilities/modifiers/modifier_vgmar_i_critical_mastery", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_pulse", "abilities/modifiers/modifier_vgmar_i_pulse", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_thirst", "abilities/modifiers/modifier_vgmar_i_thirst", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_thirst_debuff", "abilities/modifiers/modifier_vgmar_i_thirst", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_multishot", "abilities/modifiers/modifier_vgmar_i_multishot", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_multishot_attack", "abilities/modifiers/modifier_vgmar_i_multishot_attack", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_util_multishot_active", "abilities/modifiers/modifier_vgmar_i_multishot", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_arcane_intellect", "abilities/modifiers/modifier_vgmar_i_arcane_intellect", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_poison_dagger", "abilities/modifiers/modifier_vgmar_i_poison_dagger", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_i_poison_dagger_debuff", "abilities/modifiers/modifier_vgmar_i_poison_dagger", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_ai_companion_wisp_item_usage", "abilities/modifiers/ai/modifier_vgmar_ai_companion_wisp_item_usage", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_vgmar_util_give_debugitems", "abilities/util/modifiers/modifier_vgmar_util_give_debugitems", LUA_MODIFIER_MOTION_NONE)
	
	self.essenceauraignoredabilities = {
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
		keeper_of_the_light_illuminate_end = true,
		keeper_of_the_light_spirit_form_illuminate_end = true,
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
		silencer_glaives_of_wisdom = true,
		slardar_sprint = true,
		spirit_breaker_empowering_haste = true,
		techies_minefield_sign = true,
		templar_assassin_trap = true,
		tiny_toss_tree = true,
		life_stealer_control = true,
		tiny_toss = false
	}

	self.arcaneintignoredabilities = {
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
		invoker_invoke = true,
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
		keeper_of_the_light_illuminate_end = true,
		keeper_of_the_light_spirit_form_illuminate_end = true,
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
		silencer_glaives_of_wisdom = true,
		slardar_sprint = true,
		spirit_breaker_empowering_haste = true,
		techies_minefield_sign = true,
		templar_assassin_trap = true,
		tiny_toss_tree = true,
		life_stealer_control = true,
		obsidian_destroyer_astral_imprisonment = false,
		sniper_shrapnel = false,
		tiny_toss = false
	}
	
	self.mode = GameRules:GetGameModeEntity()
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, RADIANT_TEAM_MAX_PLAYERS)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, DIRE_TEAM_MAX_PLAYERS)
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )
	GameRules:SetCustomGameSetupAutoLaunchDelay( 5 )
	GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
	GameRules:SetRuneMinimapIconScale( 1 )
	self.mode:SetRecommendedItemsDisabled(true)
	if VGMAR_BOT_FILL == true then
		GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
	end
	self.mode:SetRuneEnabled( DOTA_RUNE_DOUBLEDAMAGE, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_HASTE, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_ILLUSION, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_INVISIBILITY, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_REGENERATION, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_ARCANE, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_BOUNTY, true )
	self.mode:SetRuneSpawnFilter( Dynamic_Wrap( VGMAR, "FilterRuneSpawn" ), self )
	self.mode:SetExecuteOrderFilter( Dynamic_Wrap( VGMAR, "ExecuteOrderFilter" ), self )
	self.mode:SetDamageFilter( Dynamic_Wrap( VGMAR, "FilterDamage" ), self )
	self.mode:SetModifierGainedFilter( Dynamic_Wrap( VGMAR, "FilterModifierGained" ), self)
	self.mode:SetModifyGoldFilter(Dynamic_Wrap( VGMAR, "FilterGoldGained" ), self)
	self.mode:SetModifyExperienceFilter( Dynamic_Wrap( VGMAR, "FilterExperienceGained" ), self)

	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( VGMAR, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_player_learned_ability", Dynamic_Wrap( VGMAR, "OnPlayerLearnedAbility" ), self)
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( VGMAR, 'OnGameStateChanged' ), self )
	--ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( VGMAR, 'OnItemPickedUp' ), self )
	ListenToGameEvent( "dota_tower_kill", Dynamic_Wrap( VGMAR, 'OnTowerKilled' ), self )
	--ListenToGameEvent( "dota_player_used_ability", Dynamic_Wrap( VGMAR, 'OnPlayerUsedAbility' ), self )
	Convars:RegisterConvar('vgmar_devmode', "0", "Set to 1 to show debug info.  Set to 0 to disable.", 0)
	Convars:RegisterConvar('vgmar_blockbotcontrol', "1", "Set to 0 to enable controlling bots", 0)
	Convars:RegisterConvar('vgmar_enablecompanion_fullcontrol', "0", "Set to 1 to enable controlling a companion", 0)
	Convars:RegisterCommand('vgmar_reload_test_modifier', Dynamic_Wrap( VGMAR, "ReloadTestModifier" ), "Reload script modifier", 0)
	Convars:RegisterCommand('vgmar_test', Dynamic_Wrap( VGMAR, "TestFunction" ), "Runs a test function", 0)
	if VGMAR_DEBUG == true then
		Convars:SetInt("vgmar_devmode", 1)
	end
	
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 0.25 )
end

function VGMAR:TestFunction()
	--dmsg("Msg")
	--dwarning("Warning")
	--dhudmsg("Testing\nStuff")
	dprint("Testing Clamp: (0, 5, 1): "..math.clamp(0, 5, 1))
	dprint("Testing Scale: (20, 0.5, 80): "..math.scale(20, 0.5, 80))
	dprint("Testing Scale: (-150, 0.5, 150): "..math.scale(-150, 0.5, 150))
	dprint("Testing Scale: (-300, 0.5, 0): "..math.scale(-300, 0.5, 0))
end

function VGMAR:GetItemByID(id)
	return self.ItemKVs[id]
end

local debugitems = {
	["item_shivas_guard"] = 0,
	["item_assault"] = 1,
	["item_sheepstick"] = 0,
	["item_travel_boots_2"] = 1,
	["item_octarine_core"] = 3,
	["item_kaya"] = 3,
	["item_aether_lens"] = 3,
	["item_ultimate_scepter"] = 2,
	["item_mystic_staff"] = 2,
	["item_soul_booster"] = 2,
	["item_butterfly"] = 1,
	["item_eagle"] = 1,
	["item_orb_of_venom"] = 2,
	["item_demon_edge"] = 2,
	["item_yasha"] = 1,
	["item_dragon_lance"] = 4,
	["item_mask_of_madness"] = 1,
	["item_gloves"] = 2
}

--Creep -> Building Damage Multiplier
local creeptobuildingdmgmult = {
	["npc_dota_creep_lane"] = 0.5,
	["npc_dota_creep_siege"] = 0.25
}

function IsDevMode()
	if Convars:GetInt("vgmar_devmode") == 1 then
		return true
	end
	return false
end

function VGMAR:ReloadTestModifier()
	SendToServerConsole("script_reload")
	LinkLuaModifier("modifier_vgmar_i_ogre_tester", "abilities/modifiers/modifier_vgmar_i_ogre_tester", LUA_MODIFIER_MOTION_NONE)
end

function dprint(...)
	if IsDevMode() then
		print(...)
	end
end

function dmsg(...)
	if IsDevMode() then
		Msg(....."\n")
	end
end

function dwarning(...)
	if IsDevMode() then
		Warning(....."\n")
	end
end

function dhudmsg(...)
	if IsDevMode() then
		GameRules.VGMAR:DisplayClientError(0, ...)
	end
end

function VGMAR:LogBalance()
	local timeminute = GameRules:GetDOTATime(false, false) / 60
	local timesecond = GameRules:GetDOTATime(false, false) % 60
	LogLib:WriteLog("balance", 0, false, "-----------------------")
	LogLib:WriteLog("balance", 0, false, "Game Time: "..math.floor(timeminute)..":"..math.floor(timesecond))
	--NetWorth Data
	local radiantteamnetworth = 0
	local direteamnetworth = 0
	local radiantheroes = 0
	local direheroes = 0
	local radiantXP = 0
	local direXP = 0
	local allheroes = HeroList:GetAllHeroes()
	LogLib:WriteLog("balance", 1, false, "")
	LogLib:WriteLog("balance", 1, false, "Hero Data:")
	for i=1,#allheroes do
		LogLib:WriteLog("balance", 2, false, "Hero: "..HeroNamesLib:ConvertInternalToHeroName( allheroes[i]:GetName() ))
		if allheroes[i]:GetTeamNumber() == 2 then
			radiantheroes = radiantheroes + 1
			LogLib:WriteLog("balance", 3, false, "Team: Radiant")
			LogLib:WriteLog("balance", 3, false, "Kills: "..allheroes[i]:GetKills())
			LogLib:WriteLog("balance", 3, false, "Deaths: "..allheroes[i]:GetDeaths())
			LogLib:WriteLog("balance", 3, false, "Assists: "..allheroes[i]:GetAssists())
			LogLib:WriteLog("balance", 3, false, "Last Hits: "..allheroes[i]:GetLastHits())
			LogLib:WriteLog("balance", 3, false, "Gold: "..allheroes[i]:GetGold())
			LogLib:WriteLog("balance", 3, false, "XP: "..allheroes[i]:GetCurrentXP())
			LogLib:WriteLog("balance", 3, false, "Level: "..allheroes[i]:GetLevel())
			LogLib:WriteLog("balance", 3, false, "Items: ")
			local heronw = 0
			for j = 0, 14 do
				local slotitem = allheroes[i]:GetItemInSlot(j);
				if slotitem then
					LogLib:WriteLog("balance", 4, false, "Slot: "..j.." Item: "..slotitem:GetName().." Cost: "..slotitem:GetCost())
					heronw = heronw + slotitem:GetCost()
				end
			end
			LogLib:WriteLog("balance", 3, false, "Item Networth: "..heronw)
			radiantteamnetworth = radiantteamnetworth + heronw
			
			radiantXP = radiantXP + allheroes[i]:GetCurrentXP()
		elseif allheroes[i]:GetTeamNumber() == 3 then
			direheroes = direheroes + 1
			LogLib:WriteLog("balance", 3, false, "Team: Dire")
			LogLib:WriteLog("balance", 3, false, "Kills: "..allheroes[i]:GetKills())
			LogLib:WriteLog("balance", 3, false, "Deaths: "..allheroes[i]:GetDeaths())
			LogLib:WriteLog("balance", 3, false, "Assists: "..allheroes[i]:GetAssists())
			LogLib:WriteLog("balance", 3, false, "Last Hits: "..allheroes[i]:GetLastHits())
			LogLib:WriteLog("balance", 3, false, "Gold: "..allheroes[i]:GetGold())
			LogLib:WriteLog("balance", 3, false, "XP: "..allheroes[i]:GetCurrentXP())
			LogLib:WriteLog("balance", 3, false, "Level: "..allheroes[i]:GetLevel())
			LogLib:WriteLog("balance", 3, false, "Items: ")
			local heronw = 0
			for j = 0, 14 do
				local slotitem = allheroes[i]:GetItemInSlot(j);
				if slotitem then
					LogLib:WriteLog("balance", 4, false, "Slot: "..j.." Item: "..slotitem:GetName().." Cost: "..slotitem:GetCost())
					heronw = heronw + slotitem:GetCost()
				end
			end
			LogLib:WriteLog("balance", 3, false, "Item Networth: "..heronw)
			direteamnetworth = direteamnetworth + heronw
			direXP = direXP + allheroes[i]:GetCurrentXP()
		end
	end
	LogLib:WriteLog("balance", 0, false, "")
	LogLib:WriteLog("balance", 1, false, "Team Data:")
	LogLib:WriteLog("balance", 2, false, "Networth: ")
	LogLib:WriteLog("balance", 3, false, "Full Radiant: "..radiantteamnetworth)
	LogLib:WriteLog("balance", 3, false, "Full Dire: "..direteamnetworth)
	local avgradiantnw = radiantteamnetworth
	if radiantheroes > 0 then
		avgradiantnw = radiantteamnetworth/radiantheroes
	end
	local avgdirenw = direteamnetworth
	if direheroes > 0 then
		avgdirenw = direteamnetworth/direheroes
	end
	LogLib:WriteLog("balance", 3, false, "Average Radiant: "..avgradiantnw)
	LogLib:WriteLog("balance", 3, false, "Average Dire: "..avgdirenw)
	--Tower Kill Data
	LogLib:WriteLog("balance", 2, false, "Towers: ")
	LogLib:WriteLog("balance", 3, false, "Towers Killed by Radiant: "..self.towerskilledrad)
	LogLib:WriteLog("balance", 3, false, "Towers Killed by Dire: "..self.towerskilleddire)
	--Kills Data
	LogLib:WriteLog("balance", 2, false, "Kills: ")
	LogLib:WriteLog("balance", 3, false, "Radiant Kills: "..PlayerResource:GetTeamKills(2))
	LogLib:WriteLog("balance", 3, false, "Dire Kills: "..PlayerResource:GetTeamKills(3))
	--XP Data
	LogLib:WriteLog("balance", 2, false, "XP: ")
	LogLib:WriteLog("balance", 3, false, "Full Radiant: "..radiantXP)
	LogLib:WriteLog("balance", 3, false, "Full Dire: "..direXP)
	local avgxprad = radiantXP
	if radiantheroes > 0 then
		avgxprad = radiantXP/radiantheroes
	end
	local avgxpdire = direXP
	if direheroes > 0 then
		avgxpdire = direXP/direheroes
	end
	LogLib:WriteLog("balance", 3, false, "Average Radiant: "..avgxprad)
	LogLib:WriteLog("balance", 3, false, "Average Dire: "..avgxpdire)
	--Advantage Formula Output
	LogLib:WriteLog("balance", 2, false, "Advantage Formula Output")
	LogLib:WriteLog("balance", 3, false, "Radiant: "..self:GetTeamAdvantage(true, true, true, true))
	LogLib:WriteLog("balance", 3, false, "Dire: "..self:GetTeamAdvantage(false, true, true, true))
end

local MaxMoveSpeed = 550

local modifierdatatable = {
	["modifier_vgmar_i_manaregen_aura"] = {radius = 4000, bonusmanaself = 400, bonusmanaallies = 300, regenself = 4, regenallies = 3},
	["modifier_vgmar_i_attackrange"] = {range = 140, bonusstr = 12, bonusagi = 12},
	["modifier_vgmar_i_castrange"] = {range = 250, manaregen = 1.25, bonusmana = 400},
	["modifier_vgmar_i_spellamp"] = {percentage = 10, costpercentage = 10, bonusint = 16},
	["modifier_vgmar_i_cdreduction"] = {percentage = 25, bonusmana = 905, bonushealth = 905, intbonus = 25, spelllifestealhero = 25, spelllifestealcreep = 5},
	["modifier_vgmar_i_essence_aura"] = {radius = 1000, bonusmana = 900, restorechance = 25, restoreamount = 20},
	["modifier_vgmar_i_spellshield"] = {resistance = 35, cooldown = 12, maxstacks = 2},
	["modifier_vgmar_i_fervor"] = {maxstacks = 15, asperstack = 15},
	["modifier_vgmar_i_essence_shift"] = {reductionprimary = 1, reductionsecondary = 0, increaseprimary = 1, increasesecondary = 0, hitsperstackinc = 1, hitsperstackred = 2, duration = 40, durationtarget = 40},
	["modifier_vgmar_i_pulse"] = {stackspercreep = 1, stacksperhero = 8, duration = 4, hpregenperstack = 1, manaregenperstack = 0.5, maxstacks = 20},
	["modifier_vgmar_i_greatcleave"] = {cleaveperc = 100, cleavestartrad = 150, cleaveendrad = 300, cleaveradius = 700, bonusdamage = 75},
	["modifier_vgmar_i_vampiric_aura"] = {radius = 700, lspercent = 30, lspercentranged = 20},
	["modifier_vgmar_i_multishot"] = {stackscap = 5, shotspercap = 3, attackduration = 1, bonusrange = 140},
	["modifier_vgmar_i_midas_greed"] = {min_bonus_gold = 0, count_per_kill = 1, reduction_per_tick = 2, bonus_gold_cap = 40, stack_duration = 30, reduction_duration = 2.5, killsperstack = 3, midasusestacks = 2},
	["modifier_vgmar_i_kingsaegis_cooldown"] = {cooldown = 240, reincarnate_time = 5},
	["modifier_vgmar_i_critical_mastery"] = {critdmgpercentage = 250, critchance = 100},
	["modifier_vgmar_i_atrophy"] = {radius = 1000, dmgpercreep = 1, dmgperhero = 5, stack_duration = 240, stack_duration_scepter = -1, max_stacks = 1000, initial_stacks = 0},
	["modifier_vgmar_i_deathskiss"] = {critdmgpercentage = 20000, critchance = 1.0},
	["modifier_vgmar_i_truesight"] = {radius = 900},
	["modifier_item_ultimate_scepter_consumed"] = {bonus_all_stats = 10, bonus_health = 175, bonus_mana = 175},
	["modifier_vgmar_i_arcane_intellect"] = {percentage = 10, multpercast = 0.2, bonusint = 25},
	["modifier_vgmar_i_thirst"] = {threshold = 75, visionthreshold = 50, maxperhero = 50, visionrange = 10, visionduration = 0.2, giverealvision = 0, givemodelvision = 1, msperstack = 2, maxbasems = MaxMoveSpeed, radius = 5000},
	["modifier_vgmar_i_poison_dagger"] = {cooldown = 15, maxstacks = 4, aoestacks = 2, minenemiesforaoe = 3, aoedmgperc = 50, damage = 30, initialdamageperc = 50, aoeradius = 500, duration = 20, interval = 1.0},
	["modifier_vgmar_i_ogre_tester"] = {}
}

local missclickproofabilities = {
	["item_tpscroll"] = true,
	["item_travel_boots"] = true,
	["item_travel_boots_2"] = true,
	["item_moon_shard"] = true
}
	
function VGMAR:InitNetTables()
	local num = 0
	for i,v in pairs(modifierdatatable) do
		CustomNetTables:SetTableValue( "client_side_ability_values", i, v )
		num = num + 1
	end
	print("Initiated "..num.." KeyNames in Ability Value Net Table")
end

--BackDoorProtected Building List
local bdplist = {
	{group = "goodbase",
		buildinglist = {
			"dota_goodguys_fort",
			"good_rax_melee_bot",
			"good_rax_melee_mid",
			"good_rax_melee_top",
			"good_rax_range_bot",
			"good_rax_range_mid",
			"good_rax_range_top",
			"dota_goodguys_tower3_bot",
			"dota_goodguys_tower3_mid",
			"dota_goodguys_tower3_top",
			"dota_goodguys_tower4_bot",
			"dota_goodguys_tower4_top",
			"good_filler_1",
			"good_filler_2",
			"good_filler_3",
			"good_filler_4",
			"good_filler_5",
			"good_filler_6",
			"good_filler_7"
			},
		activationtime = 25,
		protectionholder = "dota_goodguys_fort",
		protectionrange = 2800,
		maxdamage = 10
		},
	{group = "badbase",
		buildinglist = {
			"dota_badguys_fort",
			"bad_rax_melee_bot",
			"bad_rax_melee_mid",
			"bad_rax_melee_top",
			"bad_rax_range_bot",
			"bad_rax_range_mid",
			"bad_rax_range_top",
			"dota_badguys_tower3_bot",
			"dota_badguys_tower3_mid",
			"dota_badguys_tower3_top",
			"dota_badguys_tower4_bot",
			"dota_badguys_tower4_top",
			"bad_filler_1",
			"bad_filler_2",
			"bad_filler_3",
			"bad_filler_4",
			"bad_filler_5",
			"bad_filler_6",
			"bad_filler_7"
			},
		activationtime = 25,
		protectionholder = "dota_badguys_fort",
		protectionrange = 2800,
		maxdamage = 10
		},
	{group = "g_t2_top",
		buildinglist = {
			"dota_goodguys_tower2_top"	
			},
		activationtime = 25,
		protectionholder = "dota_goodguys_tower2_top",
		protectionrange = 700,
		maxdamage = 1
		},
	{group = "g_t2_mid",
		buildinglist = {
			"dota_goodguys_tower2_mid"		
			},
		activationtime = 25,
		protectionholder = "dota_goodguys_tower2_mid",
		protectionrange = 700,
		maxdamage = 1
		},
	{group = "g_t2_bot",
		buildinglist = {
			"dota_goodguys_tower2_bot"		
			},
		activationtime = 25,
		protectionholder = "dota_goodguys_tower2_bot",
		protectionrange = 700,
		maxdamage = 1
		},
	{group = "b_t2_top",
		buildinglist = {
			"dota_badguys_tower2_top"		
			},
		activationtime = 25,
		protectionholder = "dota_badguys_tower2_top",
		protectionrange = 700,
		maxdamage = 1
		},
	{group = "b_t2_mid",
		buildinglist = {
			"dota_badguys_tower2_mid"		
			},
		activationtime = 25,
		protectionholder = "dota_badguys_tower2_mid",
		protectionrange = 700,
		maxdamage = 1
		},
	{group = "b_t2_bot",
		buildinglist = {
			"dota_badguys_tower2_bot"		
			},
		activationtime = 25,
		protectionholder = "dota_badguys_tower2_bot",
		protectionrange = 700,
		maxdamage = 1
		}
	}
	
--List of Units with additional abilities
--[[
Leveling mechanic modes unitlevel, returnvalue, daynight.
-unitlevel args - N/A (sets ability level to unit level)
-returnvalue args - any script (unit pointer not available)
-daynight args - {daylvl = ,nightlvl = }
Unbroken modes - 1:Remove abilities 0:UnLvl abilities

Up to 10 abilities

Example:
{classname = "npc_dota_creep_siege",
	abilities = {
		{name = "ability1", ismodifier = 0},
		{name = "ability2", ismodifier = 1}
	},
	levelmechanicmode = {
		"unitlevel",
		"daynight"
	},
	levelmechanicarg = {
		nil,
		{daylvl = 1, nightlvl = 2}
	},
	unbroken = true,
	unbrokenmode = 1
}

]]--
local creepabilitieslist = {
	{classname = "npc_dota_creep_siege",
		abilities = {
			{name = "vgmar_c_siegetimelock", ismodifier = 0}
		},
		levelmechanicmode = {
			"unitlevel"
		},
		levelmechanicarg = {
			nil
		},
		unbroken = true,
		unbrokenmode = 1
	}
}
	
function PreGameSpeed()
	if Convars:GetInt("vgmar_devmode") == 1 then
		return 8.0
	end
	return 2.0
end

function VGMAR:DisplayClientError(pid, message)
    local player = PlayerResource:GetPlayer(pid)
    if player then
        CustomGameEventManager:Send_ServerToPlayer(player, "VGMARDisplayError", {message=message})
    end
end

function VGMAR:FilterRuneSpawn( filterTable )
	local function GetRandomRune( notrune )
		local runeslist = {
			0,
			1,
			2,
			3,
			4,
			6
		}
		
		local rune = notrune
		
		while rune == notrune do
			rune = runeslist[math.random(#runeslist)]
		end
		return rune
	end
	filterTable.rune_type = GetRandomRune( -1 )
	if self.currunenum > 2 then
		self.currunenum = 1
		self.removedrunenum = math.random(1,2)
	end

	if filterTable.rune_type == self.lastrunetype then
		filterTable.rune_type = GetRandomRune( self.lastrunetype )
	end
	if GameRules:GetDOTATime(false, false) < 10 then
		filterTable.rune_type = DOTA_RUNE_INVALID
	end
	if GameRules:GetDOTATime(false, false) < 2400 then
		if self.currunenum == self.removedrunenum then
			filterTable.rune_type = DOTA_RUNE_INVALID
		end
	end

	if filterTable.rune_type ~= -1 then
		self.lastrunetype = filterTable.rune_type
	end
	self.currunenum = self.currunenum + 1
	return true
end

function VGMAR:FilterExperienceGained( filterTable )
	--DeepPrintTable( filterTable )
	if self.playercompanionsnum[filterTable["player_id_const"]] ~= nil then
		filterTable["experience"] = filterTable["experience"] + filterTable["experience"] * (self.playercompanionsnum[filterTable["player_id_const"]] * 0.5)
	end
	return true
end

function VGMAR:FilterGoldGained( filterTable )
	--dprint("PreModification Table: HeroId: ", filterTable["player_id_const"], "Gold: ", filterTable["gold"])
	--DeepPrintTable( filterTable )
	--[[reason_const
	reliable
	player_id_const
	gold
	--]]
	local player = PlayerResource:GetPlayer(filterTable["player_id_const"])
	if filterTable["reliable"] == 0 then
		if player:GetTeamNumber() == 2 then
			filterTable["gold"] = filterTable["gold"] * self:GetTeamAdvantageClamped(false, true, true, true, 0.5, 3.0) --math.min(2.0,math.max(0.5,self:GetTeamAdvantage(false, true, true, true, filterTable["player_id_const"])))
		elseif player:GetTeamNumber() == 3 then
			filterTable["gold"] = filterTable["gold"] * self:GetTeamAdvantageClamped(true, true, true, true, 0.5, 3.0) --math.min(2.0,math.max(0.5,self:GetTeamAdvantage(true, true, true, true, filterTable["player_id_const"])))
		end
	end
	--dprint("PostModification Table: HeroId: ", filterTable["player_id_const"], "Gold: ", filterTable["gold"])
	return true
end

function VGMAR:AddAuraChildren(caster, auraent, child)
	local exists = false
	local id = -1
	for i=1,#self.auramodifieraffectedlist do
		if self.auramodifieraffectedlist[i].aura == auraent then
			exists = true
			id = i
		end
	end
	if exists == true then
		local childrentable = self.auramodifieraffectedlist[id].children
		local newchildrentable = {}
		for j=1,#childrentable do
			if childrentable[j]:IsNull() == false then
				table.insert(newchildrentable, childrentable[j])
			end
		end
		table.insert(newchildrentable, child)
		local aura = {caster = caster, aura = auraent, children = newchildrentable, mfd = false}
		self.auramodifieraffectedlist[id] = aura
	else
		local newchildrentable = {}
		table.insert(newchildrentable, child)
		local aura = {caster = caster, aura = auraent, children = newchildrentable, mfd = false}
		table.insert(self.auramodifieraffectedlist, aura)
	end
end

function VGMAR:UpdateAuraChildParentTable()
	local function MarkForDeletion(n)
		local auraupdate = {caster = self.auramodifieraffectedlist[n].caster, aura = self.auramodifieraffectedlist[n].aura, children = self.auramodifieraffectedlist[n].children, mfd = true}
		self.auramodifieraffectedlist[n] = auraupdate
	end
	local newauramodifieraffectedlist = {}
	for i=1,#self.auramodifieraffectedlist do
		if self.auramodifieraffectedlist[i].aura ~= nil then
			if self.auramodifieraffectedlist[i].aura:IsNull() == false then
				local newchildrentable = {}
				if #self.auramodifieraffectedlist[i].children > 0 then
					for j=1,#self.auramodifieraffectedlist[i].children do
						if self.auramodifieraffectedlist[i].children[j]:IsNull() == false then
							table.insert(newchildrentable, self.auramodifieraffectedlist[i].children[j])
						end
					end
					local auraupdate = {caster = self.auramodifieraffectedlist[i].caster, aura = self.auramodifieraffectedlist[i].aura, children = newchildrentable, mfd = self.auramodifieraffectedlist[i].mfd}
					self.auramodifieraffectedlist[i] = auraupdate
				else
					MarkForDeletion(i)
				end
			else
				MarkForDeletion(i)
			end
		end
		if self.auramodifieraffectedlist[i].mfd == false then
			local auraupdate = {caster = self.auramodifieraffectedlist[i].caster, aura = self.auramodifieraffectedlist[i].aura, children = self.auramodifieraffectedlist[i].children, mfd = self.auramodifieraffectedlist[i].mfd}
			table.insert(newauramodifieraffectedlist, auraupdate)
		end
	end
	self.auramodifieraffectedlist = newauramodifieraffectedlist
end

function VGMAR:FindAuraParent(child)
	if child ~= nil then
		self:UpdateAuraChildParentTable()
		for i=1,#self.auramodifieraffectedlist do
			if self.auramodifieraffectedlist[i].children ~= nil then
				for j=1,#self.auramodifieraffectedlist[i].children do
					if self.auramodifieraffectedlist[i].children[j] == child then
						return self.auramodifieraffectedlist[i].aura
					end
				end
			end
		end
	end
	return nil				
end

function VGMAR:FindAuraChildren(parent)
	if parent ~= nil then
		self:UpdateAuraChildParentTable()
		for i=1,#self.auramodifieraffectedlist do
			if self.auramodifieraffectedlist[i].aura ~= nil then
				if self.auramodifieraffectedlist[i].aura:IsNull() == false then
					if #self.auramodifieraffectedlist[i].children > 0 then
						return self.auramodifieraffectedlist[i].children
					end
				end
			end
		end
	end
	return nil				
end

function VGMAR:FilterModifierGained( filterTable )
	--if IsDevMode() then
		--DeepPrintTable( filterTable )
	--end
	--[[
	entindex_parent_const           	= (number)
	entindex_ability_const          	= (number)
	duration                        	= (number)
	entindex_caster_const           	= (number)
	name_const                      	= (string)
	]]--
	local modifiername = filterTable["name_const"]
	local ability = nil
	if filterTable["entindex_ability_const"] then
		ability = EntIndexToHScript(filterTable.entindex_ability_const)
	end
	
	--Custom Aura abilities and modifiers list used to update the list of Aura Recievers
	--Child Effect<->Parent Aura
	local auraeffectlist = {
		["modifier_vgmar_i_thirst_debuff"] = "modifier_vgmar_i_thirst",
		["modifier_essence_aura_effect"] = "modifier_vgmar_i_essence_aura",
		["modifier_vgmar_i_manaregen_aura_effect"] = "modifier_vgmar_i_manaregen_aura",
		["modifier_vgmar_i_vampiric_aura_effect"] = "modifier_vgmar_i_vampiric_aura"
	}
	
	if filterTable.entindex_caster_const then
		local caster = EntIndexToHScript(filterTable.entindex_caster_const)
		if caster then
			local castermodifiers = caster:FindAllModifiers()
			for i=1,#castermodifiers do
				if castermodifiers[i] ~= nil and castermodifiers[i]:GetName() == auraeffectlist[filterTable.name_const] then
					self:AddAuraChildren(caster, castermodifiers[i], EntIndexToHScript(filterTable.entindex_parent_const):FindModifierByName(filterTable.name_const))
				end
			end
		end
	end
	return true
end

function VGMAR:HeroHasUsableItemInInventory( hero, item, mutedallowed, backpackallowed, stashallowed )
	if stashallowed ~= true and not hero:HasItemInInventory(item) then
		return false
	end
	local endslot = 8
	if stashallowed == true then
		endslot = 14
	end
	for i = 0, endslot do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			if slotitem:GetName() == item then
				if slotitem:IsMuted() and mutedallowed == true then
					if i <= 5 then
						return true
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						return true
					elseif i >= 9 and stashallowed == true then
						return true
					else 
						return false
					end
				elseif not slotitem:IsMuted() then
					if i <= 5 then
						return true
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						return true
					elseif i >= 9 and stashallowed == true then
						return true
					else 
						return false
					end
				else
					return false
				end
			end
		end
	end
end

function VGMAR:GetItemFromInventoryByName( hero, item, mutedallowed, backpackallowed, stashallowed )
	if stashallowed ~= true and not hero:HasItemInInventory(item) then
		return nil
	end
	local endslot = 8
	if stashallowed == true then
		endslot = 14
	end
	for i = 0, endslot do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			if slotitem:GetName() == item then
				if slotitem:IsMuted() and mutedallowed == true then
					if i <= 5 then
						return slotitem
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						return slotitem
					elseif i >= 9 and stashallowed == true then
						return slotitem
					else 
						return nil
					end
				elseif not slotitem:IsMuted() then
					if i <= 5 then
						return slotitem
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						return slotitem
					elseif i >= 9 and stashallowed == true then
						return slotitem
					else 
						return nil
					end
				else
					return nil
				end
			end
		end
	end
end

function VGMAR:GetItemSlotFromInventoryByItemName( hero, item, mutedallowed, backpackallowed, stashallowed )
	if stashallowed ~= true and not hero:HasItemInInventory(item) then
		return -1
	end
	local endslot = 8
	if stashallowed == true then
		endslot = 14
	end
	for i = 0, endslot do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			if slotitem:GetName() == item then
				if slotitem:IsMuted() and mutedallowed == true then
					if i <= 5 then
						return i
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						return i
					elseif i >= 9 and stashallowed == true then
						return i
					else 
						return -1
					end
				elseif not slotitem:IsMuted() then
					if i <= 5 then
						return i
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						return i
					elseif i >= 9 and stashallowed == true then
						return i
					else 
						return -1
					end
				else
					return -1
				end
			end
		end
	end
end

function VGMAR:CountUsableItemsInHeroInventory( hero, item, mutedallowed, backpackallowed, stashallowed )
	if stashallowed ~= true and not hero:HasItemInInventory(item) then
		return 0
	end
	local itemcount = 0
	local endslot = 8
	if stashallowed == true then
		endslot = 14
	end
	for i = 0, endslot do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			if slotitem:GetName() == item then
				if slotitem:IsMuted() and mutedallowed == true then
					if i <= 5 then
						itemcount = itemcount + 1
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						itemcount = itemcount + 1
					elseif i >= 9 and stashallowed == true then
						itemcount = itemcount + 1
					end
				elseif not slotitem:IsMuted() then
					if i <= 5 then
						itemcount = itemcount + 1
					elseif i >= 6 and i <= 8 and backpackallowed == true then
						itemcount = itemcount + 1
					elseif i >= 9 and stashallowed == true then
						itemcount = itemcount + 1
					end
				end
			end
		end
	end
	return itemcount
end

function VGMAR:RemoveNItemsInInventory( hero, item, num )
	local removeditemsnum = 0
	for i = 0, 14 do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			if slotitem:GetName() == item and removeditemsnum < num then
				hero:RemoveItem(slotitem)
				removeditemsnum = removeditemsnum + 1
			elseif removeditemsnum >= num then
				break
			end
		end
	end
	return
end

function VGMAR:TimeIsLaterThan( minute, second )
	local num = minute * 60 + second
	if GameRules:GetDOTATime(false, false) > num then
		return true
	else
		return false
	end
end

function VGMAR:HeroHasAllItemsFromListWMultiple( hero, itemlist, backpack )
	for i=1,#itemlist.itemnames do
		if self:CountUsableItemsInHeroInventory( hero, itemlist.itemnames[i], false, backpack, false) < itemlist.itemnum[i] then
			return false
		end
	end
	return true
end

function VGMAR:GetHeroFreeInventorySlots( hero, backpackallowed, stashallowed )
	local slotcount = 0
	local endslot = 8
	if stashallowed == true then
		endslot = 14
	end
	for i = 0, endslot, 1 do
		if hero:GetItemInSlot(i) == nil then
			if i <= 5 then
				slotcount = slotcount + 1
			elseif i >= 6 and i <= 8 and backpackallowed == true then
				slotcount = slotcount + 1
			elseif i >= 9 and stashallowed == true then
				slotcount = slotcount + 1
			end
		end
	end
	return slotcount
end

--[[
function VGMAR:OnItemPickedUp(keys)
	local heroEntity = EntIndexToHScript(keys.HeroEntityIndex or keys.UnitEntityIndex)
	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname
	
	if heroEntity:IsRealHero() and not heroEntity:IsCourier() then
	end
end
--]]

function VGMAR:OnTowerKilled( keys )
	local switchAI = (RandomInt(1,3))
	if switchAI == 1 then
		self.botsInLateGameMode = false
		GameRules:GetGameModeEntity():SetBotsInLateGame(self.botsInLateGameMode)
		GameRules:GetGameModeEntity():SetThink(function()
			self.botsInLateGameMode = true
			GameRules:GetGameModeEntity():SetBotsInLateGame(self.botsInLateGameMode)
		end, DoUniqueString('makesBotsLateGameAgain'), 180)
	else
		self.botsInLateGameMode = true
		GameRules:GetGameModeEntity():SetBotsInLateGame(self.botsInLateGameMode)
	end
	--///////////////
	--Balance system ##BALANCEDEV##
	--///////////////
	--Counting Towers
	if keys.teamnumber == 2 then
		if self.towerskilleddire ~= nil then
			self.towerskilleddire = self.towerskilleddire + 1
		else
			self.towerskilleddire = 1
		end
	elseif keys.teamnumber == 3 then
		if self.towerskilledrad ~= nil then
			self.towerskilledrad = self.towerskilledrad + 1
		else
			self.towerskilledrad = 1
		end
	end
end

function VGMAR:IsHeroBotControlled(hero)
	if hero ~= nil then
		local heroplayerID = hero:GetPlayerID()
		if PlayerResource:IsValidPlayer(heroplayerID) and PlayerResource:GetConnectionState(heroplayerID) == 1 then
			return true
		end
	end
	return false
end

function VGMAR:IsUnitACompanion( unit, index )
	if index == 0 and unit ~= nil then
		index = unit:entindex()
	end
	if index then
		for i=1,#self.companionheroes do
			if self.companionheroes[i].index == index then
				if unit then
					dprint("Unit: ", unit:GetName(), "index: ", index, "Is A Companion")
				else
					dprint("index: ", index, "Is A Companion")
				end
				return true
			end
		end
	end
	return false
end

function VGMAR:GetCompanionNum( ownerhero, ownerid, index )
	if ownerhero == nil and ownerid >= 0 then
		ownerhero = PlayerResource:GetPlayer(ownerid):GetAssignedHero()
	end
	if ownerid < 0 and ownerhero ~= nil then
		ownerid = ownerhero:GetPlayerID()
	end
	dprint("Attempting to find a companion with index: ", index)
	for i=1,#self.companionheroes do
		if index and self.companionheroes[i].index == index then
			dprint("GetCompanionNum got a match on Index: ", index, "with: ", i)
			return i
		end
		if ownerhero ~= nil and self.companionheroes[i].ownerhero == ownerhero then
			dprint("GetCompanionNum got a match on OwnerHero: ", HeroNamesLib:ConvertInternalToHeroName(ownerhero:GetName()), "with: ", i)
			return i
		end
		if ownerid >= 0 and self.companionheroes[i].ownerid == ownerid then
			dprint("GetCompanionNum got a match on OwnerID: ", ownerid, "with: ", i)
			return i
		end
	end
	dprint("GetCompanionNum Didnt find any match. Returning nil")
	return 0
end

function VGMAR:GetTeamAdvantage( radiant, tower, kill, networth )
	--//////////////////
	--Team Balance ##BALANCEDEV##
	--//////////////////
	--Importance Percentages
	--!!!Should add up to 100!!!
	local towerkillimp = 50
	local killsimp = 20
	local networthimp = 30
	--End of Importance Percentages
	--Calculating Networth
	local radiantteamnetworth = 0
	local direteamnetworth = 0
	if networth == true then
		local radiantheroes = {}
		local direheroes = {}
		local allheroes = HeroList:GetAllHeroes()
		for i=1,#allheroes do
			local hero = {id = allheroes[i]:GetPlayerID(), hero = allheroes[i]}
			if allheroes[i]:GetTeamNumber() == 2 then
				table.insert(radiantheroes, hero)
			elseif allheroes[i]:GetTeamNumber() == 3 then
				table.insert(direheroes, hero)
			end
		end
		
		--PureItemsMethod
		for i=1,#radiantheroes do
			--radiantteamnetworth = radiantteamnetworth + PlayerResource:GetGold(radiantheroes[i].id)
			for j = 0, 14 do
				local slotitem = radiantheroes[i].hero:GetItemInSlot(j);
				if slotitem then
					radiantteamnetworth = radiantteamnetworth + slotitem:GetCost()
				end
			end
		end
		for i=1,#direheroes do
			--direteamnetworth = direteamnetworth + PlayerResource:GetGold(direheroes[i].id)
			for j = 0, 14 do
				local slotitem = direheroes[i].hero:GetItemInSlot(j);
				if slotitem then
					direteamnetworth = direteamnetworth + slotitem:GetCost()
				end
			end
		end
		--DotaMethod
		local radiantteamnetworthdota = 0
		local direteamnetworthdota = 0
		for i=1,#radiantheroes do
			radiantteamnetworthdota = radiantteamnetworthdota + ((radiantheroes[i].hero:GetDeathGoldCost() - 50) * 40)
		end
		for i=1,#direheroes do
			direteamnetworthdota = direteamnetworthdota + ((direheroes[i].hero:GetDeathGoldCost() - 50) * 40)
		end
		if #radiantheroes ~= 0 and #direheroes ~= 0 then
			radiantteamnetworth = radiantteamnetworth / #radiantheroes
			direteamnetworth = direteamnetworth / #direheroes
			radiantteamnetworthdota = radiantteamnetworthdota / #radiantheroes
			direteamnetworthdota = direteamnetworthdota / #direheroes
		end
		--[[dprint("Networth:")
		dprint("Custom: Radiant: "..radiantteamnetworth.." Dire: "..direteamnetworth)
		dprint("Dota: Radiant: "..radiantteamnetworthdota.." Dire: "..direteamnetworthdota)--]]
	end
	--End Values Calculation
	local towerkilladv
	local killadv
	local networthadv
	if radiant == true then
		if tower == true then
			if self.towerskilleddire ~= 0 and self.towerskilledrad ~= 0 then
				towerkilladv = ((self.towerskilledrad/self.towerskilleddire)/100)*towerkillimp
			else
				if self.towerskilleddire ~= 0 then
					towerkilladv = ((0/self.towerskilleddire)/100)*towerkillimp
				elseif self.towerskilledrad ~= 0 then
					towerkilladv = (((self.towerskilledrad+1)/1)/100)*towerkillimp
				else
					towerkilladv = (1/100)*towerkillimp
				end
			end
		else
			towerkilladv = (1/100)*towerkillimp
		end
		if kill == true then
			if PlayerResource:GetTeamKills(2) ~= 0 and PlayerResource:GetTeamKills(3) ~= 0 then
				killadv = ((PlayerResource:GetTeamKills(2)/PlayerResource:GetTeamKills(3))/100)*killsimp
			else
				if PlayerResource:GetTeamKills(2) ~= 0 then
					killadv = (((PlayerResource:GetTeamKills(2)+1)/1)/100)*killsimp
				elseif PlayerResource:GetTeamKills(3) ~= 0 then
					killadv = ((0/PlayerResource:GetTeamKills(3))/100)*killsimp
				else
					killadv = (1/100)*killsimp
				end
			end
		else
			killadv = (1/100)*killsimp
		end
		if networth == true then
			if radiantteamnetworth ~= 0 and direteamnetworth ~= 0 then
				networthadv = ((radiantteamnetworth/direteamnetworth)/100)*networthimp
			else
				networthadv = (1/100)*networthimp
			end
		else
			networthadv = (1/100)*networthimp
		end
	else
		if tower == true then
			if self.towerskilleddire ~= 0 and self.towerskilledrad ~= 0 then
				towerkilladv = ((self.towerskilleddire/self.towerskilledrad)/100)*towerkillimp
			else
				if self.towerskilleddire ~= 0 then
					towerkilladv = (((self.towerskilleddire+1)/1)/100)*towerkillimp
				elseif self.towerskilledrad ~= 0 then
					towerkilladv = ((0/self.towerskilledrad)/100)*towerkillimp
				else
					towerkilladv = (1/100)*towerkillimp
				end
			end
		else
			towerkilladv = (1/100)*towerkillimp
		end
		if kill == true then
			if PlayerResource:GetTeamKills(2) ~= 0 and PlayerResource:GetTeamKills(3) ~= 0 then
				killadv = ((PlayerResource:GetTeamKills(3)/PlayerResource:GetTeamKills(2))/100)*killsimp
			else
				if PlayerResource:GetTeamKills(2) ~= 0 then
					killadv = ((0/PlayerResource:GetTeamKills(2))/100)*killsimp
				elseif PlayerResource:GetTeamKills(3) ~= 0 then
					killadv = (((PlayerResource:GetTeamKills(3)+1)/1)/100)*killsimp
				else
					killadv = (1/100)*killsimp
				end
			end
		else
			killadv = (1/100)*killsimp
		end
		if networth == true then
			if radiantteamnetworth ~= 0 and direteamnetworth ~= 0 then
				networthadv = ((direteamnetworth/radiantteamnetworth)/100)*networthimp
			else
				networthadv = (1/100)*networthimp
			end
		else
			networthadv = (1/100)*networthimp
		end
	end
	--[[if tower == true and kill == true and networth == true then
		dprint("Radiant Team Net: "..radiantteamnetworth.." Dire Team Net: "..direteamnetworth)
		if self.towerskilleddire ~= nil and self.towerskilledrad ~= nil then
			dprint("Towers Killed Radiant: "..self.towerskilledrad.." Towers Killed Dire: "..self.towerskilleddire)
		end
		dprint("Tower Kill Advantage: "..towerkilladv.." Kill Advantage: "..killadv.." Networth Advantage: "..networthadv)
		dprint("Total Advantage: ", towerkilladv + killadv + networthadv)
	end--]]
	return towerkilladv + killadv + networthadv
end

function VGMAR:GetTeamAdvantageClamped(radiant, tower, kill, networth, min, max)
	--[[local rdtext 
	if radiant then
		rdtext = "Radiant"
	else
		rdtext = "Dire"
	end--]]
	--dprint("Balance: "..rdtext.." Unclamped Adv: "..self:GetTeamAdvantage(radiant, tower, kill, networth))
	if self:GetTeamAdvantage(radiant, tower, kill, networth) > 1 then
		--dprint("Balance: "..rdtext..": Adv: "..math.clamp(1, self:GetTeamAdvantage(radiant, tower, kill, networth), 2).." Remapped: "..math.scale(1, math.map(math.clamp(1, self:GetTeamAdvantage(radiant, tower, kill, networth), 2), 1, 2, 0, 1), max))
		return math.scale(1, math.map(math.clamp(1, self:GetTeamAdvantage(radiant, tower, kill, networth), 2), 1, 2, 0, 1), max)
	elseif self:GetTeamAdvantage(radiant, tower, kill, networth) == 1 then
		--dprint("Balance: "..rdtext..": Adv: 1")
		return 1
	else
		--dprint("Balance: "..rdtext..": Adv: "..math.clamp(0, self:GetTeamAdvantage(radiant, tower, kill, networth), 1).." Remapped: "..math.scale( min, self:GetTeamAdvantage(radiant, tower, kill, networth), 1 ))
		return math.scale( min, self:GetTeamAdvantage(radiant, tower, kill, networth), 1 )
	end
end

function VGMAR:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, PlayerResource:GetPlayerCount())
		for playerID=0,PlayerResource:GetPlayerCount() do
			if PlayerResource:IsValidPlayer(playerID) and PlayerResource:GetConnectionState(playerID) == 2 then
				dprint("Valid Player found on slot:", playerID)
				dprint("Player Team is:", PlayerResource:GetTeam(playerID))
				if PlayerResource:GetTeam(playerID) ~= 2 then
					PlayerResource:SetCustomTeamAssignment(playerID, DOTA_TEAM_GOODGUYS)
				end
			end
		end
		GameRules:LockCustomGameSetupTeamAssignment(true)
	end
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		local heroes = HeroList:GetAllHeroes()
		for i=0,HeroList:GetHeroCount() do
			local heroent = heroes[i]
			if heroent then
			--///////////////////////////
			--Bot Rune Fix
			--///////////////////////////
				local heroplayerid = heroent:GetPlayerID()
				local closestrune = Entities:FindByClassnameNearest("dota_item_rune", heroent:GetOrigin(), 250.0)
				
				if PlayerResource:GetConnectionState(heroplayerid) == 1 then
					heroent:SetBotDifficulty(3)
					if closestrune then
						heroent:PickupRune(closestrune)
					end
					
					--///////////////////
					--[[--BotShrineActivation
					--///////////////////
					local nearbyshrine = Entities:FindByClassnameWithin(nil, "npc_dota_healer", heroent:GetOrigin(), 400)
					if nearbyshrine ~= nil and nearbyshrine:GetTeamNumber() == heroent:GetTeamNumber() then
						dprint("Found a shrine: ", nearbyshrine:GetName())
						local shrineability = nearbyshrine:FindAbilityByName("filler_ability")
						local shrinemodifier = nearbyshrine:FindModifierByName("modifier_filler_heal_aura")
						if shrineability ~= nil and (shrineability:GetCooldownTimeRemaining() == 0 or shrinemodifier ~= nil) then
							if heroent:GetHealth()/heroent:GetMaxHealth() < 0.7 or heroent:GetMana()/heroent:GetMaxMana() <= 0.5 then
								shrineability:CastAbility()
								heroent:MoveToPositionAggressive(nearbyshrine:GetOrigin())
							end
						elseif shrineability:GetCooldownTimeRemaining() >= 295 then
							if heroent:GetHealth()/heroent:GetMaxHealth() < 0.7 or heroent:GetMana()/heroent:GetMaxMana() <= 0.5 then
								heroent:MoveToPositionAggressive(nearbyshrine:GetOrigin())
							end					
						end
					end--]]
				end
				
				--//////////////////
				--AbilityAutoUpgrade
				--//////////////////
				local heroname = heroent:GetName()
				--AbilityAutoUpgradeTable
				local heroautoabilityuplist = {
					["npc_dota_hero_riki"] = {
						spells = {"riki_smoke_screen",
							"riki_blink_strike", 
							"riki_permanent_invisibility", 
							"riki_tricks_of_the_trade"},
						levelup = {
							{[5] = heroent:GetLevel() >= 22},
							{[5] = heroent:GetLevel() >= 20},
							{[5] = heroent:GetLevel() >= 15 or heroent:HasScepter(), [6] = heroent:HasScepter() and heroent:GetLevel() >= 15},
							{[4] = heroent:HasScepter() or heroent:GetLevel() == 25, [5] = heroent:HasScepter() and heroent:GetLevel() == 25}
						}
					},
				}
				if heroautoabilityuplist[heroname] ~= nil then
					for j=1,#heroautoabilityuplist[heroname].spells do
						local ability = heroent:FindAbilityByName(heroautoabilityuplist[heroname].spells[j])
						if ability then
							local ablvl = ability:GetLevel()
							if heroautoabilityuplist[heroname].levelup[j][ablvl] ~= nil and heroautoabilityuplist[heroname].levelup[j][ablvl] == false then
								ability:SetLevel( ability:GetLevel() - 1 )
							elseif heroautoabilityuplist[heroname].levelup[j][ablvl + 1] ~= nil and heroautoabilityuplist[heroname].levelup[j][ablvl + 1] == true then
								ability:SetLevel( ability:GetLevel() + 1 )
							end
						end
					end
				end
				
				if heroent:IsRealHero() and not heroent:IsCourier() then
					--Shrines Fill Bottles --modifier_filler_heal_aura
					if self:HeroHasUsableItemInInventory( heroent, "item_bottle", false, true, false) and heroent:FindModifierByName("modifier_filler_heal") ~= nil then
						local bottle = self:GetItemFromInventoryByName( heroent, "item_bottle", false, true, false )
						if bottle:GetCurrentCharges() < bottle:GetInitialCharges() then
							bottle:SetCurrentCharges( bottle:GetInitialCharges() )
						end
					end
					--##Obsolete707
					--Diffusal Blade 2+ Upgrade
					--[[if self:HeroHasUsableItemInInventory( heroent, "item_recipe_diffusal_blade", false, false, false) and self:HeroHasUsableItemInInventory( heroent, "item_diffusal_blade_2", false, false, false)  then
						local diffbladeitem = self:GetItemFromInventoryByName( heroent, "item_diffusal_blade_2", false, false, false )
						local diffbladerecipe = self:GetItemFromInventoryByName( heroent, "item_recipe_diffusal_blade", false, false, false )
						if diffbladeitem ~= nil and diffbladeitem:GetCurrentCharges() < diffbladeitem:GetInitialCharges() then
							heroent:RemoveItem(diffbladerecipe)
							diffbladeitem:SetCurrentCharges(diffbladeitem:GetInitialCharges())
						end
					end--]]
					--//////////////////////////////
					--Consumable Items System
					--//////////////////////////////
					--Bloodstone recharge
					if self:HeroHasUsableItemInInventory(heroent, "item_bloodstone", false, false, false) and self:CountUsableItemsInHeroInventory(heroent, "item_pers", false, true, false) >= 2 then
						self:RemoveNItemsInInventory(heroent, "item_pers", 2)
						local bloodstone = self:GetItemFromInventoryByName( heroent, "item_bloodstone", false, false, false )
						if bloodstone ~= nil then
							bloodstone:SetCurrentCharges(bloodstone:GetCurrentCharges() + 24)
						end
					end
					--Companion System
					if self:CountUsableItemsInHeroInventory(heroent, "item_bloodstone", false, true, false) >= 2 then
						self:RemoveNItemsInInventory(heroent, "item_bloodstone", 2)
						--GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, GameRules:GetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS) + 1)
						local playerID = heroent:GetPlayerID()
						local player = PlayerResource:GetPlayer(playerID)
						local wisp = CreateUnitByName("npc_dota_hero_wisp", heroent:GetAbsOrigin(), true, heroent, heroent, heroent:GetTeamNumber())
						wisp:SetControllableByPlayer(playerID, false)
						for j=2,heroent:GetLevel() do
							wisp:HeroLevelUp(false)
						end
						wisp:AddAbility("vgmar_ca_wisp_tether")
						wisp:SwapAbilities("wisp_tether", "vgmar_ca_wisp_tether", false, true)
						wisp:RemoveAbility("wisp_tether")
						wisp:AddAbility("vgmar_ca_wisp_overcharge")
						wisp:SwapAbilities("wisp_overcharge", "vgmar_ca_wisp_overcharge", false, true)
						wisp:RemoveAbility("wisp_overcharge")
						wisp:AddAbility("vgmar_ca_wisp_relocate")
						wisp:SwapAbilities("wisp_relocate", "vgmar_ca_wisp_relocate", false, true)
						wisp:RemoveAbility("wisp_relocate")
						wisp:AddAbility("vgmar_ai_companion_wisp_toggle_autohit"):SetLevel( 1 )
						wisp:SwapAbilities("wisp_spirits_in", "vgmar_ai_companion_wisp_toggle_autohit", false, true)
						wisp:RemoveAbility("wisp_spirits_in")
						wisp:AddAbility("vgmar_ai_companion_wisp_toggle_scepter"):SetLevel( 1 )
						wisp:SwapAbilities("wisp_spirits_out", "vgmar_ai_companion_wisp_toggle_scepter", false, true)
						wisp:RemoveAbility("wisp_spirits_out")
						local tethertoggle = wisp:AddAbility("vgmar_ai_companion_wisp_toggle_tether")
						tethertoggle:SetLevel( 1 )
						if tethertoggle:GetToggleState() ~= true then
							tethertoggle:ToggleAbility()
						end
						wisp:SwapAbilities("wisp_spirits", "vgmar_ai_companion_wisp_toggle_tether", false, true)
						wisp:RemoveAbility("wisp_spirits")
						Timers:CreateTimer(2,
						function()
							self:RemoveNItemsInInventory( wisp, "item_tpscroll", 1 )
							self:GetItemFromInventoryByName( wisp, "item_travel_boots_2", false, false, false ):EndCooldown()
						end)
						wisp:AddItemByName("item_travel_boots_2")
						wisp:AddItemByName("item_octarine_core")
						local companion = {type = "wisp", hero = wisp, index = wisp:entindex(), owner = player, ownerhero = heroent, ownerindex = heroent:entindex(), ownerid = playerID}
						dprint("Saving a Companion to companion List:")
						dprint("type: wisp, heroindex: ", wisp:entindex(), "ownerhero: ", HeroNamesLib:ConvertInternalToHeroName(heroent:GetName()), "ownerindex: ", heroent:entindex(), "ownerid: ", playerID)
						if self.playercompanionsnum[playerID] == nil then
							self.playercompanionsnum[playerID] = 1
						else
							self.playercompanionsnum[playerID] = self.playercompanionsnum[playerID] + 1
						end
						table.insert(self.companionheroes, companion)
						wisp:AddNewModifier( wisp, nil, "modifier_vgmar_ai_companion_wisp", {ownerid = playerID, ownerindex = heroent:entindex()})
					end
				end
				
				--////////////////////
				--CompanionAutoLevelUp
				--////////////////////
				if self:IsUnitACompanion( heroent , 0 ) then
					local companionnum = self:GetCompanionNum( nil, -1, heroent:entindex())
					local companionowner = self.companionheroes[companionnum].ownerhero
					if heroent:GetLevel() < companionowner:GetLevel() then
						for j=1,companionowner:GetLevel()-heroent:GetLevel() do
							heroent:HeroLevelUp(false)
						end
					end
				end
				
				--//////////////////////
				--Passive Item Abilities
				--//////////////////////
				--Items For Spells Table --vgmar_i_spellshield
				local itemlistforspell = {
			{spell = "modifier_vgmar_i_midas_greed",
				items = {itemnames = {"item_hand_of_midas"}, itemnum = {1}},
				isconsumable = false,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {min_bonus_gold = 0, count_per_kill = 1, reduction_per_tick = 2, bonus_gold_cap = 80, stack_duration = 30, reduction_duration = 2.5, killsperstack = 4},
				usesmultiple = false,
				backpack = self:TimeIsLaterThan( 30, 0 ) or heroent:GetLevel() >= 25,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_essence_shift",
				items = {itemnames = {"item_diffusal_blade"}, itemnum = {1}},
				isconsumable = false,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {reductionprimary = 1, reductionsecondary = 0, increaseprimary = 1, increasesecondary = 0, hitsperstackinc = 1, hitsperstackred = 2, duration = 40, durationtarget = 40},
				usesmultiple = false,
				backpack = false,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_thirst",
				items = {itemnames = {"item_lesser_crit", "item_bloodstone"}, itemnum = {1, 1}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {},
				usesmultiple = false,
				backpack = true,
				preventedhero = "npc_dota_hero_bloodseeker",
				specificcond = true },
			{spell = "modifier_vgmar_i_pulse",
				items = {itemnames = {"item_urn_of_shadows"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {stackspercreep = 1, stacksperhero = 10, duration = 3, hpregenperstack = 4, manaregenperstack = 4},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_fervor",
				items = {itemnames = {"item_gloves", "item_mask_of_madness"}, itemnum = {2, 1}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {maxstacks = 15, asperstack = 15},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_troll_warlord",
				specificcond = true },
			{spell = "modifier_vgmar_i_kingsaegis_cooldown",
				items = {itemnames = {"item_stout_shield", "item_vanguard", "item_buckler", "item_aegis"}, itemnum = {1, 1, 1, 1}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {cooldown = 240, reincarnate_time = 5},
				usesmultiple = false,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_atrophy",
				items = {itemnames = {"item_helm_of_the_dominator", "item_satanic"}, itemnum = {2, 1}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {radius = 1000, dmgpercreep = 1, dmgperhero = 5, stack_duration = 240, stack_duration_scepter = -1, max_stacks = 1000, initial_stacks = 0},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_deathskiss",
				items = {itemnames = {"item_relic"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {critdmgpercentage = 20000, critchance = 1},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = heroent:FindModifierByName("modifier_vgmar_i_critical_mastery") == nil },
			{spell = "modifier_vgmar_i_cdreduction",
				items = {itemnames = {"item_octarine_core"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = { percentage = 25, bonusmana = 905, bonushealth = 905, intbonus = 25, spelllifestealhero = 25, spelllifestealcreep = 5 },
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_manaregen_aura",
				items = {itemnames = {"item_infused_raindrop"}, itemnum = {4}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {radius = 4000, bonusmanaself = 400, bonusmanaallies = 300, regenself = 4, regenallies = 3},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_spellshield",
				items = {itemnames = {"item_lotus_orb", "item_aeon_disk"}, itemnum = {1, 1}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {resistance = 35, cooldown = 12, maxstacks = 2},
				usesmultiple = false,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_vampiric_aura",
				items = {itemnames = {"item_vladmir"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {radius = 700, lspercent = 30, lspercentranged = 20},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_critical_mastery",
				items = {itemnames = {"item_greater_crit", "item_lesser_crit"}, itemnum = {2, 1}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {critdmgpercentage = 300, critchance = 100},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = heroent:FindModifierByName("modifier_vgmar_i_deathskiss") == nil },
			{spell = "vgmar_i_purgefield",
				items = {itemnames = {"item_nullifier", "item_null_talisman"}, itemnum = {1, 3}},
				isconsumable = true,
				ismodifier = false,
				usemodifierdatatable = true,
				modifierdata = {},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_razor",
				specificcond = true	},
			{spell = "modifier_vgmar_i_truesight",
				items = {itemnames = {"item_gem"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {radius = 900},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_item_ultimate_scepter_consumed",
				items = {itemnames = {"item_ultimate_scepter"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = { bonus_all_stats = 10, bonus_health = 175, bonus_mana = 175 },
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_alchemist",
				specificcond = true },
			{spell = "modifier_vgmar_i_spellamp",
				items = {itemnames = {"item_kaya"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {percentage = 10, costpercentage = 10, bonusint = 16},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true },
			{spell = "modifier_vgmar_i_castrange",
				items = {itemnames = {"item_aether_lens"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {range = 250, manaregen = 1.25, bonusmana = 400},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true},
			{spell = "modifier_vgmar_i_attackrange",
				items = {itemnames = {"item_dragon_lance"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {range = 140, bonusstr = 12, bonusagi = 12},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = heroent:IsRangedAttacker()},
			{spell = "modifier_vgmar_i_essence_aura",
				items = {itemnames = {"item_soul_booster"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = { radius = 1000, bonusmana = 900, restorechance = 25, restoreamount = 20 },
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_obsidian_destroyer",
				specificcond = true },
			{spell = "modifier_vgmar_i_greatcleave",
				items = {itemnames = {"item_bfury"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = { cleaveperc = 100, cleavestartrad = 150, cleaveendrad = 300, cleaveradius = 700 },
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = heroent:IsRangedAttacker() == false },
			{spell = "modifier_vgmar_i_multishot",
				items = {itemnames = {"item_dragon_lance", "item_demon_edge", "item_yasha"}, itemnum = {1, 2, 1}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {stackscap = 5, shotspercap = 8, attackduration = 2},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = heroent:IsRangedAttacker() == true },
			{spell = "modifier_vgmar_i_arcane_intellect",
				items = {itemnames = {"item_mystic_staff"}, itemnum = {2}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = { percentage = 10, multperhit = 0.5, stack_duration = 30 },
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true	},
			{spell = "modifier_vgmar_i_poison_dagger",
				items = {itemnames = {"item_butterfly", "item_orb_of_venom", "item_eagle"}, itemnum = {1, 2, 1}},
				isconsumable = true,
				ismodifier = true,
				usemodifierdatatable = true,
				modifierdata = {},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = true	},
			{spell = "modifier_vgmar_i_ogre_tester",
				items = {itemnames = {"item_ogre_axe"}, itemnum = {2}},
				isconsumable = false,
				ismodifier = true,
				usemodifierdatatable = false,
				modifierdata = {},
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_target_dummy",
				specificcond = Convars:GetInt("vgmar_devmode") == 1 }
			}
			--TableEND
			
				for k=1,#itemlistforspell do
					if heroent:IsRealHero() then
						if heroent:GetClassname() ~= itemlistforspell[k].preventedhero then
							if itemlistforspell[k].specificcond == true then
								if itemlistforspell[k].isconsumable == true then
									if itemlistforspell[k].ismodifier == true then
										if self:HeroHasAllItemsFromListWMultiple( heroent, itemlistforspell[k].items, itemlistforspell[k].backpack) and heroent:IsAlive() and not heroent:HasModifier(itemlistforspell[k].spell) then
											for j=1,#itemlistforspell[k].items.itemnames do
												self:RemoveNItemsInInventory( heroent, itemlistforspell[k].items.itemnames[j], itemlistforspell[k].items.itemnum[j])
											end
											if itemlistforspell[k].usemodifierdatatable == true then
												heroent:AddNewModifier(heroent, nil, itemlistforspell[k].spell, modifierdatatable[itemlistforspell[k].spell])
											else
												heroent:AddNewModifier(heroent, nil, itemlistforspell[k].spell, itemlistforspell[k].modifierdata)
											end
										end
									else
										if AbilitySlotsLib:GetFreeAbilitySlotsForSpecificHero( heroent, true ) > 0 then
											if self:HeroHasAllItemsFromListWMultiple( heroent, itemlistforspell[k].items, itemlistforspell[k].backpack) and heroent:IsAlive() and not heroent:FindAbilityByName(itemlistforspell[k].spell) then
												local itemability = heroent:FindAbilityByName(itemlistforspell[k].spell)
												if itemability == nil then
													for j=1,#itemlistforspell[k].items.itemnames do
														self:RemoveNItemsInInventory( heroent, itemlistforspell[k].items.itemnames[j], itemlistforspell[k].items.itemnum[j])
													end
													AbilitySlotsLib:SafeAddAbility( heroent, itemlistforspell[k].spell, 1 )
												end
											end
										end
									end
								else
									if self:HeroHasAllItemsFromListWMultiple( heroent, itemlistforspell[k].items, itemlistforspell[k].backpack) then
										if heroent:IsAlive() then
											if itemlistforspell[k].ismodifier == true then
												if not heroent:HasModifier(itemlistforspell[k].spell) then
													if itemlistforspell[k].usemodifierdatatable == true then
														heroent:AddNewModifier(heroent, nil, itemlistforspell[k].spell, modifierdatatable[itemlistforspell[k].spell])
													else
														heroent:AddNewModifier(heroent, nil, itemlistforspell[k].spell, itemlistforspell[k].modifierdata)
													end
												end
											else
												if AbilitySlotsLib:GetFreeAbilitySlotsForSpecificHero( heroent, true ) > 0 then
													local itemability = heroent:FindAbilityByName(itemlistforspell[k].spell)
													if itemability == nil then
														AbilitySlotsLib:SafeAddAbility( heroent, itemlistforspell[k].spell, 1 )
														--heroent:AddAbility(itemlistforspell[k].spell):SetLevel(1)
													end
												end
											end
										end
									else
										if itemlistforspell[k].ismodifier == true then
											if heroent:HasModifier(itemlistforspell[k].spell) then
												heroent:RemoveModifierByName(itemlistforspell[k].spell)
											end
										else
											local itemability = heroent:FindAbilityByName(itemlistforspell[k].spell)
											if itemability ~= nil then
												AbilitySlotsLib:SafeRemoveAbility( heroent, itemlistforspell[k].spell )
												--heroent:RemoveAbility(itemlistforspell[k].spell)
											end
										end
									end
								end
							end
						end
					end
				end
				--////////////////
				--PurgeFieldVisual
				--////////////////
				if heroent:FindAbilityByName("vgmar_i_purgefield") ~= nil and heroent:IsAlive() then
					if not heroent:HasModifier("modifier_vgmar_i_purgefield_visual") then
						heroent:AddNewModifier(heroent, nil, "modifier_vgmar_i_purgefield_visual", {})
					end
				end
				
				--///////////////////
				--CourierBurstUpgrade
				--///////////////////
				if self:HeroHasUsableItemInInventory(heroent, "item_flying_courier", false, true, true) then
					local couriers = Entities:FindAllByClassname("npc_dota_courier")
					for j=1,#couriers do
						if couriers[j]:GetTeamNumber() == heroent:GetTeamNumber() then
							local courierburstability = couriers[j]:FindAbilityByName("courier_burst")
							if courierburstability and courierburstability:GetLevel() >= 1 then
								if couriers[j]:GetTeamNumber() == 2 and self.radiantcourieruplevel < 4 then
									self:RemoveNItemsInInventory(heroent, "item_flying_courier", 1)
									courierburstability:SetLevel(self.radiantcourieruplevel + 1)
									self.radiantcourieruplevel = courierburstability:GetLevel()
								elseif couriers[j]:GetTeamNumber() == 3 and self.direcourieruplevel < 4 then
									self:RemoveNItemsInInventory(heroent, "item_flying_courier", 1)
									courierburstability:SetLevel(self.direcourieruplevel + 1)
									self.direcourieruplevel = courierburstability:GetLevel()
								end
							end
						end
					end
				end
				--/////////////////
				--BotCourierUpgrade
				--/////////////////
				if self:TimeIsLaterThan(12, 0) and self.direcourierup2given == false and self:GetCourierBurstLevel( nil, 3 ) >= 1 then
					if heroent:GetTeamNumber() == 3 and self:GetHeroFreeInventorySlots(heroent, true, false) > 0 then
						heroent:AddItemByName("item_flying_courier")
						dprint("Giving ", heroent:GetName(), " having ", self:GetHeroFreeInventorySlots(heroent, true, false), " empty slots 1st courier upgrade")
						self.direcourierup2given = true
					end
				elseif self:TimeIsLaterThan(24, 0) and self.direcourierup3given == false and self:GetCourierBurstLevel( nil, 3 ) >= 1 then
					if heroent:GetTeamNumber() == 3 and self:GetHeroFreeInventorySlots(heroent, true, false) > 0 then
						heroent:AddItemByName("item_flying_courier")
						dprint("Giving ", heroent:GetName(), " having ", self:GetHeroFreeInventorySlots(heroent, true, false), " empty slots 2nd courier upgrade")
						self.direcourierup3given = true
					end
				elseif self:TimeIsLaterThan(38, 0) and self.direcourierup4given == false and self:GetCourierBurstLevel( nil, 3 ) >= 1 then
					if heroent:GetTeamNumber() == 3 and self:GetHeroFreeInventorySlots(heroent, true, false) > 0 then
						heroent:AddItemByName("item_flying_courier")
						dprint("Giving ", heroent:GetName(), " having ", self:GetHeroFreeInventorySlots(heroent, true, false), " empty slots 3rd courier upgrade")
						self.direcourierup4given = true
					end
				end
			end
			--//////////////////
			--CourierLevelVisual
			--//////////////////
			local couriers = Entities:FindAllByClassname("npc_dota_courier")
			for j=1,#couriers do
				if not couriers[j]:HasModifier("modifier_vgmar_util_courier_level") then
					if couriers[j]:FindAbilityByName("vgmar_util_courier_level") ~= nil then
						local spellshieldcooldownability = couriers[j]:FindAbilityByName("vgmar_util_courier_level")
						spellshieldcooldownability:ApplyDataDrivenModifier(couriers[j], couriers[j], "modifier_vgmar_util_courier_level", {})
					else
						local spellshieldcooldownability = couriers[j]:AddAbility("vgmar_util_courier_level")
						spellshieldcooldownability:ApplyDataDrivenModifier(couriers[j], couriers[j], "modifier_vgmar_util_courier_level", {})
					end
				end
				if couriers[j]:FindAbilityByName("courier_burst"):GetLevel() > 0 then
					couriers[j]:SetModifierStackCount("modifier_vgmar_util_courier_level", couriers[j], couriers[j]:FindAbilityByName("courier_burst"):GetLevel())
				end
			end
		end
		--//////////////////
		--BackDoorProtection
		--//////////////////
		for j=1,#bdplist do
			for k=1,#bdplist[j].buildinglist do
				local buildingname = bdplist[j].buildinglist[k]
				if self.backdoorstatustable[buildingname] == nil then
					table.insert(self.backdoorstatustable, buildingname)
					self.backdoorstatustable[buildingname] = true
				else
					if self.backdoortimertable[buildingname] == nil then
						table.insert(self.backdoortimertable, buildingname)
						self.backdoortimertable[buildingname] = GameRules:GetDOTATime(false, false)
					else
						self.backdoorstatustable[buildingname] = GameRules:GetDOTATime(false, false) >= self.backdoortimertable[buildingname] + bdplist[j].activationtime
						local buildingentity = Entities:FindByName(nil, buildingname)
						if buildingentity then
							if self.backdoorstatustable[buildingname] == true then
								buildingentity:AddNewModifier(buildingentity, nil, "modifier_backdoor_protection_active", {})
							else
								buildingentity:RemoveModifierByName("modifier_backdoor_protection_active")
							end
						end
					end
				end
			end	
		end
		--///////////////
		--BalanceLogPrint
		--///////////////
		if VGMAR_LOG_BALANCE == true then
			if GameRules:GetDOTATime(false, false) >= self.balancelogprinttimestamp + VGMAR_LOG_BALANCE_INTERVAL then
				self.balancelogprinttimestamp = math.floor(GameRules:GetDOTATime(false, false))
				self:LogBalance()
			end
		end
		--///////////////////////////////
		--Dire Defensive Particle Removal
		--///////////////////////////////
		if GameRules:GetGameTime() >= self.direthronedefparticletimestamp + 5 and self.direthronedefparticlesactive == true then
			if self.direthronedefparticle1 ~= nil then
				ParticleManager:DestroyParticle(self.direthronedefparticle1, false)
				ParticleManager:ReleaseParticleIndex(self.direthronedefparticle1)
				ParticleManager:DestroyParticle(self.direthronedefparticle1_1, false)
				ParticleManager:ReleaseParticleIndex(self.direthronedefparticle1_1)
				ParticleManager:DestroyParticle(self.direthronedefparticle1_2, false)
				ParticleManager:ReleaseParticleIndex(self.direthronedefparticle1_2)
				self.direthronedefparticle1 = nil
			end
			if self.direthronedefparticle2 ~= nil then
				ParticleManager:DestroyParticle(self.direthronedefparticle2, false)
				ParticleManager:ReleaseParticleIndex(self.direthronedefparticle2)
				self.direthronedefparticle2 = nil
			end
			self.direthrone:StopSound("Hero_Razor.Storm.Loop")
			self.direthronedefparticlesactive = false
		end
	end
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
		--///////////////////
		--CustomItemsReminder
		--///////////////////
		
		local customitemreminderlist = {
			[-90] = "<font color='honeydew'>Remember, this gamemode has multiple scripted item abilities</font>",
			[-80] = "<font color='honeydew'>Use information Icon above your minimap</font>",
			[-5] = "<font color='lime'>GLHF</font>"
		}
		
		if self.customitemsreminderfinished == false then
			local gametimefloor = math.floor(GameRules:GetDOTATime( false, true ))
			if customitemreminderlist[gametimefloor] ~= nil then
				GameRules:SendCustomMessageToTeam(customitemreminderlist[gametimefloor], DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS)
				customitemreminderlist[gametimefloor] = nil
			end
			if gametimefloor >= -5 then
				self.customitemsreminderfinished = true
			end
		end
		
		--////////////////////
		--CourierBurstLevelFix
		--////////////////////
		if self.radiantcourierlvlup == false or self.direcourierlvlup == false then
			local couriers = Entities:FindAllByClassname("npc_dota_courier")
			for i=1,#couriers do
				if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME or self:TimeIsLaterThan( 3, 5 ) == false then
					if couriers[i]:GetTeamNumber() == 2 and self.radiantcourierlvldown == false then
						couriers[i]:FindAbilityByName("courier_burst"):SetLevel( 0 )
						couriers[i]:FindAbilityByName("courier_shield"):SetLevel( 0 )
						self.radiantcourierlvldown = true
					elseif couriers[i]:GetTeamNumber() == 3 and self.direcourierlvldown == false then
						couriers[i]:FindAbilityByName("courier_burst"):SetLevel( 0 )
						couriers[i]:FindAbilityByName("courier_shield"):SetLevel( 0 )
						self.direcourierlvldown = true
					end
				elseif self:TimeIsLaterThan( 3, 5 ) and GameRules:State_Get() > DOTA_GAMERULES_STATE_PRE_GAME then
					if couriers[i]:GetTeamNumber() == 2 and self.radiantcourierlvlup == false then
						couriers[i]:FindAbilityByName("courier_burst"):SetLevel( 1 )
						couriers[i]:FindAbilityByName("courier_shield"):SetLevel( 1 )
						self.radiantcourierlvlup = true
					elseif couriers[i]:GetTeamNumber() == 3 and self.direcourierlvlup == false then
						couriers[i]:FindAbilityByName("courier_burst"):SetLevel( 1 )
						couriers[i]:FindAbilityByName("courier_shield"):SetLevel( 1 )
						self.direcourierlvlup = true
					end
					self.radiantcourierlvldown = true
					self.direcourierlvldown = true
				end
			end
		end
		
		--///////////////////////////
		--END
		--///////////////////////////
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then		-- Safe guard catching any state that may exist beyond DOTA_GAMERULES_STATE_POST_GAME
		return nil
	end
	return 1
end

function VGMAR:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:GetClassname() == "npc_dota_thinker" or spawnedUnit:IsPhantom() then
		return
	end
	
	if spawnedUnit:GetClassname() == "npc_dota_venomancer_plagueward" then
		local destroySpell = spawnedUnit:FindAbilityByName( "vgmar_util_plague_ward_destroy" )
		if destroySpell then
			destroySpell:SetLevel( 1 )
		end
	end
	
	for i=1,#creepabilitieslist do
		if spawnedUnit:GetClassname() == creepabilitieslist[i].classname then
			local requiresupdater = false
			local updaterabilitieslist = {}
			for k=1,#creepabilitieslist[i].abilities do
				if creepabilitieslist[i].abilities[k] then
					if creepabilitieslist[i].abilities[k].ismodifier == 1 then
						spawnedUnit:AddNewModifier(spawnedUnit, nil, creepabilitieslist[i].abilities[k].name, modifierdatatable[creepabilitieslist[i].abilities[k].name])
					else
						local ability = spawnedUnit:AddAbility( creepabilitieslist[i].abilities[k].name )
						local updaylvl = 0
						local upnightlvl = 0
						local uptype = 0
						if creepabilitieslist[i].levelmechanicmode[k] == "unitlevel" then
							ability:SetLevel( spawnedUnit:GetLevel() )
						elseif creepabilitieslist[i].levelmechanicmode[k] == "returnvalue" then
							ability:SetLevel( creepabilitieslist[i].levelmechanicarg[k] )
						elseif creepabilitieslist[i].levelmechanicmode[k] == "daynight" then
							requiresupdater = true
							uptype = 1
							if GameRules:IsDaytime() then
								ability:SetLevel( creepabilitieslist[i].levelmechanicarg[k].daylvl )
								updaylvl = creepabilitieslist[i].levelmechanicarg[k].daylvl
							else
								ability:SetLevel( creepabilitieslist[i].levelmechanicarg[k].nightlvl )
								upnightlvl = creepabilitieslist[i].levelmechanicarg[k].nightlvl
							end
						end
						local abil = {name = creepabilitieslist[i].abilities[k].name, uptype = uptype, updaylvl = updaylvl, upnightlvl = upnightlvl}
						table.insert(updaterabilitieslist, abil)
					end
					if creepabilitieslist[i].unbroken == true then
						spawnedUnit:AddNewModifier(spawnedUnit, nil, "modifier_vgmar_util_dominator_ability_purger", 
						{remove_mode = creepabilitieslist[i].unbrokenmode,
							ability = creepabilitieslist[i].abilities[k].name,
							abilityismod = creepabilitieslist[i].abilities[k].ismodifier})
					end
					if requiresupdater then
						for j=1,#updaterabilitieslist do
							spawnedUnit:AddNewModifier(spawnedUnit, nil, "modifier_vgmar_util_creep_ability_updater", 
								{name = updaterabilitieslist[j].name, uptype = updaterabilitieslist[j].uptype, updaylvl = updaterabilitieslist[j].updaylvl, upnightlvl = updaterabilitieslist[j].upnightlvl})
						end
					end
				end
			end
		end
	end
end

--[[function VGMAR:OnPlayerUsedAbility( keys )
	local PlayerID = keys.PlayerID
	local ability = keys.abilityname
end--]]

function VGMAR:OnPlayerLearnedAbility( keys )
	local player = EntIndexToHScript(keys.player)
	local abilityname = keys.abilityname
	
	local playerhero = player:GetAssignedHero()
	
	--///////////////////////////////////
	--Preventing manual ability upgrading
	--///////////////////////////////////
	
	local blockedlvlupabilities = {
		{spell = "riki_smoke_screen", maxmanuallevel = 4},
		{spell = "riki_blink_strike", maxmanuallevel = 4},
		{spell = "riki_permanent_invisibility", maxmanuallevel = 4},
		{spell = "riki_tricks_of_the_trade", maxmanuallevel = 3}
	}
	
	
	for i=1,#blockedlvlupabilities do
		if abilityname == blockedlvlupabilities[i].spell then
			local ability = playerhero:FindAbilityByName(abilityname)
			local abilitylevel = ability:GetLevel()
			if abilitylevel > blockedlvlupabilities[i].maxmanuallevel then
				playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
				ability:SetLevel( ability:GetLevel() - 1 )
			end
		end
	end
end

function GetBuildingGroupFromName( name )
	for i=1,#bdplist do
		for k=1,#bdplist[i].buildinglist do
			if bdplist[i].buildinglist[k] == name then
				return bdplist[i].group
			end
		end
	end
	return nil
end

function GetEnemyCreepsInRadius(team, origin, radius, dominated)
	local ret = false
	local creeps = FindUnitsInRadius(team, origin, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, FIND_CLOSEST, false)
	if #creeps > 0 then
		for i=1,#creeps do
			if creeps[i]:GetClassname() == "npc_dota_creep_lane" or creeps[i]:GetClassname() == "npc_dota_creep_siege" then
				if not creeps[i]:IsDominated() then
					ret = true
				elseif creeps[i]:IsDominated() and dominated == true then
					ret = true
				end
			end
		end
	end
	return ret
end

function VGMAR:UpdateBackdoorGroupTimer(group)
	for i=1,#bdplist do
		if bdplist[i].group == group then
			for k=1,#bdplist[i].buildinglist do
			local buildingname = bdplist[i].buildinglist[k]
				if self.backdoortimertable[buildingname] == nil then
					table.insert(self.backdoortimertable, buildingname)
					self.backdoortimertable[buildingname] = GameRules:GetDOTATime(false, false)
				else
					self.backdoortimertable[buildingname] = GameRules:GetDOTATime(false, false)
					self.backdoorstatustable[buildingname] = false
					local buildingentity = Entities:FindByName(nil, buildingname)
					if buildingentity then
						buildingentity:RemoveModifierByName("modifier_backdoor_protection_active")
					end
				end
			end
		end
	end
end

function VGMAR:CreepDamage(radiant, min, max)
	--[[local rdtext 
	if radiant then
		rdtext = "Radiant"
	else
		rdtext = "Dire"
	end--]]
	--dprint("Balance: "..rdtext.." C to C Dmg: Unclamped Adv: "..self:GetTeamAdvantage(radiant == false, true, false, false))
	if self:GetTeamAdvantage(radiant == false, true, false, false) > 1 then
		--dprint("Balance: "..rdtext.." C to C Dmg: Adv: "..math.clamp(1, self:GetTeamAdvantage(radiant == false, true, false, false), 5).." Remapped: "..math.map(math.clamp(1, self:GetTeamAdvantage(radiant == false, true, false, false), 5), 1, 5, 0.5, 1).." Scaled: "..math.scale(min, math.map(math.clamp(1, self:GetTeamAdvantage(radiant == false, true, false, false), 5), 1, 5, 0.5, 1), max))
		return math.scale(min, math.map(math.clamp(1, self:GetTeamAdvantage(radiant == false, true, false, false), 5), 1, 5, 0.5, 1), max)
	else
		--dprint("Balance: "..rdtext.." C to C Dmg: Adv: "..math.clamp(0, self:GetTeamAdvantage(radiant == false, true, false, false), 1).." Remapped: "..math.map(math.clamp(0, self:GetTeamAdvantage(radiant == false, true, false, false), 1), 0, 1, 0, 0.5).." Scaled: "..math.scale(min, math.map(math.clamp(0, self:GetTeamAdvantage(radiant == false, true, false, false), 1), 0, 1, 0, 0.5), max))
		return math.scale(min, math.map(math.clamp(0, self:GetTeamAdvantage(radiant == false, true, false, false), 1), 0, 1, 0, 0.5), max)
	end
end

function VGMAR:FilterDamage( filterTable )
	--local victim_index = filterTable["entindex_victim_const"]
    --local attacker_index = filterTable["entindex_attacker_const"]
	if not filterTable["entindex_victim_const"] or not filterTable["entindex_attacker_const"] then
        return true
    end
	local victim = EntIndexToHScript(filterTable.entindex_victim_const)
	local attacker = EntIndexToHScript(filterTable.entindex_attacker_const)
	local damage = filterTable["damage"]
	
	--Damn 7.07 Makes Creeps SuperDemolishingSquads
	--Reduce Creep Damage to Buildings
	if (victim:IsBuilding() or victim:IsTower()) and (attacker:GetClassname() == "npc_dota_creep_lane" or attacker:GetClassname() == "npc_dota_creep_lane") and not attacker:IsDominated() then
		filterTable["damage"] = filterTable["damage"] * creeptobuildingdmgmult[attacker:GetClassname()]
	end
	
	--Creep and Tower Damage Balance System
	if attacker:IsDominated() == false and victim:IsDominated() == false then
		if (victim:GetClassname() == "npc_dota_creep_lane" or victim:GetClassname() == "npc_dota_creep_siege") and (attacker:GetClassname() == "npc_dota_creep_lane" or attacker:GetClassname() == "npc_dota_creep_siege") then
			--Creep to Creep Damage
			if attacker:GetTeamNumber() == 2 then --Radiant damage
				filterTable["damage"] = filterTable["damage"] * self:CreepDamage(true, 0.8, 1.2) --math.min(1.2,math.max(0.8,self:GetTeamAdvantage(false, true, false, false)))
			elseif attacker:GetTeamNumber() == 3 then --Dire damage
				filterTable["damage"] = filterTable["damage"] * self:CreepDamage(false, 0.8, 1.2) --math.min(1.2,math.max(0.8,self:GetTeamAdvantage(true, true, false, false)))
			end
		--[[elseif (attacker:GetClassname() == "npc_dota_creep_lane" or attacker:GetClassname() == "npc_dota_creep_siege") and (victim:IsBuilding() or victim:IsTower()) then
			--Creep to Building Damage
			if attacker:GetTeamNumber() == 2 then --Radiant damage
				filterTable["damage"] = filterTable["damage"] * math.min(1.2,math.max(0.8,self:GetTeamAdvantage(false, true, false, false)))
			elseif attacker:GetTeamNumber() == 3 then --Dire damage
				filterTable["damage"] = filterTable["damage"] * math.min(1.2,math.max(0.8,self:GetTeamAdvantage(true, true, false, false)))
			end
		elseif attacker:IsTower() and (victim:GetClassname() == "npc_dota_creep_lane" or victim:GetClassname() == "npc_dota_creep_siege") then
			--Tower to Creep Damage
			if attacker:GetTeamNumber() == 2 then --Radiant damage
				filterTable["damage"] = filterTable["damage"] * math.min(1.2,math.max(0.8,self:GetTeamAdvantage(false, true, false, false)))
			elseif attacker:GetTeamNumber() == 3 then --Dire damage
				filterTable["damage"] = filterTable["damage"] * math.min(1.2,math.max(0.8,self:GetTeamAdvantage(true, true, false, false)))
			end--]]
		end
	end
	
	--//////////////////////////
	--Bot Ancient Defence System
	--//////////////////////////
	if victim:GetName() == "dota_badguys_fort" then
		--TimeStamp
		if GameRules:GetGameTime() > self.direancientfailsafetimestamp + 2 then
			--Checking for radiant heroes
			local enemyheroes = FindUnitsInRadius(victim:GetTeamNumber(), victim:GetOrigin(), nil, 1600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, 0, FIND_CLOSEST, false)
			if #enemyheroes < 1 then
				local creeps = FindUnitsInRadius(victim:GetTeamNumber(), victim:GetOrigin(), nil, 1800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_CREEP, 0, FIND_CLOSEST, false)
				local selectedcreeps = {}
				for i=1,#creeps do
					if creeps[i]:IsDominated() == false and creeps[i]:GetClassname() == "npc_dota_creep_lane" or creeps[i]:GetClassname() == "npc_dota_creep_siege" then
						table.insert(selectedcreeps, creeps[i])
					end
				end
				if self.direthronedefparticle1 == nil then
					self.direthronedefparticle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_rain_storm.vpcf", PATTACH_WORLDORIGIN, victim)
					ParticleManager:SetParticleControl(self.direthronedefparticle1, 0, victim:GetAbsOrigin() + Vector(0,0,200))
					ParticleManager:SetParticleControl(self.direthronedefparticle1, 2, victim:GetAbsOrigin() + Vector(0,0,200))
					self.direthronedefparticle1_1 = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_rain_storm.vpcf", PATTACH_WORLDORIGIN, victim)
					ParticleManager:SetParticleControl(self.direthronedefparticle1_1, 0, victim:GetAbsOrigin() + Vector(0,0,200))
					ParticleManager:SetParticleControl(self.direthronedefparticle1_1, 2, victim:GetAbsOrigin() + Vector(0,0,200))
					self.direthronedefparticle1_2 = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_rain_storm.vpcf", PATTACH_WORLDORIGIN, victim)
					ParticleManager:SetParticleControl(self.direthronedefparticle1_2, 0, victim:GetAbsOrigin() + Vector(0,0,200))
					ParticleManager:SetParticleControl(self.direthronedefparticle1_2, 2, victim:GetAbsOrigin() + Vector(0,0,200))
				end
				if self.direthronedefparticle2 == nil then
					self.direthronedefparticle2 = ParticleManager:CreateParticle("particles/econ/items/outworld_devourer/od_shards_exile_gold/od_shards_exile_prison_top_orb_gold.vpcf", PATTACH_WORLDORIGIN, victim)
					ParticleManager:SetParticleControl(self.direthronedefparticle2, 0, victim:GetAbsOrigin() + Vector(0,0,350))
				end
				if self.direthronedefparticlesactive == false then
					victim:EmitSound("Hero_Razor.Storm.Cast")
					victim:EmitSound("Hero_Razor.Storm.Loop")
					self.direthrone = victim
					local direthronedefparticle3 = ParticleManager:CreateParticle("particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf", PATTACH_POINT_FOLLOW, victim)
					ParticleManager:SetParticleControl(direthronedefparticle3, 0, victim:GetAbsOrigin() + Vector(0,0,400))
					victim:EmitSound("Hero_Zuus.LightningBolt")
					ParticleManager:ReleaseParticleIndex(direthronedefparticle3)
					self.direthronedefparticlesactive = true
				end
				if #selectedcreeps > 0 then
					for j=1,#selectedcreeps do
						--particles/items_fx/chain_lightning.vpcf
						local static_pfx = ParticleManager:CreateParticle("particles/econ/events/ti6/maelstorm_ti6.vpcf", PATTACH_ABSORIGIN_FOLLOW, victim)
						ParticleManager:SetParticleControlEnt(static_pfx, 0, selectedcreeps[j], PATTACH_POINT_FOLLOW, "attach_hitloc", selectedcreeps[j]:GetAbsOrigin(), true)
						ParticleManager:SetParticleControl(static_pfx, 1, victim:GetAbsOrigin() + Vector(0,0,500))
						ParticleManager:ReleaseParticleIndex(static_pfx)
						local dmg = (selectedcreeps[j]:GetMaxHealth()/100) * (#creeps * 4)
						ApplyDamage({attacker = victim, victim = selectedcreeps[j], ability = nil, damage = dmg, damage_type = DAMAGE_TYPE_PURE})
					end
					AddFOWViewer(2, victim:GetAbsOrigin(), 500, 2.0, false)
					victim:EmitSound("Hero_Zuus.ArcLightning.Cast")
					attacker:EmitSound("Hero_Zuus.ArcLightning.Target")
				end
				self.direancientfailsafetimestamp = GameRules:GetGameTime()
				self.direthronedefparticletimestamp = GameRules:GetGameTime()
			end
		end
	end

	--///////////////////
	--BackDoor Protection
	--///////////////////
	for i=1,#bdplist do
		for k=1,#bdplist[i].buildinglist do
			if victim:GetName() == bdplist[i].buildinglist[k] then
				local buildingname = bdplist[i].buildinglist[k]
				local protent = Entities:FindByName(nil, bdplist[i].protectionholder)
				local protorigin = protent:GetOrigin()
				if GetEnemyCreepsInRadius(victim:GetTeamNumber(), protorigin, bdplist[i].protectionrange, false) then
					self:UpdateBackdoorGroupTimer(bdplist[i].group)
				end
				if self.backdoorstatustable[buildingname] == true then
					if attacker:GetTeamNumber() ~= victim:GetTeamNumber() then
						if filterTable["damage"] > bdplist[i].maxdamage then
							filterTable["damage"] = bdplist[i].maxdamage
						end
					end
					return true
				end
			end
		end
	end
	return true
end

function VGMAR:GetHerosCourier(hero)
	local couriers = Entities:FindAllByClassname("npc_dota_courier")
	for i=1,#couriers do
		if couriers[i]:GetTeamNumber() == hero:GetTeamNumber() then
			return couriers[i]
		end
	end
	return nil
end

function VGMAR:GetCourierBurstLevel( hero, teamnumber )
	if hero ~= nil then
		local courier = self:GetHerosCourier( hero )
		if courier then
			local courierburstability = courier:FindAbilityByName("courier_burst")
			if courierburstability then
				return courierburstability:GetLevel()
			end
		end
	elseif hero == nil and teamnumber ~= nil then
		local couriers = Entities:FindAllByClassname("npc_dota_courier")
		if #couriers > 0 then
			for i=1,#couriers do
				if couriers[i]:GetTeamNumber() == teamnumber then
					local courierburstability = couriers[i]:FindAbilityByName("courier_burst")
					if courierburstability then
						return courierburstability:GetLevel()
					end
				end
			end
		end
	else
		return 0
	end
	return 0
end

function VGMAR:ExecuteOrderFilter( filterTable )
	--[[if filterTable["issuer_player_id_const"] == 0 then
		DeepPrintTable(filterTable)
	end--]]
	local order_type = filterTable.order_type
    local units = filterTable["units"]
    local issuer = filterTable["issuer_player_id_const"]
	local unit = nil
	if units["0"] ~= nil then
		unit = EntIndexToHScript(units["0"])
	end
    local ability = EntIndexToHScript(filterTable.entindex_ability)
    local target = EntIndexToHScript(filterTable.entindex_target)		
	
	--//////////
	--Buy Orders
	--//////////
	local itempurchaseblocklist = {
		["item_courier"] = { radiant = {true, "This item cannot be purchased"}, dire = {false, nil} },
		["item_flying_courier"] = { radiant = {self.radiantcourieruplevel >= 4, "Courier is at max level"}, dire = {self.direcourieruplevel >= 4, "Courier is at max level"} }
	}
	
	if order_type == 16 then
		--dprint("Purchase Order Detected.")
		--dprint("Item ID: ", filterTable["entindex_ability"])
		local itemname = self:GetItemByID(filterTable["entindex_ability"])
		--dprint("Item: "..itemname)
		if itempurchaseblocklist[itemname] ~= nil then
			if PlayerResource:GetTeam(issuer) == 2 then
				if itempurchaseblocklist[itemname].radiant[1] == true then
					if itempurchaseblocklist[itemname].radiant[2] ~= nil then
						self:DisplayClientError(issuer, itempurchaseblocklist[itemname].radiant[2])
					end
					return false
				end
			elseif PlayerResource:GetTeam(issuer) == 3 then
				if itempurchaseblocklist[itemname].dire[1] == true then
					if itempurchaseblocklist[itemname].dire[2] ~= nil then
						self:DisplayClientError(issuer, itempurchaseblocklist[itemname].dire[2])
					end
					return false
				end
			end
		end
	end
	
	--///////////////////////
	--SecondCourierPrevention
	--///////////////////////
	if unit then
		if unit:IsRealHero() then
			if ability and ability:GetName() == "item_courier" then
				if self:GetHerosCourier(unit) ~= nil then
					self:RemoveNItemsInInventory(unit, "item_courier", 1)
					SendOverheadEventMessage( nil, 0, unit, 100, nil )
					self:DisplayClientError(issuer, "Second Courier is not allowed")
					unit:ModifyGold(100, false, 6)
					return false
				end
			end
		end
		if unit:GetClassname() == "npc_dota_venomancer_plagueward" then
			if ability and ability:GetName() == "vgmar_util_plague_ward_destroy" then
				unit:ForceKill(false)
				return false
			end
		end
	end
	
	if unit then
        if unit:IsRealHero() then
            local unitPlayerID = unit:GetPlayerID()

            -- BOT STUCK FIX
            -- How It Works: Every time bot creates an order, this checks their position, if they are in the same last position as last order,
            -- increase counter. If counter gets too high, it means they have been stuck in same position for a long time, do action to help them.
            if PlayerResource:GetConnectionState(unitPlayerID) == 1 then
                -- Bot Armlet Fix: Bots do not know how to use armlets so return false if they attempt to and put on cooldown
                if ability and ability:GetName() == "item_armlet" then
                    ability:StartCooldown(200)
                    return false
                end

                if not unit.OldPosition then
                    unit.OldPosition = unit:GetAbsOrigin()
                    unit.StuckCounter = 0
                elseif unit:GetAbsOrigin() == unit.OldPosition then
                    unit.StuckCounter = unit.StuckCounter + 1

                    -- Stuck at observer ward fix
                    if unit.StuckCounter > 50 then
                        for i=0,11 do
                            local item = unit:GetItemInSlot(i)
                            if item and item:GetName() == "item_ward_observer" then
                                unit:ModifyGold(item:GetCost() * item:GetCurrentCharges(), true, 0)
                                unit:RemoveItem(item)
                                return true
                            end
                        end
                    end

                    --[[-- Stuck at shop trying to get stash items, remove stash items. THIS IS A BAND-AID FIX. IMPROVE AT SOME POINT
                    if unit.StuckCounter > 150 and fixed == false then
                        for slot =  DOTA_STASH_SLOT_1, DOTA_STASH_SLOT_6 do
                            item = unit:GetItemInSlot(slot)
                            if item ~= nil then
                                item:RemoveSelf()
                                return true
                            end
                        end
                    end

                    -- Its well and truly borked, kill it and hope for the best.
                    if unit.StuckCounter > 300 and fixed == false then
                        unit:Kill(nil, nil)
                        return true
                    end--]]

                else
                   unit.OldPosition = unit:GetAbsOrigin()
                   unit.StuckCounter = 0
                end
				
				--/////////////////////////////////////////////////////////////////////////
				--Yeah Sure Dont Check Drums For Charges Before Trying To Use Them For Bots
				--/////////////////////////////////////////////////////////////////////////
				if order_type == 8 and ability:IsItem() and ability:GetName() == "item_ancient_janggo" and ability:GetCurrentCharges() == 0 then
					return false
				end
				
				--//////////////////////////
				--Bot Action Miss Simulation
				--//////////////////////////
				if order_type == 5 or order_type == 6 or order_type == 8 or order_type == 9 then
					-- TODO: Make percentage depend on time
					-- max->min earlygame->lategame
					-- 20->10 0->50+
					local minidlechance = 10
					local maxidlechance = 20
					local minmissclickchance = 10
					local maxmissclickchance = 20
					local maxminute = 40
					local currentminute = math.floor(GameRules:GetDOTATime(false, false)/60)
					local idlechance = math.scale( minidlechance, math.clamp(0, (currentminute/maxminute), 1), maxidlechance)
					local missclickchance = math.scale( minmissclickchance, math.clamp(0, (currentminute/maxminute), 1), maxmissclickchance)
					local missclickrange = 150
					--Deny an order
					if missclickproofabilities[EntIndexToHScript(filterTable.entindex_ability):GetName()] == nil or missclickproofabilities[EntIndexToHScript(filterTable.entindex_ability):GetName()] ~= true then
						if math.random(1,100) <= idlechance then
							dprint("Making PlayerID: "..issuer.." not cast an ability: "..ability:GetName())
							return false
						else
							if order_type == 6 then
								--Check for Missclick Opportunity
								local targetteam = DOTA_UNIT_TARGET_TEAM_ENEMY
								if ability:GetAbilityTargetTeam() == "DOTA_UNIT_TARGET_TEAM_ENEMY" then
									targetteam = DOTA_UNIT_TARGET_TEAM_ENEMY
								elseif ability:GetAbilityTargetTeam() == "DOTA_UNIT_TARGET_TEAM_FRIENDLY" then
									targetteam = DOTA_UNIT_TARGET_TEAM_FRIENDLY
								elseif ability:GetAbilityTargetTeam() == "DOTA_UNIT_TARGET_TEAM_BOTH" then
									targetteam = DOTA_UNIT_TARGET_TEAM_BOTH
								end
								local missclicktargets = FindUnitsInRadius(unit:GetTeamNumber(), target:GetOrigin(), nil, missclickrange, targetteam, EntIndexToHScript(filterTable.entindex_ability):GetAbilityTargetType(), 0, FIND_CLOSEST, false)
								local filteredmissclicktargets = {}
								if #missclicktargets > 1 then
									for i=1,#missclicktargets do
										if missclicktargets[i] ~= target then
											table.insert(filteredmissclicktargets, missclicktargets[i])
										end
									end
								end
								if #filteredmissclicktargets > 0 then
									if math.random(1,100) <= missclickchance then
										dprint("Making PlayerID: "..issuer.." missclick a unit target ability: "..ability:GetName())
										local newtar = filteredmissclicktargets[math.random(1,#filteredmissclicktargets)]
										if IsDevMode() then
											DebugDrawLine(unit:GetOrigin(), target:GetOrigin(), 128, 255, 255, true, 2)
											DebugDrawCircle(target:GetOrigin(), Vector(128, 255, 255), 100, missclickrange, true, 2)
											DebugDrawCircle(target:GetOrigin(), Vector(128, 255, 128), 255, 15, true, 2)
											DebugDrawLine(target:GetOrigin(), newtar:GetOrigin(), 255, 128, 128, true, 2)
										end
										unit:CastAbilityOnTarget(newtar, ability, issuer)
										return false
									end
								end
							elseif order_type == 5 then
								if math.random(1,100) <= missclickchance then
									dprint("Making PlayerID: "..issuer.." missclick a ground point ability: "..ability:GetName())
									local TargetVector = Vector(filterTable["position_x"], filterTable["position_y"], filterTable["position_z"])
									local newx = filterTable["position_x"] + math.random(-1*missclickrange, missclickrange)
									local newy = filterTable["position_y"] + math.random(-1*missclickrange, missclickrange)
									local newz = GetGroundHeight(Vector(newx,newy,0), nil)
									if IsDevMode() then
										DebugDrawLine(unit:GetOrigin(), TargetVector, 128, 255, 255, true, 2)
										DebugDrawCircle(TargetVector, Vector(128, 255, 255), 100, missclickrange, true, 2)
										DebugDrawCircle(TargetVector, Vector(128, 255, 128), 255, 15, true, 2)
										DebugDrawLine(TargetVector, Vector(newx,newy,newz), 255, 128, 128, true, 2)
									end
									unit:CastAbilityOnPosition(Vector(newx,newy,newz), ability, issuer)
									return false
								end
							end
						end
					end
				end
            end
		end
	end
	
	--Bot Control Prevention
	if unit and Convars:GetInt("vgmar_blockbotcontrol") == 1 then
		local player = PlayerResource:GetPlayer(issuer)
		if unit:IsRealHero() then
			local unitPlayerID = unit:GetPlayerID()
			if PlayerResource:GetConnectionState(unitPlayerID) == 1 and unitPlayerID ~= issuer and issuer ~= -1 then
				dprint("Blocking a command to a unit not owned by player UnitPlayerID: ", unitPlayerID, "PlayerID: ", issuer)
				if IsDevMode() then
					DeepPrintTable(filterTable)
				end
				if player then
					dprint("Trying to call panorama to reset players unit selection")
					CustomGameEventManager:Send_ServerToPlayer(player, "selection_reset", {})
				end
				return false
			end
		end
		if unit:GetClassname() == "npc_dota_courier" or unit:GetClassname() == "npc_dota_flying_courier" then
			if PlayerResource:GetTeam(issuer) == 2 or PlayerResource:GetTeam(issuer) == 3 then
				if unit:GetTeamNumber() ~= PlayerResource:GetTeam(issuer) then
					dprint("Blocking enemy team Courier usage CourierTeamID: ", unit:GetTeamNumber(), "PlayerTeamID: ", PlayerResource:GetTeam(issuer))
					CustomGameEventManager:Send_ServerToPlayer(player, "selection_reset", {})
					return false
				end
			end
		end
	end
	
	--CompanionControl
	if unit and self:IsUnitACompanion( unit , 0 ) then
		local companionnum = self:GetCompanionNum( nil, -1, unit:entindex())
		local companionowner = self.companionheroes[companionnum].ownerid
		if issuer == companionowner then
			if ability and (ability:GetName() == "vgmar_ca_wisp_relocate" or ability:GetName() == "vgmar_ai_companion_wisp_toggle_autohit" or ability:GetName() == "vgmar_ai_companion_wisp_toggle_scepter" or ability:GetName() == "vgmar_ai_companion_wisp_toggle_tether") then
				--if ability:GetName() == "vgmar_ai_companion_wisp_toggle_autohit" or ability:GetName() == "vgmar_ai_companion_wisp_toggle_scepter" then
				--	unit:AddNewModifier( unit, nil, "modifier_vgmar_ai_companion_wisp_force_retether", {ownerindex = unit:entindex(), ownerid = companionowner})
				--end
				return true
			else
				if Convars:GetInt("vgmar_enablecompanion_fullcontrol") == 0 then
					return false
				end
			end
		elseif issuer ~= companionowner then
			self:DisplayClientError(issuer, "You are not allowed to control other players Companions")
			return false
		end
	end
	
	--Riki No Enemy Ult Before lvl4 scepters
	if unit and unit:IsRealHero() then
		if ability and ability:GetName() == "riki_tricks_of_the_trade" then
			if ability:GetLevel() < 4 then
				if filterTable.entindex_target ~= 0 and target:GetTeamNumber() ~= unit:GetTeamNumber() then
					self:DisplayClientError(issuer, "Unable to cast on enemies before LVL4")
					return false
				end
			end
		end
	end
	
	--////////////////
	--AutoCourierBurst
	--////////////////
	if unit and unit:GetClassname() == "npc_dota_courier" then
		local burstability = unit:FindAbilityByName("courier_burst")
		if unit:GetTeamNumber() == 2 and ability and (ability:GetName() == "courier_take_stash_and_transfer_items" or ability:GetName() == "courier_shield" or ability:GetName() == "courier_burst") then
			if burstability and burstability:GetCooldownTimeRemaining() == 0 then
				burstability:CastAbility()
				unit:FindAbilityByName("courier_shield"):EndCooldown()
				unit:FindAbilityByName("courier_shield"):StartCooldown(burstability:GetCooldown(burstability:GetLevel() - 1))
			end
		elseif unit:GetTeamNumber() == 3 and burstability:GetLevel() > 2 then
			if burstability and burstability:GetCooldownTimeRemaining() == 0 then
				burstability:CastAbility()
			end
		end
	end
	
	return true
end

function VGMAR:OnGameStateChanged( keys )
	local state = GameRules:State_Get()
	
	if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		if IsServer() then
			Convars:SetBool("sv_cheats", true)
			dprint("Instant:Enabling Cheats")
			if VGMAR_BOT_FILL == true then
				SendToServerConsole("dota_bot_populate")
			end
			Timers:CreateTimer(3, function()
				Convars:SetBool("sv_cheats", true)
				dprint("Timer:Enabling Cheats")
				SendToServerConsole("dota_bot_set_difficulty 3")
				if VGMAR_BOT_FILL == true then
					GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
				end
			end)
			SendToServerConsole("dota_bot_set_difficulty 3")
			Convars:SetBool("sv_cheats", false)
			if VGMAR_BOT_FILL == true then
				GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
			end
		end
	elseif state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		local used_hero_name = "npc_dota_hero_dragon_knight"
		dprint("Checking players...")
		
		for playerID=0, DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:IsValidPlayer(playerID) then
				dprint("PlayedID:", playerID)
				
				if PlayerResource:GetTeam(playerID) == DOTA_TEAM_GOODGUYS then
					self.n_players_radiant = self.n_players_radiant + 1
				elseif PlayerResource:GetTeam(playerID) == DOTA_TEAM_BADGUYS then
					self.n_players_dire = self.n_players_dire + 1
				end

				-- Random heroes for people who have not picked
				if PlayerResource:HasSelectedHero(playerID) == false then
					dprint("Randoming hero for:", playerID)
					PlayerResource:GetPlayer(playerID):MakeRandomHeroSelection()
					dprint("Randomed:", PlayerResource:GetSelectedHeroName(playerID))
				end
				
				used_hero_name = PlayerResource:GetSelectedHeroName(playerID)
			end
		end
		
		Convars:SetBool("sv_cheats", true)
		for f=0,100 do
			if VGMAR_BOT_FILL == true then
				SendToServerConsole("dota_bot_populate")
			end
			SendToServerConsole("dota_bot_set_difficulty 3")
		end
		Convars:SetBool("dota_bot_disable", false)
		
		dprint("Number of players:", self.n_players_radiant + self.n_players_dire)
		dprint("Radiant:", self.n_players_radiant)
		dprint("Radiant:", self.n_players_dire)
		
	elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
		if IsServer() then
			Timers:CreateTimer(10, function()
				Convars:SetBool("sv_cheats", true)
				Convars:SetBool("dota_bot_disable", false)
				if VGMAR_BOT_FILL == true then
					GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
					GameRules:GetGameModeEntity():SetBotsInLateGame(self.botsInLateGameMode)
				end
				Convars:SetFloat("host_timescale", PreGameSpeed())
			end)
		end
	
		--////////////
		--Free Courier
		--////////////
		if IsServer() then
			Timers:CreateTimer(5,
			function()
				if self.couriergiven == false then
					local heroes = HeroList:GetAllHeroes()
					local radiantheroes = {}
					if #heroes > 0 then
						for i=1,#heroes do
							if heroes[i]:GetTeamNumber() == 2 then
								table.insert(radiantheroes, heroes[i])
							end
						end
					else
						return 5.0
					end
					local luckyhero = radiantheroes[math.random(1, #radiantheroes)]
					if luckyhero ~= nil then
						luckyhero:AddItemByName("item_courier")
						local heroname = HeroNamesLib:ConvertInternalToHeroName(luckyhero:GetName())
						GameRules:SendCustomMessageToTeam("<font color='turquoise'>Giving Free Courier to</font> <font color='gold'>"..heroname.."</font>", DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS)
						self.couriergiven = true
					end
					if self.couriergiven == false then
						return 5.0
					end
				end
				if IsDevMode() and VGMAR_GIVE_DEBUG_ITEMS == true then
					local heroes = HeroList:GetAllHeroes()
					local radiantheroes = {}
					if #heroes > 0 then
						for i=1,#heroes do
							if heroes[i]:GetTeamNumber() == 2 then
								table.insert(radiantheroes, heroes[i])
							end
						end
					end
					local itemslist = {}
					for k,v in pairs(debugitems) do
						if v >= 1 then
							for j=1, v do
								table.insert(itemslist, k)
							end
						end
					end
					if #itemslist > 0 then
						for i=1,#radiantheroes do
							radiantheroes[i]:AddNewModifier(radiantheroes[i], nil, "modifier_vgmar_util_give_debugitems", 
								{item1 = itemslist[1],
								item2 = itemslist[2],
								item3 = itemslist[3],
								item4 = itemslist[4],
								item5 = itemslist[5],
								item6 = itemslist[6],
								item7 = itemslist[7],
								item8 = itemslist[8],
								item9 = itemslist[9],
								item10 = itemslist[10],
								item11 = itemslist[11],
								item12 = itemslist[12],
								item13 = itemslist[13],
								item14 = itemslist[14],
								item15 = itemslist[15],
								item16 = itemslist[16],
								item17 = itemslist[17],
								item18 = itemslist[18],
								item19 = itemslist[19],
								item20 = itemslist[20],
								item21 = itemslist[21],
								item22 = itemslist[22],
								item23 = itemslist[23],
								item24 = itemslist[24],
								item25 = itemslist[25],
								item26 = itemslist[26],
								item27 = itemslist[27],
								item28 = itemslist[28],
								item29 = itemslist[29],
								item30 = itemslist[30],
								item31 = itemslist[31],
								item32 = itemslist[32],
								item33 = itemslist[33],
								item34 = itemslist[34],
								item35 = itemslist[35],
								item36 = itemslist[36],
								item37 = itemslist[37],
								item38 = itemslist[38],
								item39 = itemslist[39],
								item40 = itemslist[40],
								item41 = itemslist[41],
								item42 = itemslist[42],
								item43 = itemslist[43],
								item44 = itemslist[44],
								item45 = itemslist[45],
								item46 = itemslist[46],
								item47 = itemslist[47],
								item48 = itemslist[48],
								item49 = itemslist[49],
								item50 = itemslist[50]})
						end
					end
				end
			end)
		end	
		--///////////////////////////////
		--New Implementation of defskills
		--///////////////////////////////
		local buildingstobufflist = {
			{bn = "dota_goodguys_fort", priority = 4, istower = 0, regnegation = 5.5},
			{bn = "good_rax_melee_bot", priority = 3, istower = 0, regnegation = 5.5},
			{bn = "good_rax_melee_mid", priority = 3, istower = 0, regnegation = 5.5},
			{bn = "good_rax_melee_top", priority = 3, istower = 0, regnegation = 5.5},
			{bn = "good_rax_range_top", priority = 2, istower = 0, regnegation = 5.5},
			{bn = "good_rax_range_mid", priority = 2, istower = 0, regnegation = 5.5},
			{bn = "good_rax_range_bot", priority = 2, istower = 0, regnegation = 5.5},
			{bn = "dota_goodguys_tower4_bot", priority = 1, istower = 1, regnegation = 5.5},
			{bn = "dota_goodguys_tower4_top", priority = 1, istower = 1, regnegation = 5.5},
			{bn = "dota_goodguys_tower3_top", priority = 0, istower = 1, regnegation = 5.5},
			{bn = "dota_goodguys_tower3_mid", priority = 0, istower = 1, regnegation = 5.5},
			{bn = "dota_goodguys_tower3_bot", priority = 0, istower = 1, regnegation = 5.5}
		}
		
		local defskills = {
			{skill = "dragon_knight_dragon_blood", agressive = 0, p0 = 0, p1 = 0, p2 = 0, p3 = 0, p4 = 1, autocast = 0},
			{skill = "tower_corrosive_skin", agressive = 0, p0 = 1, p1 = 3, p2 = 3, p3 = 3, p4 = 4, autocast = 0},
			{skill = "tower_dispersion", agressive = 0, p0 = 1, p1 = 4, p2 = 3, p3 = 3, p4 = 4, autocast = 0},
			{skill = "tower_atrophy_aura", agressive = 1, p0 = 1, p1 = 4, p2 = 0, p3 = 0, p4 = 0, autocast = 0},
			{skill = "tower_berserkers_blood", agressive = 1, p0 = 1, p1 = 4, p2 = 0, p3 = 0, p4 = 0, autocast = 0},
			{skill = "tower_take_aim", agressive = 1, p0 = 0, p1 = 4, p2 = 0, p3 = 0, p4 = 0, autocast = 0},
			{skill = "tower_walrus_punch", agressive = 1, p0 = 2, p1 = 4, p2 = 0, p3 = 0, p4 = 0, autocast = 1},
			{skill = "tower_great_cleave", agressive = 1, p0 = 0, p1 = 4, p2 = 0, p3 = 0, p4 = 0, autocast = 0},
			{skill = "tower_tidebringer", agressive = 1, p0 = 2, p1 = 4, p2 = 0, p3 = 0, p4 = 0, autocast = 0}
		}
		
		local defitems = {
			{item = "item_vanguard", agressive = 0, p0 = 1, p1 = 1, p2 = 1, p3 = 1, p4 = 1},
			{item = "item_shivas_guard", agressive = 0, p0 = 0, p1 = 0, p2 = 0, p3 = 1, p4 = 1},
			{item = "item_assault", agressive = 0, p0 = 0, p1 = 0, p2 = 0, p3 = 1, p4 = 1},
			--{item = "item_radiance", agressive = 1, p0 = 0, p1 = 1, p2 = 0, p3 = 0, p4 = 0},
			{item = "item_vladmir", agressive = 0, p0 = 0, p1 = 0, p2 = 1, p3 = 0, p4 = 0},
			{item = "item_maelstrom", agressive = 1, p0 = 0, p1 = 1, p2 = 0, p3 = 0, p4 = 0},
			{item = "item_dragon_lance", agressive = 1, p0 = 0, p1 = 1, p2 = 0, p3 = 0, p4 = 0},
			{item = "item_solar_crest", agressive = 0, p0 = 1, p1 = 1, p2 = 1, p3 = 1, p4 = 1}
		}
		
		for k=1,#buildingstobufflist do
			local building = Entities:FindByName(nil, buildingstobufflist[k].bn)
			if building then
				--Negating unnecessary regen
				building:SetBaseHealthRegen(building:GetBaseHealthRegen() + (buildingstobufflist[k].regnegation * -1))
				for i=1,#defskills do
					--Applying Spells(only towers get agressive spells)
					if buildingstobufflist[k].istower == 1 and defskills[i].agressive == 1 then
						building:AddAbility(defskills[i].skill)
					elseif defskills[i].agressive == 0 then
						building:AddAbility(defskills[i].skill)
					end
					--Leveling Spells
					local processedskill = building:FindAbilityByName(defskills[i].skill)
					if processedskill then
						if buildingstobufflist[k].priority == 0 then
							processedskill:SetLevel(defskills[i].p0)
						elseif buildingstobufflist[k].priority == 1 then
							processedskill:SetLevel(defskills[i].p1)
						elseif buildingstobufflist[k].priority == 2 then
							processedskill:SetLevel(defskills[i].p2)
						elseif buildingstobufflist[k].priority == 3 then
							processedskill:SetLevel(defskills[i].p3)
						elseif buildingstobufflist[k].priority == 4 then
							processedskill:SetLevel(defskills[i].p4)
						else
							dprint("Error in defspells assigning mechanism, UNEXPECTED_PRIORITY_FOUND")
						end
						if processedskill:GetLevel() == 0 then
							building:RemoveAbility(defskills[i].skill)
						end
						if defskills[i].autocast == 1 then
							processedskill:ToggleAutoCast()
						end
					end
				end
				for j=1,#defitems do
					if buildingstobufflist[k].priority == 0 and defitems[j].p0 == 1 then
						if defitems[j].agressive == 1 and buildingstobufflist[k].istower == 1 then
							building:AddItemByName(defitems[j].item)
						elseif defitems[j].agressive == 0 then
							building:AddItemByName(defitems[j].item)
						end
					elseif buildingstobufflist[k].priority == 1 and defitems[j].p1 == 1 then
						if defitems[j].agressive == 1 and buildingstobufflist[k].istower == 1 then
							building:AddItemByName(defitems[j].item)
						elseif defitems[j].agressive == 0 then
							building:AddItemByName(defitems[j].item)
						end
					elseif buildingstobufflist[k].priority == 2 and defitems[j].p2 == 1 then
						if defitems[j].agressive == 1 and buildingstobufflist[k].istower == 1 then
							building:AddItemByName(defitems[j].item)
						elseif defitems[j].agressive == 0 then
							building:AddItemByName(defitems[j].item)
						end
					elseif buildingstobufflist[k].priority == 3 and defitems[j].p3 == 1 then
						if defitems[j].agressive == 1 and buildingstobufflist[k].istower == 1 then
							building:AddItemByName(defitems[j].item)
						elseif defitems[j].agressive == 0 then
							building:AddItemByName(defitems[j].item)
						end
					elseif buildingstobufflist[k].priority == 4 and defitems[j].p4 == 1 then
						if defitems[j].agressive == 1 and buildingstobufflist[k].istower == 1 then
							building:AddItemByName(defitems[j].item)
						elseif defitems[j].agressive == 0 then
							building:AddItemByName(defitems[j].item)
						end
					end
				end
			end
		end
		--////////////////////////////////////////
	elseif state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if IsServer() and self.istimescalereset == 0 then
			Convars:SetFloat("host_timescale", 1.0)
			self.istimescalereset = 1
		end
	end
end
