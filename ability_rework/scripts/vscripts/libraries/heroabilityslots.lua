if not AbilitySlotsLib then
	AbilitySlotsLib = class({})
end

function AbilitySlotsLib:Init()
	print("[AbilitySlotsLib] : Initiating")
	AbilitySlotsLib.talentskvtable = {}
	AbilitySlotsLib.heroslotsreplacedlist = {}
	AbilitySlotsLib.heroslotsaddedhiddenlist = {}
	AbilitySlotsLib.heroaddedabilitiescount = {}
	AbilitySlotsLib.invokerabilitiescleanedup = {}
	AbilitySlotsLib.removetalentsqueue = {}
	
	ListenToGameEvent( "dota_player_learned_ability", Dynamic_Wrap( AbilitySlotsLib, "OnAbilityLearned" ), self)
	
	--Filling Talent Table
	if #AbilitySlotsLib.talentskvtable == 0 then
		local heroeskv = LoadKeyValues('scripts/npc/npc_heroes.txt')
		for i,h in pairs(heroeskv) do
			if i and h and i~="npc_dota_hero_base" and i~="npc_dota_hero_target_dummy" and i~="Version" then
				local heroabilities = {}
				local talentnum = 0
				for j=1,24 do
					if h["Ability"..j] and string.find(h["Ability"..j],"special_bonus_") ~= nil then
						talentnum = talentnum + 1
						table.insert(heroabilities, talentnum, h["Ability"..j])
					end
				end
				table.insert(AbilitySlotsLib.talentskvtable, i)
				-- in pairs: 1 is right talent, 2 is left talent
				AbilitySlotsLib.talentskvtable[i] = { talent10 = {heroabilities[1],heroabilities[2]}, talent15 = {heroabilities[3],heroabilities[4]}, talent20 = {heroabilities[5],heroabilities[6]}, talent25 = {heroabilities[7],heroabilities[8]} }
			end
		end
		print("[AbilitySlotsLib] Starting Think Function")
		print("Invoker Test")
		print(AbilitySlotsLib:GetTalent( "npc_dota_hero_invoker", 25, false ), "25", AbilitySlotsLib:GetTalent( "npc_dota_hero_invoker", 25, true ))
		print(AbilitySlotsLib:GetTalent( "npc_dota_hero_invoker", 20, false ), "20", AbilitySlotsLib:GetTalent( "npc_dota_hero_invoker", 20, true ))
		print(AbilitySlotsLib:GetTalent( "npc_dota_hero_invoker", 15, false ), "15", AbilitySlotsLib:GetTalent( "npc_dota_hero_invoker", 15, true ))
		print(AbilitySlotsLib:GetTalent( "npc_dota_hero_invoker", 10, false ), "10", AbilitySlotsLib:GetTalent( "npc_dota_hero_invoker", 10, true ))
		Timers:CreateTimer(function()
			if #self.removetalentsqueue > 0 then
				if AbilitySlotsLib:ReplaceWithGenericHidden( self.removetalentsqueue[1].hero, self.removetalentsqueue[1].ability, false ) then
					print("Removed", self.removetalentsqueue[1].ability, "from Queue")
					table.remove(self.removetalentsqueue, 1)
					if #self.removetalentsqueue > 0 then
						return 0.5
					else
						return 5.0
					end
				end
			end
			return 5.0
		end)
	end
end

function AbilitySlotsLib:OnAbilityLearned( keys )
	DeepPrintTable( keys )
	local player = EntIndexToHScript(keys.player)
	local abilityname = keys.abilityname
	local playerhero = nil
	
	local heroes = HeroList:GetAllHeroes()
	for i=1,HeroList:GetHeroCount() do
		if heroes[i] and heroes[i]:GetPlayerOwner() == player then
			playerhero = heroes[i]
		end	
		if playerhero and playerhero:FindAbilityByName(abilityname) then
			print("Testing Assigned Hero For AbilitySlotsLib")
			print("Player ", playerhero:GetPlayerID(), "Hero is: ", playerhero:GetName())
			if abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 10, true ) then
				print("Removing Lvl10 Left Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 10, false ))
				AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 10, false ), true )
			elseif abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 10, false ) then
				print("Removing Lvl10 Right Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 10, true ))
				AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 10, true ), true )
			end
			if abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 15, true ) then
				print("Removing Lvl15 Left Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 15, false ))
				AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 15, false ), true )
			elseif abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 15, false ) then
				print("Removing Lvl15 Right Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 15, true ))
				AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 15, true ), true )
			end
			if abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 20, true ) then
				print("Removing Lvl20 Left Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 20, false ))
				AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 20, false ), true )
			elseif abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 20, false ) then
				print("Removing Lvl20 Right Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 20, true ))
				AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 20, true ), true )
			end
			if abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 25, true ) then
				print("Removing Lvl25 Left Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 25, false ))
				AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 25, false ), true )
			elseif abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 25, false ) then
				print("Removing Lvl25 Right Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 25, true ))
				AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 25, true ), true )
			end
		end
	end
