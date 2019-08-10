--Extensions for various standart libs

--Class Init
if not Extensions then
	Extensions = class({})
end

function Extensions:Init()
	print("[Extensions] : Initiating")
	LinkLuaModifier("modifier_extensions_eventhandler", "abilities/util/modifiers/modifier_extensions_eventhandler", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_extensions_dummy_timer", "abilities/util/modifiers/modifier_extensions_dummy_timer", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_extensions_dummy_scepter", "abilities/util/modifiers/modifier_extensions_dummy_scepter", LUA_MODIFIER_MOTION_NONE)
	Convars:RegisterConvar('vgmar_ext_debugdraw', "0", "Set to 1 to draw Extensions debug info. Set to 0 to disable.", 0)
	Convars:RegisterConvar('vgmar_ext_meteor_polygon_helper', "0", "Set to 1 to enable meteor hammer to gather cast targets and print a polygon later", 0)
	
	self.enttexttable = {
		lasttime = 0,
		texts = {}
	}
	self.herodamagetrackingtable = {}
	self.heroestable = {
		radiant = {},
		dire = {},
		filled = false
	}
	self.polygonhelperdata = {}
	print("[Extensions] : Attaching Event Handler")
	--Set to a unit present throughout the game
	local eventhandlerholderentity = "dota_goodguys_fort"
	local ehhent = Entities:FindByName(nil, eventhandlerholderentity)
	if ehhent then
		self.eventhandler = ehhent:AddNewModifier(ehhent, nil, "modifier_extensions_eventhandler", {})
	else
		Warning("[Extensions] : Failed to find Event Handler Holder Entity! \nThis will prevent all Extensions based event callbacks from working!\n")
	end
	print("[Extensions] : Starting 1s Thinker Timer")
	Timers:CreateTimer(function()
		Extensions:ShowEntText()
		Extensions:HeroDamageTrackingLoop()
		return 1.0
	end)
end

--Called from AllHeroesSpawned
function Extensions:InitHeroTables(radiant, dire)
	self.heroestable.radiant = radiant
	self.heroestable.dire = dire
	self.heroestable.filled = true
end

function Extensions:DebugDraw()
	if Convars:GetInt("vgmar_ext_debugdraw") == 1 then
		return true
	end
	return false
end

--Event Callbacks
function Extensions:Event_OnAttackLanded(attacker, target, event)
	if event and attacker and target then
		
	end
end

function Extensions:Event_OnAttackStart(attacker, target, event)
	if event and attacker and target then
		
	end
end

function Extensions:Event_OnDeath(unit, attacker, event)
	if attacker and unit and event then
		if unit and unit:GetName() == "npc_dota_roshan" then
			GameRules.VGMAR.roshandeathtime = GameRules:GetGameTime()
		end
	end
end

function Extensions:Event_OnDamaged(unit, attacker, event)
	if unit and attacker and event then
		
	end
end

function Extensions:Event_OnAbilityCast(unit, ability, target, event)
	if event and unit and ability then

	end
end

function Extensions:Event_OnOrder(unit, ability, target, event)
	if event and unit and ability then
		if ability:GetName() == "item_ward_observer" or ability:GetName() == "item_ward_sentry" or ability:GetName() == "item_ward_dispenser" and event.order_type == 5 then
			unit.wardpos = Vector(event.position_x, event.position_y, event.position_z)
		end
		if Convars:GetInt('vgmar_ext_meteor_polygon_helper') == 1 and ability:GetName() == "item_meteor_hammer" then
			if event.order_type == 5 then
				Extensions:PolygonHelperAdd(math.truncate(event.position_x, 2), math.truncate(event.position_y, 2), math.truncate(event.position_z, 2))
				return false
			elseif event.order_type == 12 then
				Extensions:PolygonHelperDraw()
				return false
			elseif event.order_type == 27 then
				Extensions:PolygonHelperPrint()
				return false
			elseif event.order_type == 32 then
				Extensions:PolygonHelperClear()
				return false
			end
		end
	end
end

function Extensions:PolygonHelperAdd(pos_x, pos_y, pos_z)
	local n = #Extensions.polygonhelperdata+1
	table.insert(Extensions.polygonhelperdata, n)
	Extensions.polygonhelperdata[n] = Vector(pos_x, pos_y, pos_z)
	DebugDrawBox(Vector(pos_x, pos_y, pos_z), Vector(-5, -5, 0), Vector(5, 5, 0), 0, 255, 0, 180, 3)
	if n-1 > 0 then
		DebugDrawLine(Vector(pos_x, pos_y, pos_z), Extensions.polygonhelperdata[n-1], 255, 255, 255, true, 3)
	end
	GameRules.VGMAR:DisplayClientError(0, "Saved ["..n.."] ("..pos_x..", "..pos_y..", "..pos_z..")")
end

