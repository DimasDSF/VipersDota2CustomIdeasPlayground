if not AbilitySlotsLib then
	AbilitySlotsLib = class({})
end

function AbilitySlotsLib:Init()
	print("[AbilitySlotsLib] : Initiating")
	AbilitySlotsLib.talentskvtable = {}
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
		Timers:CreateTimer(function()
			if #self.removetalentsqueue > 0 then
				if AbilitySlotsLib:ReplaceWithGenericHidden( self.removetalentsqueue[1].hero, self.removetalentsqueue[1].ability, false ) then
					--print("Removed", self.removetalentsqueue[1].ability, "from Queue")
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
	--DeepPrintTable( keys )
	local player = EntIndexToHScript(keys.player)
	local abilityname = keys.abilityname
	local playerhero = nil
	
	local heroes = HeroList:GetAllHeroes()
	for i=1,HeroList:GetHeroCount() do
		if heroes[i] and heroes[i]:GetPlayerOwner() == player then
			playerhero = heroes[i]
			break
		end
	end
	if playerhero and playerhero:FindAbilityByName(abilityname) then
		local printdebug = true
		--print("Testing Assigned Hero For AbilitySlotsLib")
		if printdebug then print("Player ", playerhero:GetPlayerID(), "Hero is: ", playerhero:GetName()) end
		if abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 10, true ) then
			if printdebug then print("Removing Lvl10 Left Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 10, false )) end
			AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 10, false ), true )
		elseif abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 10, false ) then
			if printdebug then print("Removing Lvl10 Right Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 10, true )) end
			AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 10, true ), true )
		end
		if abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 15, true ) then
			if printdebug then print("Removing Lvl15 Left Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 15, false )) end
			AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 15, false ), true )
		elseif abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 15, false ) then
			if printdebug then print("Removing Lvl15 Right Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 15, true )) end
			AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 15, true ), true )
		end
		if abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 20, true ) then
			if printdebug then print("Removing Lvl20 Left Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 20, false )) end
			AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 20, false ), true )
		elseif abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 20, false ) then
			if printdebug then print("Removing Lvl20 Right Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 20, true )) end
			AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 20, true ), true )
		end
		if abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 25, true ) then
			if printdebug then print("Removing Lvl25 Left Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 25, false )) end
			AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 25, false ), true )
		elseif abilityname == AbilitySlotsLib:GetTalent( playerhero:GetName(), 25, false ) then
			if printdebug then print("Removing Lvl25 Right Talent: ", AbilitySlotsLib:GetTalent( playerhero:GetName(), 25, true )) end
			AbilitySlotsLib:ReplaceWithGenericHidden( playerhero, AbilitySlotsLib:GetTalent( playerhero:GetName(), 25, true ), true )
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

function AbilitySlotsLib:GetFreeAbilitySlotsForSpecificHero( hero, withreplaceable )
	if hero ~= nil then
		local heroname = hero:GetName()
		local heroindex = hero:entindex()
		local abilitiescount = 0
		local replaceable = 0
		if heroname == "npc_dota_hero_invoker" and (hero:FindAbilityByName("invoker_empty1") ~= nil or hero:FindAbilityByName("invoker_empty2") ~= nil) then
			--print("GetFreeAbilitySlotsForSpecificHero Calling InvokerCleanUp")
			self:InvokerAbilityCleanUp( hero )
			--print("Free Slots with replaceables: ", self:GetFreeAbilitySlotsForDefaultHero( heroname, true ) - (self:ReadFromAbilitiesCountList(heroindex) + (self:ReadFromSlotsReplacedList(heroindex) - self:ReadFromAddedHiddenCountList( heroindex ))))
		end
		for j=0,23,1 do
			local abilityinslot = hero:GetAbilityByIndex(j)
			if abilityinslot ~= nil then
				if withreplaceable == true then
					if abilityinslot:GetName() == "generic_hidden" or abilityinslot:GetName() == "special_bonus_unique_hidden_1" or abilityinslot:GetName() == "special_bonus_unique_hidden_2" or abilityinslot:GetName() == "special_bonus_unique_hidden_3" or abilityinslot:GetName() == "special_bonus_unique_hidden_4" then
						replaceable = replaceable + 1
					end
				end
				abilitiescount = abilitiescount + 1
			end
		end
		return (hardcodedslots - abilitiescount) + replaceable
	end
	return 0
