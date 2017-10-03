-- generic action
----------------------------------------------------------------------------------------------------

local J = require( GetScriptDirectory() .. "/gxc/gxcJ" )
local S = require( GetScriptDirectory() .. "/gxc/gxcS" )

----------------------------------------------------------------------------------------------------

local X = {}

----------------------------------------------------------------------------------------------------

function X.BuybackUsageThink()

	local npcBot = GetBot();

	-- no buyback, no need to use GetUnitList() for performance considerations
	if ( not J.CanBuybackUpperRespawnTime(10) ) then
		return;
	end

	local tower_top_3 = GetTower( GetTeam(), TOWER_TOP_3 );
	local tower_mid_3 = GetTower( GetTeam(), TOWER_MID_3 );
	local tower_bot_3 = GetTower( GetTeam(), TOWER_BOT_3 );
	local tower_base_1 = GetTower( GetTeam(), TOWER_BASE_1 );
	local tower_base_2 = GetTower( GetTeam(), TOWER_BASE_2 );

	local barracks_top_melee = GetBarracks( GetTeam(), BARRACKS_TOP_MELEE );
	local barracks_top_ranged = GetBarracks( GetTeam(), BARRACKS_TOP_RANGED );
	local barracks_mid_melee = GetBarracks( GetTeam(), BARRACKS_MID_MELEE );
	local barracks_mid_ranged = GetBarracks( GetTeam(), BARRACKS_MID_RANGED );
	local barracks_bot_melee = GetBarracks( GetTeam(), BARRACKS_BOT_MELEE );
	local barracks_bot_ranged = GetBarracks( GetTeam(), BARRACKS_BOT_RANGED );

	local ancient = GetAncient( GetTeam() );

	local buildingList = {
		tower_top_3, tower_mid_3, tower_bot_3, tower_base_1, tower_base_2,
		barracks_top_melee, barracks_top_ranged,
		barracks_mid_melee, barracks_mid_ranged,
		barracks_bot_melee, barracks_bot_ranged,
		ancient
	};

	for _, building in pairs(buildingList) do
		local tableNearbyEnemyHeroes = building:GetNearbyHeroes( J.ALERT_RANGE, true, BOT_MODE_NONE );

		if ( tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0 ) then
			if ( building:GetHealth() / building:GetMaxHealth() < 0.5
				and building:WasRecentlyDamagedByAnyHero(2.0) and J.CanBuybackUpperRespawnTime(30) ) then

				npcBot:ActionImmediate_Buyback();
				return;
			end
		end
	end

	if ( DotaTime() > 60 * 60 and J.CanBuybackUpperRespawnTime(30) ) then
		npcBot:ActionImmediate_Buyback();
	end

end

----------------------------------------------------------------------------------------------------

