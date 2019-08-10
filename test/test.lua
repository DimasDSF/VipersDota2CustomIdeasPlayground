local test = require 'simple_test'
------------------------------
--APICallDummies
require('test/DotaAPIDummies')
------------------------------
require('ability_rework/scripts/vscripts/libraries/extensions')


test('Extensions:GetOpposingTeamNumber should return nil if teamNumber is nil', function(a)
	a.equal(nil, Extensions:GetOpposingTeamNumber(nil))
end)

test('Extensions:GetOpposingTeamNumber should return nil if teamNumber is not a number', function(a)
	a.equal(nil, Extensions:GetOpposingTeamNumber("test"))
end)

test('Extensions:GetOpposingTeamNumber should return nil if teamNumber is not 2 or 3', function(a)
	a.equal(nil, Extensions:GetOpposingTeamNumber(4))
	a.equal(nil, Extensions:GetOpposingTeamNumber(1))
end)

test('Extensions:GetOpposingTeamNumber should return Opposing Team Number', function(a)
	a.equal(3, Extensions:GetOpposingTeamNumber(2))
	a.equal(2, Extensions:GetOpposingTeamNumber(3))
end)

test('Extensions:CalculateArmorDamageReductionMultiplier should return nil if armor is nil', function(a)
	a.equal(nil, Extensions:CalculateArmorDamageReductionMultiplier(nil))
end)

test('Extensions:CalculateArmorDamageReductionMultiplier should return nil if armor is not a number', function(a)
	a.equal(nil, Extensions:CalculateArmorDamageReductionMultiplier("test"))
end)

test('Extensions:IsVisibleToTeam should return false if input entity is nil', function(a)
	a.equal(false, Extensions:IsVisibleToTeam(nil, 2))
end)

test('Extensions:IsVisibleToTeam should return nil if team is incorrect', function(a)
	a.equal(nil, Extensions:IsVisibleToTeam("test", "radnt"))
	a.equal(nil, Extensions:IsVisibleToTeam("test", "dre"))
	a.equal(nil, Extensions:IsVisibleToTeam("test", 1))
	a.equal(nil, Extensions:IsVisibleToTeam("test", -10))
	a.equal(nil, Extensions:IsVisibleToTeam("test", nil))
	a.equal(nil, Extensions:IsVisibleToTeam("test"))
end)

test('Extensions:IsVisibleToTeam should return correct output', function(a)
	a.equal(true, Extensions:IsVisibleToTeam("unit1", 2))
	a.equal(true, Extensions:IsVisibleToTeam("unit2", 2))
	a.equal(true, Extensions:IsVisibleToTeam("unit3", 2))
	a.equal(true, Extensions:IsVisibleToTeam("unit3", 3))
	a.equal(true, Extensions:IsVisibleToTeam("unit3", "radiant"))
	a.equal(true, Extensions:IsVisibleToTeam("unit3", "dire"))
	a.equal(false, Extensions:IsVisibleToTeam("unit4", 2))
	a.equal(false, Extensions:IsVisibleToTeam("unit4", 3))
	a.equal(false, Extensions:IsVisibleToTeam("unit4", "radiant"))
	a.equal(false, Extensions:IsVisibleToTeam("unit4", "dire"))
end)

test('math.scale calc test', function(a)
	a.equal(6.0, math.scale(0,0.6,10))
	a.equal(-10.0, math.scale(0,-1,10))
end)

test('math.scale should return nil if values are nil or not numbers', function(a)
	a.equal(nil, math.scale(nil,0.6,10))
	a.equal(nil, math.scale(0,nil,10))
	a.equal(nil, math.scale(0,0.6,nil))
	a.equal(nil, math.scale("test",0.6,10))
	a.equal(nil, math.scale(0,"test",10))
	a.equal(nil, math.scale(0,0.6,"test"))
end)

test('math.map calc test', function(a)
	a.equal(math.map(7,0,10,0,1000), 700.0)
	a.equal(math.map(4.5,0,10,0,1000), 450.0)
	a.equal(math.map(-2,0,10,0,1000), -200.0)
end)

