_G._savedEnv = getfenv()
module( "ability_item", package.seeall )

----------------------------------------------------------------------------------------------------

local A = require( GetScriptDirectory() .. "/gxc/gxcA" )

----------------------------------------------------------------------------------------------------

function BuybackUsageThink()

	A.BuybackUsageThink();

end

----------------------------------------------------------------------------------------------------

function AbilityLevelUpThink()

	A.AbilityLevelUpThink();
	A.AbilityUsageThink();

end

----------------------------------------------------------------------------------------------------

function CourierUsageThink()

	A.CourierUsageThink();

end

----------------------------------------------------------------------------------------------------

for k,v in pairs( ability_item ) do	_G._savedEnv[k] = v end