function Extensions:PolygonHelperPrint()
	print("Meteor Poligon Helper Output: ")
	local text_data = ""
	local line_end = ""
	if #Extensions.polygonhelperdata > 0 then
		for i,v in ipairs(Extensions.polygonhelperdata) do
			if i % 2 == 0 then
				line_end = "\n"
			else
				line_end = ""
			end
			text_data = text_data.."["..i.."] = Vector("..math.truncate(v.x, 2)..", "..math.truncate(v.y, 2)..", "..math.truncate(v.z, 2).."), "..line_end
		end
		print(text_data)
		GameRules.VGMAR:DisplayClientError(0, "Printed Meteor Polygon to Console")
	else
		GameRules.VGMAR:DisplayClientError(0, "Meteor Polygon is Empty")
	end
end

function Extensions:DrawPolygon(polygon, polygonname, duration)
	local j = #polygon
	if #polygon > 0 then
		DebugDrawText(Extensions:getPolygonMidPoint(polygon)+Vector(0, 0, 10), tostring(polygonname), false, duration)
		for i= 1, #polygon do
			DebugDrawBox(polygon[i], Vector(-5, -5, 0), Vector(5, 5, 0), 0, 255, 0, 180, duration)
			DebugDrawLine(polygon[i], polygon[j], 255, 255, 255, true, duration)
			DebugDrawText(polygon[i]+Vector(0, 0, 10), tostring(i), false, duration)
			j = i
		end
	end
end

function Extensions:PolygonHelperDraw()
	local PHD = Extensions.polygonhelperdata
	if #Extensions.polygonhelperdata > 0 then
		GameRules.VGMAR:DisplayClientError(0, "Drawing Meteop Polygon")
		Extensions:DrawPolygon(PHD, "Meteor", 10)
	else
		GameRules.VGMAR:DisplayClientError(0, "Meteor Polygon is Empty")
	end
end

function Extensions:PolygonHelperClear()
	GameRules.VGMAR:DisplayClientError(0, "Cleared Selected Polygon")
	Extensions.polygonhelperdata = {}
end

function Extensions:isPointInsidePolygon(point, polygon)
	local ret = false
	local j = #polygon
	if Extensions:DebugDraw() then
		DebugDrawBox(point, Vector(-10, -10, 0), Vector(10, 10, 0), 255, 255, 0, 180, 2)
	end
	for i = 1, #polygon do
		if Extensions:DebugDraw() then
			DebugDrawBox(polygon[i], Vector(-5, -5, 0), Vector(5, 5, 0), 0, 255, 0, 180, 2)
			DebugDrawLine(polygon[i], polygon[j], 0, 0, 255, true, 2)
		end
	    if (polygon[i].y < point.y and polygon[j].y >= point.y or polygon[j].y < point.y and polygon[i].y >= point.y) then
	        if (polygon[i].x + ( point.y - polygon[i].y ) / (polygon[j].y - polygon[i].y) * (polygon[j].x - polygon[i].x) < point.x) then
	            ret = not ret
	        end
	    end
	    j = i
	end
	return ret
end

function Extensions:getPolygonMidPoint(polygon)
	local midPoint = Vector(0,0,0)
    for i=1,#polygon do
		midPoint = midPoint + polygon[i]
    end
    midPoint = midPoint / #polygon
    return midPoint
end

function Extensions:getPolygonMaxDistancePoint(polygon)
	local midpoint = Extensions:getPolygonMidPoint(polygon)
	local dX = 0
	local dY = 0
	local maxX = 0
	local maxY = 0
	for i=1,#polygon do
		if math.abs(polygon[i].x - midpoint.x) > dX then
			dX = math.abs(polygon[i].x - midpoint.x)
			maxX = polygon[i].x
		end
		if math.abs(polygon[i].y - midpoint.y) > dY then
			dY = math.abs(polygon[i].y - midpoint.y)
			maxY = polygon[i].y
		end
	end
	return Extensions:GetCoordDistance(midpoint, Vector(maxX, maxY, 0))
end

function Extensions:getRandomPointInPolygon( polygon )
	local minX = polygon[1].x
	local maxX = polygon[1].x
	local minY = polygon[1].y
	local maxY = polygon[1].y

	for k,v in pairs(polygon) do
		minX = math.min( v.x, minX )
		maxX = math.max( v.x, maxX )
		minY = math.min( v.y, minY )
		maxY = math.max( v.y, maxY )
	end

	local nextPoint
	repeat
		nextPoint = Vector(RandomFloat(minX,maxX), RandomFloat(minY,maxY), 0)
	until Extensions:isPointInsidePolygon(nextPoint, polygon)

	return nextPoint
end

function Extensions:GetCoordDistance(vector1,vector2)
  return math.sqrt(((vector2.x-vector1.x)^2)+((vector2.y-vector1.y)^2))
end

function Extensions:UnitIsInAABBArea(unit, vstart, vend)
	if unit and vstart ~= nil and vend ~= nil then
		local vsx = vstart.y
		local vsy = vstart.y
		local vex = vend.x
		local vey = vend.x
		local sortedAABB = {AX = 999999, AY = 999999, BX = -999999, BY = -999999}
		if vsx <= vex then
			sortedAABB.AX = vsx
			sortedAABB.BX = vex
		else
			sortedAABB.AX = vex
			sortedAABB.BX = vsx
		end
		if vsy <= vey then
			sortedAABB.AY = vsy
			sortedAABB.BY = vey
		else
			sortedAABB.AY = vey
			sortedAABB.BY = vsy
		end
		local unitpos = unit:GetAbsOrigin()
		if unitpos.x >= sortedAABB.AX and unitpos.x <= sortedAABB.BX then
			if unitpos.y >= sortedAABB.AY and unitpos.y <= sortedAABB.BY then
				return true
			end
		end
		return false
	end
	return nil
