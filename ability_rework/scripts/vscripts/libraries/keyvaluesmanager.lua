if not KeyValuesManager then
	KeyValuesManager = class({})
end

function KeyValuesManager:Init()
	self.ItemKV = {}
	self.ItemIDtoKV = {}
	self.AbilityKV = {}
	self.UnitKV = {}
	self.HeroKV = {}
	
	self:LoadValues()
end

function KeyValuesManager:LoadValues()
	local itemskvnum = 0
	local itemscustomkvnum = 0
	local itemskverrornum = 0
	local itemscustomkverrornum = 0
	local abilitieskvnum = 0
	local abilitiescustomkvnum = 0
	local unitkvnum = 0
	local unitcustomkvnum = 0
	local herokvnum = 0
	local herocustomkvnum = 0
	local erroreditems = {}
	local conflictingitems = {}
	local conflictingunits = {}
	local errorheroes = {}
	local conflictingheroes = {}
	local erroredabilities = {}
	local conflictingabilities = {}
	for k,v in pairs(LoadKeyValues("scripts/npc/items.txt")) do
		if k and v and k~="Version" then
			if v["ID"] then
				--print("Adding Item: "..k.." With ID: "..v["ID"].." from items.txt")
				itemskvnum = itemskvnum + 1
				if self.ItemKV[k] == nil then
					self.ItemKV[k] = v
				else
					--print("Item: "..k.." Has a conflicting item ID "..v["ID"].." with "..self.ItemKV[v["ID"]])
					table.insert(conflictingitems, {v["ID"], k, self.ItemKV[k]})
				end
				if self.ItemIDtoKV[v["ID"]] == nil then
					self.ItemIDtoKV[v["ID"]] = k
				end
			else
				itemskverrornum = itemskverrornum + 1
				print("Item: "..k.." Has no ID!!!")
				table.insert(erroreditems, k)
			end
		end
	end
	for k,v in pairs(LoadKeyValues("scripts/npc/npc_items_custom.txt")) do
		if k and v and k~="Version" then
			if v["ID"] then
				--print("Adding Item: "..k.." With ID: "..v["ID"].." from items_custom.txt")
				itemscustomkvnum = itemscustomkvnum + 1
				if self.ItemKV[k] == nil then
					self.ItemKV[k] = v
				else
					--print("Item: "..k.." Has a conflicting item ID "..v["ID"].." with "..self.ItemKV[v["ID"]])
					table.insert(conflictingitems, {v["ID"], k, self.ItemKV[k]})
				end
				if self.ItemIDtoKV[v["ID"]] == nil then
					self.ItemIDtoKV[v["ID"]] = k
				end
			else
				itemscustomkverrornum = itemscustomkverrornum + 1
				print("Item: "..k.." Has no ID!!!")
				table.insert(erroreditems, k)
			end
		end
	end
	print("Added "..itemskvnum.." Items and "..itemscustomkvnum.." Custom Items to KVTable")
	for k,v in pairs(LoadKeyValues("scripts/npc/npc_abilities.txt")) do
		if k and v and k~="Version" and k~="ability_base" and k~="dota_base_ability" then
			abilitieskvnum = abilitieskvnum + 1
			if self.AbilityKV[k] == nil then
				self.AbilityKV[k] = v
			else
				--print("Item: "..k.." Has a conflicting item ID "..v["ID"].." with "..self.ItemKV[v["ID"]])
				table.insert(conflictingabilities, {k, self.AbilityKV[k]})
			end
		end
	end
	for k,v in pairs(LoadKeyValues("scripts/npc/npc_abilities_custom.txt")) do
		if k and v and k~="Version" and k~="ability_base" and k~="dota_base_ability" then
			abilitiescustomkvnum = abilitiescustomkvnum + 1
			if self.AbilityKV[k] == nil then
				self.AbilityKV[k] = v
			else
				--print("Item: "..k.." Has a conflicting item ID "..v["ID"].." with "..self.ItemKV[v["ID"]])
				table.insert(conflictingabilities, {k, self.AbilityKV[k]})
			end
		end
	end
	print("Added "..abilitieskvnum.." Abilities and "..abilitiescustomkvnum.." Custom Abilities to KVTable")
	for k,v in pairs(LoadKeyValues("scripts/npc/npc_units.txt")) do
		if k and v and k~="Version" and k~="npc_dota_units_base" and k~="npc_dota_thinker" and k~="npc_dota_loadout_generic" and k~="npc_dota_companion" then
			unitkvnum = unitkvnum + 1
			if self.UnitKV[k] == nil then
				self.UnitKV[k] = v
			else
				--print("Item: "..k.." Has a conflicting item ID "..v["ID"].." with "..self.ItemKV[v["ID"]])
				table.insert(conflictingunits, {k, self.UnitKV[k]})
			end
		end
	end
	for k,v in pairs(LoadKeyValues("scripts/npc/npc_units_custom.txt")) do
		if k and v and k~="Version" and k~="npc_dota_units_base" and k~="npc_dota_thinker" and k~="npc_dota_loadout_generic" and k~="npc_dota_companion" then
			unitcustomkvnum = unitcustomkvnum + 1
			if self.UnitKV[k] == nil then
				self.UnitKV[k] = v
			else
				print('Modifying '..k)
				for i,j in pairs(v) do
					print('Setting '..i..' from '..tostring(self.UnitKV[k][i])..' to '..j)
					self.UnitKV[k][i] = j
				end
			end
		end
	end
	print("Added "..unitkvnum.." Units and "..unitcustomkvnum.." Custom Units to KVTable")
	for k,v in pairs(LoadKeyValues("scripts/npc/npc_heroes.txt")) do
		if k and v and k~="Version" and k~="npc_dota_hero_base" then
			herokvnum = herokvnum + 1
			if self.HeroKV[k] == nil then
				self.HeroKV[k] = v
			else
				table.insert(conflictingheroes, {k, self.HeroKV[k]})
			end
		end
	end
	for k,v in pairs(LoadKeyValues("scripts/npc/npc_heroes_custom.txt")) do
		if k and v and k~="Version" and k~="npc_dota_hero_base" then
			if self.HeroKV[k] == nil then
				print('Warning!\nTrying to initialize a custom entry to Heroes: '..k..' with npc_heroes_custom.\nThis Does Not Work!!!')
				table.insert(errorheroes, {k, v})
				self.HeroKV[k] = v
			else
				herocustomkvnum = herocustomkvnum + 1
				for i,j in pairs(v) do
					self.HeroKV[k][i] = j
				end
			end
		end
	end
	print("Added "..herokvnum.." Heroes and "..herocustomkvnum.." Hero Modifications to KVTable")
	
	--Conflict Prevention
	if itemskverrornum > 0 or itemscustomkverrornum > 0 then
		print("Encountered Errors: items.txt: "..itemskverrornum.." item_custom.txt: "..itemscustomkverrornum)
		LogLib:Log_Error("Items Missing IDs", 1, "Error parsing Item IDs")
		for i=1,#erroreditems do
			LogLib:Log_Error(i..". "..erroreditems[i], 2)
		end
	end
	if #conflictingitems > 0 then
		print("Encountered "..#conflictingitems.." Conflicting Item IDs")
		LogLib:Log_Error("Conflicting Item IDs:", 0, "Item KV ID system encountered "..#conflictingitems.." conflicting Item IDs")
		for i=1,#conflictingitems do
			local cidata = conflictingitems[i]
			print(i..": ID: "..cidata[1].." Items: "..cidata[2].." - "..cidata[3])
			LogLib:Log_Error(i..": ID: "..cidata[1].." Items: "..cidata[2].." - "..cidata[3], 1)
		end
	end
	if #conflictingabilities > 0 then
		print("Encountered "..#conflictingabilities.." Conflicting Abilities")
		LogLib:Log_Error("Conflicting Abilities:", 0, "Ability KV system encountered "..#conflictingabilities.." conflicting Abilities")
		for i=1,#conflictingabilities do
			local cidata = conflictingabilities[i]
			print(i..": Abilities: "..cidata[1].." - "..cidata[2])
			LogLib:Log_Error(i..": Items: "..cidata[1].." - "..cidata[2], 1)
		end
	end
	if #errorheroes > 0 then
		print("Encountered "..#errorheroes.." Hero Modifications without base.")
		LogLib:Log_Error("Orphan Heroes:", 0, "Hero KV system encountered "..#errorheroes.." Orphan Hero Modifications")
		for i=1,#errorheroes do
			local cidata = errorheroes[i]
			print(i..": Hero: "..cidata[1])
			LogLib:Log_Error(i..": Hero: "..cidata[1], 1)
		end
	end
end

function KeyValuesManager:GetItemKV(itemname)
	if self.ItemKV[itemname] then
		return self.ItemKV[itemname]
	end
	return nil
end

function KeyValuesManager:GetAbilitySpecialKV(kv, key)
	for _,v in pairs(kv.AbilitySpecial) do
		for k,j in pairs(v) do
			if k == key then
				return j
			end
		end
	end
	return nil
end

function KeyValuesManager:GetItemPrice(itemname)
	if self.ItemKV[itemname] then
		local item = self.ItemKV[itemname]
		return item["ItemCost"] or 0
	end
	return 0
end

function KeyValuesManager:GetUnitKV(unitname)
	if self.UnitKV[unitname] then
		return self.UnitKV[unitname]
	end
	return nil
end

function KeyValuesManager:GetHeroKV(heroname)
	if self.HeroKV[heroname] then
		return self.HeroKV[heroname]
	end
	return nil
end

function KeyValuesManager:GetAbilityKV(abilityname)
	if self.AbilityKV[abilityname] then
		return self.AbilityKV[abilityname]
	end
	return nil
end

function KeyValuesManager:GetItemByID(id)
	if self.ItemIDtoKV[id] then
		return self.ItemIDtoKV[id]
	end
	return nil
end

GameRules.KeyValuesManager = KeyValuesManager