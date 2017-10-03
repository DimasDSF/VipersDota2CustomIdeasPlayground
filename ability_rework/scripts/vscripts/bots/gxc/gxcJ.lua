-- generic judge
----------------------------------------------------------------------------------------------------

local DB = require( GetScriptDirectory() .. "/gxc/gxcDB" )

----------------------------------------------------------------------------------------------------

local X = {}

----------------------------------------------------------------------------------------------------

X.ALERT_RANGE = 1500;
X.WARD_RANGE = 500 + 500;
X.WARD_OBSERVER_SIGHT = 1600;
X.WARD_SENTRY_OBSERVER_SIGHT = 150;
X.WARD_SENTRY_TRUE_SIGHT = 850;

X.nTowers = { TOWER_TOP_1, TOWER_TOP_2, TOWER_TOP_3, TOWER_MID_1, TOWER_MID_2, TOWER_MID_3, TOWER_BOT_1, TOWER_BOT_2, TOWER_BOT_3, TOWER_BASE_1, TOWER_BASE_2 };
X.nBarracks = { BARRACKS_TOP_MELEE, BARRACKS_TOP_RANGED, BARRACKS_MID_MELEE, BARRACKS_MID_RANGED, BARRACKS_BOT_MELEE, BARRACKS_BOT_RANGED };
X.nShrines = {SHRINE_BASE_1, SHRINE_BASE_2, SHRINE_BASE_3, SHRINE_JUNGLE_1, SHRINE_JUNGLE_2 };
X.nShops = { SHOP_HOME, SHOP_SIDE, SHOP_SIDE2, SHOP_SECRET, SHOP_SECRET2 };

-- equals { RAD_SAFE_BOUNTY_RUNE, RAD_OFF_BOUNTY_RUNE, DIRE_SAFE_BOUNTY_RUNE, DIRE_OFF_BOUNTY_RUNE, PU_RUNE_TOP, PU_RUNE_BOT }
X.nRuneLocations = { RUNE_BOUNTY_1, RUNE_BOUNTY_2, RUNE_BOUNTY_3, RUNE_BOUNTY_4, RUNE_POWERUP_1, RUNE_POWERUP_2 };

----------------------------------------------------------------------------------------------------