end

--Extensions
function Extensions:FindUnitsInCone(teamNumber, vDirection, vPosition, startRadius, endRadius, flLength, hCacheUnit, teamFilter, typeFilter, flagFilter, findOrder, bCache)
	local vDirectionCone = Vector( vDirection.y, -vDirection.x, 0.0 )
	local units = FindUnitsInRadius(teamNumber, vPosition, hCacheUnit, endRadius + flLength, teamFilter, typeFilter, flagFilter, findOrder, bCache )
	local unitTable = {}
	if #units > 0 then
		for _,unit in pairs(units) do
			if unit ~= nil then
				local vToPotentialTarget = unit:GetOrigin() - vPosition
				local flSideAmount = math.abs( vToPotentialTarget.x * vDirectionCone.x + vToPotentialTarget.y * vDirectionCone.y + vToPotentialTarget.z * vDirectionCone.z )
				local unit_distance_from_caster = ( vToPotentialTarget.x * vDirection.x + vToPotentialTarget.y * vDirection.y + vToPotentialTarget.z * vDirection.z )

				local max_increased_radius_from_distance = endRadius - startRadius
				local pct_distance = unit_distance_from_caster / flLength
				local radius_increase_from_distance = max_increased_radius_from_distance * pct_distance
				if ( flSideAmount < startRadius + radius_increase_from_distance ) and ( unit_distance_from_caster > 0.0 ) and ( unit_distance_from_caster < flLength ) then
					table.insert(unitTable, unit)
				end
			end
		end
		if self:DebugDraw() then
			DebugDrawLine(vPosition+(vDirectionCone*startRadius), vPosition+(vDirection*flLength)+(vDirectionCone*(endRadius)), 0, 0, 255, true, 2)
			DebugDrawLine(vPosition+(vDirectionCone*-startRadius), vPosition+(vDirection*flLength)+(vDirectionCone*(-1*(endRadius))), 0, 0, 255, true, 2)
			DebugDrawLine(vPosition+(vDirection*flLength)+(vDirectionCone*-endRadius), vPosition+(vDirection*flLength)+(vDirectionCone*endRadius), 0, 0, 255, true, 2)
			DebugDrawLine(vPosition+(vDirectionCone*-startRadius), vPosition+(vDirectionCone*startRadius), 0, 0, 255, true, 2)
		end
	end
	return unitTable
end

