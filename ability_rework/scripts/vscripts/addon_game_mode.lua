local RADIANT_TEAM_MAX_PLAYERS = 1
local DIRE_TEAM_MAX_PLAYERS = 8
local RUNE_SPAWN_TIME = 120
local VGMAR_DEBUG = false
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

function Precache( ctx )

end

function Activate()
	GameRules.VGMAR = VGMAR()
	GameRules.VGMAR:Init()
end

function VGMAR:Init()
	self.n_players_radiant = 0
	self.n_players_dire = 0
	self.istimescalereset = 0
	self.direcourieruplevel = 1
	self.radiantcourieruplevel = 1
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


	self.mode = GameRules:GetGameModeEntity()
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, RADIANT_TEAM_MAX_PLAYERS)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, DIRE_TEAM_MAX_PLAYERS)
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )
	GameRules:SetCustomGameSetupAutoLaunchDelay( 5 )
	GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
	GameRules:SetRuneMinimapIconScale( 1 )
	self.mode:SetRecommendedItemsDisabled(true)
	GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
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
	--self.mode:SetModifierGainedFilter( Dynamic_Wrap( VGMAR, "FilterModifierGained" ), self)

	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( VGMAR, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_player_learned_ability", Dynamic_Wrap( VGMAR, "OnPlayerLearnedAbility" ), self)
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( VGMAR, 'OnGameStateChanged' ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( VGMAR, 'OnItemPickedUp' ), self )
	ListenToGameEvent( "dota_tower_kill", Dynamic_Wrap( VGMAR, 'OnTowerKilled' ), self )
	Convars:RegisterConvar('vgmar_devmode', "0", "Set to 1 to show debug info.  Set to 0 to disable.", 0)
	if VGMAR_DEBUG == true then
		Convars:SetInt("vgmar_devmode", 1)
	end
	
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 0.25 )
end

function dprint(...)
	if Convars:GetInt("vgmar_devmode") == 1 then
		print(...)
	end
end

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
			"good_healer_2",
			"good_healer_3",
			"good_healer_4",
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
			"bad_healer_2",
			"bad_healer_3",
			"bad_healer_4",
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
	
function PreGameSpeed()
	if Convars:GetInt("vgmar_devmode") == 1 then
		return 8.0
	end
	return 2.0
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

--[[function VGMAR:FilterModifierGained( filterTable )
	local modifiername = filterTable["name_const"]
	local ability = nil
	if filterTable["entindex_ability_const"] then
		ability = EntIndexToHScript(filterTable.entindex_ability_const)
	end
	
	return true
end--]]

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
	--if not hero:HasItemInInventory(item) then
	--	return
	--end
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

function VGMAR:HeroHasAllItemsFromListWMultiple( hero, itemlist, backpack )
	for i=1,#itemlist.itemnames do
		if self:CountUsableItemsInHeroInventory( hero, itemlist.itemnames[i], false, backpack, false) < itemlist.itemnum[i] then
			return false
		end
	end
	return true
end

function VGMAR:TimeIsLaterThan( minute, second )
	local num = minute * 60 + second
	if GameRules:GetDOTATime(false, false) > num then
		return true
	else
		return false
	end
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

function VGMAR:OnItemPickedUp(keys)
	local heroEntity = EntIndexToHScript(keys.HeroEntityIndex or keys.UnitEntityIndex)
	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname
	
	--//////////////////////////////
	--Consumable Items System
	--//////////////////////////////
	if heroEntity:IsRealHero() and not heroEntity:IsCourier() then
		--Alchemist-less Scepter consumption
		if self:CountUsableItemsInHeroInventory( heroEntity, "item_ultimate_scepter", false, true, false) >= 2 and not heroEntity:FindModifierByName("modifier_item_ultimate_scepter_consumed") then
			self:RemoveNItemsInInventory(heroEntity, "item_ultimate_scepter", 2)
			heroEntity:AddNewModifier(heroEntity, nil, 'modifier_item_ultimate_scepter_consumed', { bonus_all_stats = 10, bonus_health = 175, bonus_mana = 175 })
		end
		--Diffusal Blade 2+ Upgrade
		if self:HeroHasUsableItemInInventory( heroEntity, "item_recipe_diffusal_blade", false, false, false) and self:HeroHasUsableItemInInventory( heroEntity, "item_diffusal_blade_2", false, false, false)  then
			local diffbladeitem = self:GetItemFromInventoryByName( heroEntity, "item_diffusal_blade_2", false, false, false )
			local diffbladerecipe = self:GetItemFromInventoryByName( heroEntity, "item_recipe_diffusal_blade", false, false, false )
			if diffbladeitem ~= nil and diffbladeitem:GetCurrentCharges() < diffbladeitem:GetInitialCharges() then
				heroEntity:RemoveItem(diffbladerecipe)
				diffbladeitem:SetCurrentCharges(diffbladeitem:GetInitialCharges())
			end
		end
		--Bloodstone recharge
		if self:HeroHasUsableItemInInventory(heroEntity, "item_bloodstone", false, false, false) and self:CountUsableItemsInHeroInventory(heroEntity, "item_recipe_bloodstone", false, true, false) >= 3 then
			self:RemoveNItemsInInventory(heroEntity, "item_recipe_bloodstone", 3)
			local bloodstone = self:GetItemFromInventoryByName( heroEntity, "item_bloodstone", false, false, false )
			if bloodstone ~= nil then
				bloodstone:SetCurrentCharges(bloodstone:GetCurrentCharges() + 24)
			end
		end
	end
