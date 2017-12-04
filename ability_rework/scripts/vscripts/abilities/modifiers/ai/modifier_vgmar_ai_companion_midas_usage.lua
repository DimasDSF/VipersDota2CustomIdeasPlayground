--A modifier used as a visualisation for a custom spell

modifier_vgmar_ai_companion_midas_usage = class({})

--------------------------------------------------------------------------------

function modifier_vgmar_ai_companion_midas_usage:GetTexture()
	return "custom/aimidasusage"
end

--------------------------------------------------------------------------------

function modifier_vgmar_ai_companion_midas_usage:IsHidden()
    return false
end

function modifier_vgmar_ai_companion_midas_usage:IsPurgable()
	return false
end

function modifier_vgmar_ai_companion_midas_usage:RemoveOnDeath()
	return false
end

function modifier_vgmar_ai_companion_midas_usage:DestroyOnExpire()
	return false
end

--------------------------------------------------------------------------------

function modifier_vgmar_ai_companion_midas_usage:OnCreated( kv )
	if IsServer() then
		self.midas = self:GetCaster():GetItemInSlot( kv.midasslot )
		self.ownerid = kv.ownerid
		self:StartIntervalThink( 0.5 )
	end
end

function modifier_vgmar_ai_companion_midas_usage:OnIntervalThink()
	local parent = self:GetCaster()
	local function shouldmove()
		if parent:HasModifier("modifier_vgmar_ai_companion_wisp_force_stop") == false then
			return true
		else
			return false
		end
	end
	
	local function MidasACreep( midas )
		local target = nil
		local enemycreeps = {}
		enemycreeps = FindUnitsInRadius(3, parent:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		if #enemycreeps > 0 then
			local fallbackcreep = nil
			for i=1,#enemycreeps do
				print("enemycreeps: ", i, "Distance: ", (enemycreeps[i]:GetAbsOrigin() - parent:GetAbsOrigin()):Length2D(), "index: ", enemycreeps[i]:entindex())
				if enemycreeps[i] ~= nil and ((enemycreeps[i]:GetAbsOrigin() - parent:GetAbsOrigin()):Length2D() < 1200 and parent:CanEntityBeSeenByMyTeam(enemycreeps[i])) and not (enemycreeps[i]:IsTower() or enemycreeps[i]:IsBuilding() or enemycreeps[i]:IsSummoned() or enemycreeps[i]:IsCourier()) then
					if enemycreeps[i]:GetClassname() == "npc_dota_creep_siege" then
						fallbackcreep = enemycreeps[i]
						break
					else
						fallbackcreep = enemycreeps[i]
					end
				end
			end
			if fallbackcreep ~= nil then
				target = fallbackcreep
			end
		end
		local neutralcreeps = {}
		neutralcreeps = FindUnitsInRadius(4, parent:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false)
		if #neutralcreeps > 0 then
			local maxlvl
			if parent:GetLevel() == 25 then
				maxlvl = 9999
			else
				maxlvl = 0
			end
			local lvltarget = nil
			for i=1,#neutralcreeps do
				print("neutralcreeps: ", i, "Distance: ", (neutralcreeps[i]:GetAbsOrigin() - parent:GetAbsOrigin()):Length2D(), "index: ", neutralcreeps[i]:entindex())
				if neutralcreeps[i] ~= nil and ((neutralcreeps[i]:GetAbsOrigin() - parent:GetAbsOrigin()):Length2D() < 1200 and parent:CanEntityBeSeenByMyTeam(neutralcreeps[i])) then
					if parent:GetLevel() == 25 then
						if neutralcreeps[i]:GetLevel() == 1 then
							lvltarget = neutralcreeps[i]
							break
						end
						if neutralcreeps[i]:GetLevel() < maxlvl then
							lvltarget = neutralcreeps[i]
							maxlvl = neutralcreeps[i]:GetLevel()
						end
					else
						if neutralcreeps[i]:GetLevel() == 6 then
							lvltarget = neutralcreeps[i]
							break
						end
						if neutralcreeps[i]:GetLevel() > maxlvl then
							lvltarget = neutralcreeps[i]
							maxlvl = neutralcreeps[i]:GetLevel()
						end
					end
				end
			end
			if lvltarget ~= nil then
				target = lvltarget
			end
		end
		if target ~= nil and shouldmove() and ((target:GetAbsOrigin() - parent:GetAbsOrigin()):Length2D() < 1200 and parent:CanEntityBeSeenByMyTeam(target)) then
			print("Wisp is trying to midas ", target:GetName(), "index: ", target:entindex())
			parent:AddNewModifier( self:GetCaster(), nil, "modifier_vgmar_ai_companion_wisp_force_stop", {duration = 1})
			parent:CastAbilityOnTarget(target, midas, self.ownerid)
		end
	end
	
	if IsServer() then
		self:SetStackCount(self:GetRemainingTime())
		if self.midas:GetCooldownTimeRemaining() <= 0 and self:GetCaster():IsAlive() then
			if self.midas ~= nil then
				MidasACreep( self.midas )
			end
		end
	end
end

function modifier_vgmar_ai_companion_midas_usage:DeclareFunctions()
	local funcs = {
        MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
    }
    return funcs
end

function modifier_vgmar_ai_companion_midas_usage:OnAbilityFullyCast( event )
	if IsServer() then
		if event.unit == self:GetCaster() then
			print("Wisp Called OnAbilityExecuted Event", event.ability:GetName())
			local hAbility = event.ability
			if hAbility ~= nil then
				if hAbility:GetName() == "item_hand_of_midas" then
					self:SetDuration( self.midas:GetCooldownTimeRemaining(), true )
				elseif hAbility:GetName() == "item_refresher" or hAbility:GetName() == "item_refresher_shard" then
					self:SetDuration( 0, true )
				end
			end
		end
	end
 
	return 0
end

--------------------------------------------------------------------------------