--A modifier used as an AI for a companion

modifier_vgmar_ai_companion_wisp = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_ai_companion_wisp:GetTexture()
	return "custom/ai"
end

--------------------------------------------------------------------------------

function modifier_vgmar_ai_companion_wisp:IsHidden()
    return false
end

function modifier_vgmar_ai_companion_wisp:IsDebuff()
	return false
end

function modifier_vgmar_ai_companion_wisp:IsPurgable()
	return false
end

function modifier_vgmar_ai_companion_wisp:RemoveOnDeath()
	return false
end
--------------------------------------------------------------------------------

function modifier_vgmar_ai_companion_wisp:OnCreated( kv )
	self.ownerid = kv.ownerid
	self.ownerindex = kv.ownerindex
	self.enablesceptertoggle = self:GetCaster():GetLevel() >= 15
	self.enablehittoggle = self:GetCaster():GetLevel() >= 20
	self.abilitypointsspent = 0
	self.itemdata = {
			[0] = {itemname = nil, timestamp = 0},
			[1] = {itemname = nil, timestamp = 0},
			[2] = {itemname = nil, timestamp = 0},
			[3] = {itemname = nil, timestamp = 0},
			[4] = {itemname = nil, timestamp = 0},
			[5] = {itemname = nil, timestamp = 0},
			[6] = {itemname = nil, timestamp = 0},
			[7] = {itemname = nil, timestamp = 0},
			[8] = {itemname = nil, timestamp = 0}
		}
	print("Attempting to find hero entity by id: ", self.ownerindex, "kv index: ", kv.ownerindex)
	if IsServer() then
		self.ownerhero = EntIndexToHScript(self.ownerindex)
		self.idlemovetime = math.floor(GameRules:GetDOTATime( false, true ))
		self:GetParent():AddNewModifier( self:GetParent(), nil, "modifier_vgmar_ai_companion_wisp_item_usage", {ownerid = self.ownerid, ownerindex = self.ownerindex})
		self:StartIntervalThink( 0.5 )
	end
end

