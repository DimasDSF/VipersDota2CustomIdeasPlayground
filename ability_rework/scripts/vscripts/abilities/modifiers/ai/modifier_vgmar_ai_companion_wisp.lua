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
	print("Attempting to find hero entity by id: ", self.ownerindex, "kv index: ", kv.ownerindex)
	if IsServer() then
		self.ownerhero = EntIndexToHScript(self.ownerindex)
		self.idlemovetime = math.floor(GameRules:GetDOTATime( false, true ))
		self:StartIntervalThink( 0.5 )
	end
end

--[[

]]--


function modifier_vgmar_ai_companion_wisp:OnIntervalThink()
	local parent = self:GetCaster()
	local distancetoowner = (parent:GetAbsOrigin() - self.ownerhero:GetAbsOrigin()):Length2D()
	local fountainpos = GetGroundPosition(Vector(-6945, -6525, 512), parent)
	local fountaindistance = (parent:GetAbsOrigin() - fountainpos):Length2D()
	local istethered = self.ownerhero:HasModifier("modifier_wisp_tether_haste") and self.ownerhero:FindModifierByName("modifier_wisp_tether_haste"):GetCaster() == parent
	local closestrune = Entities:FindByClassnameNearest("dota_item_rune", parent:GetOrigin(), 400.0)
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
		Restrict entering tower range if owner is not in range--]]
		if self.ownerhero:IsAlive() then
			if closestrune and shouldmove() and istethered == false and distancetoowner > 1000 then
				parent:PickupRune(closestrune)
			end
			if distancetoowner < 400 and shouldmove() then
				if GameRules:GetDOTATime( false, true ) > self.idlemovetime + 3 then
					parent:MoveToPosition(self.ownerhero:GetAbsOrigin()+RandomVector(390))
					self.idlemovetime = math.floor(GameRules:GetDOTATime( false, true ))
				end
			elseif (distancetoowner >= 400 and distancetoowner < 4000) and shouldmove() then
				parent:MoveToPosition(self.ownerhero:GetAbsOrigin()+RandomVector(300))
			elseif distancetoowner >= 4000 and shouldmove() then
				if self.tpboots and self.tpboots:GetCooldownTime() == 0 then
					--TeleportWithTravelBoots( self.tpboots, "vector", GetGroundPosition(self.ownerhero:GetAbsOrigin(), self.ownerhero) )
					if self:GetCaster():FindAbilityByName("vgmar_ai_companion_wisp_toggle_tether"):GetToggleState() == true and not parent:HasModifier("modifier_relocate_return_datadriven") then
						print("AI Considers teleporting to owner, Distance: ", distancetoowner)
						TeleportWithTravelBoots( self.tpboots, "unit", self.ownerhero )
					end
				end
			end
		elseif self.ownerhero:IsAlive() == false then
			if closestrune and shouldmove() then
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
					self:GetCaster():CastAbilityToggle(self:GetCaster():FindAbilityByName("vgmar_ca_wisp_overcharge"), kv.ownerid)
				end
				parent:RemoveModifierByName("modifier_wisp_tether")
				self.ownerhero:RemoveModifierByName("modifier_wisp_tether_haste")
				self.ownerhero:RemoveModifierByName("modifier_wisp_overcharge")
			end
		end
		
	
	
		--OverchargeCode
		local overchargeability = parent:FindAbilityByName("vgmar_ca_wisp_overcharge")
		local overchargedesiredstate = false
		if self.ownerhero:IsAlive() and istethered == true and self.ownerhero:GetHealth()/self.ownerhero:GetMaxHealth() < 0.9 then
			overchargedesiredstate = true
		else
			overchargedesiredstate = false
		end
		if overchargeability:GetToggleState() ~= overchargedesiredstate then
			parent:CastAbilityToggle(overchargeability, self.ownerid)
		end
		
		--ItemManagement
		--List of useful items
		--Any Item not on the list is either handed over to the owner or drop on the ground ..after 15s (for itemabilities combination)..
		
		--ScepterTalent Toggle
		if self.enablesceptertoggle == true then
			local aghstogglestate = parent:FindAbilityByName("vgmar_ai_companion_wisp_toggle_scepter"):GetToggleState()
			if aghstogglestate == true then
				if parent:FindAbilityByName("special_bonus_unique_wisp_5"):GetLevel() == 0 then
					parent:FindAbilityByName("special_bonus_unique_wisp_5"):SetLevel( 1 )
				end
			else
				if parent:FindAbilityByName("special_bonus_unique_wisp_5"):GetLevel() == 1 then
					parent:FindAbilityByName("special_bonus_unique_wisp_5"):SetLevel( 0 )
				end
			end
		end
		
		--AttackTalent Toggle
		if self.enablehittoggle == true then
			local hittogglestate = parent:FindAbilityByName("vgmar_ai_companion_wisp_toggle_autohit"):GetToggleState()
			if hittogglestate == true then
				if parent:FindAbilityByName("special_bonus_unique_wisp_4"):GetLevel() == 0 then
					parent:FindAbilityByName("special_bonus_unique_wisp_4"):SetLevel( 1 )
				end
			else
				if parent:FindAbilityByName("special_bonus_unique_wisp_4"):GetLevel() == 1 then
					parent:FindAbilityByName("special_bonus_unique_wisp_4"):SetLevel( 0 )
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
	--[[
		Set to same level as owner then follow an ability for level table
		Level all left talents
		tether
		overcharge
		overcharge
		tether
		overcharge
		relocate
		overcharge
		
		--
		
		"Ability11"		"special_bonus_unique_wisp_3"
		"Ability12"		"special_bonus_attack_damage_60"
		"Ability13"		"special_bonus_unique_wisp"
		"Ability14"		"special_bonus_unique_wisp_5"
		"Ability15"		"special_bonus_gold_income_25"
		"Ability16"		"special_bonus_unique_wisp_4"
		"Ability17"		"special_bonus_unique_wisp_2"
		"Ability18"		"special_bonus_hp_regen_50"
		
		--
		if level >= 15 then
			self.enablesceptertoggle = true
		end
		if level >= 20 then
			self.enablehittoggle = true
		end
	]]--
	
	--DangerAutoRelocateCode
	
	
end

function modifier_vgmar_ai_companion_wisp:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DISABLE_AUTOATTACK,
		MODIFIER_EVENT_ON_DEATH,
		MODIFIER_EVENT_ON_RESPAWN,
	}
 
	return funcs
end

function modifier_vgmar_ai_companion_wisp:OnDeath( kv )
	if IsServer() and kv.unit == self:GetCaster() then
	end
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