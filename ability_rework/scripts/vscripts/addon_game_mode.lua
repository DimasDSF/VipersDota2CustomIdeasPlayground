local RADIANT_TEAM_MAX_PLAYERS = 1
local DIRE_TEAM_MAX_PLAYERS = 8
local RUNE_SPAWN_TIME = 120

if VGMAR == nil then
	VGMAR = class({})
end

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
	self.lastrunetype = -1
	self.currunenum = 1
	self.removedrunenum = math.random(1,2)

	self.mode = GameRules:GetGameModeEntity()
	GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_GOODGUYS, RADIANT_TEAM_MAX_PLAYERS)
    GameRules:SetCustomGameTeamMaxPlayers(DOTA_TEAM_BADGUYS, DIRE_TEAM_MAX_PLAYERS)
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetShowcaseTime( 0.0 )
	GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
	GameRules:SetRuneMinimapIconScale( 1 )
	GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
	self.mode:SetRuneEnabled( DOTA_RUNE_DOUBLEDAMAGE, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_HASTE, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_ILLUSION, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_INVISIBILITY, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_REGENERATION, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_ARCANE, true )
	self.mode:SetRuneEnabled( DOTA_RUNE_BOUNTY, true )
	self.mode:SetRuneSpawnFilter( Dynamic_Wrap( VGMAR, "FilterRuneSpawn" ), self )
	
	--GameRules:SetCustomGameSetupTimeout( 30 )
	--GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
	--GameRules:EnableCustomGameSetupAutoLaunch( false )
	--GameRules:SetPreGameTime( 30 )
	--GameRules:SetHeroSelectionTime( 30 )
	--GameRules:SetStrategyTime( 30 )
	--GameRules:SetCustomGameEndDelay( 0 )
	--GameRules:SetCustomVictoryMessageDuration( 20 )

	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( VGMAR, "OnNPCSpawned" ), self )
	ListenToGameEvent( "dota_player_learned_ability", Dynamic_Wrap( VGMAR, "OnPlayerLearnedAbility" ), self)
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( VGMAR, 'OnGameStateChanged' ), self )
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( VGMAR, 'OnItemPickedUp' ), self )
	
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, 0.25 )
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

function VGMAR:HeroHasUsableItemInInventory( hero, item, mutedallowed, backpackallowed )
	if not hero:HasItemInInventory(item) then
		return false
	end
	for i = 0, 8, 1 do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			if slotitem:GetName() == item then
				if slotitem:IsMuted() and mutedallowed == true then
					if i <= 5 then
						return true
					elseif i >= 6 and backpackallowed == true then
						return true
					else 
						return false
					end
				elseif not slotitem:IsMuted() then
					if i <= 5 then
						return true
					elseif i >= 6 and backpackallowed == true then
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

function VGMAR:GetItemFromInventoryByName( hero, item, mutedallowed, backpackallowed )
	if not hero:HasItemInInventory(item) then
		return nil
	end
	for i = 0, 8, 1 do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			if slotitem:GetName() == item then
				if slotitem:IsMuted() and mutedallowed == true then
					if i <= 5 then
						return slotitem
					elseif i >= 6 and backpackallowed == true then
						return slotitem
					else 
						return nil
					end
				elseif not slotitem:IsMuted() then
					if i <= 5 then
						return slotitem
					elseif i >= 6 and backpackallowed == true then
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

function VGMAR:CountUsableItemsInHeroInventory( hero, item, mutedallowed, backpackallowed )
	if not hero:HasItemInInventory(item) then
		return 0
	end
	local itemcount = 0
	for i = 0, 8, 1 do
		local slotitem = hero:GetItemInSlot(i);
		if slotitem then
			if slotitem:GetName() == item then
				if slotitem:IsMuted() and mutedallowed == true then
					if i <= 5 then
						itemcount = itemcount + 1
					elseif i >= 6 and backpackallowed == true then
						itemcount = itemcount + 1
					end
				elseif not slotitem:IsMuted() then
					if i <= 5 then
						itemcount = itemcount + 1
					elseif i >= 6 and backpackallowed == true then
						itemcount = itemcount + 1
					end
				end
			end
		end
	end
	return itemcount
end

function VGMAR:RemoveNItemsInInventory( hero, item, num )
	if not hero:HasItemInInventory(item) then
		return
	end
	local removeditemsnum = 0
	for i = 0, 8, 1 do
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
		if self:CountUsableItemsInHeroInventory( hero, itemlist.itemnames[i], false, backpack) < itemlist.itemnum[i] then
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

