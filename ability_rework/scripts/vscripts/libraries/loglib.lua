if not LogLib then
	LogLib = class({})
end

local GAME_NAME = "VGMAR"
local ENABLE_FORCED_LOG = true
local DEVMODE_CONVAR = "vgmar_devmode"
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
		local gamestartdate = string.split(GetSystemDate(), "/")
		self.GameStartDate = gamestartdate[2].."."..gamestartdate[1].."."..gamestartdate[3]
		self.GameStartTime = string.gsub(GetSystemTime(), ":", " ")
		self.ErrorsLogged = 0
		self.WarningsLogged = 0
		self.InfosLogged = 0
		ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( LogLib, 'OnGameStateChanged' ), self )
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

function LogLib:DisplayClientError(pid, message)
    local player = PlayerResource:GetPlayer(pid)
    if player then
        CustomGameEventManager:Send_ServerToPlayer(player, "VGMARDisplayError", {message=message})
    end
end

function LogLib:OnGameStateChanged( keys )
	local state = GameRules:State_Get()
	if state == DOTA_GAMERULES_STATE_POST_GAME then
		if self.ErrorsLogged+self.WarningsLogged > 0 then
			self:DisplayClientError(0, self.ErrorsLogged+self.WarningsLogged.." errors or warnings logged. Check Logs")
		end
		if self.ErrorsLogged > 0 then
			GameRules:SendCustomMessageToTeam("<font color='red'>"..self.ErrorsLogged.." Errors logged.", DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS)
		end
		if self.WarningsLogged > 0 then
			GameRules:SendCustomMessageToTeam("<font color='yellow'>"..self.WarningsLogged.." Warnings logged.", DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS)
		end
		if self.InfosLogged > 0 then
			GameRules:SendCustomMessageToTeam("<font color='honeydew'>"..self.InfosLogged.." Info logged.", DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS, DOTA_TEAM_GOODGUYS)
		end
	end
end

function LogLib:Log_Warning(text, indent, header)
	if ENABLE_FORCED_LOG or Convars:GetInt(DEVMODE_CONVAR) == 1 then
		if Convars:GetInt(DEVMODE_CONVAR) == 1 then
			Warning(text.."\n")
			self:DisplayClientError(0, "Logged Warning, Check console.")
		end
		if header ~= nil then
			self.WarningsLogged = self.WarningsLogged + 1
		end
		local ind = (tonumber(indent)~=nil and indent) or 1
		if header ~= nil then
			LogLib:WriteLog("warning", 0, false, "----------------")
			LogLib:WriteLog("warning", 0, true, header)
		end
		LogLib:WriteLog("warning", ind, false, text)
	end
end

function LogLib:Log_Error(text, indent, header)
	if ENABLE_FORCED_LOG or Convars:GetInt(DEVMODE_CONVAR) == 1 then
		if Convars:GetInt(DEVMODE_CONVAR) == 1 then
			Warning(text.."\n")
			self:DisplayClientError(0, "Logged Error, Check console.")
		end
		if header ~= nil then
			self.ErrorsLogged = self.ErrorsLogged + 1
		end
		local ind = (tonumber(indent)~=nil and indent) or 1
		if header ~= nil then
			LogLib:WriteLog("error", 0, false, "----------------")
			LogLib:WriteLog("error", 0, true, header)
		end
		LogLib:WriteLog("error", ind, false, text)
	end
end

function LogLib:Log_Info(text, indent, header)
	if ENABLE_FORCED_LOG or Convars:GetInt(DEVMODE_CONVAR) == 1 then
		if Convars:GetInt(DEVMODE_CONVAR) == 1 then
			Msg(text.."\n")
		end
		if header ~= nil then
			self.InfosLogged = self.InfosLogged + 1
		end
		local ind = (tonumber(indent)~=nil and indent) or 1
		if header ~= nil then
			LogLib:WriteLog("info", 0, false, "----------------")
			LogLib:WriteLog("info", 0, true, header)
		end
		LogLib:WriteLog("info", ind, false, text)
	end
end

GameRules.LogLib = LogLib