function X.AssignRole( idList, roleName )

	local assignRole = {
		['index'] = -1,
		['id'] = -1
	};

	local hero_roles = DB["hero_roles"];
	local least = 1000;
	local bestIndex = -1;
	local bestId = -1;

	if ( idList ~= nil and #idList > 0 and roleName ~= nil ) then

		for role, roleList in pairs(hero_roles) do
			if ( role == roleName ) then
				for index, id in pairs(idList) do
					for i, name in pairs(roleList) do
						if ( id ~= -1 and GetSelectedHeroName(id) == name and i < least ) then
							least = i;
							bestIndex = index;
							bestId = id;
							break;
						end
					end
				end

				assignRole['index'] = bestIndex;
				assignRole['id'] = bestId;
			end
		end
	end

	return assignRole;

end

----------------------------------------------------------------------------------------------------

function X.CanBuybackUpperRespawnTime( respawnTime )

	local npcBot = GetBot();

	if ( not npcBot:IsAlive() and respawnTime ~= nil and npcBot:GetRespawnTime() >= respawnTime
		and npcBot:GetBuybackCooldown() <= 0 and npcBot:GetGold() > npcBot:GetBuybackCost() ) then
		return true;
	end

	return false;

end

----------------------------------------------------------------------------------------------------

function X.GetCheapestItemInInventory()

	local npcBot = GetBot();

	local cheapestItem = nil;
	local cheapestValue = 100000;

	for i = 0, 5 do
		local sCurItem = npcBot:GetItemInSlot(i);

		if ( sCurItem == nil ) then
			return nil;
		else
			local itemCost = GetItemCost(sCurItem:GetName());
			if ( itemCost < cheapestValue ) then
				cheapestValue = itemCost;
				cheapestItem = sCurItem;
			end
		end
	end

	return cheapestItem;
end

----------------------------------------------------------------------------------------------------

function X.GetDotaMinute()

	return math.floor( DotaTime() / 60 );

end

----------------------------------------------------------------------------------------------------

function X.GetDotaSecond()

	return DotaTime() % 60;

end

----------------------------------------------------------------------------------------------------

-- Returns 0 ~ 100.
function X.GetEstimatedPower( hUnit )

	local levelPower = 0;
	local worthPower = 0;
	local healthPower = 0;

	if ( hUnit ~= nil ) then
		local level = npcBot:GetLevel();
		local worth = X.GetItemsTotalWorth( hUnit );
		local healthPercent = X.GetPercentHealth( hUnit );

		if ( healthPercent < 0.1 ) then
			healthPower = healthPercent * 10;
		else
			levelPower = RemapValClamped( level, 0, 25, 0, 40 );
			worthPower = RemapValClamped( worth, 0, 30000, 0, 40 );
			healthPower = RemapValClamped( healthPercent, 0.0, 1.0, 0, 20 );
		end
	end

	local totalEstimatedPower = levelPower + worthPower + healthPower;
	return totalEstimatedPower;

end

----------------------------------------------------------------------------------------------------

function X.GetItemAvailable( item_name )

	local npcBot = GetBot();

	local item = nil;

	for i = 0, 5 do
		local sCurItem = npcBot:GetItemInSlot(i);
		
		if ( sCurItem ~= nil and sCurItem:GetName() == item_name and sCurItem:IsFullyCastable() ) then
			item = sCurItem;
			break;
		end
	end

	return item;
end

----------------------------------------------------------------------------------------------------

function X.GetItemCountInStash()

	local npcBot = GetBot();

	local count = 0;

	for i = 9, 14 do
		local sCurItem = npcBot:GetItemInSlot(i);
		
		if ( sCurItem ~= nil and sCurItem:GetName() ~= "" ) then
			count = count + 1;
		end
	end

	return count;
end

----------------------------------------------------------------------------------------------------

function X.GetItemInBackpack( item_name )

	local npcBot = GetBot();

	local item = nil;

	for i = 6, 8 do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil and sCurItem:GetName() == item_name ) then
			item = sCurItem;
			break;
		end
	end

	return item;
end

----------------------------------------------------------------------------------------------------

function X.GetItemInInventory( item_name )

	local npcBot = GetBot();

	local item = nil;

	for i = 0, 5 do
		local sCurItem = npcBot:GetItemInSlot(i);
		
		if ( sCurItem ~= nil and sCurItem:GetName() == item_name ) then
			item = sCurItem;
			break;
		end
	end

	return item;
end

----------------------------------------------------------------------------------------------------

function X.GetItemInStash( item_name )

	local npcBot = GetBot();

	local item = nil;

	for i = 9, 14 do
		local sCurItem = npcBot:GetItemInSlot(i);
		
		if ( sCurItem ~= nil and sCurItem:GetName() == item_name ) then
			item = sCurItem;
			break;
		end
	end

	return item;
end

----------------------------------------------------------------------------------------------------

function X.GetItemIncludeBackpack( item_name )

	local npcBot = GetBot();

	local item = nil;

	for i = 0, 8 do
		local sCurItem = npcBot:GetItemInSlot(i);
		if ( sCurItem ~= nil and sCurItem:GetName() == item_name ) then
			item = sCurItem;
			break;
		end
	end

	return item;
end

----------------------------------------------------------------------------------------------------

function X.GetItemIncludeStash( item_name )

	local npcBot = GetBot();

	local item = nil;

	for i = 0, 14 do
		local sCurItem = npcBot:GetItemInSlot(i);
		
		if ( sCurItem ~= nil and sCurItem:GetName() == item_name ) then
			item = sCurItem;
			break;
		end
	end

	return item;
end

----------------------------------------------------------------------------------------------------