test('math.map should return nil if values are nil or not numbers', function(a)
	a.equal(nil, math.map(nil,0,10,0,1000))
	a.equal(nil, math.map(7,nil,10,0,1000))
	a.equal(nil, math.map(7,0,nil,0,1000))
	a.equal(nil, math.map(7,0,10,nil,1000))
	a.equal(nil, math.map(7,0,10,0,nil))
	a.equal(nil, math.map(7,0,10,0))
	a.equal(nil, math.map("test",0,10,0,1000))
end)

test('math.clamp calc test', function(a)
	a.equal(7.0, math.clamp(0,10,7))
	a.equal(0.0, math.clamp(0,-2,7))
end)

test('math.clamp should return nil if values are nil or not numbers or if min > max', function(a)
	a.equal(nil, math.clamp(nil,10,7))
	a.equal(nil, math.clamp(0,nil,7))
	a.equal(nil, math.clamp(0,10,nil))
	a.equal(nil, math.clamp("test",10,7))
	a.equal(nil, math.clamp(0,"test",7))
	a.equal(nil, math.clamp(0,10,"test"))
	a.equal(nil, math.clamp(10,-2,7))
end)

test('math.mapl calc test', function(a)
	a.equal(700.0, math.mapl(7,0,10,0,1000))
	a.equal(450.0, math.mapl(4.5,0,10,0,1000))
	a.equal(0.0, math.mapl(-2,0,10,0,1000))
	a.equal(1000.0, math.mapl(11,0,10,0,1000))
end)

test('math.mapl should return nil if values are nil or not numbers', function(a)
	a.equal(nil, math.mapl(nil,0,10,0,1000))
	a.equal(nil, math.mapl(7,nil,10,0,1000))
	a.equal(nil, math.mapl(7,0,nil,0,1000))
	a.equal(nil, math.mapl(7,0,10,nil,1000))
	a.equal(nil, math.mapl(7,0,10,0,nil))
	a.equal(nil, math.mapl(7,0,10,0))
	a.equal(nil, math.mapl("test",0,10,0,1000))
end)

test('math.round calc test', function(a)
	a.equal(2, math.round(1.6))
	a.equal(1, math.round(1.4))
	a.equal(1, math.round(1))
	a.equal(-1, math.round(-1.1))
	a.equal(-2, math.round(-1.9))
end)

test('math.round should return nil if values are nil or not numbers', function(a)
	a.equal(nil, math.round(nil))
	a.equal(nil, math.round())
	a.equal(nil, math.round(test))
	a.equal(nil, math.round("test"))
end)

test('math.truncate calc test', function(a)
	a.equal(1.24, math.truncate(1.235623, 2))
	a.equal(1.2356, math.truncate(1.235623, 4))
end)

test('math.truncate should return nil if values are nil or not numbers', function(a)
	a.equal(nil, math.truncate(nil, 2))
	a.equal(nil, math.truncate(1.235623, nil))
	a.equal(nil, math.truncate(1.235623))
	a.equal(nil, math.truncate())
	a.equal(nil, math.truncate("test", 2))
end)

test('math.bool test', function(a)
	a.equal(1, math.bool(true))
	a.equal(0, math.bool(false))
	a.equal(0, math.bool(nil))
end)

test('string.split test', function(a)
	a.equal("split testing", string.split("testing split/split testing","/")[2])
	a.equal("testing split", string.split("testing split/split testing","/")[1])
	a.equal("t", string.split("t.e.s.t/.t.s.e.t",".")[8])
end)

test('string.split should return nil if values are nil or not strings', function(a)
	a.equal(nil, string.split()[1])
	a.equal(nil, string.split("testing split/split testing")[1])
end)

function is_in_table(table, key)
	for _, k in pairs(table) do
		if k == key then
			return true
		end
	end
	return false
end

test('table.random should return nil if input is incorrect', function(a)
	a.equal(nil, table.random({}))
	a.equal(nil, table.random("test"))
	a.equal(nil, table.random(11))
end)

test('table.random should return the value if input is a table of 1', function(a)
	a.equal(1, table.random({1}))
	a.equal("test", table.random({"test"}))
end)