function VGMAR:OnItemPickedUp(keys)
	local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
	local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local itemname = keys.itemname
	
	--//////////////////////////////
	--Consumable Items System
	--//////////////////////////////
	--Alchemist-less Scepter consumption
	if self:CountUsableItemsInHeroInventory( heroEntity, "item_ultimate_scepter", false, true) >= 2 and not heroEntity:FindModifierByName("modifier_item_ultimate_scepter_consumed") then
		self:RemoveNItemsInInventory(heroEntity, "item_ultimate_scepter", 2)
		heroEntity:AddNewModifier(heroEntity, nil, 'modifier_item_ultimate_scepter_consumed', { bonus_all_stats = 10, bonus_health = 175, bonus_mana = 175 })
	end
	--Diffusal Blade 2+ Upgrade
	if self:HeroHasUsableItemInInventory( heroEntity, "item_recipe_diffusal_blade", false, false) and self:HeroHasUsableItemInInventory( heroEntity, "item_diffusal_blade_2", false, false)  then
		local diffbladeitem = self:GetItemFromInventoryByName( heroEntity, "item_diffusal_blade_2", false, false )
		local diffbladerecipe = self:GetItemFromInventoryByName( heroEntity, "item_recipe_diffusal_blade", false, false )
		if diffbladeitem ~= nil and diffbladeitem:GetCurrentCharges() < diffbladeitem:GetInitialCharges() then
			heroEntity:RemoveItem(diffbladerecipe)
			diffbladeitem:SetCurrentCharges(diffbladeitem:GetInitialCharges())
		end
	end
	--Bloodstone recharge
	if self:HeroHasUsableItemInInventory(heroEntity, "item_bloodstone", false, false) and self:CountUsableItemsInHeroInventory(heroEntity, "item_recipe_bloodstone", false, true) >= 3 then
		self:RemoveNItemsInInventory(heroEntity, "item_recipe_bloodstone", 3)
		local bloodstone = self:GetItemFromInventoryByName( heroEntity, "item_bloodstone" )
		if bloodstone ~= nil then
			bloodstone:SetCurrentCharges(bloodstone:GetCurrentCharges() + 24)
		end
	end
end