function X.GetItemsTotalWorth( hUnit )

	local itemsTotalWorth = 0;

	for i = 0, 8 do
		local sCurItem = npcBot:GetItemInSlot(i);
		local itemCost = 0;

		if ( sCurItem ~= nil and sCurItem:GetName() ~= "item_aegis" ) then
			itemCost = GetItemCost( sCurItem:GetName() );
		end

		itemsTotalWorth = itemsTotalWorth + itemCost;
	end 

	return itemsTotalWorth;

end

----------------------------------------------------------------------------------------------------

function X.GetModifierIndexByName( modifierName )

	local npcBot = GetBot();

	if ( modifierName ~= nil and modifierName == "") then
		local modifierCount = npcBot:NumModifiers();

		for i = 1, modifierCount, 1  do
			if ( npcBot:GetModifierName(i) == modifierName ) then
				return i;
			end
		end
	end

	return -1;

end

----------------------------------------------------------------------------------------------------

function X.GetNearByUnitsInfo( nRadius )

	local npcBot = GetBot();

	local unitsInfo = {
		["enemy_heroes"] = {},
		["ally_heroes"] = {},
		["enemy_creeps"] = {},
		["ally_creeps"] = {},
		["neutral_creeps"] = {},
		["enemy_towers"] = {},
		["ally_towers"] = {},
		["enemy_shrines"] = {},
		["ally_shrines"] = {}
	};

	local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes( nRadius, true, BOT_MODE_NONE );
	local tableNearbyAllyHeroes = npcBot:GetNearbyHeroes( nRadius, false, BOT_MODE_NONE );
	local tableNearbyEnemyCreeps = npcBot:GetNearbyLaneCreeps( nRadius, true );
	local tableNearbyAllyCreeps = npcBot:GetNearbyLaneCreeps( nRadius, false );
	local tableNearbyNeutralCreeps = npcBot:GetNearbyNeutralCreeps( nRadius );
	local tableNearbyEnemyTowers = npcBot:GetNearbyTowers( nRadius, true );
	local tableNearbyAllyTowers = npcBot:GetNearbyTowers( nRadius, false );
	local tableNearByEnemyShrines = npcBot:GetNearbyShrines( nRadius, true );
	local tableNearByAllyShrines = npcBot:GetNearbyShrines( nRadius, false );

	if ( tableNearbyEnemyHeroes ~= nil and #tableNearbyEnemyHeroes > 0 ) then
		unitsInfo["enemy_heroes"] = tableNearbyEnemyHeroes;
	end

	if ( tableNearbyAllyHeroes ~= nil and #tableNearbyAllyHeroes > 0 ) then
		unitsInfo["ally_heroes"] = tableNearbyAllyHeroes;
	end

	if ( tableNearbyEnemyCreeps ~= nil and #tableNearbyEnemyCreeps > 0 ) then
		unitsInfo["enemy_creeps"] = tableNearbyEnemyCreeps;
	end

	if ( tableNearbyAllyCreeps ~= nil and #tableNearbyAllyCreeps > 0 ) then
		unitsInfo["ally_creeps"] = tableNearbyAllyCreeps;
	end

	if ( tableNearbyNeutralCreeps ~= nil and #tableNearbyNeutralCreeps > 0 ) then
		unitsInfo["neutral_creeps"] = tableNearbyNeutralCreeps;
	end

	if ( tableNearbyEnemyTowers ~= nil and #tableNearbyEnemyTowers > 0 ) then
		unitsInfo["enemy_towers"] = tableNearbyEnemyTowers;
	end

	if ( tableNearbyAllyTowers ~= nil and #tableNearbyAllyTowers > 0 ) then
		unitsInfo["ally_towers"] = tableNearbyAllyTowers;
	end

	if ( tableNearByEnemyShrines ~= nil and #tableNearByEnemyShrines > 0 ) then
		unitsInfo["enemy_shrines"] = tableNearByEnemyShrines;
	end

	if ( tableNearByAllyShrines ~= nil and #tableNearByAllyShrines > 0 ) then
		unitsInfo["ally_shrines"] = tableNearByAllyShrines;
	end

	return unitsInfo;

end

----------------------------------------------------------------------------------------------------

function X.GetNpcItemIncludeBackpack( npc, item_name )

	local item = nil;

	if ( npc ~= nil and npc:IsHero() ) then
		for i = 0, 8 do
			local sCurItem = npc:GetItemInSlot(i);
			
			if ( sCurItem ~= nil and sCurItem:GetName() == item_name ) then
				item = sCurItem;
				break;
			end
		end
	end

	return item;
end

----------------------------------------------------------------------------------------------------

function X.GetNpcItemInInventory( npc, item_name )

	local item = nil;

	if ( npc ~= nil and npc:IsHero() ) then
		for i = 0, 5 do
			local sCurItem = npc:GetItemInSlot(i);
			
			if ( sCurItem ~= nil and sCurItem:GetName() == item_name ) then
				item = sCurItem;
				break;
			end
		end
	end

	return item;
end

----------------------------------------------------------------------------------------------------

-- our bot heroes
function X.GetOurBots()

	local heroes = {};

	for i = 1, 5, 1 do
		local hero = GetTeamMember(i);

		if ( hero ~= nil and IsPlayerBot( hero:GetPlayerID() ) ) then
			heroes[i] = hero;
		end
	end

	return heroes;

end

----------------------------------------------------------------------------------------------------

-- our all heroes
function X.GetOurHeroes()

	local heroes = {};

	for i = 1, 5, 1 do
		local hero = GetTeamMember(i);

		if ( hero ~= nil ) then
			heroes[i] = hero;
		end
	end

	return heroes;

end

----------------------------------------------------------------------------------------------------

-- our human heroes
function X.GetOurHumans()

	local heroes = {};

	for i = 1, 5, 1 do
		local hero = GetTeamMember(i);

		if ( hero ~= nil and not IsPlayerBot( hero:GetPlayerID() ) ) then
			heroes[i] = hero;
		end
	end

	return heroes;

end

----------------------------------------------------------------------------------------------------

function X.GetPercentHealth( hUnit )

	return hUnit:GetHealth() / hUnit:GetMaxHealth();

end

----------------------------------------------------------------------------------------------------

function X.GetPercentMana( hUnit )

	return hUnit:GetMana() / hUnit:GetMaxMana();

end

----------------------------------------------------------------------------------------------------

function X.GetTeamAlivePlayers( bIsOurTeam, bAlive )

	local idList = {};

	local ourId = GetTeamPlayers( GetTeam() );
	local opposingId = GetTeamPlayers( GetOpposingTeam() );

	if ( bIsOurTeam and bAlive ) then
		for _, id in pairs(ourId) do
			if ( IsHeroAlive(id) ) then
				table.insert( idList, id );
			end
		end
	elseif ( bIsOurTeam and not bAlive ) then
		for _, id in pairs(ourId) do
			if ( not IsHeroAlive(id) ) then
				table.insert( idList, id );
			end
		end
	elseif ( not bIsOurTeam and bAlive ) then
		for _, id in pairs(opposingId) do
			if ( IsHeroAlive(id) ) then
				table.insert( idList, id );
			end
		end
	elseif ( not bIsOurTeam and not bAlive ) then
		for _, id in pairs(opposingId) do
			if ( not IsHeroAlive(id) ) then
				table.insert( idList, id );
			end
		end
	end

	return idList;

end

----------------------------------------------------------------------------------------------------

function X.GetTeamInfo( nTeam )

	local teamInfo = {};

	local idTeam = nil;
	if ( nTeam == TEAM_RADIANT ) then
		idTeam = GetTeamPlayers( TEAM_RADIANT );
	elseif ( nTeam == TEAM_DIRE ) then
		idTeam = GetTeamPlayers( TEAM_DIRE );
	end

	if ( idTeam ~= nil ) then
		for _, id in pairs(idTeam) do
			table.insert( teamInfo, id );
		end

		--TODO
	end

	return teamInfo;

end

----------------------------------------------------------------------------------------------------

-- returns our Role-PlayerID pairs.
-- Role: mid, carry, offlane, pureSupport, semiSupport.
-- note: before it, I still hava used the function GetTeamRoles2 in this file to assign the roles.It's also useful.
function X.GetTeamRoles()

	local teamRoles = {
		["mid"] = -1,
		["carry"] = -1,
		["offlane"] = -1,
		["pureSupport"] = -1,
		["semiSupport"] = -1
	};

	local id_team = GetTeamPlayers( GetTeam() );

	-- make sure our mid-player
	local mid = X.AssignRole( id_team, "mid" );
	if ( mid.id ~= -1 ) then
		teamRoles["mid"] = mid.id;
	end
	if ( mid.index ~= -1 ) then
		id_team[mid.index] = -1;
	end

	-- make sure our offlane-player
	local offlane = X.AssignRole( id_team, "offlane" );
	if ( offlane.id ~= -1 ) then
		teamRoles["offlane"] = offlane.id;
	end
	if ( offlane.index ~= -1 ) then
		id_team[offlane.index] = -1;
	end

	-- make sure our carry-player
	local carry = X.AssignRole( id_team, "carry" );
	if ( carry.id ~= -1 ) then
		teamRoles["carry"] = carry.id;
	end
	if ( carry.index ~= -1 ) then
		id_team[carry.index] = -1;
	end

	-- make sure our pureSupport-player
	local support = X.AssignRole( id_team, "support" );
	if ( support.id ~= -1 ) then
		teamRoles["pureSupport"] = support.id;
	end
	if ( support.index ~= -1 ) then
		id_team[support.index] = -1;
	end

	-- make sure our semiSupport-player
	local unAssignedHeroCount = 0;
	local unAssignedHeroId = -1;
	local unAssignedHeroIndex = -1;
	for i, id in pairs(id_team) do
		if ( id ~= -1 ) then
			unAssignedHeroCount = unAssignedHeroCount + 1;
			unAssignedHeroId = id;
			unAssignedHeroIndex = i;
		end
	end
	if ( unAssignedHeroCount == 1 and unAssignedHeroId ~= -1 ) then
		teamRoles["semiSupport"] = unAssignedHeroId;
	end
	if ( unAssignedHeroIndex ~= -1 ) then
		id_team[unAssignedHeroIndex] = -1;
	end

	return teamRoles;

end

----------------------------------------------------------------------------------------------------

-- returns our Role-PlayerID pairs.
-- Role: mid, carry, offlane, pureSupport, semiSupport.
function X.GetTeamRoles2()

	local teamRoles = {
		["mid"] = -1,
		["carry"] = -1,
		["offlane"] = -1,
		["pureSupport"] = -1,
		["semiSupport"] = -1
	};

	local team = GetTeam();
	local id_team = GetTeamPlayers( team );
	local hero_roles = DB["hero_ability"];

	-- count the number of carry roles
	local carryRolesCount = 0;
	for _, id in pairs(id_team) do
		local heroName = GetSelectedHeroName(id);
		local heroHero = hero_roles[heroName];

		if ( heroName ~= nil and heroName ~= "" and heroHero ~= nil ) then
			local carryLevel = heroHero["carry"];

			if ( carryLevel ~= nil ) then
				carryRolesCount = carryRolesCount + 1;
			end
		end
	end

	-- assign our mid-player with enough 'carry' roles
	local midId = -1;
	local midLevel = -1;
	local midSupportLevel = 10;
	for _, id in pairs(id_team) do
		local heroName = GetSelectedHeroName(id);
		local heroHero = hero_roles[heroName];

		if ( heroName ~= nil and heroName ~= "" and heroHero ~= nil ) then
			local carryLevel = heroHero["carry"];
			local nukerLevel = heroHero["nuker"];
			local disablerLevel = heroHero["disabler"];
			local supportLevel = heroHero["support"];

			if ( carryLevel == nil ) then
				carryLevel = 0;
			end
			if ( nukerLevel == nil ) then
				nukerLevel = 0;
			end
			if ( disablerLevel == nil ) then
				disablerLevel = 0;
			end
			if ( supportLevel == nil ) then
				supportLevel = 0;
			end

			local myMidLevel = nukerLevel + disablerLevel;
			if ( carryRolesCount > 1 and carryLevel > 0 ) then
				if ( supportLevel < midSupportLevel ) then
					midId = id;
					midLevel = myMidLevel;
					midSupportLevel = supportLevel;
				elseif ( supportLevel == midSupportLevel ) then
					if ( myMidLevel > midLevel ) then
						midId = id;
						midLevel = myMidLevel;
						midSupportLevel = supportLevel;
					end
				end
			end
		end
	end

	-- assign our mid-player with not enough 'carry' roles
	if ( midId < 0 or midLevel < 0 ) then
		for _, id in pairs(id_team) do
			local heroName = GetSelectedHeroName(id);
			local heroHero = hero_roles[heroName];

			if ( heroName ~= nil and heroName ~= "" and heroHero ~= nil ) then
				local nukerLevel = heroHero["nuker"];
				local disablerLevel = heroHero["disabler"];
				local supportLevel = heroHero["support"];

				if ( nukerLevel == nil ) then
					nukerLevel = 0;
				end
				if ( disablerLevel == nil ) then
					disablerLevel = 0;
				end
				if ( supportLevel == nil ) then
					supportLevel = 0;
				end

				local myMidLevel = nukerLevel + disablerLevel;
				if ( supportLevel < midSupportLevel ) then
					midId = id;
					midLevel = myMidLevel;
					midSupportLevel = supportLevel;
				elseif ( supportLevel == midSupportLevel ) then
					if ( myMidLevel > midLevel ) then
						midId = id;
						midLevel = myMidLevel;
						midSupportLevel = supportLevel;
					end
				end
			end
		end
	end

	-- make sure our mid-player
	teamRoles["mid"] = midId;

	-- assign our carry-player
	local carryId = -1;
	local carryLevel = -1;
	for _, id in pairs(id_team) do
		local heroName = GetSelectedHeroName(id);
		local heroHero = hero_roles[heroName];

		if ( heroName ~= nil and heroName ~= "" and heroHero ~= nil ) then
			if ( id ~= teamRoles["mid"] ) then
				local myCarryLevel = heroHero["carry"];

				if ( myCarryLevel == nil ) then
					myCarryLevel = 0;
				end

				if ( myCarryLevel > carryLevel ) then
					carryId = id;
					carryLevel = myCarryLevel;
				end
			end
		end
	end

	-- make sure our carry-player
	teamRoles["carry"] = carryId;

	-- assign our offlane-player
	local offlaneId = -1;
	local offlaneLevel = -1;
	local offlaneInitiatorLevel = -1;
	local offlaneSupportLevel = 10;
	for _, id in pairs(id_team) do
		local heroName = GetSelectedHeroName(id);
		local heroHero = hero_roles[heroName];

		if ( heroName ~= nil and heroName ~= "" and heroHero ~= nil ) then
			if ( id ~= teamRoles["mid"] and id ~= teamRoles["carry"] ) then
				local disablerLevel = heroHero["disabler"];
				local initiatorLevel = heroHero["initiator"];
				local supportLevel = heroHero["support"];

				if ( disablerLevel == nil ) then
					disablerLevel = 0;
				end
				if ( initiatorLevel == nil ) then
					initiatorLevel = 0;
				end
				if ( supportLevel == nil ) then
					supportLevel = 0;
				end

				local myOfflaneLevel = disablerLevel + initiatorLevel;
				if ( supportLevel < offlaneSupportLevel ) then
					offlaneId = id;
					offlaneLevel = myOfflaneLevel;
					offlaneInitiatorLevel = initiatorLevel;
					offlaneSupportLevel = supportLevel;
				elseif ( supportLevel == offlaneSupportLevel ) then
					if ( (myOfflaneLevel > offlaneLevel)
						or (myOfflaneLevel == offlaneLevel and initiatorLevel > offlaneInitiatorLevel) ) then
						offlaneId = id;
						offlaneLevel = myOfflaneLevel;
						offlaneInitiatorLevel = initiatorLevel;
						offlaneSupportLevel = supportLevel;
					end
				end
			end
		end
	end

	-- make sure our offlane-player
	teamRoles["offlane"] = offlaneId;

	-- assign our pureSupport-player
	local pureSupportId = -1;
	local pureSupportLevel = -1;
	for _, id in pairs(id_team) do
		local heroName = GetSelectedHeroName(id);
		local heroHero = hero_roles[heroName];

		if ( heroName ~= nil and heroName ~= "" and heroHero ~= nil ) then
			if ( id ~= teamRoles["mid"] and id ~= teamRoles["carry"] and id ~= teamRoles["offlane"] ) then
				local mySupportLevel = heroHero["support"];

				if ( mySupportLevel == nil ) then
					mySupportLevel = 0;
				end

				if ( mySupportLevel > pureSupportLevel ) then
					pureSupportId = id;
					pureSupportLevel = mySupportLevel;
				end
			end
		end
	end

	-- make sure our pureSupport-player
	teamRoles["pureSupport"] = pureSupportId;

	-- assign our semiSupport-player
	local semiSupportId = -1;
	for _, id in pairs(id_team) do
		local heroName = GetSelectedHeroName(id);
		local heroHero = hero_roles[heroName];

		if ( heroName ~= nil and heroName ~= "" and heroHero ~= nil ) then
			if ( id ~= teamRoles["mid"] and id ~= teamRoles["carry"]
				and id ~= teamRoles["offlane"] and id ~= teamRoles["pureSupport"] ) then
				semiSupportId = id;
			end
		end
	end

	-- make sure our semiSupport-player
	teamRoles["semiSupport"] = semiSupportId;

	return teamRoles;

end

----------------------------------------------------------------------------------------------------

function X.GetWardObserverCountIncludeStash()

	local npcBot = GetBot();

	local count = 0;

	for i = 0, 14 do
		local sCurItem = npcBot:GetItemInSlot(i);
		
		if ( sCurItem ~= nil and sCurItem:GetName() == "item_ward_observer" ) then
			local charges = sCurItem:GetCurrentCharges();
			count = count + charges;
		end

		if ( sCurItem ~= nil and sCurItem:GetName() == "item_ward_dispenser" ) then
			local charges = 0;
			if ( sCurItem:GetToggleState() ) then
				charges = sCurItem:GetCurrentCharges();
			else
				charges = sCurItem:GetSecondaryCharges();
			end
			
			count = count + charges;
		end
	end

	return count;

end

----------------------------------------------------------------------------------------------------

function X.HasEmptySlotsIncludeBackpack()

	local npcBot = GetBot();

	for i = 0, 8 do
		local sCurItem = npcBot:GetItemInSlot(i);
		
		if ( sCurItem == nil ) then
			return true;
		end
	end

	return false;
end

----------------------------------------------------------------------------------------------------

function X.HasEmptySlotsInInventory()

	local npcBot = GetBot();

	for i = 0, 5 do
		local sCurItem = npcBot:GetItemInSlot(i);
		
		if ( sCurItem == nil ) then
			return true;
		end
	end

	return false;
end

----------------------------------------------------------------------------------------------------

function X.HasItem( item_name )

	local npcBot = GetBot();
	npcBot.courier = GetCourier(0);

	for i = 0, 14 do
		local sCurItem = npcBot:GetItemInSlot(i);
		
		if ( sCurItem ~= nil and sCurItem:GetName() == item_name ) then
			return true;
		end
	end

	if ( npcBot.courier ~= nil ) then
		for i = 0, 8 do
			local sCurItem = npcBot.courier:GetItemInSlot(i);
			
			if ( sCurItem ~= nil and sCurItem:GetName() == item_name ) then
				return true;
			end
		end
	end

	return false;
end

----------------------------------------------------------------------------------------------------

return X;