test('table.random should return a random value from the input table if input is correct', function(a)
	local testtable = {
		1,
		2,
		3
	}
	local testtable2 = {
		"test",
		"test2"
	}
	local testtable3 = {
		{1, 11, 111},
		{2, 22, 222},
		{3, 33, 333}
	}
	local trand = table.random(testtable)
	a.ok(is_in_table(testtable, trand), "Failed Random Integer from table")
	trand = table.random(testtable2)
	a.ok(is_in_table(testtable2, trand), "Failed Random String from table")
	trand = table.random(testtable3)
	local ttest1 = trand[1] == 1 or trand[1] == 2 or trand[1] == 3
	local ttest2 = trand[2] == 11 or trand[2] == 22 or trand[2] == 33
	local ttest3 = trand[3] == 111 or trand[3] == 222 or trand[3] == 333
	local ttests = ttest1 and ttest2 and ttest3
	a.ok(ttests, "Failed Random Table from table")
end)

test('table.contains should return nil if input is not a table', function(a)
	a.equal(nil, table.contains(1, 2))
end)

test('table.contains should return nil if input is nil', function(a)
	a.equal(nil, table.contains())
end)

test('table.contains should return false if key is nil', function(a)
	a.equal(false, table.contains({1,2,3}))
end)

test('table.contains should return false if table is empty', function(a)
	a.equal(false, table.contains({}, 2))
end)

test('table.contains should return the correct output', function(a)
	local testtable = {
		1,
		2,
		3
	}
	local testtable2 = {
		"test",
		"test2"
	}
	local testtable3 = {
		{1, 11, 111},
		{2, 22, 222},
		{3, 33, 333}
	}
	a.ok(table.contains(testtable, 1), "Failed Integer Test")
	a.ok(table.contains(testtable2, 'test2'), "Failed String Test")
	a.ok(table.contains(testtable3, {3, 33, 333}), "Failed Table Test")
end)

test('table.equals should compare values if input is not a table', function(a)
	a.ok(table.equals(1,1), "Failed Integer not in a table Test")
	a.ok(table.equals("test","test"), "Failed String not in a table Test")
	a.ok(table.equals("test","test1")==false, "Failed not equal String not in a table Test")
end)

test('table.equals should return false if input is not a table and type is not the same', function(a)
	a.ok(table.equals(1,"test")==false, "Failed Type Mismatch Test")
end)

test('table.equals should return false if input table contents quantity does not match', function(a)
	a.ok(table.equals({1, 2},{1, 2, 3})==false, "Failed contents quantity mismatch Test")
end)

test('table.equals should return correct output', function(a)
	local testtable = {
		1,
		2,
		3
	}
	local testtable2 = {
		"test",
		"test2"
	}
	local testtable3 = {
		{1, 11, 111},
		{2, 22, 222},
		{3, 33, 333}
	}
	local testtable4 = {
		{1, 11, 111},
		{2, {22, 22}, 222},
		{3, 33, 333}
	}
	a.ok(table.equals(testtable, {1,2,3}), "Failed Integer Table Test")
	a.ok(table.equals(testtable2, {'test','test2'}), "Failed String Table Test")
	a.ok(table.equals(testtable3, {{1, 11, 111},{2, 22, 222},{3, 33, 333}}), "Failed Nested Table Test")
	a.ok(table.equals(testtable4, {{1, 11, 111},{2, {22, 22}, 222},{3, 33, 333}}), "Failed Nested Table Test 2")
	a.ok(table.equals(testtable4, {{1, 11, 111},{2, {22, 11}, 222},{3, 33, 333}}) == false, "Failed Nested Table Test 3")
end)

test('table.getkeys should return nil if input is nil', function(a)
	a.equal(nil, table.getkeys())
end)

test('table.getkeys should return nil if input is not a table', function(a)
	a.equal(nil, table.getkeys(2))
	a.equal(nil, table.getkeys("test"))
end)

test('table.getkeys should return the correct output', function(a)
	local testtable1 = {
		["t1"] = {1, 2, 3},
		["t2"] = {4, 5, 6},
		["t3"] = {7, 8, 9}
	}
	local testtable1r = {
		"t1",
		"t2",
		"t3"
	}
	local testtable2 = {}
	a.ok(table.equals(table.getkeys(testtable1), testtable1r), "Failed testtable1 return test.")
	a.ok(table.equals(table.getkeys(testtable2), {}), "Failed empty table return test.")
end)