end

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
		for i=0,HeroList:GetHeroCount() do
			local heroent = HeroList:GetHero(i)
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
					--[[--///////////////////
					--BotShrineActivation
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
			--//////////////////////
			--Passive Item Abilities
			--//////////////////////
			--Items For Spells Table
				local itemlistforspell = {
			{spell = "vgmar_i_goblins_greed",
				items = {itemnames = {"item_hand_of_midas"}, itemnum = {1}},
				isconsumable = false,
				usesmultiple = false,
				backpack = self:TimeIsLaterThan( 30, 0 ) or heroent:GetLevel() >= 25,
				preventedhero = "npc_dota_hero_alchemist"},
			{spell = "vgmar_i_essense_shift",
				items = {itemnames = {"item_silver_edge"}, itemnum = {1}},
				isconsumable = false,
				usesmultiple = false,
				backpack = false,
				preventedhero = "npc_dota_hero_slark"},
			{spell = "vgmar_i_thirst",
				items = {itemnames = {"item_gem", "item_phase_boots"}, itemnum = {2, 1}},
				isconsumable = true,
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_bloodseeker"},
			{spell = "vgmar_i_pulse",
				items = {itemnames = {"item_urn_of_shadows"}, itemnum = {2}},
				isconsumable = true,
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_necrolyte"},
			{spell = "vgmar_i_fervor",
				items = {itemnames = {"item_gloves", "item_mask_of_madness"}, itemnum = {2, 1}},
				isconsumable = true,
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_troll_warlord"},
			{spell = "aegis_king_reincarnation",
				items = {itemnames = {"item_stout_shield", "item_poor_mans_shield", "item_vanguard", "item_buckler", "item_aegis"}, itemnum = {1, 1, 1, 1, 1}},
				isconsumable = true,
				usesmultiple = false,
				backpack = true,
				preventedhero = "npc_dota_hero_skeleton_king"},
			{spell = "vgmar_i_atrophy_aura",
				items = {itemnames = {"item_helm_of_the_dominator", "item_satanic"}, itemnum = {2, 1}},
				isconsumable = true,
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_abyssal_underlord"},
			{spell = "vgmar_i_deathskiss",
				items = {itemnames = {"item_relic"}, itemnum = {2}},
				isconsumable = true,
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_phantom_assassin"},
			{spell = "vgmar_i_essence_aura",
				items = {itemnames = {"item_octarine_core"}, itemnum = {2}},
				isconsumable = true,
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_obsidian_destroyer"},
			{spell = "vgmar_i_rainfall",
				items = {itemnames = {"item_infused_raindrop"}, itemnum = {6}},
				isconsumable = true,
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_crystal_maiden"},
			{spell = "vgmar_i_spellshield",
				items = {itemnames = {"item_lotus_orb", "item_cloak"}, itemnum = {1, 2}},
				isconsumable = true,
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_antimage"},
			{spell = "vgmar_i_vampiric_aura",
				items = {itemnames = {"item_vladmir"}, itemnum = {2}},
				isconsumable = true,
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_skeleton_king"}
			}
			--TableEND
			
				for k=1,#itemlistforspell do
					if heroent:GetClassname() ~= itemlistforspell[k].preventedhero then
						if itemlistforspell[k].isconsumable == true then
							if self:HeroHasAllItemsFromListWMultiple( heroent, itemlistforspell[k].items, itemlistforspell[k].backpack) and not heroent:FindAbilityByName(itemlistforspell[k].spell) then
								local itemability = heroent:FindAbilityByName(itemlistforspell[k].spell)
								if itemability == nil then
									for j=1,#itemlistforspell[k].items.itemnames do
										self:RemoveNItemsInInventory( heroent, itemlistforspell[k].items.itemnames[j], itemlistforspell[k].items.itemnum[j])
									end
									local addedability = heroent:AddAbility(itemlistforspell[k].spell)
									addedability:SetLevel(1)
								end
							end
						else
							if self:HeroHasAllItemsFromListWMultiple( heroent, itemlistforspell[k].items, itemlistforspell[k].backpack) then
								local itemability = heroent:FindAbilityByName(itemlistforspell[k].spell)
								if itemability == nil then
									local addedability = heroent:AddAbility(itemlistforspell[k].spell)
									if addedability then
										addedability:SetLevel(1)
									end
								end
							else
								local itemability = heroent:FindAbilityByName(itemlistforspell[k].spell)
								if itemability ~= nil then
									heroent:RemoveAbility(itemlistforspell[k].spell)
								end
							end
						end
					end
				end
				if heroent:FindAbilityByName("aegis_king_reincarnation") ~= nil and heroent:IsAlive() then
					local reincarnationability = heroent:FindAbilityByName("aegis_king_reincarnation")
					local reincarnationcooldown = reincarnationability:GetCooldownTime()
					if reincarnationcooldown ~= 0 then
						if not heroent:HasModifier("modifier_skeleton_king_mortal_strike_drain_buff") then
							heroent:AddNewModifier(heroent, heroent, "modifier_skeleton_king_mortal_strike_drain_buff", {hp_drain = 0, drain_duration = 99999})
						end
						if heroent:HasModifier("modifier_skeleton_king_mortal_strike_drain_debuff") then
							heroent:RemoveModifierByName("modifier_skeleton_king_mortal_strike_drain_debuff")
						end
						heroent:SetModifierStackCount("modifier_skeleton_king_mortal_strike_drain_buff", heroent, reincarnationcooldown)
					else
						if not heroent:HasModifier("modifier_skeleton_king_mortal_strike_drain_debuff") then
							heroent:AddNewModifier(heroent, heroent, "modifier_skeleton_king_mortal_strike_drain_debuff", {hp_drain = 0, drain_duration = 99999})
						end
						if heroent:HasModifier("modifier_skeleton_king_mortal_strike_drain_buff") then
							heroent:RemoveModifierByName("modifier_skeleton_king_mortal_strike_drain_buff")
						end
					end
				end
				--/////////////////////////
				--ActiveSpellShieldCooldown
				--/////////////////////////
				if heroent:FindAbilityByName("vgmar_i_spellshield") ~= nil and heroent:IsAlive() then
					local spellshieldability = heroent:FindAbilityByName("vgmar_i_spellshield")
					local spellshieldcooldown = spellshieldability:GetCooldownTime()
					if not heroent:HasModifier("modifier_vgmar_i_spellshield_cooldown") then
						if heroent:FindAbilityByName("vgmar_i_spellshield_cooldown") ~= nil then
							local spellshieldcooldownability = heroent:FindAbilityByName("vgmar_i_spellshield_cooldown")
							spellshieldcooldownability:ApplyDataDrivenModifier(heroent, heroent, "modifier_vgmar_i_spellshield_cooldown", {})
						else
							local spellshieldcooldownability = heroent:AddAbility("vgmar_i_spellshield_cooldown")
							spellshieldcooldownability:ApplyDataDrivenModifier(heroent, heroent, "modifier_vgmar_i_spellshield_cooldown", {})
						end
					end
					if heroent:HasScepter() then
						heroent:SetModifierStackCount("modifier_vgmar_i_spellshield_cooldown", heroent, spellshieldcooldown)
					else
						heroent:SetModifierStackCount("modifier_vgmar_i_spellshield_cooldown", heroent, 0)
					end
				end
				--////////////////
				--DeathsKissVisual
				--////////////////
				if heroent:FindAbilityByName("vgmar_i_deathskiss") ~= nil and heroent:IsAlive() then
					if not heroent:HasModifier("modifier_vgmar_i_deathskiss_visual") then
						if heroent:FindAbilityByName("vgmar_i_deathskiss_visual") ~= nil then
							local spellshieldcooldownability = heroent:FindAbilityByName("vgmar_i_deathskiss_visual")
							spellshieldcooldownability:ApplyDataDrivenModifier(heroent, heroent, "modifier_vgmar_i_deathskiss_visual", {})
						else
							local spellshieldcooldownability = heroent:AddAbility("vgmar_i_deathskiss_visual")
							spellshieldcooldownability:ApplyDataDrivenModifier(heroent, heroent, "modifier_vgmar_i_deathskiss_visual", {})
						end
					end
				end
				--AegisKingAntiOctarine
				--/////////////////////
				if heroent:FindAbilityByName("aegis_king_reincarnation") ~= nil then
					local reincarnationability = heroent:FindAbilityByName("aegis_king_reincarnation")
					if self:HeroHasUsableItemInInventory(heroent, "item_octarine_core", false, false, false) and reincarnationability:GetLevel() == 1 then
						reincarnationability:SetLevel(2)
					elseif reincarnationability:GetLevel() == 2 and not self:HeroHasUsableItemInInventory(heroent, "item_octarine_core", false, false, false) then
						reincarnationability:SetLevel(1)
					end
				end
				
				--///////////////////
				--CourierBurstUpgrade
				--///////////////////
				if self:HeroHasUsableItemInInventory(heroent, "item_flying_courier", false, true, true) then
					local couriers = Entities:FindAllByClassname("npc_dota_courier")
					for i=1,#couriers do
						if couriers[i]:GetTeamNumber() == heroent:GetTeamNumber() then
							local courierburstability = couriers[i]:FindAbilityByName("courier_burst")
							if courierburstability and courierburstability:GetLevel() >= 1 then
								if couriers[i]:GetTeamNumber() == 2 and self.radiantcourieruplevel < 4 then
									self:RemoveNItemsInInventory(heroent, "item_flying_courier", 1)
									courierburstability:SetLevel(self.radiantcourieruplevel + 1)
									self.radiantcourieruplevel = courierburstability:GetLevel()
								elseif couriers[i]:GetTeamNumber() == 3 and self.direcourieruplevel < 4 then
									self:RemoveNItemsInInventory(heroent, "item_flying_courier", 1)
									courierburstability:SetLevel(self.direcourieruplevel + 1)
									self.direcourieruplevel = courierburstability:GetLevel()
								end
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
	end
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
		--///////////////////
		--CustomItemsReminder
		--///////////////////
		local customitemreminderlist = {
			[-90] = "<font color='honeydew'>Remember, this gamemode has multiple scripted item abilities</font>",
			[-85] = "<font color='honeydew'>List of custom abilities:</font>",
			[-80] = "<font color='red'>[C]</font>-<font color='orange'>items</font> consumed for <font color='gold'>effect</font>",
			[-77] = "<font color='orange'>Hand of Midas</font> => <font color='gold'>Goblins Greed</font> (works from backpack after 30min or if hero is lvl25)",
			[-73] = "<font color='orange'>Silver Edge</font> => <font color='gold'>Essense Shift</font>",
			[-67] = "<font color='orange'>Gem*2 + Phase Boots</font> => <font color='gold'>Thirst</font> <font color='red'>[C]</font>",
			[-63] = "<font color='orange'>Urn*2</font> => <font color='gold'>DeathPulse Regen</font> <font color='red'>[C]</font>",
			[-57] = "<font color='orange'>Mask of Madness + Gloves*2</font> => <font color='gold'>Fervor</font> <font color='red'>[C]</font>",
			[-53] = "<font color='orange'>StoutShield+PMS+Vanguard+Buckler+Aegis</font> => <font color='gold'>Kings Aegis</font> <font color='red'>[C]</font>",
			[-50] = "<font color='orange'>Dominator*2 + Satanic</font> => <font color='gold'>Atrophy Aura</font> <font color='red'>[C]</font>",
			[-47] = "<font color='orange'>Sacred Relic*2</font> => <font color='gold'>Deaths Kiss</font> <font color='red'>[C]</font>",
			[-45] = "<font color='orange'>Octarine Core*2</font> => <font color='gold'>Essence Aura</font> <font color='red'>[C]</font>",
			[-43] = "<font color='orange'>Infused Raindrop*6</font> => <font color='gold'>Enchanted Rainfall</font> <font color='red'>[C]</font>",
			[-40] = "<font color='orange'>Lotus Orb+Cloak*2</font> => <font color='gold'>Spell Shield</font> <font color='red'>[C]</font>",
			[-37] = "<font color='orange'>Vladmir*2</font> => <font color='gold'>Vampiric Aura</font> <font color='red'>[C]</font>",
			[-30] = "<font color='gold'>Bloodstone</font> <font color='honeydew'>can be recharged with</font> <font color='orange'>3*bloodstone recipes</font>",
			[-25] = "<font color='gold'>Diffusal Blade</font> <font color='honeydew'>can be recharged with a</font> <font color='orange'>recipe</font>",
			[-20] = "<font color='gold'>Aghanims infusion</font> <font color='honeydew'>is available with</font> <font color='orange'>2*Aghanims scepters</font>",
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
		
		--///////////////////////////
		--RealTime Hero Modifications
		--///////////////////////////
		
		--Building a list of heroes
		local herolistnightstalker = Entities:FindAllByClassname( "npc_dota_hero_night_stalker" )
		local herolistluna = Entities:FindAllByClassname( "npc_dota_hero_luna" )
		local herolistwinterwyvern = Entities:FindAllByClassname( "npc_dota_hero_winter_wyvern" )
		local herolistdrow = Entities:FindAllByClassname( "npc_dota_hero_drow_ranger" )
		local herolistriki = Entities:FindAllByClassname( "npc_dota_hero_riki" )
		local herolistam = Entities:FindAllByClassname( "npc_dota_hero_antimage" )
		local herolistrazor = Entities:FindAllByClassname( "npc_dota_hero_razor" )
		local herolistphantomlancer = Entities:FindAllByClassname( "npc_dota_hero_phantom_lancer" )
		local herolistviper = Entities:FindAllByClassname( "npc_dota_hero_viper" )
		
		--Checking conditions for automatic Ability leveling
		--Nightstalker
		for i, hero in ipairs(herolistnightstalker) do
			local nsvoid = hero:FindAbilityByName( "night_stalker_void" )
			local nshunterinthenight = hero:FindAbilityByName( "night_stalker_hunter_in_the_night" )
			local nsdarkeness = hero:FindAbilityByName( "night_stalker_darkness" )
			if (hero:GetLevel() >= 20 or hero:HasScepter()) and nshunterinthenight:GetLevel()==4 then
				nshunterinthenight:SetLevel( 5 )
			elseif nshunterinthenight:GetLevel()==5 and (hero:GetLevel() < 20 and not hero:HasScepter()) then
				nshunterinthenight:SetLevel( 4 )
			elseif nshunterinthenight:GetLevel() == 5 and hero:GetLevel() >= 20 and hero:HasScepter() then
				nshunterinthenight:SetLevel( 6 )
			elseif nshunterinthenight:GetLevel() == 6 and (hero:GetLevel() < 20 or not hero:HasScepter()) then
				nshunterinthenight:SetLevel( 5 )
			end
			if nsdarkeness:GetLevel() == 3 and hero:HasScepter() then
				nsdarkeness:SetLevel( 4 )
			elseif nsdarkeness:GetLevel() == 4 and not hero:HasScepter() then
				nsdarkeness:SetLevel( 3 )
			end
			if nsvoid and nsvoid:GetLevel() == 4 and GameRules:IsNightstalkerNight() then
				nsvoid:SetLevel( 5 )
			elseif nsvoid and nsvoid:GetLevel() == 5 and not GameRules:IsNightstalkerNight() then
				nsvoid:SetLevel( 4 )
			end
		end
		
		--Luna
		for i, hero in ipairs(herolistluna) do
			local lunaglaive = hero:FindAbilityByName( "luna_moon_glaive" )
			local lunabeam = hero:FindAbilityByName( "luna_lucent_beam" )
			local lunablessing = hero:FindAbilityByName( "luna_lunar_blessing" )
			local lunault = hero:FindAbilityByName( "luna_eclipse" )
			if hero:GetLevel() >= 15 and lunablessing:GetLevel() == 4 then
				lunablessing:SetLevel( 5 )
			end
			if hero:GetLevel() >= 20 and lunaglaive:GetLevel() == 4 then
				lunaglaive:SetLevel( 5 )
			end
			if lunabeam:GetLevel() == 4 and lunault:GetLevel() >= 3 then
				lunabeam:SetLevel( 5 )
			end
			if lunault:GetLevel() == 3 and (hero:HasScepter() or hero:GetLevel() == 25) then
				lunault:SetLevel( 4 )
			elseif lunault:GetLevel() == 4 and hero:GetLevel() < 25 and not hero:HasScepter() then
				lunault:SetLevel( 3 )
			elseif lunault:GetLevel() >= 4 and hero:HasScepter() and hero:GetLevel() == 25 then
				lunault:SetLevel( 5 )
			elseif lunault:GetLevel() == 5 and hero:GetLevel() == 25 and not hero:HasScepter() then
				lunault:SetLevel( 4 )
			end
		end
		
		--WinterWyvern
		for i, hero in ipairs(herolistwinterwyvern) do
			local wwarcticburn = hero:FindAbilityByName( "winter_wyvern_arctic_burn" )
			local wwsplinterblast = hero:FindAbilityByName( "winter_wyvern_splinter_blast" )
			local wwcoldembrace = hero:FindAbilityByName( "winter_wyvern_cold_embrace" )
			local wwwinterscurse = hero:FindAbilityByName( "winter_wyvern_winters_curse" )
			if hero:GetLevel() >= 15 and wwcoldembrace:GetLevel() == 4 then
				wwcoldembrace:SetLevel( 5 )
			end
			if hero:GetLevel() >= 20 and wwarcticburn:GetLevel() == 4 then
				wwarcticburn:SetLevel( 5 )
			end
			if hero:GetLevel() >= 22 and wwsplinterblast:GetLevel() == 4 then
				wwsplinterblast:SetLevel( 5 )
			end
			if hero:GetLevel() == 25 and wwwinterscurse:GetLevel() == 3 then
				wwwinterscurse:SetLevel( 4 )
			end
		end
		
		--DrowRanger
		for i, hero in ipairs(herolistdrow) do
			local drowsilence = hero:FindAbilityByName( "drow_ranger_wave_of_silence" )
			local drowaura = hero:FindAbilityByName( "drow_ranger_trueshot" )
			local drowult = hero:FindAbilityByName( "drow_ranger_marksmanship" )
			if hero:GetLevel() >= 15 and drowsilence:GetLevel() == 4 then
				drowsilence:SetLevel( 5 )
			end
			if hero:GetLevel() >= 20 and drowaura:GetLevel() == 4 then
				drowaura:SetLevel( 5 )
			end
			if drowult:GetLevel() >= 3 then
				if hero:GetLevel() >= 20 and drowult:GetLevel() == 3 then
					drowult:SetLevel( 4 )
				elseif hero:GetLevel() >= 22 and drowult:GetLevel() == 4 then
					drowult:SetLevel( 5 )
				elseif hero:GetLevel() >= 24 and drowult:GetLevel() == 5 then
					drowult:SetLevel( 6 )
				elseif hero:GetLevel() == 25 and drowult:GetLevel() == 6 then
					drowult:SetLevel( 7 )
				end
			end
		end
		
		--Riki
		for i, hero in ipairs(herolistriki) do
			local rikismoke = hero:FindAbilityByName( "riki_smoke_screen" )
			local rikiblink = hero:FindAbilityByName( "riki_blink_strike" )
			local rikiinvis = hero:FindAbilityByName( "riki_permanent_invisibility" )
			local rikiult = hero:FindAbilityByName( "riki_tricks_of_the_trade" )
			if rikiinvis:GetLevel() == 4 and (hero:GetLevel() >= 15 or hero:HasScepter()) then
				rikiinvis:SetLevel( 5 )
			elseif rikiinvis:GetLevel() == 5 and hero:GetLevel() < 15 and not hero:HasScepter() then
				rikiinvis:SetLevel( 4 )
			elseif rikiinvis:GetLevel() == 5 and hero:HasScepter() and hero:GetLevel() >= 15 then
				rikiinvis:SetLevel( 6 )
			elseif rikiinvis:GetLevel() == 6 and hero:GetLevel() >= 15 and not hero:HasScepter() then
				rikiinvis:SetLevel( 5 )
			end
			if hero:GetLevel() >= 20 and rikiblink:GetLevel() == 4 then
				rikiblink:SetLevel( 5 )
			end
			if hero:GetLevel() >= 22 and rikismoke:GetLevel() >= 4 then
				rikismoke:SetLevel( 5 )
			end
			if rikiult:GetLevel() == 3 and (hero:HasScepter() or hero:GetLevel() == 25) then
				rikiult:SetLevel( 4 )
			elseif rikiult:GetLevel() == 4 and hero:GetLevel() < 25 and not hero:HasScepter() then
				rikiult:SetLevel( 3 )
			elseif rikiult:GetLevel() >= 4 and hero:HasScepter() and hero:GetLevel() == 25 then
				rikiult:SetLevel( 5 )
			elseif rikiult:GetLevel() == 5 and hero:GetLevel() == 25 and not hero:HasScepter() then
				rikiult:SetLevel( 4 )
			end
		end
		
		--Antimage
		for i, hero in ipairs(herolistam) do
			local antimagemanaburn = hero:FindAbilityByName( "antimage_mana_break" )
			local antimageshield = hero:FindAbilityByName( "antimage_spell_shield" )
			local antimagevoid = hero:FindAbilityByName( "antimage_mana_void" )
			if antimagemanaburn:GetLevel() == 4 and (hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false )) then
				antimagemanaburn:SetLevel( 5 )
			elseif antimagemanaburn:GetLevel() == 5 and not (hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false )) then
				antimagemanaburn:SetLevel( 4 )
			end
			if antimageshield:GetLevel() == 4 and (hero:GetLevel() >= 15 or hero:HasScepter()) then
				antimageshield:SetLevel( 5 )
			elseif antimageshield:GetLevel() == 5 and hero:GetLevel() < 15 and not hero:HasScepter() then
				antimageshield:SetLevel( 4 )
			elseif antimageshield:GetLevel() == 5 and hero:HasScepter() and hero:GetLevel() >= 15 then
				antimageshield:SetLevel( 6 )
			elseif antimageshield:GetLevel() == 6 and hero:GetLevel() >= 15 and not hero:HasScepter() then
				antimageshield:SetLevel( 5 )
			elseif antimageshield:GetLevel() == 6 and hero:HasScepter() and hero:GetLevel() >= 20 and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false ) then
				antimageshield:SetLevel( 7 )
			elseif antimageshield:GetLevel() == 7 and hero:GetLevel() >= 15 and (not hero:HasScepter() or not self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false )) then
				antimageshield:SetLevel( 6 )
			end
			if antimagevoid:GetLevel() == 3 and (hero:HasScepter() or hero:GetLevel() == 25) then
				antimagevoid:SetLevel( 4 )
			elseif antimagevoid:GetLevel() == 4 and hero:GetLevel() < 25 and not hero:HasScepter() then
				antimagevoid:SetLevel( 3 )
			elseif antimagevoid:GetLevel() == 4 and hero:HasScepter() and hero:GetLevel() == 25 then
				antimagevoid:SetLevel( 5 )
			elseif antimagevoid:GetLevel() == 5 and hero:GetLevel() == 25 and not hero:HasScepter() then
				antimagevoid:SetLevel( 4 )
			elseif antimagevoid:GetLevel() == 5 and hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false ) then
				antimagevoid:SetLevel( 6 )
			elseif antimagevoid:GetLevel() == 6 and (not hero:HasScepter() or not self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false ))  then
				antimagevoid:SetLevel( 5 )
			end
		end
		
		--Razor
		for i, hero in ipairs(herolistrazor) do
			local razorplasmafield = hero:FindAbilityByName( "razor_plasma_field" )
			local razorstaticlink = hero:FindAbilityByName( "razor_static_link" )
			local razorunstablecurrent = hero:FindAbilityByName( "razor_unstable_current" )
			local razorult = hero:FindAbilityByName( "razor_eye_of_the_storm" )
			if razorplasmafield:GetLevel() == 4 and (hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false )) then
				razorplasmafield:SetLevel( 5 )
			elseif razorplasmafield:GetLevel() == 5 and not (hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false )) then
				razorplasmafield:SetLevel( 4 )
			elseif razorplasmafield:GetLevel() == 5 and hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false ) and self:HeroHasUsableItemInInventory( hero, "item_aether_lens", false, false, false ) then
				razorplasmafield:SetLevel( 6 )
			elseif razorplasmafield:GetLevel() == 6 and (not hero:HasScepter() or not self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false ) or not self:HeroHasUsableItemInInventory( hero, "item_aether_lens", false, false, false )) then
				razorplasmafield:SetLevel( 5 )
			end
			if razorstaticlink:GetLevel() == 4 and (hero:GetLevel() >= 20 and hero:HasScepter()) then
				razorstaticlink:SetLevel( 5 )
			elseif razorstaticlink:GetLevel() == 5 and (hero:GetLevel() < 20 or not hero:HasScepter()) then
				razorstaticlink:SetLevel( 4 )
			end
			if razorunstablecurrent:GetLevel() == 4 and hero:HasScepter() and hero:GetLevel() >= 15 then
				razorunstablecurrent:SetLevel( 5 )
			elseif razorunstablecurrent:GetLevel() == 5 and (hero:GetLevel() < 15 or not hero:HasScepter()) then
				razorunstablecurrent:SetLevel( 4 )
			elseif razorunstablecurrent:GetLevel() == 5 and hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false ) then
				razorunstablecurrent:SetLevel( 6 )
			elseif razorunstablecurrent:GetLevel() == 6 and (not hero:HasScepter() or not self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false ))  then
				razorunstablecurrent:SetLevel( 5 )
			end
			if razorult:GetLevel() == 3 and hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_refresher", false, false, false ) then
				razorult:SetLevel( 4 )
			elseif razorult:GetLevel() == 4 and (not hero:HasScepter() or not self:HeroHasUsableItemInInventory( hero, "item_refresher", false, false, false )) then
				razorult:SetLevel( 3 )
			elseif razorult:GetLevel() == 4 and hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_refresher", false, false, false ) and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false ) then
				razorult:SetLevel( 5 )
			elseif razorult:GetLevel() == 5 and (not hero:HasScepter() or not self:HeroHasUsableItemInInventory( hero, "item_refresher", false, false, false ) or not self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false )) then
				razorult:SetLevel( 4 )
			end
		end
		
		--Phantom Lancer
		for i, hero in ipairs(herolistphantomlancer) do
			local plspiritlance = hero:FindAbilityByName( "phantom_lancer_spirit_lance" )
			local pldoppelwalk = hero:FindAbilityByName( "phantom_lancer_doppelwalk" )
			local plphantomedge = hero:FindAbilityByName( "phantom_lancer_phantom_edge" )
			local pljuxtapose = hero:FindAbilityByName( "phantom_lancer_juxtapose" )
			if plspiritlance:GetLevel() == 4 and (hero:GetLevel() >= 15 or hero:HasScepter()) then
				plspiritlance:SetLevel( 5 )
			elseif plspiritlance:GetLevel() == 5 and hero:GetLevel() < 15 and not hero:HasScepter() then
				plspiritlance:SetLevel( 4 )
			elseif plspiritlance:GetLevel() == 5 and hero:HasScepter() and hero:GetLevel() >= 18 then
				plspiritlance:SetLevel( 6 )
			elseif plspiritlance:GetLevel() == 6 and (hero:GetLevel() < 18 or not hero:HasScepter()) then
				plspiritlance:SetLevel( 5 )
			elseif plspiritlance:GetLevel() == 6 and hero:HasScepter() and hero:GetLevel() >= 20 and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false ) and self:HeroHasUsableItemInInventory( hero, "item_aether_lens", false, false, false ) then
				plspiritlance:SetLevel( 7 )
			elseif plspiritlance:GetLevel() == 7 and not (hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false ) and self:HeroHasUsableItemInInventory( hero, "item_aether_lens", false, false, false )) then
				plspiritlance:SetLevel( 6 )
			end
			if pljuxtapose:GetLevel() == 3 and hero:GetLevel() >= 22 and (hero:HasScepter() or self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false )) then
				pljuxtapose:SetLevel( 4 )
			elseif pljuxtapose:GetLevel() == 4 and not (hero:HasScepter() or self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false )) then
				pljuxtapose:SetLevel( 3 )
			elseif pljuxtapose:GetLevel() == 4 and hero:GetLevel() == 25 and (hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false )) then
				pljuxtapose:SetLevel( 5 )
			elseif pljuxtapose:GetLevel() == 5 and not (hero:HasScepter() and hero:GetLevel() == 25 and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false )) then
				pljuxtapose:SetLevel( 4 )
			elseif pljuxtapose:GetLevel() == 5 and hero:HasScepter() and hero:GetLevel() == 25 and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false ) and self:CountUsableItemsInHeroInventory( hero, "item_heart", false, false, false) >= 2 then
				pljuxtapose:SetLevel( 6 )
			elseif pljuxtapose:GetLevel() == 6 and not (hero:HasScepter() and hero:GetLevel() == 25 and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false ) and (self:CountUsableItemsInHeroInventory( hero, "item_heart", true, false, false) >= 2)) then
				pljuxtapose:SetLevel( 5 )
			end
			if pldoppelwalk:GetLevel() == 4 and hero:GetLevel() >= 15 then
				pldoppelwalk:SetLevel( 5 )
			elseif pldoppelwalk:GetLevel() == 5 and (hero:GetLevel() >= 20 or self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false )) then
				pldoppelwalk:SetLevel( 6 )
			elseif pldoppelwalk:GetLevel() == 6 and (hero:GetLevel() < 20 and not self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false, false )) then
				pldoppelwalk:SetLevel( 5 )
			end
			if plphantomedge:GetLevel() == 4 and hero:GetLevel() >= 20 then
				plphantomedge:SetLevel( 5 )
			elseif plphantomedge:GetLevel() == 5 and hero:GetLevel() >= 20 and self:HeroHasUsableItemInInventory( hero, "item_aether_lens", false, false, false ) then
				plphantomedge:SetLevel( 6 )
			elseif plphantomedge:GetLevel() == 6 and hero:GetLevel() >= 20 and not self:HeroHasUsableItemInInventory( hero, "item_aether_lens", false, false, false ) then
				plphantomedge:SetLevel( 5 )
			end
		end
		--Viper
		for i, hero in ipairs(herolistviper) do
			local viperspit = hero:FindAbilityByName( "viper_poison_attack" )
			local vipernethertoxin = hero:FindAbilityByName( "viper_nethertoxin" )
			local vipercorrosiveskin = hero:FindAbilityByName( "viper_corrosive_skin" )
			local viperstrike = hero:FindAbilityByName( "viper_viper_strike" )
			if viperspit:GetLevel() == 4 and hero:GetLevel() >= 20 then
				viperspit:SetLevel( 5 )
			elseif viperspit:GetLevel() == 5 and ((hero:GetLevel() >= 20 and self:HeroHasUsableItemInInventory( hero, "item_orb_of_venom", false, true, false)) or hero:GetLevel() == 25) then
				viperspit:SetLevel( 6 )
			elseif viperspit:GetLevel() == 6 and hero:GetLevel() < 25 and not self:HeroHasUsableItemInInventory( hero, "item_orb_of_venom", false, true, false) then
				viperspit:SetLevel( 5 )
			end
			if vipernethertoxin:GetLevel() == 4 and hero:GetLevel() >= 15 and hero:GetLevel() < 22 then
				vipernethertoxin:SetLevel( 5 )
			elseif vipernethertoxin:GetLevel() == 5 and hero:GetLevel() >= 22 then
				vipernethertoxin:SetLevel( 6 )
			end
			if vipercorrosiveskin:GetLevel() == 4 and hero:GetLevel() >= 10 and (self:HeroHasUsableItemInInventory( hero, "item_cloak", false, false, false) or self:HeroHasUsableItemInInventory( hero, "item_hood_of_defiance", false, false, false) or self:HeroHasUsableItemInInventory( hero, "item_pipe", false, false, false)) then
				vipercorrosiveskin:SetLevel( 5 )
			elseif vipercorrosiveskin:GetLevel() == 5 and (hero:GetLevel() < 10 or not (self:HeroHasUsableItemInInventory( hero, "item_cloak", false, false, false) or self:HeroHasUsableItemInInventory( hero, "item_hood_of_defiance", false, false, false) or self:HeroHasUsableItemInInventory( hero, "item_pipe", false, false, false))) then
				vipercorrosiveskin:SetLevel( 4 )
			elseif vipercorrosiveskin:GetLevel() == 5 and hero:GetLevel() >= 15 and (self:HeroHasUsableItemInInventory( hero, "item_hood_of_defiance", false, false, false) or self:HeroHasUsableItemInInventory( hero, "item_pipe", false, false, false)) then
				vipercorrosiveskin:SetLevel( 6 )
			elseif vipercorrosiveskin:GetLevel() == 6 and (hero:GetLevel() < 15 or not (self:HeroHasUsableItemInInventory( hero, "item_hood_of_defiance", false, false, false) or self:HeroHasUsableItemInInventory( hero, "item_pipe", false, false, false))) then
				vipercorrosiveskin:SetLevel( 5 )
			elseif vipercorrosiveskin:GetLevel() >= 4 and hero:GetLevel() == 25 or ( self:IsHeroBotControlled(hero) and hero:GetLevel() >= 8 and self:TimeIsLaterThan( 30, 0 ) ) then
				vipercorrosiveskin:SetLevel( 7 )
			end
			if viperstrike:GetLevel() == 3 and hero:GetLevel() >= 22 then
				viperstrike:SetLevel( 4 )
			elseif viperstrike:GetLevel() == 4 and hero:GetLevel() >= 22 and hero:HasScepter() then
				viperstrike:SetLevel( 5 )
			elseif viperstrike:GetLevel() == 5 and not hero:HasScepter() then
				viperstrike:SetLevel( 4 )
			elseif viperstrike:GetLevel() == 5 and hero:GetLevel() >= 25 and hero:HasScepter() and self:TimeIsLaterThan( 40, 0 ) then
				viperstrike:SetLevel( 6 )
			elseif viperstrike:GetLevel() == 6 and (hero:GetLevel() < 25 or not hero:HasScepter()) then
				viperstrike:SetLevel( 5 )
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
		local destroySpell = spawnedUnit:FindAbilityByName( "broodmother_spin_web_destroy" )
		if destroySpell then
			destroySpell:SetLevel( 1 )
		end
	end
