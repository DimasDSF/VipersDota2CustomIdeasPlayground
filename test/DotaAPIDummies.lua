--[[
|------------------------------------------------------------|
|      Include contating dummies used to replace globals     |
|      specifically created by DotaAPI to allow testing      |
|                    software to run tests                   |
|------------------------------------------------------------|
	Do not include this anywhere except for testing scripts!
--]]
function class()
	return {}
end
GameRules = {}
CBaseEntity = {}
LogLib = {}
--Fake Functions for testing outputs without including other modules or closed source APIs
function LogLib:Log_Error() end
function LogLib:Log_Warning() end
function FindUnitsInRadius()
	return {"unit1", "unit2", "unit3"}
end
