_G._savedEnv = getfenv()
module( "doBot", package.seeall )

----------------------------------------------------------------------------------------------------

local A = require( GetScriptDirectory() .. "/gxc/gxcA" )

----------------------------------------------------------------------------------------------------

function BuybackUsageThink()

	A.BuybackUsageThink();

end

----------------------------------------------------------------------------------------------------

function AbilityLevelUpThink()

	A.AbilityLevelUpThink();

end

----------------------------------------------------------------------------------------------------

function CourierUsageThink()

	print("CourierUsageThink")
	A.CourierUsageThink();

end

----------------------------------------------------------------------------------------------------

-- ItemUsageThink seems to affect all the heroes' item usage? Strange!
function ItemUsage()

	A.ItemUsageThink();

end

----------------------------------------------------------------------------------------------------

function AbilityUsageThink()

	A.AbilityUsageThink();

end

----------------------------------------------------------------------------------------------------

for k,v in pairs( doBot ) do	_G._savedEnv[k] = v end