end

function VGMAR:OnPlayerLearnedAbility( keys )
	local player = EntIndexToHScript(keys.player)
	local abilityname = keys.abilityname
	
	local playerhero = player:GetAssignedHero()
	
	--Building ability list for modification
	--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	--Probably a better solution would be to build those according to existing heroes
	--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	local zeuscloud = playerhero:FindAbilityByName( "zuus_cloud" )
	local nshunterinthenight = playerhero:FindAbilityByName( "night_stalker_hunter_in_the_night" )
	local nsdarkeness = playerhero:FindAbilityByName( "night_stalker_darkness" )
	local nsvoid = playerhero:FindAbilityByName( "night_stalker_void" )
	local lunaglaive = playerhero:FindAbilityByName( "luna_moon_glaive" )
	local lunabeam = playerhero:FindAbilityByName( "luna_lucent_beam" )
	local lunablessing = playerhero:FindAbilityByName( "luna_lunar_blessing" )
	local lunault = playerhero:FindAbilityByName( "luna_eclipse" )
	local wwarcticburn = playerhero:FindAbilityByName( "winter_wyvern_arctic_burn" )
	local wwsplinterblast = playerhero:FindAbilityByName( "winter_wyvern_splinter_blast" )
	local wwcoldembrace = playerhero:FindAbilityByName( "winter_wyvern_cold_embrace" )
	local wwwinterscurse = playerhero:FindAbilityByName( "winter_wyvern_winters_curse" )
	local drowsilence = playerhero:FindAbilityByName( "drow_ranger_wave_of_silence" )
	local drowaura = playerhero:FindAbilityByName( "drow_ranger_trueshot" )
	local drowult = playerhero:FindAbilityByName( "drow_ranger_marksmanship" )
	local rikismoke = playerhero:FindAbilityByName( "riki_smoke_screen" )
	local rikiblink = playerhero:FindAbilityByName( "riki_blink_strike" )
	local rikiinvis = playerhero:FindAbilityByName( "riki_permanent_invisibility" )
	local rikiult = playerhero:FindAbilityByName( "riki_tricks_of_the_trade" )
	local antimagemanaburn = playerhero:FindAbilityByName( "antimage_mana_break" )
	local antimageshield = playerhero:FindAbilityByName( "antimage_spell_shield" )
	local antimagevoid = playerhero:FindAbilityByName( "antimage_mana_void" )
	local razorplasmafield = playerhero:FindAbilityByName( "razor_plasma_field" )
	local razorstaticlink = playerhero:FindAbilityByName( "razor_static_link" )
	local razorunstablecurrent = playerhero:FindAbilityByName( "razor_unstable_current" )
	local razorult = playerhero:FindAbilityByName( "razor_eye_of_the_storm" )
	local plspiritlance = playerhero:FindAbilityByName( "phantom_lancer_spirit_lance" )
	local pldoppelwalk = playerhero:FindAbilityByName( "phantom_lancer_doppelwalk" )
	local plphantomedge = playerhero:FindAbilityByName( "phantom_lancer_phantom_edge" )
	local plult = playerhero:FindAbilityByName( "phantom_lancer_juxtapose" )
	local viperspit = playerhero:FindAbilityByName( "viper_poison_attack" )
	local vipernethertoxin = playerhero:FindAbilityByName( "viper_nethertoxin" )
	local vipercorrosiveskin = playerhero:FindAbilityByName( "viper_corrosive_skin" )
	local viperstrike = playerhero:FindAbilityByName( "viper_viper_strike" )
	if zeuscloud then
		local zeusult = playerhero:FindAbilityByName( "zuus_thundergods_wrath" )
		if zeusult and not (playerhero:GetLevel() == 25) then
			if zeusult:GetLevel() == 0 then
				zeuscloud:SetLevel( 1 )
			else
				zeuscloud:SetLevel( zeusult:GetLevel())
			end
		elseif (playerhero:GetLevel()==25) and zeusult:GetLevel()==3 then
			zeuscloud:SetLevel( 4 )
		else
			zeuscloud:SetLevel( 1 )
		end
	end
	--///////////////////////////////////
	--Preventing manual ability upgrading
	--///////////////////////////////////

	--Nightstalker
	if abilityname == "night_stalker_hunter_in_the_night" then
		if nshunterinthenight:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			nshunterinthenight:SetLevel( nshunterinthenight:GetLevel() - 1 )
		end
	elseif abilityname == "night_stalker_darkness" then
		if nsdarkeness:GetLevel() == 4 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			nsdarkeness:SetLevel( nsdarkeness:GetLevel() - 1)
		end
	elseif abilityname == "night_stalker_void" then
		if nsvoid:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			nsvoid:SetLevel( nsvoid:GetLevel() - 1)
		end
	end
	--Luna
	if abilityname == "luna_moon_glaive" then
		if lunaglaive:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			lunaglaive:SetLevel( lunaglaive:GetLevel() - 1 )
		end
	elseif abilityname == "luna_lucent_beam" then
		if lunabeam:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			lunabeam:SetLevel( lunabeam:GetLevel() - 1 )
		end
	elseif abilityname == "luna_lunar_blessing" then
		if lunablessing:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			lunablessing:SetLevel( lunablessing:GetLevel() - 1 )
		end
	elseif abilityname == "luna_eclipse" then
		if lunault:GetLevel() >= 4 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			lunault:SetLevel( lunault:GetLevel() - 1)
		end
	end
	--WinterWyvern
	if abilityname == "winter_wyvern_arctic_burn" then
		if wwarcticburn:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			wwarcticburn:SetLevel( wwarcticburn:GetLevel() - 1 )
		end
	elseif abilityname == "winter_wyvern_splinter_blast" then
		if wwsplinterblast:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			wwsplinterblast:SetLevel( wwsplinterblast:GetLevel() - 1 )
		end
	elseif abilityname == "winter_wyvern_cold_embrace" then
		if wwcoldembrace:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			wwcoldembrace:SetLevel( wwcoldembrace:GetLevel() - 1 )
		end
	elseif abilityname == "winter_wyvern_winters_curse" then
		if wwwinterscurse:GetLevel() == 4 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			wwwinterscurse:SetLevel( wwwinterscurse:GetLevel() - 1)
		end
	end
	--DrowRanger
	if abilityname == "drow_ranger_wave_of_silence" then
		if drowsilence:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			drowsilence:SetLevel( drowsilence:GetLevel() - 1 )
		end
	elseif abilityname == "drow_ranger_trueshot" then
		if drowaura:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			drowaura:SetLevel( drowaura:GetLevel() - 1 )
		end
	elseif abilityname == "drow_ranger_marksmanship" then
		if drowult:GetLevel() >= 4 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			drowult:SetLevel( drowult:GetLevel() - 1)
		end
	end
	--Riki
	if abilityname == "riki_smoke_screen" then
		if rikismoke:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			rikismoke:SetLevel( rikismoke:GetLevel() - 1 )
		end
	elseif abilityname == "riki_blink_strike" then
		if rikiblink:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			rikiblink:SetLevel( rikiblink:GetLevel() - 1 )
		end
	elseif abilityname == "riki_permanent_invisibility" then
		if rikiinvis:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			rikiinvis:SetLevel( rikiinvis:GetLevel() - 1 )
		end
	elseif abilityname == "riki_tricks_of_the_trade" then
		if rikiult:GetLevel() >= 4 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			rikiult:SetLevel( rikiult:GetLevel() - 1)
		end
	end
	--Antimage
	if abilityname == "antimage_mana_break" then
		if antimagemanaburn:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			antimagemanaburn:SetLevel( antimagemanaburn:GetLevel() - 1 )
		end
	elseif abilityname == "antimage_spell_shield" then
		if antimageshield:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			antimageshield:SetLevel( antimageshield:GetLevel() - 1 )
		end
	elseif abilityname == "antimage_mana_void" then
		if antimagevoid:GetLevel() >= 4 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			antimagevoid:SetLevel( antimagevoid:GetLevel() - 1)
		end
	end
	--Razor
	if abilityname == "razor_plasma_field" then
		if razorplasmafield:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			razorplasmafield:SetLevel( razorplasmafield:GetLevel() - 1 )
		end
	elseif abilityname == "razor_static_link" then
		if razorstaticlink:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			razorstaticlink:SetLevel( razorstaticlink:GetLevel() - 1 )
		end
	elseif abilityname == "razor_unstable_current" then
		if razorunstablecurrent:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			razorunstablecurrent:SetLevel( razorunstablecurrent:GetLevel() - 1 )
		end
	elseif abilityname == "razor_eye_of_the_storm" then
		if razorult:GetLevel() >= 4 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			razorult:SetLevel( razorult:GetLevel() - 1)
		end
	end
	--PhantomLancer
	if abilityname == "phantom_lancer_spirit_lance" then
		if plspiritlance:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			plspiritlance:SetLevel( plspiritlance:GetLevel() - 1 )
		end
	elseif abilityname == "phantom_lancer_doppelwalk" then
		if pldoppelwalk:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			pldoppelwalk:SetLevel( pldoppelwalk:GetLevel() - 1 )
		end
	elseif abilityname == "phantom_lancer_phantom_edge" then
		if plphantomedge:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			plphantomedge:SetLevel( plphantomedge:GetLevel() - 1 )
		end
	elseif abilityname == "phantom_lancer_juxtapose" then
		if plult:GetLevel() >= 4 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			plult:SetLevel( plult:GetLevel() - 1)
		end
	end
	--Viper
	if abilityname == "viper_poison_attack" then
		if viperspit:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			viperspit:SetLevel( viperspit:GetLevel() - 1 )
		end
	elseif abilityname == "viper_nethertoxin" then
		if vipernethertoxin:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			vipernethertoxin:SetLevel( vipernethertoxin:GetLevel() - 1 )
		end
	elseif abilityname == "viper_corrosive_skin" then
		if vipercorrosiveskin:GetLevel() >= 5 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			vipercorrosiveskin:SetLevel( vipercorrosiveskin:GetLevel() - 1 )
		end
	elseif abilityname == "viper_viper_strike" then
		if viperstrike:GetLevel() >= 4 then
			playerhero:SetAbilityPoints(playerhero:GetAbilityPoints() + 1)
			viperstrike:SetLevel( viperstrike:GetLevel() - 1 )
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