function VGMAR:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then		
		for i=0,HeroList:GetHeroCount() do
			local heroent = HeroList:GetHero(i)
			if heroent then
			--///////////////////////////
			--Bot Rune Fix
			--///////////////////////////
				local heroplayerid = heroent:GetPlayerID()
				local closestrune = Entities:FindByClassnameNearest("dota_item_rune", heroent:GetOrigin(), 250.0)
				if closestrune then
					if PlayerResource:GetConnectionState(heroplayerid) == 1 then
						heroent:PickupRune(closestrune)
					end
				end
			--//////////////////////
			--Passive Item Abilities
			--//////////////////////
			--Items For Spells Table
				local itemlistforspell = {
			{spell = "midas_goblins_greed",
				items = {itemnames = {"item_hand_of_midas"}, itemnum = {1}},
				isconsumable = false,
				usesmultiple = false,
				backpack = self:TimeIsLaterThan( 30, 0 ) or heroent:GetLevel() >= 25,
				preventedhero = "npc_dota_hero_alchemist"},
			{spell = "silver_essense_shift",
				items = {itemnames = {"item_silver_edge"}, itemnum = {1}},
				isconsumable = false,
				usesmultiple = false,
				backpack = false,
				preventedhero = "npc_dota_hero_slark"},
			{spell = "gem_thirst",
				items = {itemnames = {"item_gem", "item_phase_boots"}, itemnum = {2, 1}},
				isconsumable = true,
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_bloodseeker"},
			{spell = "urn_pulse",
				items = {itemnames = {"item_urn_of_shadows"}, itemnum = {2}},
				isconsumable = true,
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_necrolyte"},
			{spell = "sabre_fervor",
				items = {itemnames = {"item_echo_sabre"}, itemnum = {2}},
				isconsumable = self:TimeIsLaterThan( 30, 0 ),
				usesmultiple = true,
				backpack = (self:TimeIsLaterThan( 20, 0 ) or heroent:GetLevel() >= 25) and not self:TimeIsLaterThan( 30, 0 ),
				preventedhero = "npc_dota_hero_troll_warlord"},
			{spell = "aegis_king_reincarnation",
				items = {itemnames = {"item_stout_shield", "item_poor_mans_shield", "item_vanguard", "item_aegis"}, itemnum = {1, 1, 1, 1}},
				isconsumable = true,
				usesmultiple = false,
				backpack = true,
				preventedhero = "npc_dota_hero_skeleton_king"},
			{spell = "satanicdominator_atrophy",
				items = {itemnames = {"item_helm_of_the_dominator", "item_satanic"}, itemnum = {2, 1}},
				isconsumable = true,
				usesmultiple = true,
				backpack = true,
				preventedhero = "npc_dota_hero_abyssal_underlord"}
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
									itemability = heroent:AddAbility(itemlistforspell[k].spell)
									itemability:SetLevel(1)
								end
							end
						else
							if self:HeroHasAllItemsFromListWMultiple( heroent, itemlistforspell[k].items, itemlistforspell[k].backpack) then
								local itemability = heroent:FindAbilityByName(itemlistforspell[k].spell)
								if itemability == nil then
									itemability = heroent:AddAbility(itemlistforspell[k].spell)
									itemability:SetLevel(1)
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
			end
		end
	end
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
		
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
			if antimagemanaburn:GetLevel() == 4 and (hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false )) then
				antimagemanaburn:SetLevel( 5 )
			elseif antimagemanaburn:GetLevel() == 5 and not (hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false )) then
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
			elseif antimageshield:GetLevel() == 6 and hero:HasScepter() and hero:GetLevel() >= 20 and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false ) then
				antimageshield:SetLevel( 7 )
			elseif antimageshield:GetLevel() == 7 and hero:GetLevel() >= 15 and (not hero:HasScepter() or not self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false )) then
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
			elseif antimagevoid:GetLevel() == 5 and hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false ) then
				antimagevoid:SetLevel( 6 )
			elseif antimagevoid:GetLevel() == 6 and (not hero:HasScepter() or not self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false ))  then
				antimagevoid:SetLevel( 5 )
			end
		end
		
		--Razor
		for i, hero in ipairs(herolistrazor) do
			local razorplasmafield = hero:FindAbilityByName( "razor_plasma_field" )
			local razorstaticlink = hero:FindAbilityByName( "razor_static_link" )
			local razorunstablecurrent = hero:FindAbilityByName( "razor_unstable_current" )
			local razorult = hero:FindAbilityByName( "razor_eye_of_the_storm" )
			if razorplasmafield:GetLevel() == 4 and (hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false )) then
				razorplasmafield:SetLevel( 5 )
			elseif razorplasmafield:GetLevel() == 5 and not (hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false )) then
				razorplasmafield:SetLevel( 4 )
			elseif razorplasmafield:GetLevel() == 5 and hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false ) and self:HeroHasUsableItemInInventory( hero, "item_aether_lens", false, false ) then
				razorplasmafield:SetLevel( 6 )
			elseif razorplasmafield:GetLevel() == 6 and (not hero:HasScepter() or not self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false ) or not self:HeroHasUsableItemInInventory( hero, "item_aether_lens", false, false )) then
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
			elseif razorunstablecurrent:GetLevel() == 5 and hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false ) then
				razorunstablecurrent:SetLevel( 6 )
			elseif razorunstablecurrent:GetLevel() == 6 and (not hero:HasScepter() or not self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false ))  then
				razorunstablecurrent:SetLevel( 5 )
			end
			if razorult:GetLevel() == 3 and hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_refresher", false, false ) then
				razorult:SetLevel( 4 )
			elseif razorult:GetLevel() == 4 and (not hero:HasScepter() or not self:HeroHasUsableItemInInventory( hero, "item_refresher", false, false )) then
				razorult:SetLevel( 3 )
			elseif razorult:GetLevel() == 4 and hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_refresher", false, false ) and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false ) then
				razorult:SetLevel( 5 )
			elseif razorult:GetLevel() == 5 and (not hero:HasScepter() or not self:HeroHasUsableItemInInventory( hero, "item_refresher", false, false ) or not self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false )) then
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
			elseif plspiritlance:GetLevel() == 6 and hero:HasScepter() and hero:GetLevel() >= 20 and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false ) and self:HeroHasUsableItemInInventory( hero, "item_aether_lens", false, false ) then
				plspiritlance:SetLevel( 7 )
			elseif plspiritlance:GetLevel() == 7 and not (hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false ) and self:HeroHasUsableItemInInventory( hero, "item_aether_lens", false, false )) then
				plspiritlance:SetLevel( 6 )
			end
			if pljuxtapose:GetLevel() == 3 and hero:GetLevel() >= 22 and (hero:HasScepter() or self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false )) then
				pljuxtapose:SetLevel( 4 )
			elseif pljuxtapose:GetLevel() == 4 and not (hero:HasScepter() or self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false )) then
				pljuxtapose:SetLevel( 3 )
			elseif pljuxtapose:GetLevel() == 4 and hero:GetLevel() == 25 and (hero:HasScepter() and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false )) then
				pljuxtapose:SetLevel( 5 )
			elseif pljuxtapose:GetLevel() == 5 and not (hero:HasScepter() and hero:GetLevel() == 25 and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false )) then
				pljuxtapose:SetLevel( 4 )
			elseif pljuxtapose:GetLevel() == 5 and hero:HasScepter() and hero:GetLevel() == 25 and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false ) and self:CountUsableItemsInHeroInventory( hero, "item_heart", false, false) >= 2 then
				pljuxtapose:SetLevel( 6 )
			elseif pljuxtapose:GetLevel() == 6 and not (hero:HasScepter() and hero:GetLevel() == 25 and self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false ) and (self:CountUsableItemsInHeroInventory( hero, "item_heart", true, false) >= 2)) then
				pljuxtapose:SetLevel( 5 )
			end
			if pldoppelwalk:GetLevel() == 4 and hero:GetLevel() >= 15 then
				pldoppelwalk:SetLevel( 5 )
			elseif pldoppelwalk:GetLevel() == 5 and hero:GetLevel() >= 20 or self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false ) then
				pldoppelwalk:SetLevel( 6 )
			elseif pldoppelwalk:GetLevel() == 6 and (not hero:GetLevel() >= 20 and not self:HeroHasUsableItemInInventory( hero, "item_octarine_core", false, false )) then
				pldoppelwalk:SetLevel( 5 )
			end
			if plphantomedge:GetLevel() == 4 and hero:GetLevel() >= 20 then
				plphantomedge:SetLevel( 5 )
			elseif plphantomedge:GetLevel() == 5 and hero:GetLevel() >= 20 and self:HeroHasUsableItemInInventory( hero, "item_aether_lens", false, false ) then
				plphantomedge:SetLevel( 6 )
			elseif plphantomedge:GetLevel() == 6 and hero:GetLevel() >= 20 and not self:HeroHasUsableItemInInventory( hero, "item_aether_lens", false, false ) then
				plphantomedge:SetLevel( 5 )
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
end

