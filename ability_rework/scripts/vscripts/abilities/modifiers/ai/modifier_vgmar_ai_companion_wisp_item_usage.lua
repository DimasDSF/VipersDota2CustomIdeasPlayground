--A modifier used as a visualisation for a custom spell

modifier_vgmar_ai_companion_wisp_item_usage = class({})

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

function modifier_vgmar_ai_companion_wisp_item_usage:IsHidden()
    return true
end

function modifier_vgmar_ai_companion_wisp_item_usage:IsPurgable()
	return false
end

function modifier_vgmar_ai_companion_wisp_item_usage:RemoveOnDeath()
	return false
end

function modifier_vgmar_ai_companion_wisp_item_usage:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_vgmar_ai_companion_wisp_item_usage:OnCreated( kv )
	if IsServer() then
		self.ownerid = kv.ownerid
		self.ownerindex = kv.ownerindex
		self.ownerhero = EntIndexToHScript(self.ownerindex)
		self:StartIntervalThink( 0.5 )
	end
end

function modifier_vgmar_ai_companion_wisp_item_usage:OnIntervalThink()
	local parent = self:GetParent()
	local istethered = self.ownerhero:HasModifier("modifier_wisp_tether_haste") and self.ownerhero:FindModifierByName("modifier_wisp_tether_haste"):GetCaster() == parent
	if self.bottle == nil then
		self.bottle = GameRules.VGMAR:GetItemFromInventoryByName( parent, "item_bottle", false, false, false )
	end
	if self.urn == nil then
		self.urn = GameRules.VGMAR:GetItemFromInventoryByName( parent, "item_urn_of_shadows", false, false, false )
		if self.urn == nil then
			self.urn = GameRules.VGMAR:GetItemFromInventoryByName( parent, "item_spirit_vessel", false, false, false )
		end
	end
	local function shouldmove()
		if parent:HasModifier("modifier_vgmar_ai_companion_wisp_force_stop") == false then
			return true
		else
			return false
		end
	end
	
	--Useful Data
	local ownerhpperc = self.ownerhero:GetHealth()/self.ownerhero:GetMaxHealth()
	local ownermanaperc = self.ownerhero:GetMana()/self.ownerhero:GetMaxMana()
	local selfhpperc = parent:GetHealth()/parent:GetMaxHealth()
	local selfmanaperc = parent:GetMana()/parent:GetMaxMana()
	
	--Item Functions
	local function BottleUsage( bottle )
		local bottlecharges = bottle:GetCurrentCharges()
		local castbottle = false
		if bottlecharges > 0 and parent:HasModifier("modifier_bottle_regeneration") == false and parent:HasModifier("modifier_rune_regen") == false then
			--Owner Treatment
			if istethered then
				if self.ownerhero:GetName() == "npc_dota_hero_huskar" then
					if ownerhpperc < 0.3 and selfhpperc < 0.90 then
						castbottle = true
					end
				else
					if ownerhpperc < 0.8 and selfhpperc < 0.90 then
						castbottle = true
					end
				end
				if selfmanaperc < 0.7 and ownermanaperc < 0.9 then
					castbottle = true
				end
			end
			--Self Treatment
			if selfhpperc < 0.5 then
				castbottle = true
			end
			if selfmanaperc < 0.2 then
				castbottle = true
			end
			--Final Decision
			if castbottle == true then
				parent:CastAbilityImmediately( bottle, self.ownerid )
			end
		end
	end
	
	local function UrnUsage()
		local urn = GameRules.VGMAR:GetItemFromInventoryByName( parent, "item_urn_of_shadows", false, false, false ) or GameRules.VGMAR:GetItemFromInventoryByName( parent, "item_spirit_vessel", false, false, false )
		local urncharges = urn:GetCurrentCharges()
		local casturn = false
		if urn ~= nil and urncharges > 0 and parent:HasModifier("modifier_item_urn_heal") == false and parent:HasModifier("modifier_item_spirit_vessel_heal") == false then
			--Owner Treatment
			if istethered then
				if self.ownerhero:GetName() == "npc_dota_hero_huskar" then
					if ownerhpperc < 0.4 and selfhpperc < 0.85 then
						casturn = true
					end
				else
					if ownerhpperc < 0.7 and selfhpperc < 0.85 then
						casturn = true
					end
				end
			end
			--Self Treatment
			if selfhpperc < 0.5 then
				casturn = true
			end
			--Final Decision
			if casturn == true then
				print("Wisp is Trying to cast urn")
				parent:AddNewModifier( self:GetParent(), nil, "modifier_vgmar_ai_companion_wisp_force_stop", {duration = 0.5})
				parent:CastAbilityOnTarget(parent, urn, self.ownerid)
			end
		end
	end
	
	local function CheeseUsage()
		if self.cheese == nil then
			self.cheese = GameRules.VGMAR:GetItemFromInventoryByName( parent, "item_cheese", false, false, false )
		end
		local usecheese = false
		if self.cheese ~= nil and parent:HasModifier("modifier_rune_regen") == false then
			--Owner Treatment
			if istethered then
				if self.ownerhero:GetName() == "npc_dota_hero_huskar" then
					if ownerhpperc < 0.2 and selfhpperc < 0.7 then
						usecheese = true
					end
				else
					if ownerhpperc < 0.4 and selfhpperc < 0.7 then
						usecheese = true
					end
				end
				if selfmanaperc < 0.3 and ownermanaperc < 0.7 then
					usecheese = true
				end
			end
			--Self Treatment
			if selfhpperc < 0.3 then
				usecheese = true
			end
			if selfmanaperc < 0.2 then
				usecheese = true
			end
			--Final Decision
			if usecheese == true then
				parent:CastAbilityImmediately( self.cheese, self.ownerid )
				self.cheese = nil
			end
		end
	end
	
	if IsServer() then
		if self:GetParent():IsAlive() then
			if shouldmove() then
				if self.bottle ~= nil then
					BottleUsage( self.bottle )
				end
				if parent:HasItemInInventory("item_urn_of_shadows") or parent:HasItemInInventory("item_spirit_vessel") then
					UrnUsage()
				end
				if parent:HasItemInInventory("item_cheese") then
					CheeseUsage()
				end
			end
		end
	end
end

--------------------------------------------------------------------------------