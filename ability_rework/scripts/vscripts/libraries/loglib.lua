if not LogLib then
	LogLib = class({})
end

local GAME_NAME = "VGMAR"
local LOG_DIR = "log/"..GAME_NAME
local LOG_EXT = ".log"
local logtypetexttable = {
	["balance"] = "BalanceLog",
	["perf"] = "PerformanceLog",
	["info"] = "InfoLog",
	["warning"] = "WarningLog",
	["error"] = "ErrorLog"
}

function LogLib:Init()
	if IsDedicatedServer() then
		print("[LogLib] : Disabled due to being run on a Dedicated Server")
	else
		local gamestartdate = string.split(string.gsub(GetSystemDate(), "/", " "))
		self.GameStartDate = gamestartdate[2].."."..gamestartdate[1].."."..gamestartdate[3]
		self.GameStartTime = string.gsub(GetSystemTime(), ":", " ")
		print("[LogLib] : Initiated")
	end
end

function LogLib:WriteLog(logtype, indent, writetime, ...)
	if IsDedicatedServer() then
		print("{LogLib]: Log Creation is Disabled for Dedicated Servers")
	else
		local logtypetext = "Log"
		if logtypetexttable[logtype] ~= nil then
			logtypetext = logtypetexttable[logtype]
		end
		local logname = LOG_DIR.."/"..logtypetexttable[logtype].."-"..self.GameStartDate.." - "..self.GameStartTime..LOG_EXT
		local indentchar = " "
		local indentstr = string.rep(indentchar, indent * 2)
		local text = ""
		if writetime == true then
			local timeminute = math.floor(GameRules:GetDOTATime(false, false) / 60)
			local timesecond = math.floor(GameRules:GetDOTATime(false, false) % 60)
			text = string.format("%s %s %s", indentstr, "["..GetSystemTime().." / "..timeminute..":"..timesecond.."]", ...)
		else
			text = string.format("%s %s",indentstr, ...)
		end
		InitLogFile(logname, logtypetext.." for "..GAME_NAME.." game\nStart Date "..self.GameStartDate.."\nStart Time "..self.GameStartTime.."\n")
		AppendToLogFile(logname, text.."\n")
	end
end


GameRules.LogLib = LogLib