function modifier_vgmar_ai_companion_wisp:OnIntervalThink()
	local parent = self:GetParent()
	local distancetoowner = (parent:GetAbsOrigin() - self.ownerhero:GetAbsOrigin()):Length2D()
	local fountainpos = GetGroundPosition(Vector(-6945, -6525, 512), parent)
	local fountaindistance = (parent:GetAbsOrigin() - fountainpos):Length2D()
	local istethered = self.ownerhero:HasModifier("modifier_wisp_tether_haste") and self.ownerhero:FindModifierByName("modifier_wisp_tether_haste"):GetCaster() == parent
	local runerange = 400
	if istethered == false then
		runerange = runerange + 1000
	end
	if self.bottle ~= nil then
		runerange = runerange + 1000
	end
	local closestrune = Entities:FindByClassnameNearest("dota_item_rune", parent:GetOrigin(), runerange)
	if self.midas == nil then
		self.midas = GameRules.VGMAR:GetItemFromInventoryByName( parent, "item_hand_of_midas", false, false, false )
	else
		if not parent:HasModifier("modifier_vgmar_ai_companion_midas_usage") then
			local midasitemslot = GameRules.VGMAR:GetItemSlotFromInventoryByItemName( parent, "item_hand_of_midas", false, false, false )
			parent:AddNewModifier( self:GetCaster(), nil, "modifier_vgmar_ai_companion_midas_usage", {midasslot = midasitemslot, ownerid = self.ownerid})
		end
	end
	if self.tpboots == nil then
		self.tpboots = GameRules.VGMAR:GetItemFromInventoryByName( parent, "item_travel_boots_2", false, false, false )
	end
	if self.bottle == nil then
		self.bottle = GameRules.VGMAR:GetItemFromInventoryByName( parent, "item_bottle", false, false, false )
	end
	
	local function shouldmove()
		if parent:HasModifier("modifier_vgmar_ai_companion_wisp_force_stop") == false then
			return true
		else
			return false
		end
	end
	
	local function TeleportWithTravelBoots( boots, targettype, target )
		parent:Stop()
		parent:AddNewModifier( self:GetCaster(), nil, "modifier_vgmar_ai_companion_wisp_force_stop", {duration = 4})
		if targettype == "vector" then
			print("Casting Travelboots on"..target:__tostring())
			self:GetCaster():CastAbilityOnPosition(target, boots, self.ownerid)
		elseif targettype == "unit" then
			self:GetCaster():CastAbilityOnTarget(target, boots, self.ownerid)
		end
	end
	
	--Alive Code
	if parent:IsAlive() then
		--Follow Code
		--[[Improvement
		Create a table of enemy towers and their ranges
		Update it on event towerfalls
		Restrict entering tower range if owner is not in range
		
		Prioritize staying away from enemies
		
		Separate Tethered Activities and Untethered Activities
		to allow wisp to do its own stuff while untethered instead of just following owner
		--]]
		
		if self.ownerhero:IsAlive() then
			if closestrune and shouldmove() and (istethered == false and distancetoowner > 1000 or self.bottle ~= nil) then
				local timetorune = (parent:GetAbsOrigin() - closestrune:GetAbsOrigin()):Length2D() / parent:GetIdealSpeed()
				parent:AddNewModifier( self:GetCaster(), nil, "modifier_vgmar_ai_companion_wisp_force_stop", {duration = timetorune + 1})
				parent:PickupRune(closestrune)
			end
			if distancetoowner < 400 and shouldmove() then
				if GameRules:GetDOTATime( false, true ) > self.idlemovetime + 3 then
					local movetarget = self.ownerhero:GetAbsOrigin()+RandomVector(390)
					local towers = FindUnitsInRadius(parent:GetTeamNumber(), movetarget, nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, 0, FIND_CLOSEST, false)
					local moveallowed = true
					if #towers > 0 then
						for i=1,#towers do
							if towers[i] ~= nil then
								if towers[i]:GetClassname() == "npc_dota_tower" and towers[i]:GetTeamNumber() ~= parent:GetTeamNumber() then
									if (towers[i]:GetAbsOrigin() - self.ownerhero:GetAbsOrigin()):Length2D() > 700 then
										moveallowed = false
									end
								elseif towers[i]:GetClassname() == "npc_dota_fountain" and towers[i]:GetTeamNumber() ~= parent:GetTeamNumber() then
									moveallowed = false
								end
							end
						end
					end
					if moveallowed == true then
						parent:MoveToPosition(movetarget)
						self.idlemovetime = math.floor(GameRules:GetDOTATime( false, true ))
					end
				end
			elseif (distancetoowner >= 400 and distancetoowner < 4000) and shouldmove() then
				local movetarget = self.ownerhero:GetAbsOrigin()+RandomVector(300)
				local towers = FindUnitsInRadius(parent:GetTeamNumber(), movetarget, nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING, 0, FIND_CLOSEST, false)
				local moveallowed = true
				if #towers > 0 then
					for i=1,#towers do
						if towers[i] ~= nil then
							if towers[i]:GetClassname() == "npc_dota_tower" and towers[i]:GetTeamNumber() ~= parent:GetTeamNumber() then
								if (towers[i]:GetAbsOrigin() - self.ownerhero:GetAbsOrigin()):Length2D() > 700 then
									moveallowed = false
								end
							elseif towers[i]:GetClassname() == "npc_dota_fountain" and towers[i]:GetTeamNumber() ~= parent:GetTeamNumber() then
								moveallowed = false
							end
						end
					end
				end
				if moveallowed == true then
					parent:MoveToPosition(movetarget)
				end
			elseif distancetoowner >= 4000 and shouldmove() then
				if self.tpboots and self.tpboots:GetCooldownTime() == 0 then
					if self:GetCaster():FindAbilityByName("vgmar_ai_companion_wisp_toggle_tether"):GetToggleState() == true and not parent:HasModifier("modifier_relocate_return_datadriven") then
						print("AI Considers teleporting to owner, Distance: ", distancetoowner)
						TeleportWithTravelBoots( self.tpboots, "unit", self.ownerhero )
					end
				end
			end
		elseif self.ownerhero:IsAlive() == false then
			if closestrune and shouldmove() then
				local timetorune = (parent:GetAbsOrigin() - closestrune:GetAbsOrigin()):Length2D() / parent:GetIdealSpeed()
				parent:AddNewModifier( self:GetCaster(), nil, "modifier_vgmar_ai_companion_wisp_force_stop", {duration = timetorune + 1})
				parent:PickupRune(closestrune)
			end
			if self.tpboots and self.tpboots:GetCooldownTime() == 0 and fountaindistance > 3500 and shouldmove() then
				TeleportWithTravelBoots( self.tpboots, "vector", fountainpos)
			else
				if fountaindistance < 400 and shouldmove() then
					if GameRules:GetDOTATime( false, true ) > self.idlemovetime + 3 then
						parent:MoveToPosition(fountainpos+RandomVector(390))
						self.idlemovetime = math.floor(GameRules:GetDOTATime( false, true ))
					end
				else
					if shouldmove() then
						parent:MoveToPosition(fountainpos+RandomVector(200))
					end
				end
			end
		end

		--TetherCode
		if self:GetCaster():FindAbilityByName("vgmar_ai_companion_wisp_toggle_tether"):GetToggleState() == true then
			if self.ownerhero:IsAlive() and shouldmove() and not parent:HasModifier("modifier_wisp_tether") then
				if parent:FindAbilityByName("vgmar_ca_wisp_tether"):GetCooldownTime() <= 0 and not parent:IsChanneling() then
					print("Wisp is Trying to Tether. Distance: ", distancetoowner, "shouldmove? ", shouldmove())
					parent:CastAbilityOnTarget(self.ownerhero, parent:FindAbilityByName("vgmar_ca_wisp_tether"), self.ownerid)
				end
			end
		elseif self:GetCaster():FindAbilityByName("vgmar_ai_companion_wisp_toggle_tether"):GetToggleState() == false then
			if istethered then
				if self:GetCaster():FindAbilityByName("vgmar_ca_wisp_overcharge"):GetToggleState() ~= false then
					self:GetCaster():CastAbilityToggle(self:GetCaster():FindAbilityByName("vgmar_ca_wisp_overcharge"), self.ownerid)
				end
				parent:RemoveModifierByName("modifier_wisp_tether")
				self.ownerhero:RemoveModifierByName("modifier_wisp_tether_haste")
				self.ownerhero:RemoveModifierByName("modifier_wisp_overcharge")
			end
		end
		
		--OverchargeCode
		local overchargeability = parent:FindAbilityByName("vgmar_ca_wisp_overcharge")
		local overchargedesiredstate = false
		if self.ownerhero:IsAlive() and istethered == true and overchargeability:IsFullyCastable() then
			if self.ownerhero:GetName() == "npc_dota_hero_huskar" then
				if self.ownerhero:GetHealth()/self.ownerhero:GetMaxHealth() < 0.4 and (self.ownerhero:GetHealth() < parent:GetHealth() and parent:GetHealth()/parent:GetMaxHealth() > 0.6) then
					overchargedesiredstate = true
				end
			else
				if self.ownerhero:GetHealth()/self.ownerhero:GetMaxHealth() < 0.9 and (self.ownerhero:GetHealth() < parent:GetHealth() and parent:GetHealth()/parent:GetMaxHealth() > 0.6) then
					overchargedesiredstate = true
				end
			end
			if parent:GetMana()/parent:GetMaxMana() > 0.95 and self.ownerhero:GetMana()/self.ownerhero:GetMaxMana() < 0.9 and parent:GetHealth()/parent:GetMaxHealth() > 0.8 then
				overchargedesiredstate = true
			end
		end
		if overchargeability:GetToggleState() ~= overchargedesiredstate then
			parent:CastAbilityToggle(overchargeability, self.ownerid)
		end
		
		--ItemManagement
		--List of useful items
		--Any Item not on the list is either handed over to the owner or drop on the ground ..after 15s (for itemabilities combination)..
		--[[List
			-Tranquils considered a useful item until regen is > 20 then dumped
			-Bottle A
			-Urn A
			-Midas A
			-Heart
			-Octarine
			-Spirit Vessel A
			-Cheese A
		--]]
		
		local function TimeIsLater( minutes, seconds )
			return GameRules.VGMAR:TimeIsLaterThan( minutes, seconds )
		end
		
		local accepteditemslist = {
			["item_tranquil_boots"] = TimeIsLater( 30, 0 ) == false,
			["item_bottle"] = true,
			["item_urn_of_shadows"] = parent:HasItemInInventory("item_spirit_vessel") == false,
			["item_hand_of_midas"] = true,
			["item_heart"] = true,
			["item_spirit_vessel"] = true,
			["item_octarine_core"] = true,
			["item_cheese"] = true,
			["item_travel_boots_2"] = true
		}
		
		for i = 0, 8, 1 do
			local slotitem = parent:GetItemInSlot(i)
			local slotitemname = nil
			if slotitem ~= nil then
				slotitemname = slotitem:GetName()
			end
			if slotitemname ~= self.itemdata[i].itemname then
				if slotitemname ~= nil then
					print("Wrote item change in slot: "..i.."itemname: "..slotitemname..", time: "..GameRules:GetDOTATime(false, false))
				else
					print("Wrote item change in slot: "..i.."itemname: empty, time: "..GameRules:GetDOTATime(false, false))
				end
				self.itemdata[i] = {itemname = slotitemname, timestamp = GameRules:GetDOTATime(false, false)}
			end
			if slotitem ~= nil and accepteditemslist[self.itemdata[i].itemname] ~= true and GameRules:GetDOTATime(false, false) > self.itemdata[i].timestamp + 10 and shouldmove() then
				if GameRules.VGMAR:GetHeroFreeInventorySlots( self.ownerhero, false, false ) > 0 and istethered == true then
					parent:AddNewModifier( self:GetCaster(), nil, "modifier_vgmar_ai_companion_wisp_force_stop", {duration = 2})
					parent:MoveToNPCToGiveItem(self.ownerhero, slotitem)
				else
					parent:AddNewModifier( self:GetCaster(), nil, "modifier_vgmar_ai_companion_wisp_force_stop", {duration = 1})
					parent:DropItemAtPosition(parent:GetAbsOrigin(), slotitem)
				end
			end
		end

		--ItemManagementEND
		--ScepterTalent Toggle
		if self.enablesceptertoggle == true then
			local aghstogglestate = parent:FindAbilityByName("vgmar_ai_companion_wisp_toggle_scepter"):GetToggleState()
			if aghstogglestate == true then
				if parent:FindAbilityByName("special_bonus_unique_wisp_5"):GetLevel() == 0 then
					parent:FindAbilityByName("special_bonus_unique_wisp_5"):SetLevel( 1 )
					parent:AddNewModifier( parent, nil, "modifier_vgmar_ai_companion_wisp_force_retether", {ownerindex = parent:entindex(), ownerid = self.ownerid})
				end
			else
				if parent:FindAbilityByName("special_bonus_unique_wisp_5"):GetLevel() == 1 then
					parent:FindAbilityByName("special_bonus_unique_wisp_5"):SetLevel( 0 )
					parent:AddNewModifier( parent, nil, "modifier_vgmar_ai_companion_wisp_force_retether", {ownerindex = parent:entindex(), ownerid = self.ownerid})
				end
			end
		end
		
		--AttackTalent Toggle
		if self.enablehittoggle == true then
			local hittogglestate = parent:FindAbilityByName("vgmar_ai_companion_wisp_toggle_autohit"):GetToggleState()
			if hittogglestate == true then
				if parent:FindAbilityByName("special_bonus_unique_wisp_4"):GetLevel() == 0 then
					parent:FindAbilityByName("special_bonus_unique_wisp_4"):SetLevel( 1 )
					parent:AddNewModifier( parent, nil, "modifier_vgmar_ai_companion_wisp_force_retether", {ownerindex = parent:entindex(), ownerid = self.ownerid})
				end
			else
				if parent:FindAbilityByName("special_bonus_unique_wisp_4"):GetLevel() == 1 then
					parent:FindAbilityByName("special_bonus_unique_wisp_4"):SetLevel( 0 )
					parent:AddNewModifier( parent, nil, "modifier_vgmar_ai_companion_wisp_force_retether", {ownerindex = parent:entindex(), ownerid = self.ownerid})
				end
			end
		end
		
		--TogglesState
		self.abonestate = self:GetCaster():FindAbilityByName("vgmar_ai_companion_wisp_toggle_scepter"):GetToggleState()
		self.abtwostate = self:GetCaster():FindAbilityByName("vgmar_ai_companion_wisp_toggle_autohit"):GetToggleState()
		self.abthreestate = self:GetCaster():FindAbilityByName("vgmar_ai_companion_wisp_toggle_tether"):GetToggleState()
	end

	--DeadCode
	if parent:IsAlive() == false then
		if not self.ownerhero:HasModifier("modifier_vgmar_ai_companion_respawntime") then
			self.ownerhero:AddNewModifier(self:GetCaster(), nil, "modifier_vgmar_ai_companion_respawntime", {respawntime = parent:GetTimeUntilRespawn()})
		end
	end
	
	--LevelingCode
		
	local levelinglist = {
		[1] = {level = 1, ability = "vgmar_ca_wisp_tether", talent = false},
		[2] = {level = 2, ability = "vgmar_ca_wisp_overcharge", talent = false},
		[3] = {level = 3, ability = "vgmar_ca_wisp_overcharge", talent = false},
		[4] = {level = 4, ability = "vgmar_ca_wisp_tether", talent = false},
		[5] = {level = 5, ability = "vgmar_ca_wisp_tether", talent = false},
		[6] = {level = 6, ability = "vgmar_ca_wisp_relocate", talent = false},
		[7] = {level = 7, ability = "vgmar_ca_wisp_overcharge", talent = false},
		[8] = {level = 8, ability = "vgmar_ca_wisp_tether", talent = false},
		[9] = {level = 9, ability = "vgmar_ca_wisp_overcharge", talent = false},
		[10] = {level = 10, ability = "special_bonus_attack_damage_60", talent = true},
		[11] = {level = 12, ability = "vgmar_ca_wisp_relocate", talent = false},
		[12] = {level = 15, ability = "special_bonus_unique_wisp_5", talent = true},
		[13] = {level = 18, ability = "vgmar_ca_wisp_relocate", talent = false},
		[14] = {level = 20, ability = "special_bonus_unique_wisp_4", talent = true},
		[15] = {level = 25, ability = "special_bonus_hp_regen_50", talent = true}
	}
	
	local level = parent:GetLevel()
	local points = parent:GetAbilityPoints()
	
	if points > 0 and levelinglist[self.abilitypointsspent + 1] ~= nil then
		if level >= levelinglist[self.abilitypointsspent + 1].level then
			if levelinglist[self.abilitypointsspent + 1].talent == true then
				parent:UpgradeAbility(parent:FindAbilityByName(levelinglist[self.abilitypointsspent + 1].ability))
				print("Wisp is Attempting to LevelUp a Talent "..levelinglist[self.abilitypointsspent + 1].ability)
			else
				parent:UpgradeAbility(parent:FindAbilityByName(levelinglist[self.abilitypointsspent + 1].ability))
			end
			self.abilitypointsspent = self.abilitypointsspent + 1
		end
	end
	
	if level >= 15 and self.enablesceptertoggle == false then
		self.enablesceptertoggle = true
	end
	if level >= 20 and self.enablehittoggle == false then
		self.enablehittoggle = true
	end
	
	--DangerAutoRelocateCode
	
	