function Extensions:DoCleaveAttackPositional(attacker, target, position, direction, checkDistantCleave, damageInfo, startRadius, endRadius, length, teamFilter, typeFilter, flagFilter, particle)
	local isDistantCleave = false
	if checkDistantCleave then
		if attacker ~= nil and target ~= nil then
			if (attacker:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() > attacker:Script_GetAttackRange() + attacker:GetAttackRangeBuffer() then
				isDistantCleave = true
			end
		end
	end
	local victims = {}
	if isDistantCleave then
		victims = Extensions:FindUnitsInCone(attacker:GetTeamNumber(), direction, position, startRadius, endRadius, length, nil, teamFilter, typeFilter, flagFilter, FIND_CLOSEST, false)
		if self:DebugDraw() then
			DebugDrawLine(position, position+(direction*length), 0, 255, 0, true, 2)
		end
	else
		victims = Extensions:FindUnitsInCone(attacker:GetTeamNumber(), direction, attacker:GetAbsOrigin(), startRadius, endRadius, length, nil, teamFilter, typeFilter, flagFilter, FIND_CLOSEST, false)
		if self:DebugDraw() then
			DebugDrawLine(attacker:GetAbsOrigin(), attacker:GetAbsOrigin()+(direction*length), 255, 0, 0, true, 2)
		end
	end
	local targetarr = {target}
	victims = table.sub(victims, targetarr)
	if self:DebugDraw() then print("Found "..#victims.." Units for cleave") end
	if #victims > 0 then
		if self:DebugDraw() then
			DebugDrawText(attacker:GetAbsOrigin()+Vector(0,0,100), "Cleave Targets: "..#victims, false, 2)
		end
		for _,unit in pairs(victims) do
			if target ~= nil and unit ~= target then
				local damageTable = {
					victim = unit,
					attacker = attacker,
					damage = damageInfo.damage,
					damage_type = damageInfo.type
				}
				ApplyDamage(damageTable)
				if self:DebugDraw() then
					DebugDrawBox(unit:GetAbsOrigin(), Vector(-5, -5, 0), Vector(5, 5, 0), 0, 255, 0, 180, 2)
					DebugDrawText(unit:GetAbsOrigin()+Vector(0,0,50), "CleaveDMG: "..damageInfo.damage, false, 2)
				end
			end
		end
		--Draw Particle
		local pfx
		if isDistantCleave then
			pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, target)
			ParticleManager:SetParticleControl( pfx, 0, target:GetOrigin() )
			ParticleManager:SetParticleControl( pfx, 1, target:GetOrigin() )
		else
			pfx = ParticleManager:CreateParticle(particle, PATTACH_CUSTOMORIGIN, attacker)
			ParticleManager:SetParticleControl( pfx, 0, attacker:GetOrigin() )
			ParticleManager:SetParticleControl( pfx, 1, attacker:GetOrigin() )
		end
		ParticleManager:SetParticleControlForward( pfx, 0, direction )
		ParticleManager:ReleaseParticleIndex( pfx )
	end
end

function Extensions:GetOpposingTeamNumber(teamNumber)
	if teamNumber and type(teamNumber) == "number" then
		if teamNumber == 3 then
			return 2
		elseif teamNumber == 2 then
			return 3
		end
	end
	return nil
end

function Extensions:CalculateArmorDamageReductionMultiplier(armor)
	if type(armor) == "number" then
		return 1-((0.052*armor)/(0.9+0.048*armor))
	end
	return nil
end

function Extensions:IsVisibleToTeam(entity, team)
	if entity == nil then 
		return false
	end
	if type(team) == "string" then
		if team == "radiant" then
			team = 2
		elseif team == "dire" then
			team = 3
		end
	end
	if type(team) ~= "number" or (team ~= 2 and team ~= 3) then
		LogLib:Log_Error("Error: Invalid team: "..tostring(team), 0, "Extensions:VisibleToTeam()::")
		return nil
	else
		local unitcheck = FindUnitsInRadius(team, entity:GetAbsOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_OTHER, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
		local unitmatch = false
		for i,v in ipairs(unitcheck) do
			if v==entity then
				unitmatch = true
			end
		end
		return unitmatch
	end
end

--An inaccurate Auto-attack damage prediction
function Extensions:PredictAttackDamage(attacker, target)
	if attacker and target then
		if attacker:IsNull() == false and target:IsNull() == false then
			if target:IsAlive() then
				return attacker:GetAverageTrueAttackDamage(attacker)*Extensions:CalculateArmorDamageReductionMultiplier(target:GetPhysicalArmorValue(false))
			end
		end
	end
	return 0
end

function Extensions:CallWithDelay(delay, gametime, func)
	Timers:CreateTimer({
		useGameTime = gametime,
		endTime = delay, -- when this timer should first execute, you can omit this if you want it to run first on the next frame
		callback = func
	})
end

--EntText with offsets
function Extensions:AddEntText(entindex, text, dur)
	if entindex ~= nil and text ~= nil then
		if self.enttexttable.texts[entindex] == nil then
			table.insert(self.enttexttable.texts, entindex)
			self.enttexttable.texts[entindex] = {}
		end
		if self.enttexttable.texts[entindex] ~= nil then
			table.insert(self.enttexttable.texts[entindex], {text, dur or 1})
		else
			LogLib:Log_Warning("entindex: "..entindex, 0, "Extensions:EntText failed to AddText")
		end
	end
end

function Extensions:ShowEntText()
	local gametimeseconds = math.floor(GameRules:GetDOTATime(false, false))
	if self.enttexttable.texts ~= {} then
		if self.enttexttable.lasttime < gametimeseconds then
			for k,v in pairs(self.enttexttable.texts) do
				if type(v) == "table" then
					local unit = EntIndexToHScript(tonumber(k))
					if unit then
						local text = ""
						local maxdur = 1
						for i,j in ipairs(v) do
							text = text..j[1].."\n"
							maxdur = math.max(maxdur, j[2])
						end
						DebugDrawText(unit:GetAbsOrigin(), text, false, maxdur)
					else
						print("unit "..k.." is missing")
					end
				end
			end
			self.enttexttable.texts = {}
			self.enttexttable.lasttime = gametimeseconds
		end
	end
end

local DAMAGE_TRACKING_MAX_SECONDS = 10
--Tracking Hero Damage
function Extensions:TrackDamage(entindex, damage, damagetype, isHero)
	if self.herodamagetrackingtable[entindex] == nil then
		table.insert(self.herodamagetrackingtable, entindex)
		self.herodamagetrackingtable[entindex] = {}
		for i=1,DAMAGE_TRACKING_MAX_SECONDS do
			self.herodamagetrackingtable[entindex][i] = {herodmg = {phys = 0, magic = 0, pure = 0}, nonherodmg = {phys = 0, magic = 0, pure = 0}}
		end
	end
	if self.herodamagetrackingtable[entindex] ~= nil then
		--No need for super precise tracking -> drop decimals here
		damage = math.floor(damage)
		local damagetable = self.herodamagetrackingtable[entindex]
		if isHero then
			if damagetype == DAMAGE_TYPE_PURE then	
				damagetable[1].herodmg.pure = damagetable[1].herodmg.pure + math.max(0, damage)
			elseif damagetype == DAMAGE_TYPE_MAGICAL then
				damagetable[1].herodmg.magic = damagetable[1].herodmg.magic + math.max(0, damage)
			else
				damagetable[1].herodmg.phys = damagetable[1].herodmg.phys + math.max(0, damage)
			end
		else
			if damagetype == DAMAGE_TYPE_PURE then	
				damagetable[1].nonherodmg.pure = damagetable[1].nonherodmg.pure + math.max(0, damage)
			elseif damagetype == DAMAGE_TYPE_MAGICAL then
				damagetable[1].nonherodmg.magic = damagetable[1].nonherodmg.magic + math.max(0, damage)
			else
				damagetable[1].nonherodmg.phys = damagetable[1].nonherodmg.phys + math.max(0, damage)
			end
		end
	else
		LogLib:Log_Error("Error: Failed to initialize a tracking table for entindex: "..tonumber(entindex), 0, "Extensions:TrackDamage():: Error")
	end
end

function Extensions:QueryHeroDamage(entindex, sec, types, addHero, addNonHero)
	local damagetable = self.herodamagetrackingtable[entindex]
	--This unit either was not initiated on start and not attacked to start tracking or is not enabled for tracking -> return 0
	if damagetable == nil then return 0 end
	--Clamping time value
	sec = math.clamp(1, sec, DAMAGE_TRACKING_MAX_SECONDS)
	local ret = 0
	for i=1,sec,1 do
		if addHero then
			if bit.bor(DAMAGE_TYPE_PHYSICAL, types) == types then
				ret = ret + damagetable[i].herodmg.phys
			end
			if bit.bor(DAMAGE_TYPE_MAGICAL, types) == types then
				ret = ret + damagetable[i].herodmg.magic
			end
			if bit.bor(DAMAGE_TYPE_PURE, types) == types then
				ret = ret + damagetable[i].herodmg.pure
			end
		end
		if addNonHero then
			if bit.bor(DAMAGE_TYPE_PHYSICAL, types) == types then
				ret = ret + damagetable[i].nonherodmg.phys
			end
			if bit.bor(DAMAGE_TYPE_MAGICAL, types) == types then
				ret = ret + damagetable[i].nonherodmg.magic
			end
			if bit.bor(DAMAGE_TYPE_PURE, types) == types then
				ret = ret + damagetable[i].nonherodmg.pure
			end
		end
	end
	return ret
end

function Extensions:InitHeroDamageTrackingTable(heroes)
	for _,i in ipairs(heroes) do
		--Init tables
		self:TrackDamage(i:entindex(), 0, DAMAGE_TYPE_PHYSICAL, false)
	end
end

function Extensions:HeroDamageTrackingLoop()
	if GameRules:IsGamePaused() == false then
		for i,v in pairs(self.herodamagetrackingtable) do
			if type(v) == "table" then
				for k=DAMAGE_TRACKING_MAX_SECONDS, 2, -1 do
					v[k].herodmg = v[k-1].herodmg
					v[k].nonherodmg = v[k-1].nonherodmg
				end
				v[1] = {herodmg = {phys = 0, magic = 0, pure = 0}, nonherodmg = {phys = 0, magic = 0, pure = 0}}
			end
		end
	end
end

function Extensions:GetUnitDistance(unit1, unit2)
	if unit1 and unit2 then
		if Extensions:DebugDraw() then print(unit1:GetName()..' to '..unit2:GetName()..' Distance: '..(unit1:GetAbsOrigin() - unit2:GetAbsOrigin()):Length2D()) end
		return (unit1:GetAbsOrigin() - unit2:GetAbsOrigin()):Length2D()
	end
	return nil
end

function Extensions:GetPtoPDistance(point1, point2)
	if point1 and point2 then
		return (point1 - point2):Length2D()
	end
	return nil
end

function Extensions:GetUtoTDirectionVector(unit, target)
	if unit and target then
		if Extensions:DebugDraw() then
			DebugDrawBox(unit:GetAbsOrigin(), Vector(-3, -3, 0), Vector(3, 3, 0), 255, 255, 255, 180, 10)
			DebugDrawLine(unit:GetAbsOrigin(), unit:GetAbsOrigin()+((target:GetAbsOrigin()-unit:GetAbsOrigin()):Normalized()*100), 255, 255, 255, true, 10)
		end
		return (target:GetAbsOrigin()-unit:GetAbsOrigin()):Normalized()
	end
	return nil
end

function Extensions:GetPtoPDirectionVector(point1, point2)
	if point1 ~= nil and point2 ~= nil then
		if Extensions:DebugDraw() then
			DebugDrawBox(point1, Vector(-3, -3, 0), Vector(3, 3, 0), 255, 255, 255, 180, 10)
			DebugDrawLine(point1, point1+((point2-point1):Normalized()*100), 255, 255, 255, true, 10)
		end
		return (point2-point1):Normalized()
	end
	return nil
end

Extensions.locations = { 
	fountains = {
		Dire = {
			[1] = Vector(6491.08, 6667.34, 511.29), [2] = Vector(6290.1, 6304.22, 510.59), 
			[3] = Vector(6837.5, 5847.26, 512), [4] = Vector(7358.88, 5884.28, 512), 
			[5] = Vector(7705.24, 6261.53, 512), [6] = Vector(7354.76, 6523.97, 512), 
			[7] = Vector(7159.83, 6599.16, 512), [8] = Vector(7067.16, 6761.7, 512), 
			[9] = Vector(6898.34, 6761.7, 512), [10] = Vector(6798.84, 6483.56, 512)
		},
		Radiant = {
			[1] = Vector(-6984.65, -5868.4, 512), [2] = Vector(-7363.28, -5984.72, 512), 
			[3] = Vector(-7465.79, -6417.66, 512), [4] = Vector(-7678.62, -6525.28, 512), 
			[5] = Vector(-7308.26, -6782.12, 512), [6] = Vector(-7076.28, -7130.36, 512), 
			[7] = Vector(-6714.3, -7069.71, 512), [8] = Vector(-6476.88, -7018.35, 512), 
			[9] = Vector(-6438.54, -6424.77, 512)
		}
	},
	secretshops = {
		Dire = {
			[1] = Vector(5122.48, -1052.58, 384), [2] = Vector(5056.53, -2093.32, 256), 
			[3] = Vector(4295.94, -1996.78, 256), [4] = Vector(4310.32, -1449.75, 256), 
			[5] = Vector(4691.83, -1082.35, 384)
		},
		Radiant = {
			[1] = Vector(-4345.31, 1662.13, 256), [2] = Vector(-4337.66, 1183.31, 256), 
			[3] = Vector(-5204.84, 1197.97, 256), [4] = Vector(-5075.88, 1619.81, 256), 
			[5] = Vector(-4597.5, 1761.22, 256)
		}
	}
}

function Extensions:SimulateItemPurchase(unit, itemname)
	local retitem = nil
	if unit then
		local price = KeyValuesManager:GetItemKV(itemname).ItemCost
		if unit:GetGold() >= price then
			local unitteam = unit:GetTeamNumber()
			if unitteam == 3 or unitteam == 2 then
				local itemslot = nil
				if unitteam == 2 and Extensions:isPointInsidePolygon(unit:GetAbsOrigin(), self.locations.fountains.Radiant) then
					itemslot = InvManager:GetHeroFirstFreeInventorySlot(unit, true, true, true)
				elseif unitteam == 3 and Extensions:isPointInsidePolygon(unit:GetAbsOrigin(), self.locations.fountains.Dire) then
					itemslot = InvManager:GetHeroFirstFreeInventorySlot(unit, true, true, true)
				else
					itemslot = InvManager:GetHeroFirstFreeInventorySlot(unit, false, false, true)
				end
				if itemslot ~= nil then
					local item = CreateItem(itemname, unit, unit)
					item.suggestedSlot = itemslot
					unit:SpendGold(price, 2)
					retitem = unit:AddItem(item)
					return retitem
				end
			end
		end
	end
	return nil
end

function Extensions:GetCreepLaneAtSpawn(unit)
	local creepspawns = {
		[DOTA_TEAM_BADGUYS] = {
			["top"] = Vector(3253, 5832, 384),
			["mid"] = Vector(4071, 3638, 384),
			["bot"] = Vector(6288, 3626, 384)
		},
		[DOTA_TEAM_GOODGUYS] = {
			["top"] = Vector(-6596, -3916, 384),
			["mid"] = Vector(-4982, -4445, 384),
			["bot"] = Vector(-3682, -6113, 384)
		}
	}
	if unit and unit:GetTeamNumber() == DOTA_TEAM_BADGUYS or unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		local shortestdist = 999999
		local closestlane = nil
		for spawn, coord in pairs(creepspawns[unit:GetTeamNumber()]) do
			local dist = (unit:GetAbsOrigin() - coord):Length2D()
			if dist < shortestdist then
				shortestdist = dist
				closestlane = spawn
			end
		end
		return closestlane
	end
	return nil
end

function Extensions:CreateTimedModifierThinker( hCaster, hAbility, modifierName, paramTable, vOrigin, nTeamNumber, bPhantomBlocker, nDuration )
	local retdummy = CreateModifierThinker(hCaster, hAbility, modifierName, paramTable, vOrigin, nTeamNumber, bPhantomBlocker)
	if nDuration then
		retdummy:AddNewModifier(retdummy, nil, "modifier_extensions_dummy_timer", {duration = nDuration})
	end
	return retdummy
end

function Extensions:IsPositionFoWVisible(vOrigin, hUnit)
	local ret = false
	if hUnit then
		local dummy = CreateModifierThinker(nil, nil, nil, {}, vOrigin, Extensions:GetOpposingTeamNumber(hUnit:GetTeamNumber()), false)
		ret = hUnit:CanEntityBeSeenByMyTeam(dummy)
		UTIL_Remove(dummy)
	end
	return ret
end

function Extensions:CastAbilityThroughADummy(hAbility, hUnit, hTarget)
	local uncastable = {
		["rubick_spell_steal"] = true,
		["legion_commander_duel"] = true,
		["alchemist_unstable_concoction"] = true,
		["spirit_breaker_charge_of_darkness"] = true,
		["windrunner_focusfire"] = true,
		["vengefulspirit_nether_swap"] = true,
		["phantom_assassin_phantom_strike"] = true,
		["razor_static_link"] = true,
		["oracle_fortunes_end"] = true,
		["riki_blink_strike"] = true,
		["lion_mana_drain"] = true,
		["lich_sinister_gaze"] = true,
		["death_prophet_spirit_siphon"] = true,
		["bane_fiends_grip"] = true,
		["juggernaut_omni_slash"] = true,
		["chaos_knight_reality_rift"] = true
	}
	if hUnit and hTarget and hAbility then
		--Channelled abilities dont work with a dummy casting so dont try
		if bit.bor(DOTA_ABILITY_BEHAVIOR_CHANNELLED, hAbility:GetBehavior()) ~= hAbility:GetBehavior() and not uncastable[hAbility:GetName()] then
			local dummy = Extensions:CreateTimedModifierThinker(hUnit, nil, nil, {}, hUnit:GetAbsOrigin(), hUnit:GetTeamNumber(), false, 120)
			dummy:SetOwner(hUnit)
			if Extensions:DebugDraw() then
				Extensions:AddEntText(dummy:entindex(), "Setting Team: "..tostring(hUnit:GetTeamNumber()).." | Dummy Team: "..tostring(dummy:GetTeamNumber()))
			end
			local ability = dummy:AddAbility(hAbility:GetName())
			ability:SetStolen(true)
			ability:SetHidden(true)
			if Extensions:DebugDraw() then
				Extensions:AddEntText(dummy:entindex(), "Adding ability: "..tostring(ability:GetName()))
			end
			ability:SetLevel(hAbility:GetLevel())
			if Extensions:DebugDraw() then
				Extensions:AddEntText(dummy:entindex(), "Setting ability level to: "..tostring(hAbility:GetLevel()).."\n | Successful: "..tostring(hAbility:GetLevel()==ability:GetLevel()), 10)
			end
			dummy:SetBaseDamageMin(hUnit:GetBaseDamageMin())
			if Extensions:DebugDraw() then
				Extensions:AddEntText(dummy:entindex(), "Setting Min Attack Damage: "..tostring(hUnit:GetBaseDamageMin()).."\n | Successful: "..tostring(hUnit:GetBaseDamageMin() == dummy:GetBaseDamageMin()))
			end
			dummy:SetBaseDamageMax(hUnit:GetBaseDamageMax())
			if Extensions:DebugDraw() then
				Extensions:AddEntText(dummy:entindex(), "Setting Max Attack Damage: "..tostring(hUnit:GetBaseDamageMax()).."\n | Successful: "..tostring(hUnit:GetBaseDamageMax() == dummy:GetBaseDamageMax()))
				Extensions:AddEntText(dummy:entindex(), "Unit Has Scepter: "..tostring(hUnit:HasScepter()))
			end
			if hUnit:HasScepter() then
				dummy:AddNewModifier(dummy, nil, "modifier_extensions_dummy_scepter", {})
				if Extensions:DebugDraw() then
					Extensions:AddEntText(dummy:entindex(), "Adding Scepter: \n | Successful: "..tostring(dummy:HasScepter()))
				end
			end
			if type(hTarget) == type(Vector()) then
				if Extensions:DebugDraw() then
					Extensions:AddEntText(dummy:entindex(), "Casting ability on: "..tostring(hTarget['x'])..'.'..tostring(hTarget['y'])..'.'..tostring(hTarget['z']))
				end
				dummy:SetCursorPosition(hTarget)
			else
				if Extensions:DebugDraw() then
					Extensions:AddEntText(dummy:entindex(), "Casting ability on: "..tostring(hTarget:GetName()))
				end
				dummy:SetCursorCastTarget(hTarget)
			end
			ability:OnSpellStart()
		end
	end
end

--math
function math.scale( min, value, max )
	if ((min == nil or max == nil or value == nil) or (type(min) ~= 'number' or type(max) ~= 'number' or type(value) ~= 'number')) then return nil end
	return value * (max - min) + min
end

function math.map(value, explow, exphigh, outlow, outhigh)
	if ((outlow == nil or outhigh == nil or explow == nil or exphigh == nil or value == nil) or (type(outlow) ~= 'number' or type(outhigh) ~= 'number' or type(explow) ~= 'number' or type(exphigh) ~= 'number' or type(value) ~= 'number')) then return nil end
	return outlow + (value - explow) * (outhigh - outlow) / (exphigh - explow)
end

function math.clamp(min, value, max)
	if ((min == nil or max == nil or value == nil) or (type(min) ~= 'number' or type(max) ~= 'number' or type(value) ~= 'number')) then return nil end
	if (min > max) then return nil end
	if (value < min) then return min end
	if (value > max) then return max end
	return value
end

function math.mapl(value, explow, exphigh, outlow, outhigh)
	if ((outlow == nil or outhigh == nil or explow == nil or exphigh == nil or value == nil) or (type(outlow) ~= 'number' or type(outhigh) ~= 'number' or type(explow) ~= 'number' or type(exphigh) ~= 'number' or type(value) ~= 'number')) then return nil end
	if outlow > outhigh then
		return math.clamp(outhigh, math.map(value, explow, exphigh, outlow, outhigh), outlow)
	else
		return math.clamp(outlow, math.map(value, explow, exphigh, outlow, outhigh), outhigh)
	end
end

function math.isNaN(input)
	return input ~= input
end

function math.round(input)
	if ((input == nil) or (type(input) ~= 'number')) then return nil end
    if input >= 0 then
		return math.floor(input + 0.5)
	else
		return math.ceil(input - 0.5)
	end
end

function math.truncate(input, num)
	if ((input == nil or num == nil) or ((type(input) ~= 'number') or type(num) ~= 'number')) then return nil end
	return math.round(input * (10 ^ num)) / (10 ^ num);
end

function math.bool(input)
	if input then
		return 1
	end
	return 0
end

--string
function string.split(input, delimiter)
	local output = {}
	if ((input == nil or delimiter == nil) or (type(input) ~= 'string' or type(delimiter) ~= 'string')) then return output end
    for match in input:gmatch("([^"..delimiter.."]+)") do
        table.insert(output, match)
    end
    return output
end

--table
function table.shallowcopy(orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = orig_value
		end
	else
		copy = orig
	end
	return copy
end

function table.sub(t2, t1)
    local t = {}
    local ret = table.shallowcopy(t2)
    for i = 1, #t1 do
        t[t1[i]] = true;
    end
    for i = #ret, 1, -1 do
        if t[ret[i]] then
            table.remove(ret, i);
        end
    end
    return ret
end

function table.random(intable)
	if type(intable) == "table" then
		local valtable = {}
		for _, value in pairs(intable) do
			table.insert(valtable, value)
		end
		if #valtable > 1 then
			return valtable[math.random(1, #valtable)]
		elseif #valtable > 0 then
			return valtable[1]
		end
	end
	return nil
end

--TODO:UTests
function table.getkeys(intable)
	if intable == nil then return nil end
	if type(intable) ~= 'table' then return {} end
	local ret = {}
	for k,_ in pairs(intable) do
		table.insert(ret, k)
	end
	return ret
end

function table.contains(intable, key)
	if intable == nil then return nil end
	if type(intable) ~= 'table' then return nil end
	if key == nil then return false end
	if #intable > 0 then
		if type(key) ~= 'table' then
			for _, v in ipairs(intable) do
				if v == key then return true end
			end
		else
			for _, v in ipairs(intable) do
				if table.equals(v, key) then return true end
			end
		end
	end
	return false
end

function table.equals(table1, table2)
    if type(table1)==type(table2) and type(table1)=='table' then
        if #table1 == #table2 then
            for i=1, #table1 do
                if type(table1[i])==type(table2[i]) and type(table1[i])=='table' then
                    if table.equals(table1[i], table2[i]) == false then
                       return false 
                    end
                else
                    if table1[i] ~= table2[i] then
                       return false 
                    end
                end
            end
            return true
        else
            return false 
        end
    else
		if type(table1)==type(table2) then
			if table1 ~= table2 then
				return false
			end
			return true
		else
			return false
		end
    end
end

--CBaseEntity
--Returns true for Creeps, Heroes, Couriers
--Useful for Crits, Cleave attacks etc.
--due to OnAttackStart working with items, runes and probably other non CDOTA_BaseNPC entities disallowing use of IsCreep, IsBuilding and throwing errors.
function CBaseEntity:IsRealUnit(buildings)
	if UnitFilter( self, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_CREEP+DOTA_UNIT_TARGET_BUILDING+DOTA_UNIT_TARGET_COURIER, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0 ) == 0 then
		if buildings and self:IsBuilding() or not self:IsBuilding() then
			return true
		end
	end
	return false
end

local BaseNPC_GetName = CDOTA_BaseNPC.GetName
function CDOTA_BaseNPC:GetName()
	if self:IsBuilding() then
		return BaseNPC_GetName(self)
	else
		return self:GetUnitName()
	end
end

--debug
function debug.PrintTable(debugOver, prefix)
	prefix = prefix or ""
	
	if type(debugOver) == "table" then
		print("Printing Table: "..tostring(debugOver))
		print("vvvvvvvvvvvvvv")
		local indexedtable = false
		for name, _ in pairs(debugOver) do
			if type(name) ~= "number" then
				indexedtable = true
				break
			end
		end
		for idx, data_value in pairs(debugOver) do
			if (indexedtable and type(idx) ~= "number") or indexedtable == false then
				if type(data_value) == "string" then 
					print( string.format( "%s%-32s\t= \"%s\" (%s)", prefix, idx, data_value, type(data_value) ) )
				else 
					print( string.format( "%s%-32s\t= %s (%s)", prefix, idx, tostring(data_value), type(data_value) ) )
				end
			end
		end
		print("--------------")
	else
		print(tostring(debugOver).." is not a Table")
	end
end

function debug.ReadVar(f)
	local v = _G    -- start with the table of globals
	for w in string.gfind(f, "[%w_]+") do
		v = v[w]
	end
	return v
end

GameRules.Extensions = Extensions