function X.AbilityLevelUpThink()

	local npcBot = GetBot();

	if ( npcBot == nil ) then
		return;
	end

	if ( string.find(npcBot:GetUnitName(), "npc_dota_hero") ) then
		local sHero = S["hero_ability_level_up"][npcBot:GetUnitName()];

		if ( npcBot.hasRole == true ) then
			if ( npcBot.isRoleWellAssigned == nil or npcBot.isRoleWellAssigned == false ) then
				local teamRoles = J.GetTeamRoles();
				for role, id in pairs(teamRoles) do
					if ( npcBot:GetPlayerID() == id ) then
						npcBot.role = role;
					end
				end

				local tableAbilityCarry = sHero["abilityTable1"];
				local tableAbilityMid = sHero["abilityTable2"];
				local tableAbilityOfflane = sHero["abilityTable3"];
				local tableAbilitySemiSupport = sHero["abilityTable4"];
				local tableAbilityPureSupport = sHero["abilityTable5"];

				if ( npcBot.role == "carry" and tableAbilityCarry ~= nil and #tableAbilityCarry > 0 ) then
					npcBot.abilityTable = tableAbilityCarry;
				elseif ( npcBot.role == "mid" and tableAbilityMid ~= nil and #tableAbilityMid > 0 ) then
					npcBot.abilityTable = tableAbilityMid;
				elseif ( npcBot.role == "offlane" and tableAbilityOfflane ~= nil and #tableAbilityOfflane > 0 ) then
					npcBot.abilityTable = tableAbilityOfflane;
				elseif ( npcBot.role == "semiSupport" and tableAbilitySemiSupport ~= nil and #tableAbilitySemiSupport > 0 ) then
					npcBot.abilityTable = tableAbilitySemiSupport;
				elseif ( npcBot.role == "pureSupport" and tableAbilityPureSupport ~= nil and #tableAbilityPureSupport > 0 ) then
					npcBot.abilityTable = tableAbilityPureSupport;
				else
					npcBot.abilityTable = sHero["abilityTable"];
				end

				npcBot.isRoleWellAssigned = true;
			end
		else
			npcBot.abilityTable = sHero["abilityTable"];
		end
	end

	if ( npcBot.abilityTable ~= nil and npcBot:GetAbilityPoints() > 0 ) then
		if ( npcBot.abilityTable[1] == nil ) then
			return;
		end
		
		local ability = npcBot:GetAbilityByName( npcBot.abilityTable[1] );
		
		if ( ability ~= nil and ability:CanAbilityBeUpgraded() and ability:GetLevel() < ability:GetMaxLevel() ) then
			npcBot:ActionImmediate_LevelAbility( npcBot.abilityTable[1] );
			table.remove( npcBot.abilityTable, 1 );
		end
	end

end

----------------------------------------------------------------------------------------------------

function X.CourierUsageThink()

	local npcBot = GetBot();
	npcBot.courier = GetCourier(0);

	local item_courier = J.GetItemInInventory( "item_courier" );
	if ( item_courier ~= nil ) then
		npcBot:Action_UseAbility( item_courier );
	end

	if ( DotaTime() < 0 or npcBot.courier == nil ) then
		return;
	end

	local mostCourierValueHero = nil;
	local mostCourierValue = -1;
	local mostStashValueHero = nil;
	local mostStashValue = -1;
	local botHeroes = J.GetOurBots();

	for _, hero in pairs(botHeroes) do
		if ( hero:GetCourierValue() > mostCourierValue ) then
			mostCourierValueHero = hero;
			mostCourierValue = mostCourierValueHero:GetCourierValue();
		end

		if ( hero:GetStashValue() > mostStashValue ) then
			mostStashValueHero = hero;
			mostStashValue = mostStashValueHero:GetStashValue();
		end
	end

	--------------------------------------------------------------------------

	-- use the courier
	if ( GetCourierState(npcBot.courier) == COURIER_STATE_MOVING or GetCourierState(npcBot.courier) == COURIER_STATE_DELIVERING_ITEMS ) then

		X.ConsiderCourierBurst();

		-- when the target hero is dead suddenly, we can cancel the task of delivering to avoid feeding the courier.
		if ( not npcBot:IsAlive() ) then
			if ( npcBot:GetUnitName() == mostCourierValueHero:GetUnitName()
				or npcBot:GetUnitName() == mostStashValueHero:GetUnitName() ) then
				npcBot:ActionImmediate_Courier( npcBot.courier, COURIER_ACTION_RETURN );
			end
		end

	elseif ( GetCourierState(npcBot.courier) == COURIER_STATE_IDLE or GetCourierState(npcBot.courier) == COURIER_STATE_AT_BASE
		or GetCourierState(npcBot.courier) == COURIER_STATE_RETURNING_TO_BASE ) then

		if ( GetCourierState(npcBot.courier) == COURIER_STATE_RETURNING_TO_BASE ) then
			X.ConsiderCourierBurst();
		end

		local sNextItem = nil;
		if ( npcBot.tableItemsToBuy ~= nil and #npcBot.tableItemsToBuy > 0 ) then
			sNextItem = npcBot.tableItemsToBuy[1];
			npcBot:SetNextItemPurchaseValue( GetItemCost( sNextItem ) );
		end

		if ( npcBot:GetCourierValue() >= 400 ) then
			if ( npcBot:IsAlive() and npcBot == mostCourierValueHero ) then
				npcBot:ActionImmediate_Courier( npcBot.courier, COURIER_ACTION_TRANSFER_ITEMS );
			end
		elseif ( npcBot:GetStashValue() >= 400 ) then
			if ( npcBot:IsAlive() and npcBot == mostStashValueHero ) then
				npcBot:ActionImmediate_Courier( npcBot.courier, COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS );
			end
		elseif ( sNextItem ~= nil and npcBot:GetGold() >= GetItemCost( sNextItem ) ) then

			if ( IsItemPurchasedFromSecretShop( sNextItem ) and npcBot:DistanceFromSecretShop() > 0 ) then

				if ( npcBot.courier:DistanceFromSecretShop() == 0
					and npcBot.courier:ActionImmediate_PurchaseItem( sNextItem ) == PURCHASE_ITEM_SUCCESS ) then
					table.remove( npcBot.tableItemsToBuy, 1 );
				else
					npcBot:ActionImmediate_Courier( npcBot.courier, COURIER_ACTION_SECRET_SHOP );
				end
			elseif ( IsItemPurchasedFromSideShop( sNextItem ) and npcBot:DistanceFromSideShop() > 2000 ) then

				if ( npcBot.courier:DistanceFromSideShop() > 0 and npcBot.courier:DistanceFromSideShop() < 2000 ) then
					if ( GetTeam() == TEAM_RADIANT ) then
						npcBot:ActionImmediate_Courier( npcBot.courier, COURIER_ACTION_SIDE_SHOP );
					elseif ( GetTeam() == TEAM_DIRE ) then
						npcBot:ActionImmediate_Courier( npcBot.courier, COURIER_ACTION_SIDE_SHOP2 );
					end
				elseif ( npcBot.courier:DistanceFromSideShop() == 0 ) then
					if ( npcBot.courier:ActionImmediate_PurchaseItem( sNextItem ) == PURCHASE_ITEM_SUCCESS ) then
						table.remove( npcBot.tableItemsToBuy, 1 );
					else
						if ( GetTeam() == TEAM_RADIANT ) then
							npcBot:ActionImmediate_Courier( npcBot.courier, COURIER_ACTION_SIDE_SHOP );
						elseif ( GetTeam() == TEAM_DIRE ) then
							npcBot:ActionImmediate_Courier( npcBot.courier, COURIER_ACTION_SIDE_SHOP2 );
						end
					end
				end
			end
		else
			if ( GetCourierState(npcBot.courier) == COURIER_STATE_IDLE ) then
				npcBot:ActionImmediate_Courier( npcBot.courier, COURIER_ACTION_RETURN );
			end
		end

	elseif ( GetCourierState(npcBot.courier) == COURIER_STATE_DEAD ) then
	end

end

----------------------------------------------------------------------------------------------------

function X.ItemUsageThink()

	

end

----------------------------------------------------------------------------------------------------

function X.AbilityUsageThink()

	local npcBot = GetBot();

	npcBot.unitsInfo = J.GetNearByUnitsInfo( J.ALERT_RANGE );

	-- use our shrines
	X.ShrineUse();

	-- attack enemy shrines
	--X.ShrineAttack();

end

--################################################################################################--

function X.ConsiderCourierBurst()

	local npcBot = GetBot();

	if ( DotaTime() < 0 or npcBot.courier == nil ) then
		return;
	end

	local courierAbilityBurst = npcBot.courier:GetAbilityByName( "courier_burst" );

	if ( npcBot.courier:IsUsingAbility() or not courierAbilityBurst:IsFullyCastable() ) then
		return;
	end

	local tableNearbyEnemyHeroes = npcBot.courier:GetNearbyHeroes( J.ALERT_RANGE, true, BOT_MODE_NONE );
	local tableNearbyEnemyTowers = npcBot.courier:GetNearbyTowers( J.ALERT_RANGE, true );

	local unitDistance = 0;
	local towerDistance = 0;

	if ( tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0 ) then
		local enemyHero = tableNearbyEnemyHeroes[1];
		unitDistance = GetUnitToUnitDistance( npcBot.courier, enemyHero );
	end

	if ( tableNearbyEnemyTowers ~= nil and #tableNearbyEnemyTowers > 0 ) then
		local enemyTower = tableNearbyEnemyTowers[1];
		towerDistance = GetUnitToLocationDistance( npcBot.courier, enemyTower:GetLocation() );
	end

	if ( npcBot.courier:WasRecentlyDamagedByAnyHero(3.0) or npcBot.courier:WasRecentlyDamagedByCreep(3.0)
		or npcBot.courier:WasRecentlyDamagedByTower(3.0)
		or (unitDistance > 0 and unitDistance < 700) or (unitDistance > 0 and towerDistance < 800) ) then
		npcBot:ActionImmediate_Courier( npcBot.courier, COURIER_ACTION_BURST );
	end

end

----------------------------------------------------------------------------------------------------

function X.GrabRuneBeginning()

	local npcBot = GetBot();

	if ( DotaTime() > 0 ) then
		return;
	end

	if ( npcBot.grabRune ~= nil ) then
		local runeLocation = GetRuneSpawnLocation(npcBot.grabRune);

		if ( runeLocation ~= nil ) then
			if ( GetRuneStatus(npcBot.grabRune) == RUNE_STATUS_AVAILABLE ) then
				npcBot:Action_PickUpRune( npcBot.grabRune );
			else
				npcBot:Action_MoveToLocation( runeLocation + RandomVector(RandomFloat(0, 200)) );
			end
		end
	end

end

----------------------------------------------------------------------------------------------------

function X.GrabRuneMidSolo()

	local npcBot = GetBot();
	npcBot.beginningRune = nil;

	if ( GetTeam() == TEAM_RADIANT ) then
		npcBot.beginningRune = RUNE_BOUNTY_2;
	elseif ( GetTeam() == TEAM_DIRE ) then
		npcBot.beginningRune = RUNE_BOUNTY_4;
	end

	local runeLoc = GetRuneSpawnLocation( npcBot.beginningRune );
	local enemy_heroes = npcBot.unitsInfo["enemy_heroes"];

	if ( DotaTime() >= -70 and DotaTime() < 0 ) then
		if ( #enemy_heroes > 0 ) then
			local tower_mid_1 = GetTower(GetTeam(), TOWER_MID_1);
			local tower_mid_2 = GetTower(GetTeam(), TOWER_MID_2);
			local toTowerMid2Distance = GetUnitToLocationDistance( npcBot, tower_mid_2 );

			if ( toTowerMid2Distance > 400 ) then
				npcBot:Action_MoveToLocation( tower_mid_2:GetLocation() + RandomVector(200) );
			else
				npcBot:Action_MoveToLocation( tower_mid_1:GetLocation() + RandomVector(200) );
			end
		else
			npcBot:Action_MoveToLocation( runeLoc + RandomVector(200) );
		end
	elseif ( npcBot.beginningRune ~= nil ) then
		npcBot.grabRune = npcBot.beginningRune;
		X.GrabRuneNearby( 300 );
	end

end

----------------------------------------------------------------------------------------------------

function X.GrabRune()

	local npcBot = GetBot();

	if ( npcBot.grabRune ~= nil ) then
		local runeLocation = GetRuneSpawnLocation(npcBot.grabRune);

		if ( runeLocation ~= nil ) then
			npcBot:Action_MoveToLocation( runeLocation + RandomVector(200) );
		end
	end

end

---------------------------------------------

-- grab a rune if we walk by it
function X.GrabRuneNearby( nRadius )

	local npcBot = GetBot();

	if ( npcBot.grabRune ~= nil ) then
		local runeLocation = GetRuneSpawnLocation(npcBot.grabRune);

		if ( runeLocation ~= nil ) then
			local distance = GetUnitToLocationDistance( npcBot, runeLocation );

			if ( distance < nRadius ) then
				if ( GetRuneStatus(npcBot.grabRune) == RUNE_STATUS_AVAILABLE ) then
					npcBot:Action_PickUpRune( npcBot.grabRune );
				elseif ( GetRuneStatus(npcBot.grabRune) == RUNE_STATUS_UNKNOWN ) then
					npcBot:Action_MoveToLocation( runeLocation + RandomVector(200) );
				end
			end
		end
	end

end

----------------------------------------------------------------------------------------------------

function X.ItemBottleUsageInBase()

	local npcBot = GetBot();

	local item_bottle = J.GetItemAvailable( "item_bottle" );

	if ( npcBot:IsUsingAbility() or item_bottle == nil ) then return end;

	if ( npcBot:DistanceFromFountain() == 0 ) then
		if ( npcBot:GetHealth() < npcBot:GetMaxHealth() or npcBot:GetMana() < npcBot:GetMaxMana() ) then
			npcBot:Action_UseAbility( item_bottle );
		end
	end

end

----------------------------------------------------------------------------------------------------

function X.ShrineAttack()

	local npcBot = GetBot();

	local healthPercent = J.GetPercentHealth( npcBot );

	-- use our shrines
	local nShrines = { SHRINE_JUNGLE_1, SHRINE_JUNGLE_2 };
	for _, nShrine in pairs(nShrines) do
		local shrine = GetShrine( GetOpposingTeam(), nShrine );
		local distance = GetUnitToUnitDistance( npcBot, shrine );

		if ( shrine ~= nil and not shrine:IsInvulnerable() and shrine:GetHealth() > 0 ) then
			local enemy_heroes = npcBot.unitsInfo["enemy_heroes"];
			local ally_heroes = npcBot.unitsInfo["ally_heroes"];

			if ( #enemy_heroes <= 0 and distance < 800 
				and ( healthPercent > 0.8 or (healthPercent > 0.5 and #ally_heroes > 0)
				and npcBot:GetActiveMode() ~= BOT_MODE_RETREAT
				and npcBot:GetActiveMode() ~= BOT_MODE_PUSH_TOWER_TOP
				and npcBot:GetActiveMode() ~= BOT_MODE_PUSH_TOWER_MID
				and npcBot:GetActiveMode() ~= BOT_MODE_PUSH_TOWER_BOT
				and npcBot:GetActiveMode() ~= BOT_MODE_DEFEND_TOWER_TOP 
				and npcBot:GetActiveMode() ~= BOT_MODE_DEFEND_TOWER_MID 
				and npcBot:GetActiveMode() ~= BOT_MODE_DEFEND_TOWER_BOT
				and npcBot:GetActiveMode() ~= BOT_MODE_ROSHAN
				and npcBot:GetActiveMode() ~= BOT_MODE_ITEM
				and npcBot:GetActiveMode() ~= BOT_MODE_WARD ) ) then

				npcBot:Action_AttackUnit( shrine, false );
			end
		end
	end

end

----------------------------------------------------------------------------------------------------

function X.ShrineUse()

	local npcBot = GetBot();

	local healthPercent = J.GetPercentHealth( npcBot );
	local manaPercent = J.GetPercentMana( npcBot );
	
	if npcBot.closestshrinedist == nil then
		npcBot.closestshrinedist = 100000
	end
	
	if healthPercent == 1 and manaPercent == 1 then
		npcBot.closestshrinedist = 100000
		npcBot.closestshrine = nil
	end

	-- use our shrines
	local nShrines = J.nShrines;
	for _, nShrine in pairs(nShrines) do
		local shrine = GetShrine( GetTeam(), nShrine );
		local distance = GetUnitToUnitDistance( npcBot, shrine );
		local time = distance / npcBot:GetCurrentMovementSpeed();

		if ( shrine ~= nil and shrine:GetHealth() > 0 ) then
			local enemy_heroes = npcBot.unitsInfo["enemy_heroes"];

			if ( #enemy_heroes > 0 ) then
				if ( distance < 1000 and npcBot:WasRecentlyDamagedByAnyHero(3.0)
					and (healthPercent < 0.8 or manaPercent < 0.8) ) then

					if ( GetShrineCooldown(shrine) < time ) then
						npcBot:Action_UseShrine( shrine );
					elseif ( GetShrineCooldown(shrine) > 295 ) then
						npcBot:Action_MoveToLocation( shrine:GetLocation() + RandomVector(400) );
					end
				end
			elseif ( GetShrineCooldown(shrine) < time ) then
				if npcBot.closestshrinedist == 0 then
					npcBot.closestshrinedist = 100000
				end
				if npcBot.closestshrinedist > distance then
					npcBot.closestshrinedist = math.floor(distance)
					npcBot.closestshrine = shrine
				end
			end
		end
	end
	--print("Bot:" .. npcBot:GetUnitName() .. " Health = " .. tostring(healthPercent) .. " CShrineDist = " .. tostring(math.floor(GetUnitToUnitDistance( npcBot, npcBot.closestshrine ))) .. " Fountain Dist = " .. tostring(math.floor(npcBot:DistanceFromFountain())) )
	if ( npcBot.closestshrine ~= nil and (healthPercent < 0.5 and manaPercent < 0.5) or healthPercent < 0.3 or manaPercent < 0.1 ) and GetShrineCooldown(npcBot.closestshrine) < 5 and GetUnitToUnitDistance( npcBot, npcBot.closestshrine ) < npcBot:DistanceFromFountain() then
		npcBot:Action_UseShrine( npcBot.closestshrine );
	elseif (npcBot.closestshrine ~= nil and GetUnitToUnitDistance( npcBot, npcBot.closestshrine ) < 500 and GetShrineCooldown(npcBot.closestshrine) > 295 and (healthPercent < 1 or manaPercent < 1) ) then
		npcBot:Action_MoveToLocation( npcBot.closestshrine:GetLocation() );
		npcBot.closestshrine = nil
		npcBot.closestshrinedist = 100000
	end
end

----------------------------------------------------------------------------------------------------

function X.WardEnemyAttackThink()

	local npcBot = GetBot();

	if ( npcBot:IsUsingAbility() ) then
		return;
	end

	local enemyWardList = GetUnitList( UNIT_LIST_ENEMY_WARDS );

	for _, wardUnit in pairs(enemyWardList) do
		if ( GetUnitToUnitDistance(npcBot, wardUnit) < J.ALERT_RANGE ) then
			npcBot:Action_AttackUnit( wardUnit, false );
		end
	end

end

----------------------------------------------------------------------------------------------------

function X.WardObserverUsageThink( vWardPointLocation )

	local npcBot = GetBot();

	if ( npcBot:IsUsingAbility() ) then
		return;
	end

	local item_ward_observer = J.GetItemAvailable("item_ward_observer");
	local item_ward_dispenser = J.GetItemAvailable("item_ward_dispenser");

	if ( item_ward_observer == nil and item_ward_dispenser == nil ) then
		return;
	end

	if ( item_ward_dispenser ~= nil ) then
		if ( not item_ward_dispenser:GetToggleState() ) then
			item_ward_dispenser:ToggleAutoCast();
		end

		npcBot:Action_UseAbilityOnLocation( item_ward_dispenser, vWardPointLocation );
	elseif ( item_ward_observer ~= nil ) then
		npcBot:Action_UseAbilityOnLocation( item_ward_observer, vWardPointLocation );
	end

end

----------------------------------------------------------------------------------------------------

function X.WardSentryUsageThink( vWardPointLocation )

	local npcBot = GetBot();

	if ( npcBot:IsUsingAbility() ) then
		return;
	end

	local item_ward_sentry = J.GetItemAvailable("item_ward_sentry");
	local item_ward_dispenser = J.GetItemAvailable("item_ward_dispenser");

	if ( item_ward_sentry == nil and item_ward_dispenser == nil ) then
		return;
	end

	if ( item_ward_dispenser ~= nil ) then
		if ( item_ward_dispenser:GetToggleState() ) then
			item_ward_dispenser:ToggleAutoCast();
		end

		npcBot:Action_UseAbilityOnLocation( item_ward_dispenser, vWardPointLocation );
	elseif ( item_ward_sentry ~= nil ) then
		npcBot:Action_UseAbilityOnLocation( item_ward_sentry, vWardPointLocation );
	end

end

----------------------------------------------------------------------------------------------------










--################################################################################################--

-- move to the location fixed random radius per second
function X.Action_MoveToLocation( location, nRandomRadius, perTime )

	local npcBot = GetBot();

	if ( location ~= nil and nRandomRadius ~= nil and perTime ~= nil ) then
		if ( perTime > 0 and math.mod(DotaTime(), perTime) == 0 ) then
			npcBot:Action_MoveToLocation( location + RandomVector(nRandomRadius) );
		end
	end

end

----------------------------------------------------------------------------------------------------

return X;