function VGMAR:OnGameStateChanged( keys )
	local state = GameRules:State_Get()
	
	if state == DOTA_GAMERULES_STATE_HERO_SELECTION then
		if IsServer() then
			SendToServerConsole("sv_cheats 1")
			SendToServerConsole("dota_bot_populate")
			SendToServerConsole("dota_bot_set_difficulty 2")
			SendToServerConsole("sv_cheats 0")
			GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
		end
	elseif state == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		local used_hero_name = "npc_dota_hero_dragon_knight"
		print("Checking players...")
		
		for playerID=0, DOTA_MAX_TEAM_PLAYERS do
			if PlayerResource:IsValidPlayer(playerID) then
				print("PlayedID:", playerID)
				
				if PlayerResource:GetTeam(playerID) == DOTA_TEAM_GOODGUYS then
					self.n_players_radiant = self.n_players_radiant + 1
				elseif PlayerResource:GetTeam(playerID) == DOTA_TEAM_BADGUYS then
					self.n_players_dire = self.n_players_dire + 1
				end

				-- Random heroes for people who have not picked
				if PlayerResource:HasSelectedHero(playerID) == false then
					print("Randoming hero for:", playerID)
					PlayerResource:GetPlayer(playerID):MakeRandomHeroSelection()
					print("Randomed:", PlayerResource:GetSelectedHeroName(playerID))
				end
				
				used_hero_name = PlayerResource:GetSelectedHeroName(playerID)
			end
		end
		
		print("Number of players:", self.n_players_radiant + self.n_players_dire)
		print("Radiant:", self.n_players_radiant)
		print("Radiant:", self.n_players_dire)
		
	elseif state == DOTA_GAMERULES_STATE_PRE_GAME then
		local gm = GameRules:GetGameModeEntity()
		if IsServer() then
			gm:SetThink(function()
				SendToServerConsole("sv_cheats 1")
				SendToServerConsole("dota_bot_disable 0")
				GameRules:GetGameModeEntity():SetBotThinkingEnabled(true)
				SendToServerConsole("host_timescale 4")
			end, DoUniqueString('enablebots'), 10)
		end
		--////////////////////////////////////
		--STOP FUCKING SPLIT PUSHING CATAPULTS
		--////////////////////////////////////		
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
							print("Error in defspells assigning mechanism, UNEXPECTED_PRIORITY_FOUND")
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
			SendToServerConsole("host_timescale 1")
			self.istimescalereset = 1
		end
	end
end