end

function AbilitySlotsLib:ReplaceAbilityByName( hero, abilityname, newlevel )
	if hero ~= nil then
		local heroname = hero:GetName()
		local heroindex = hero:entindex()
		if hero:FindAbilityByName("generic_hidden") ~= nil then
			hero:RemoveAbility("generic_hidden")
		elseif hero:FindAbilityByName(self:GetHiddenTalentNum(hero, false)) ~= nil then
			hero:RemoveAbility(self:GetHiddenTalentNum(hero, false))
		end
		local newability = hero:AddAbility(abilityname)
		if newability ~= nil then
			if newlevel ~= -1 then
				newability:SetLevel( newlevel )
			end
			return newability
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

function AbilitySlotsLib:GetHiddenTalentNum( hero, add )
	if hero ~= nil then
		local ret = nil
		if add == true then
			for i=1,4 do
				if hero:FindAbilityByName("special_bonus_unique_hidden_"..i) == nil then
					ret = "special_bonus_unique_hidden_"..i
					break
				end
			end
		else
			for i=4,1,-1 do
				if hero:FindAbilityByName("special_bonus_unique_hidden_"..i) ~= nil then
					ret = "special_bonus_unique_hidden_"..i
					break
				end
			end
		end
		return ret
	end
	return nil
end

function AbilitySlotsLib:ReplaceWithGenericHidden( hero, ability, addtolistonfail )
	if hero ~= nil then
		local heroname = hero:GetName()
		local heroindex = hero:entindex()
		if self:GetFreeAbilitySlotsForSpecificHero( hero, false ) > 0 then
			local newtalentname = self:GetHiddenTalentNum( hero, true )
			local newability = hero:AddAbility(newtalentname)
			if newability ~= nil and hero:FindAbilityByName(ability) ~= nil then
				local abilityindex = hero:FindAbilityByName(ability):GetAbilityIndex()
				hero:SwapAbilities( ability, newtalentname, false, false)
				hero:RemoveAbility(ability)
				--print("Setting ability index: "..abilityindex)
				newability:SetAbilityIndex(abilityindex)
				print("Successfully replaced", ability, "with a hidden talent")
				return true
			else
				return false
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
		if heroname == "npc_dota_hero_invoker" and (hero:FindAbilityByName("invoker_empty1") ~= nil or hero:FindAbilityByName("invoker_empty2") ~= nil) then
			self:InvokerAbilityCleanUp( hero )
		end
		if self:GetFreeAbilitySlotsForSpecificHero( hero, false ) >= 1 then
			ability = hero:AddAbility(abilityname)
			if ability ~= nil then
				ability:SetLevel(newlevel)
			end
		elseif self:GetFreeAbilitySlotsForSpecificHero( hero, true ) > 0 then
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
		end
	end
end

function AbilitySlotsLib:InvokerAbilityCleanUp( invoker )
	if invoker ~= nil then
		local index = invoker:entindex()
		if invoker:FindAbilityByName("invoker_empty1") ~= nil and invoker:GetAbilityByIndex(3):GetName() ~= "invoker_empty1" and invoker:GetAbilityByIndex(4):GetName() ~= "invoker_empty1" then
			self:SafeRemoveAbility(invoker, "invoker_empty1")
			--print("Removed invoker_empty1. slots: ", self:ReadFromAddedHiddenCountList(index))
		end
		if invoker:FindAbilityByName("invoker_empty2") ~= nil and invoker:GetAbilityByIndex(3):GetName() ~= "invoker_empty2" and invoker:GetAbilityByIndex(4):GetName() ~= "invoker_empty2" then
			self:SafeRemoveAbility(invoker, "invoker_empty2")
			--print("Removed invoker empty2. slots: ", self:ReadFromAddedHiddenCountList(index))
		end
	end
end

GameRules.AbilitySlotsLib = AbilitySlotsLib
