if not BotRolesLib then
	BotRolesLib = class({})
end

function BotRolesLib:Init()
	self.heroDB = {}
	self.botheroes = {}
	self.DBReady = false
end

local typeweights = {
	["DOTA_BOT_PURE_SUPPORT"] = 1,
	["DOTA_BOT_STUN_SUPPORT"] = 2,
	["DOTA_BOT_PUSH_SUPPORT"] = 3,
	["DOTA_BOT_GANKER"] = 4,
	["DOTA_BOT_TANK"] = 5,
	["DOTA_BOT_SEMI_CARRY"] = 6,
	["DOTA_BOT_HARD_CARRY"] = 7,
}

local middesiredheroes = {
	['npc_dota_hero_nevermore'] = true,
	['npc_dota_hero_death_prophet'] = true,
	['npc_dota_hero_zuus'] = true,
	['npc_dota_hero_skywrath_mage'] = true
}

function BotRolesLib:GetTypeWeight(typestring)
	local weight = 0
	local types = string.split(typestring, " | ")
	for _,t in ipairs(types) do
		print(t)
		local w = typeweights[t] or 0
		if w > weight then
			weight = w
		end
	end
	return weight
end

function BotRolesLib:ParseHeroList(heroes)
	self.botheroes = heroes
	for _,v in ipairs(heroes) do
		local heroname = v:GetName()
		local heroKV = KeyValuesManager:GetHeroKV(heroname)
		if heroKV then
			local herotypestring = heroKV.Bot.HeroType
			local herosolodesire = heroKV.Bot.LaningInfo.SoloDesire
			local herofarmdesire = heroKV.Bot.LaningInfo.RequiresFarm
			local herorequiressetup = heroKV.Bot.LaningInfo.RequiresSetup
			local herorequiresbabysit = heroKV.Bot.LaningInfo.RequiresBabysit
			if self.heroDB[heroname] == nil then
				table.insert(self.heroDB, heroname)
			end
			local fweight = BotRolesLib:GetTypeWeight(herotypestring)
			self.heroDB[heroname] = {farmweight = fweight + herofarmdesire, types = string.split(herotypestring, " | "), typeweight = fweight, farmdesire = herofarmdesire, solodesire = herosolodesire, requiressetup = herorequiressetup, requiresbabysit = herorequiresbabysit, hero = v}
			print(heroname.." : farmweight: "..(fweight + herofarmdesire)..", solo desire: "..herosolodesire)
		end
	end
	Extensions:CallWithDelay(2, true, function()
		self.DBReady = true
		print('BotRolesLib Database Ready.')
	end)
end

function BotRolesLib:GetHeroDBEntry(hero)
	if hero then
		if type(hero) == 'string' then
			return self.heroDB[hero] or {}
		else
			return self.heroDB[hero:GetName()] or {}
		end
	end
	return {}
end

function BotRolesLib:GetMidLaner()
	local highestsolodes = {-1, nil}
	if self.DBReady then
		for _,herodata in ipairs(BotRolesLib.heroDB) do
			local data = BotRolesLib.heroDB[herodata]
			if data.solodesire + data.farmdesire + math.bool(data.typeweight >= 7) + math.bool(data.requiresbabysit < 2) + (math.bool(table.contains(data.types, "DOTA_BOT_GANKER"))*3) + math.bool(data.requiressetup < 1) + math.bool(middesiredheroes[data.hero:GetName()]) > highestsolodes[1] then
				highestsolodes = {data.solodesire + data.farmdesire + math.bool(data.typeweight >= 7) + math.bool(data.requiresbabysit < 2) + (math.bool(table.contains(data.types, "DOTA_BOT_GANKER"))*3) + math.bool(data.requiressetup < 1) + math.bool(middesiredheroes[data.hero:GetName()]), data.hero}
			end
			print(data.hero:GetName().." : "..tostring(data.solodesire + data.farmdesire + math.bool(data.typeweight >= 7) + math.bool(data.requiresbabysit < 2) + (math.bool(table.contains(data.types, "DOTA_BOT_GANKER"))*3) + math.bool(data.requiressetup < 1) + math.bool(middesiredheroes[data.hero:GetName()])).." - "..highestsolodes[1])
		end
	end
	return highestsolodes[2]
end

function BotRolesLib:HeroIsASupport(hero)
	if hero and self.DBReady then
		local heroname = hero
		if type(hero) ~= 'string' then
			heroname = hero:GetName()
		end
		local data = BotRolesLib.heroDB[heroname]
		return ((table.contains(data.types, "DOTA_BOT_PURE_SUPPORT") or table.contains(data.types, "DOTA_BOT_PUSH_SUPPORT") or table.contains(data.types, "DOTA_BOT_STUN_SUPPORT")) and not (data.farmdesire > 1 or table.contains(data.types, "DOTA_BOT_TANK") or table.contains(data.types, "DOTA_BOT_SEMI_CARRY") or table.contains(data.types, "DOTA_BOT_HARD_CARRY")))
	end
	return false
end

function BotRolesLib:HeroIsACarry(hero)
	if hero and self.DBReady then
		local heroname = hero
		if type(hero) ~= 'string' then
			heroname = hero:GetName()
		else
			local function GetHeroFromListByName(hn)
				for _,v in ipairs(self.botheroes) do
					if v:GetName() == hn then
						return v
					end
				end
			end
			hero = GetHeroFromListByName(heroname)
		end
		local data = BotRolesLib.heroDB[heroname]
		local cs = hero:GetLastHits()
		return ((cs >= GameRules:GetDOTATime(false, false) * 5 and table.contains(data.types, "DOTA_BOT_SEMI_CARRY")) or table.contains(data.types, "DOTA_BOT_HARD_CARRY"))
	end
	return false
end

function BotRolesLib:GetPureSupport()
	local herofd = {99999, nil}
	if self.DBReady then
		for _,herodata in ipairs(BotRolesLib.heroDB) do
			local data = BotRolesLib.heroDB[herodata]
			if data.farmweight < herofd[1] then
				herofd = {data.farmweight, data.hero}
			end
		end
	end
	return herofd[2]
end

GameRules.BotRolesLib = BotRolesLib