function VGMAR:FilterDamage( filterTable )
	--local victim_index = filterTable["entindex_victim_const"]
    --local attacker_index = filterTable["entindex_attacker_const"]
	if not filterTable["entindex_victim_const"] or not filterTable["entindex_attacker_const"] then
        return true
    end
	local victim = EntIndexToHScript(filterTable.entindex_victim_const)
	local attacker = EntIndexToHScript(filterTable.entindex_attacker_const)
	local damage = filterTable["damage"]
	
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
	local order_type = filterTable.order_type
    local units = filterTable["units"]
    local issuer = filterTable["issuer_player_id_const"]
	local unit = nil
	if units["0"] ~= nil then
		unit = EntIndexToHScript(units["0"])
	end
    local ability = EntIndexToHScript(filterTable.entindex_ability)
    local target = EntIndexToHScript(filterTable.entindex_target)
	
	--///////////////////////
	--SecondCourierPrevention
	--///////////////////////
	if unit then
		if unit:IsRealHero() then
			if ability and ability:GetName() == "item_courier" then
				if self:GetHerosCourier(unit) ~= nil then
					self:RemoveNItemsInInventory(unit, "item_courier", 1)
					SendOverheadEventMessage( nil, 0, unit, 100, nil )
					unit:ModifyGold(100, false, 6)
					return false
				end
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

                    -- Stuck at shop trying to get stash items, remove stash items. THIS IS A BAND-AID FIX. IMPROVE AT SOME POINT
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
                    end

                else
                   unit.OldPosition = unit:GetAbsOrigin()
                   unit.StuckCounter = 0
                end
            end
		end
	end
	
	--Bot Control Prevention
	if unit then
		local player = PlayerResource:GetPlayer(issuer)
		if unit:IsRealHero() then
			local unitPlayerID = unit:GetPlayerID()
			if PlayerResource:GetConnectionState(unitPlayerID) == 1 and unitPlayerID ~= issuer then
				dprint("Blocking a command to a unit not owned by player UnitPlayerID: ", unitPlayerID, "PlayerID: ", issuer)
				if player then
					dprint("Trying to call panorama to reset players unit selection")
					CustomGameEventManager:Send_ServerToPlayer(player, "selection_reset", {})
				end
				return false
			end
		end
		if unit:GetClassname() == "npc_dota_courier" or unit:GetClassname() == "npc_dota_flying_courier" then
			if unit:GetTeamNumber() ~= PlayerResource:GetTeam(issuer) then
				dprint("Blocking enemy team Courier usage CourierTeamID: ", unit:GetTeamNumber(), "PlayerTeamID: ", PlayerResource:GetTeam(issuer))
				CustomGameEventManager:Send_ServerToPlayer(player, "selection_reset", {})
				return false
			end
		end
	end
	
	--////////////////
	--AutoCourierBurst
	--////////////////
	if unit and unit:GetClassname() == "npc_dota_courier" then
		local burstability = unit:FindAbilityByName("courier_burst")
		if unit:GetTeamNumber() == 2 and ability and ability:GetName() == "courier_take_stash_and_transfer_items" then
			if burstability and burstability:GetCooldownTimeRemaining() == 0 then
				burstability:CastAbility()
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
			SendToServerConsole("dota_bot_populate")
			GameRules:GetGameModeEntity():SetThink(function()
				Convars:SetBool("sv_cheats", true)
				dprint("Timer:Enabling Cheats")
				SendToServerConsole("dota_bot_set_difficulty 3")
				GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
				end, DoUniqueString('setbotdiff'), 3)
			SendToServerConsole("dota_bot_set_difficulty 3")
			Convars:SetBool("sv_cheats", false)
			GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
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
			SendToServerConsole("dota_bot_populate")
			SendToServerConsole("dota_bot_set_difficulty 3")
		end
		Convars:SetBool("dota_bot_disable", false)
		
		dprint("Number of players:", self.n_players_radiant + self.n_players_dire)
		dprint("Radiant:", self.n_players_radiant)
		dprint("Radiant:", self.n_players_dire)
		
	elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
		local gm = GameRules:GetGameModeEntity()
		if IsServer() then
			gm:SetThink(function()
				Convars:SetBool("sv_cheats", true)
				Convars:SetBool("dota_bot_disable", false)
				GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
				GameRules:GetGameModeEntity():SetBotsInLateGame(self.botsInLateGameMode)
				Convars:SetFloat("host_timescale", PreGameSpeed())
			end, DoUniqueString('botsettings'), 10)
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
						dprint("PlayerName: ", heroname)
						GameRules:SendCustomMessageToTeam("<font color='turquoise'>Giving Free Courier to</font> <font color='gold'>"..heroname.."</font>", DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS)
						self.couriergiven = true
					end
					if self.couriergiven == false then
						return 5.0
					end
				end
			end)
		end	
		--///////////////////////////////
		--New Implementation of defskills
		--///////////////////////////////
		local buildingstobufflist = {
			{bn = "dota_goodguys_fort", priority = 4, istower = 0, regnegation = 8.0},
			{bn = "good_rax_melee_bot", priority = 3, istower = 0, regnegation = 8.0},
			{bn = "good_rax_melee_mid", priority = 3, istower = 0, regnegation = 8.0},
			{bn = "good_rax_melee_top", priority = 3, istower = 0, regnegation = 8.0},
			{bn = "good_rax_range_top", priority = 2, istower = 0, regnegation = 8.0},
			{bn = "good_rax_range_mid", priority = 2, istower = 0, regnegation = 8.0},
			{bn = "good_rax_range_bot", priority = 2, istower = 0, regnegation = 8.0},
			{bn = "dota_goodguys_tower4_bot", priority = 1, istower = 1, regnegation = 8.0},
			{bn = "dota_goodguys_tower4_top", priority = 1, istower = 1, regnegation = 8.0},
			{bn = "dota_goodguys_tower3_top", priority = 0, istower = 1, regnegation = 8.0},
			{bn = "dota_goodguys_tower3_mid", priority = 0, istower = 1, regnegation = 8.0},
			{bn = "dota_goodguys_tower3_bot", priority = 0, istower = 1, regnegation = 8.0}
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