end


function AbilitySlotsLib:GetTalent( heroname, lvl, right )
	if heroname ~= nil and (lvl == 10 or lvl == 15 or lvl == 20 or lvl == 25) then
		local side = 1
		if right == nil or right == false then
			side = 2
		end
		if lvl == 10 then
			return AbilitySlotsLib.talentskvtable[heroname].talent10[side]
		elseif lvl == 15 then
			return AbilitySlotsLib.talentskvtable[heroname].talent15[side]
		elseif lvl == 20 then
			return AbilitySlotsLib.talentskvtable[heroname].talent20[side]
		elseif lvl == 25 then
			return AbilitySlotsLib.talentskvtable[heroname].talent25[side]
		end
	end
	return nil
end

local hardcodedslots = 24

local herolist = {
	["npc_dota_hero_antimage"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_axe"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_bane"]				=	{ abilities = 7, replaceable = 2 },
	["npc_dota_hero_bloodseeker"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_crystal_maiden"]	=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_drow_ranger"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_earthshaker"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_juggernaut"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_mirana"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_nevermore"]			=	{ abilities = 6, replaceable = 0 },
	["npc_dota_hero_morphling"]			=	{ abilities = 8, replaceable = 0 },
	["npc_dota_hero_phantom_lancer"]	=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_puck"]				=	{ abilities = 6, replaceable = 1 },
	["npc_dota_hero_pudge"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_razor"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_sand_king"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_storm_spirit"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_sven"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_tiny"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_vengefulspirit"]	=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_windrunner"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_zuus"]				=	{ abilities = 6, replaceable = 1 },
	["npc_dota_hero_kunkka"]			=	{ abilities = 7, replaceable = 2 },
	["npc_dota_hero_lina"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_lich"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_lion"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_shadow_shaman"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_slardar"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_tidehunter"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_witch_doctor"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_riki"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_enigma"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_tinker"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_sniper"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_necrolyte"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_warlock"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_beastmaster"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_queenofpain"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_venomancer"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_faceless_void"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_skeleton_king"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_death_prophet"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_phantom_assassin"]	=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_pugna"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_templar_assassin"]	=	{ abilities = 6, replaceable = 1 },
	["npc_dota_hero_viper"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_luna"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_dragon_knight"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_dazzle"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_rattletrap"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_leshrac"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_furion"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_life_stealer"]		=	{ abilities = 9, replaceable = 1 },
	["npc_dota_hero_dark_seer"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_clinkz"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_omniknight"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_enchantress"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_huskar"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_night_stalker"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_broodmother"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_bounty_hunter"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_weaver"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_jakiro"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_batrider"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_chen"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_spectre"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_doom_bringer"]		=	{ abilities = 6, replaceable = 0 },
	["npc_dota_hero_ancient_apparition"]=	{ abilities = 7, replaceable = 2 },
	["npc_dota_hero_ursa"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_spirit_breaker"]	=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_gyrocopter"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_alchemist"]			=	{ abilities = 7, replaceable = 2 },
	["npc_dota_hero_invoker"]			=	{ abilities = 16, replaceable = 0 },
	["npc_dota_hero_silencer"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_obsidian_destroyer"]=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_lycan"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_brewmaster"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_shadow_demon"]		=	{ abilities = 6, replaceable = 1 },
	["npc_dota_hero_lone_druid"]		=	{ abilities = 7, replaceable = 1 },
	["npc_dota_hero_chaos_knight"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_meepo"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_treant"]			=	{ abilities = 6, replaceable = 1 },
	["npc_dota_hero_ogre_magi"]			=	{ abilities = 6, replaceable = 1 },
	["npc_dota_hero_undying"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_rubick"]			=	{ abilities = 10, replaceable = 0 },
	["npc_dota_hero_disruptor"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_nyx_assassin"]		=	{ abilities = 7, replaceable = 1 },
	["npc_dota_hero_naga_siren"]		=	{ abilities = 7, replaceable = 2 },
	["npc_dota_hero_keeper_of_the_light"]=	{ abilities = 9, replaceable = 0 },
	["npc_dota_hero_wisp"]				=	{ abilities = 7, replaceable = 0 },
	["npc_dota_hero_visage"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_slark"]				=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_medusa"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_troll_warlord"]		=	{ abilities = 6, replaceable = 1 },
	["npc_dota_hero_centaur"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_magnataur"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_shredder"]			=	{ abilities = 8, replaceable = 1 },
	["npc_dota_hero_bristleback"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_tusk"]				=	{ abilities = 7, replaceable = 1 },
	["npc_dota_hero_skywrath_mage"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_abaddon"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_elder_titan"]		=	{ abilities = 7, replaceable = 2 },
	["npc_dota_hero_legion_commander"]	=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_ember_spirit"]		=	{ abilities = 6, replaceable = 1 },
	["npc_dota_hero_earth_spirit"]		=	{ abilities = 6, replaceable = 0 },
	["npc_dota_hero_terrorblade"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_phoenix"]			=	{ abilities = 9, replaceable = 1 },
	["npc_dota_hero_oracle"]			=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_techies"]			=	{ abilities = 6, replaceable = 0 },
	["npc_dota_hero_winter_wyvern"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_arc_warden"]		=	{ abilities = 6, replaceable = 2 },
	["npc_dota_hero_abyssal_underlord"]	=	{ abilities = 7, replaceable = 2 },
	["npc_dota_hero_monkey_king"]		=	{ abilities = 8, replaceable = 0 },
	["npc_dota_hero_pangolier"]			=	{ abilities = 7, replaceable = 2 },
	["npc_dota_hero_dark_willow"]		=	{ abilities = 6, replaceable = 1 }
}

local talentsnum = 8

function AbilitySlotsLib:IncrementSlotsReplacedList( index )
	if index ~= 0 then
		if self.heroslotsreplacedlist[index] ~= nil then
			self.heroslotsreplacedlist[index] = self.heroslotsreplacedlist[index] + 1
		else
			self.heroslotsreplacedlist[index] = 1
		end
	end
end

function AbilitySlotsLib:ReadFromSlotsReplacedList( index )
	if index ~= 0 then
		if self.heroslotsreplacedlist[index] ~= nil then
			return self.heroslotsreplacedlist[index]
		else
			return 0
		end
	end
	return 0
end

function AbilitySlotsLib:IncrementAddedHiddenCountList( index )
	if index ~= 0 then
		if self.heroslotsaddedhiddenlist[index] ~= nil then
			self.heroslotsaddedhiddenlist[index] = self.heroslotsaddedhiddenlist[index] + 1
		else
			self.heroslotsaddedhiddenlist[index] = 1
		end
	end
end

function AbilitySlotsLib:DecrementAddedHiddenCountList( index )
	if index ~= 0 then
		if self.heroslotsaddedhiddenlist[index] ~= nil then
			self.heroslotsaddedhiddenlist[index] = self.heroslotsaddedhiddenlist[index] - 1
		else
			self.heroslotsaddedhiddenlist[index] = -1
		end
	end
end

function AbilitySlotsLib:ReadFromAddedHiddenCountList( index )
	if index ~= 0 then
		if self.heroslotsaddedhiddenlist[index] ~= nil then
			return self.heroslotsaddedhiddenlist[index]
		else
			return 0
		end
	end
	return 0
end

function AbilitySlotsLib:IncrementAbilitiesCountList( index )
	if index ~= 0 then
		if self.heroaddedabilitiescount[index] ~= nil then
			self.heroaddedabilitiescount[index] = self.heroaddedabilitiescount[index] + 1
		else
			self.heroaddedabilitiescount[index] = 1
		end
	end
end

function AbilitySlotsLib:DecrementAbilitiesCountList( index )
	if index ~= 0 then
		if self.heroaddedabilitiescount[index] ~= nil then
			self.heroaddedabilitiescount[index] = self.heroaddedabilitiescount[index] - 1
		else
			self.heroaddedabilitiescount[index] = -1
		end
	end
end

function AbilitySlotsLib:ReadFromAbilitiesCountList( index )
	if index ~= 0 then
		if self.heroaddedabilitiescount[index] ~= nil then
			return self.heroaddedabilitiescount[index]
		else
			return 0
		end
	end
	return 0
end

function AbilitySlotsLib:SetInvokerCleanedUp( index )
	if index ~= 0 then
		if self.invokerabilitiescleanedup[index] ~= nil then
			self.invokerabilitiescleanedup[index] = self.invokerabilitiescleanedup[index] + 1
		else
			self.invokerabilitiescleanedup[index] = 1
		end
	end
end

function AbilitySlotsLib:ReadFromInvokerCleanedUp( index )
	if index ~= 0 then
		if self.invokerabilitiescleanedup[index] ~= nil then
			return self.invokerabilitiescleanedup[index]
		else
			return 0
		end
	end
	return 0
end

function AbilitySlotsLib:GetFreeAbilitySlotsForDefaultHero( heroname, withreplaceable )
	if heroname ~= nil then
		if withreplaceable then
			return hardcodedslots-((herolist[heroname].abilities+talentsnum)-herolist[heroname].replaceable)
		else
			return hardcodedslots-(herolist[heroname].abilities+talentsnum)
		end
	end
	return 0
end

function AbilitySlotsLib:GetFreeAbilitySlotsForSpecificHero( hero )
	if hero ~= nil then
		local heroname = hero:GetName()
		local heroindex = hero:entindex()
		--print("Free Slots: ", self:GetFreeAbilitySlotsForDefaultHero( heroname, false ) - self:ReadFromAbilitiesCountList(heroindex))
		--print("Free Slots with replaceables: ", self:GetFreeAbilitySlotsForDefaultHero( heroname, true ) - (self:ReadFromAbilitiesCountList(heroindex) + (self:ReadFromSlotsReplacedList(heroindex) - self:ReadFromAddedHiddenCountList( heroindex ))))
		if heroname == "npc_dota_hero_invoker" and self:ReadFromInvokerCleanedUp( heroindex ) < 2 then
			print("GetFreeAbilitySlotsForSpecificHero Calling InvokerCleanUp")
			self:InvokerAbilityCleanUp( hero )
			print("Free Slots with replaceables: ", self:GetFreeAbilitySlotsForDefaultHero( heroname, true ) - (self:ReadFromAbilitiesCountList(heroindex) + (self:ReadFromSlotsReplacedList(heroindex) - self:ReadFromAddedHiddenCountList( heroindex ))))
		end
		if self:GetFreeAbilitySlotsForDefaultHero( heroname, false ) - self:ReadFromAbilitiesCountList(heroindex) > 0 then
			return self:GetFreeAbilitySlotsForDefaultHero( heroname, false ) - self:ReadFromAbilitiesCountList(heroindex)
		elseif self:GetFreeAbilitySlotsForDefaultHero( heroname, true ) - (self:ReadFromAbilitiesCountList(heroindex) + (self:ReadFromSlotsReplacedList(heroindex) - self:ReadFromAddedHiddenCountList( heroindex ))) > 0 then
			return self:GetFreeAbilitySlotsForDefaultHero( heroname, true ) - (self:ReadFromAbilitiesCountList(heroindex) + (self:ReadFromSlotsReplacedList(heroindex) - self:ReadFromAddedHiddenCountList( heroindex )))
		end
	end
	return 0	
end

function AbilitySlotsLib:ReplaceAbilityByName( hero, abilityname, newlevel )
	if hero ~= nil then
		local heroname = hero:GetName()
		local heroindex = hero:entindex()
		if (herolist[heroname].replaceable + self:ReadFromAddedHiddenCountList( heroindex ))-self:ReadFromSlotsReplacedList( heroindex ) > 0 then
			if hero:FindAbilityByName("generic_hidden") ~= nil then
				hero:RemoveAbility("generic_hidden")
			elseif hero:FindAbilityByName("special_bonus_unique_hidden") ~= nil then
				hero:RemoveAbility("special_bonus_unique_hidden")
			end
			local newability = hero:AddAbility(abilityname)
			if newability ~= nil then
				if newlevel ~= -1 then
					newability:SetLevel( newlevel )
					self:IncrementSlotsReplacedList(heroindex)
				end
				return newability
			end
		end
	end
	return nil
end

function AbilitySlotsLib:AddTalentToReplaceLaterList( heroinput, abilityinput )
	if heroinput ~= nil then
		local talent = { hero = heroinput, ability = abilityinput }
		if heroinput:FindAbilityByName(abilityinput)~= nil then
			table.insert(self.removetalentsqueue, talent)
		end
	end
end

function AbilitySlotsLib:ReplaceWithGenericHidden( hero, ability, addtolistonfail )
	if hero ~= nil then
		local heroname = hero:GetName()
		local heroindex = hero:entindex()
		if self:GetFreeAbilitySlotsForSpecificHero( hero ) > 0 then
			local newability = hero:AddAbility("special_bonus_unique_hidden")
			hero:SwapAbilities( ability, "special_bonus_unique_hidden", false, false)
			hero:RemoveAbility(ability)
			if newability ~= nil then
				self:IncrementAddedHiddenCountList(heroindex)
				print("Successfully replaced", ability, "with a hidden talent")
				return true
			end
		else
			if addtolistonfail == true then
				print("Failed to replace", ability, "with a hidden talent. Adding to Queue")
				self:AddTalentToReplaceLaterList( hero, ability )
				return false
			end
		end
	end
	return false
end

function AbilitySlotsLib:SafeAddAbility( hero, abilityname, newlevel )
	if hero ~= nil then
		local heroname = hero:GetName()
		local heroindex = hero:entindex()
		local ability = nil
		if heroname == "npc_dota_hero_invoker" and self:ReadFromInvokerCleanedUp( heroindex ) < 2 then
			self:InvokerAbilityCleanUp( hero )
		end
		if self:GetFreeAbilitySlotsForDefaultHero( heroname, false ) - self:ReadFromAbilitiesCountList(heroindex) >= 1 then
			ability = hero:AddAbility(abilityname)
			if ability ~= nil then
				ability:SetLevel(newlevel)
				self:IncrementAbilitiesCountList(heroindex)
			end
		elseif self:GetFreeAbilitySlotsForSpecificHero( hero ) > 0 then
			ability = self:ReplaceAbilityByName( hero, abilityname, newlevel )
			if ability ~= nil then
				return ability
			end
		end
		return ability
	end
	return nil
end

function AbilitySlotsLib:SafeRemoveAbility( hero, abilityname )
	if hero ~= nil then
		local heroindex = hero:entindex()
		local ability = hero:FindAbilityByName(abilityname)
		if ability ~= nil then
			hero:RemoveAbility(abilityname)
			self:DecrementAbilitiesCountList(heroindex)
		end
	end
end

function AbilitySlotsLib:InvokerAbilityCleanUp( invoker )
	if invoker ~= nil then
		local index = invoker:entindex()
		if invoker:FindAbilityByName("invoker_empty1") ~= nil and invoker:GetAbilityByIndex(3):GetName() ~= "invoker_empty1" and invoker:GetAbilityByIndex(4):GetName() ~= "invoker_empty1" then
			invoker:RemoveAbility("invoker_empty1")
			--self:IncrementAddedHiddenCountList(index)
			self:DecrementAbilitiesCountList( index )
			print("Removed invoker_empty1. slots: ", self:ReadFromAddedHiddenCountList(index))
			--invoker:AddAbility("generic_hidden")
			self:SetInvokerCleanedUp( index )
		end
		if invoker:FindAbilityByName("invoker_empty2") ~= nil and invoker:GetAbilityByIndex(3):GetName() ~= "invoker_empty2" and invoker:GetAbilityByIndex(4):GetName() ~= "invoker_empty2" then
			invoker:RemoveAbility("invoker_empty2")
			--self:IncrementAddedHiddenCountList(index)
			self:DecrementAbilitiesCountList( index )
			print("Removed invoker empty2. slots: ", self:ReadFromAddedHiddenCountList(index))
			--invoker:AddAbility("generic_hidden")
			self:SetInvokerCleanedUp( index )
		end
	end
end

GameRules.AbilitySlotsLib = AbilitySlotsLib