end

function modifier_vgmar_ai_companion_wisp:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
		MODIFIER_EVENT_ON_RESPAWN,
	}
 
	return funcs
end

function modifier_vgmar_ai_companion_wisp:OnRespawn( kv )
	if IsServer() and kv.unit == self:GetCaster() then
		if self:GetCaster():FindAbilityByName("vgmar_ai_companion_wisp_toggle_scepter"):GetToggleState() ~= self.abonestate then
			self:GetCaster():FindAbilityByName("vgmar_ai_companion_wisp_toggle_scepter"):ToggleAbility()
		end
		if self:GetCaster():FindAbilityByName("vgmar_ai_companion_wisp_toggle_autohit"):GetToggleState() ~= self.abtwostate then
			self:GetCaster():FindAbilityByName("vgmar_ai_companion_wisp_toggle_autohit"):ToggleAbility()
		end
		if self:GetCaster():FindAbilityByName("vgmar_ai_companion_wisp_toggle_tether"):GetToggleState() ~= self.abthreestate then
			self:GetCaster():FindAbilityByName("vgmar_ai_companion_wisp_toggle_tether"):ToggleAbility()
		end
	end
end

function modifier_vgmar_ai_companion_wisp:GetDisableAutoAttack( kv )
	return 1
end

--------------------------------------------------------------------------------