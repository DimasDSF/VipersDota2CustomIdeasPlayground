_G._savedEnv = getfenv()
module( "ward", package.seeall )

----------------------------------------------------------------------------------------------------

local XYZ = require( GetScriptDirectory() .. "/gxc/gxcXYZ" )
local J = require( GetScriptDirectory() .. "/gxc/gxcJ" )
local A = require( GetScriptDirectory() .. "/gxc/gxcA" )

----------------------------------------------------------------------------------------------------

WARD_RANGE = 500 + 500;
WARD_OBSERVER_SIGHT = 1600;
WARD_SENTRY_OBSERVER_SIGHT = 150;
WARD_SENTRY_TRUE_SIGHT = 850;

----------------------------------------------------------------------------------------------------

function GetDesire()

	local npcBot = GetBot();

	npcBot.isWardSentry = nil;
	npcBot.beginningWardPoint1 = nil;
	npcBot.beginningWardPoint2 = nil;
	npcBot.selectedWardPoint = nil;

	local item_ward_observer = J.GetItemAvailable("item_ward_observer");
	local item_ward_sentry = J.GetItemAvailable("item_ward_sentry");
	local item_ward_dispenser = J.GetItemAvailable("item_ward_dispenser");
	local allyWardList = GetUnitList( UNIT_LIST_ALLIED_WARDS );
	local enemyWardList = GetUnitList( UNIT_LIST_ENEMY_WARDS );

	if ( item_ward_observer == nil and item_ward_sentry == nil and item_ward_dispenser == nil ) then
		return ( 0.0 );
	end

	--------------------------------------------------------------------------

	-- we need wards in starting game
	if ( DotaTime() < 0 ) then
		local beginningRadiantWardPoint = XYZ["beginningRadiantWardPoint"];
		local beginningDireWardPoint = XYZ["beginningDireWardPoint"];

		if ( (item_ward_observer ~= nil and item_ward_observer:GetCurrentCharges() == 2)
			or (item_ward_dispenser ~= nil and item_ward_dispenser:GetToggleState() 
			and item_ward_dispenser:GetCurrentCharges() == 2)
			or (item_ward_dispenser ~= nil and not item_ward_dispenser:GetToggleState() 
			and item_ward_dispenser:GetSecondaryCharges() == 2) ) then
			
			local wardPoint1 = nil;
			local wardPoint2 = nil;
			if ( GetTeam() == TEAM_RADIANT ) then
				local index1 = RandomInt(1, #beginningRadiantWardPoint);
				wardPoint1 = beginningRadiantWardPoint[index1];

				local index2 = index1;
				while ( index2 == index1 ) do
					index2 = RandomInt(1, #beginningRadiantWardPoint);
				end

				wardPoint2 = beginningRadiantWardPoint[index2];
			elseif ( GetTeam() == TEAM_DIRE ) then
				local index1 = RandomInt(1, #beginningDireWardPoint);
				wardPoint1 = beginningDireWardPoint[index1];

				local index2 = index1;
				while ( index2 == index1 ) do
					index2 = RandomInt(1, #beginningDireWardPoint);
				end

				wardPoint2 = beginningDireWardPoint[index2];
			end

			local tower = npcBot;
			if ( npcBot:GetAssignedLane() == LANE_TOP ) then
				tower = GetTower( GetTeam(), TOWER_TOP_1 );
			elseif ( npcBot:GetAssignedLane() == LANE_MID ) then
				tower = GetTower( GetTeam(), TOWER_MID_1 );
			elseif ( npcBot:GetAssignedLane() == LANE_BOT ) then
				tower = GetTower( GetTeam(), TOWER_BOT_1 );
			end

			if ( wardPoint1 ~= nil and wardPoint2 ~= nil ) then
				if ( GetUnitToLocationDistance(tower, wardPoint1) > GetUnitToLocationDistance(tower, wardPoint2) ) then
					npcBot.beginningWardPoint1 = wardPoint1;
					npcBot.beginningWardPoint2 = wardPoint2;
				else
					npcBot.beginningWardPoint1 = wardPoint2;
					npcBot.beginningWardPoint2 = wardPoint1;
				end
			end

			npcBot.isWardSentry = false;
			return ( 0.4 );
		elseif ( (item_ward_observer ~= nil and item_ward_observer:GetCurrentCharges() == 1)
			or (item_ward_dispenser ~= nil and item_ward_dispenser:GetToggleState() 
			and item_ward_dispenser:GetCurrentCharges() == 1)
			or (item_ward_dispenser ~= nil and not item_ward_dispenser:GetToggleState() 
			and item_ward_dispenser:GetSecondaryCharges() == 1) ) then

			if ( GetTeam() == TEAM_RADIANT ) then
				local index = RandomInt(1, #beginningRadiantWardPoint);
				local wardPoint = beginningRadiantWardPoint[index];

				npcBot.beginningWardPoint1 = wardPoint;
			elseif ( GetTeam() == TEAM_DIRE ) then
				local index = RandomInt(1, #beginningDireWardPoint);
				local wardPoint = beginningDireWardPoint[index];

				npcBot.beginningWardPoint1 = wardPoint;
			end

			npcBot.isWardSentry = false;
			return ( 0.4 );
		elseif ( item_ward_sentry ~= nil or item_ward_dispenser ~= nil ) then
			npcBot.isWardSentry = true;
			-- TODO
		end
	end

	--------------------------------------------------------------------------

	if ( DotaTime() > 0 and GetSuitableTime() ) then
		local genericWardPoints = XYZ["genericWardPoint"];

		if ( item_ward_observer ~= nil or item_ward_dispenser ~= nil ) then
			for _, point in pairs( genericWardPoints ) do

				if ( allyWardList ~= nil and #allyWardList > 0 ) then
					for _, wardUnit in pairs(allyWardList) do
						if ( wardUnit:GetUnitName() == "npc_dota_observer_wards" 
							and GetUnitToLocationDistance(wardUnit, point) <= J.WARD_OBSERVER_SIGHT * 1.3 ) then
							return ( 0.0 );
						end
					end
				end

				if ( enemyWardList ~= nil and #enemyWardList > 0 ) then
					for _, wardUnit in pairs(enemyWardList) do
						if ( wardUnit:GetUnitName() == "npc_dota_sentry_wards" 
							and GetUnitToLocationDistance(wardUnit, point) <= J.WARD_SENTRY_TRUE_SIGHT ) then
							return ( 0.0 );
						end
					end
				end

				if ( GetUnitToLocationDistance(npcBot, point) < J.WARD_RANGE ) then
					npcBot.isWardSentry = false;
					npcBot.selectedWardPoint = point;
					return ( 0.7 );
				end

			end
		elseif ( item_ward_sentry ~= nil or item_ward_dispenser ~= nil ) then
			npcBot.isWardSentry = true;
			-- TODO
		end
	end

	return ( 0.0 );

end

----------------------------------------------------------------------------------------------------

function Think()

	local npcBot = GetBot();

	local item_ward_observer = J.GetItemAvailable("item_ward_observer");
	local item_ward_sentry = J.GetItemAvailable("item_ward_sentry");
	local item_ward_dispenser = J.GetItemAvailable("item_ward_dispenser");

	if ( item_ward_observer == nil and item_ward_sentry == nil and item_ward_dispenser == nil ) then
		return;
	end

	-- we need wards in starting game
	if ( DotaTime() < 0 ) then

		if ( npcBot.isWardSentry == true ) then
			if ( npcBot.selectedWardPoint ~= nil ) then
				A.WardSentryUsageThink( npcBot.selectedWardPoint );
			end
		elseif ( npcBot.isWardSentry == false ) then
			if ( npcBot.beginningWardPoint1 ~= nil and npcBot.beginningWardPoint2 ~= nil ) then
				A.WardObserverUsageThink( npcBot.beginningWardPoint1 );
				A.WardObserverUsageThink( npcBot.beginningWardPoint2 );
			elseif ( npcBot.beginningWardPoint1 ~= nil and npcBot.beginningWardPoint2 == nil ) then
				A.WardObserverUsageThink( npcBot.beginningWardPoint1 );
			elseif ( npcBot.beginningWardPoint1 == nil and npcBot.beginningWardPoint2 ~= nil ) then
				A.WardObserverUsageThink( npcBot.beginningWardPoint2 );
			end
		end

	else

		if ( npcBot.selectedWardPoint == nil ) then
			return;
		end

		if ( npcBot.isWardSentry == true ) then
			A.WardSentryUsageThink( npcBot.selectedWardPoint );
		elseif ( npcBot.isWardSentry == false ) then
			A.WardObserverUsageThink( npcBot.selectedWardPoint );
		end

	end

end

----------------------------------------------------------------------------------------------------

function GetSuitableTime()

	local npcBot = GetBot();

	if ( npcBot:GetActiveMode() ~= BOT_MODE_RETREAT
		and npcBot:GetActiveMode() ~= BOT_MODE_SECRET_SHOP ) then
		return true;
	end

	return false;

end

----------------------------------------------------------------------------------------------------

for k,v in pairs( ward ) do	_G._savedEnv[k] = v end