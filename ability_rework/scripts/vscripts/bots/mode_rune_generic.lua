_G._savedEnv = getfenv()
module( "rune", package.seeall )

----------------------------------------------------------------------------------------------------

local J = require( GetScriptDirectory() .. "/gxc/gxcJ" )
local A = require( GetScriptDirectory() .. "/gxc/gxcA" )

local activerunelist = {
		{rune = "RUNE_POWERUP_1", stat = "active"},
		{rune = "RUNE_POWERUP_2", stat = "active"},
		{rune = "RUNE_BOUNTY_1", stat = "active"},
		{rune = "RUNE_BOUNTY_2", stat = "active"},
		{rune = "RUNE_BOUNTY_3", stat = "active"},
		{rune = "RUNE_BOUNTY_4", stat = "active"},

	}

----------------------------------------------------------------------------------------------------

function GetDesire()

	local npcBot = GetBot();
	-- init rune
	npcBot.grabRune = nil;

	local minute = J.GetDotaMinute();
	local second = J.GetDotaSecond();
	
	if minute % 2 == 0 and second < 2 then
		for n=1,#activerunelist do
			activerunelist[n].stat = "active"
		end
	end

	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( J.ALERT_RANGE, true, BOT_MODE_NONE );
	local tableNearbyAllyHeroes = npcBot:GetNearbyHeroes( 800, false, BOT_MODE_NONE );

	-- grab the beginning runes.
	if ( DotaTime() < 0 ) then
		if ( GetTeam() == TEAM_RADIANT ) then
			if ( npcBot:GetAssignedLane() == LANE_BOT ) then
				npcBot.grabRune = RUNE_BOUNTY_1;
			elseif ( npcBot:GetAssignedLane() == LANE_MID ) then
				npcBot.grabRune = RUNE_BOUNTY_2;
			end
		elseif ( GetTeam() == TEAM_DIRE ) then
			if ( npcBot:GetAssignedLane() == LANE_TOP ) then
				npcBot.grabRune = RUNE_BOUNTY_3;
			elseif ( npcBot:GetAssignedLane() == LANE_MID ) then
				npcBot.grabRune = RUNE_BOUNTY_4;
			end
		end

		if ( npcBot.grabRune ~= nil ) then
			local runeLocation = GetRuneSpawnLocation(npcBot.grabRune);

			if ( GetUnitToLocationDistance(npcBot, runeLocation) < 600
				and tableNearbyEnemyHeroes ~= nil and #tableNearbyAllyHeroes ~= nil ) then
				if ( #tableNearbyEnemyHeroes <= 0 and #tableNearbyAllyHeroes > 0 ) then
					for _, ally in pairs(tableNearbyAllyHeroes) do
						if ( not ally:IsBot() and GetUnitToLocationDistance(ally, runeLocation) < 600 ) then
							return ( 0.0 );
						end
					end
				elseif ( #tableNearbyEnemyHeroes > #tableNearbyAllyHeroes ) then
					return ( 0.0 );
				end
			end

			return ( 0.32 );
		end
	end

	-- see a rune if we walk by it
	local runeList = J.nRuneLocations;
	for i, rune in ipairs(runeList) do
		local runeLocation = GetRuneSpawnLocation(rune);

		if ( runeLocation ~= nil ) then
			local distance = GetUnitToLocationDistance( npcBot, runeLocation );
			--print("Rune = " .. tostring(rune) .. " num = " .. tostring(i) .. " status = " .. tostring(activerunelist[i].stat))
			if (distance < 180) then
				activerunelist[i].stat = "inactive"
			end

			if ( distance < J.ALERT_RANGE ) then
				if ( minute > 0 and ((minute % 2 == 1 and second > 53) or (minute % 2 == 0 and second < 5)) ) then
					npcBot.grabRune = rune;

					if ( (tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes <= 0)
						or GetSuitableTime() ) then

						return RemapValClamped( distance, J.ALERT_RANGE, 200, 0.7, 1.0 );
					else
						return RemapValClamped( distance, J.ALERT_RANGE, 200, 0.0, 1.0 );
					end
				end
			--[[elseif ( distance < J.ALERT_RANGE * 3.0 and GetSuitableTime() and activerunelist[i].stat == "active" ) then
				if ( (tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes <= 0)
						or GetSuitableTime() ) then
					return RemapValClamped( distance, J.ALERT_RANGE * 3.0, 200, 0.7, 1.0 );
				else
					return RemapValClamped( distance, J.ALERT_RANGE * 3.0, 200, 0.0, 1.0 );
				end--]]
			end
		end
	end

	--if ( IsInvisibleUnitGrabRune() ) then
	--	SolveTheInvisibleUnitGrabRune();
	--end

	return ( 0.0 );
end

----------------------------------------------------------------------------------------------------

function Think()

	if ( DotaTime() < 0 ) then
		A.GrabRuneBeginning();
	else
		--[[if math.floor(J.GetDotaSecond()) % 5 == 0 then
			for num=1,#activerunelist do
				print( "rune = " .. activerunelist[num].rune .. " status = " .. tostring(activerunelist[num].stat) .. " API Status = " .. tostring(GetRuneStatus(J.nRuneLocations[num])) )
			end
		end--]]
		A.GrabRune();
		--A.GrabRuneNearby( J.ALERT_RANGE );
	end
end

----------------------------------------------------------------------------------------------------

function GetSuitableTime()

	local npcBot = GetBot();

	if ( npcBot:GetActiveMode() ~= BOT_MODE_RETREAT
		and npcBot:GetActiveMode() ~= BOT_MODE_SECRET_SHOP
		and npcBot:GetActiveMode() ~= BOT_MODE_SIDE_SHOP 
		and npcBot:GetActiveMode() ~= BOT_MODE_PUSH_TOWER_TOP 
		and npcBot:GetActiveMode() ~= BOT_MODE_PUSH_TOWER_MID 
		and npcBot:GetActiveMode() ~= BOT_MODE_PUSH_TOWER_BOT 
		and npcBot:GetActiveMode() ~= BOT_MODE_DEFEND_TOWER_TOP
		and npcBot:GetActiveMode() ~= BOT_MODE_DEFEND_TOWER_MID 
		and npcBot:GetActiveMode() ~= BOT_MODE_DEFEND_TOWER_BOT
		and npcBot:GetActiveMode() ~= BOT_MODE_DEFEND_ALLY
		and npcBot:GetActiveMode() ~= BOT_MODE_EVASIVE_MANEUVERS ) then
		return true;
	end

	return false;

end

----------------------------------------------------------------------------------------------------

-- an invisible enemy unit has grabbed the upcoming or ready rune ?
function IsInvisibleUnitGrabRune()

	local npcBot = GetBot();
	
	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( J.ALERT_RANGE, true, BOT_MODE_NONE );
	local tableNearbyAllyHeroes = npcBot:GetNearbyHeroes( J.ALERT_RANGE, false, BOT_MODE_NONE );

	minute = J.GetDotaMinute();
	second = J.GetDotaSecond();

	if ( tableNearbyEnemyHeroes ~= nil and tableNearbyAllyHeroes ~= nil ) then
		if ( #tableNearbyEnemyHeroes <= 0 and #tableNearbyAllyHeroes <= 0 ) then
			if ( minute % 2 == 0 and second < 5 ) then
				if ( minute ~= 0 ) then
					local powerupList = { RUNE_POWERUP_1, RUNE_POWERUP_2 };
					for _, rune in pairs(powerupList) do
						local runeLocation = GetRuneSpawnLocation(rune);

						if ( runeLocation ~= nil ) then
							local distance = GetUnitToLocationDistance( npcBot, runeLocation );

							if ( distance < J.ALERT_RANGE and GetRuneStatus(rune) == RUNE_STATUS_MISSING ) then
								return true;
							end
						end
					end
				end

				local bountyList = { RUNE_BOUNTY_1, RUNE_BOUNTY_2, RUNE_BOUNTY_3, RUNE_BOUNTY_4 };
				for _, rune in pairs(bountyList) do
					local runeLocation = GetRuneSpawnLocation(rune);

					if ( runeLocation ~= nil ) then
						local distance = GetUnitToLocationDistance( npcBot, runeLocation );

						if ( distance < J.ALERT_RANGE and GetRuneStatus(rune) == RUNE_STATUS_MISSING ) then
							return true;
						end
					end
				end
			end
		end
	end
	
	return false;
end

----------------------------------------------------------------------------------------------------

function SolveTheInvisibleUnitGrabRune()

	local npcBot = GetBot();

	local item_dust = nil;
	local item_ward_sentry = nil;

	item_dust = J.GetItemAvailable( "item_dust" );
	item_ward_sentry = J.GetItemAvailable( "item_ward_sentry" );

	if ( item_dust ~= nil and item_dust:IsFullyCastable() ) then
		npcBot:Action_UseAbility( item_dust );
	elseif ( item_ward_sentry ~= nil and item_ward_sentry:IsFullyCastable() ) then
		local point = npcBot:GetLocation() + RandomVector(100);
		npcBot:Action_UseAbilityOnEntity( item_ward_sentry, point );
	end

end

----------------------------------------------------------------------------------------------------

for k,v in pairs( rune ) do	_G._savedEnv[k] = v end