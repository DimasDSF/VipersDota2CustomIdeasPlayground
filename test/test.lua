local test = require 'simple_test'
------------------------------
--APICallDummies
require('test/DotaAPIDummies')
------------------------------
require('ability_rework/scripts/vscripts/libraries/extensions')


test('Extensions:GetOpposingTeamNumber should return nil if teamNumber is nil', function(a)
	a.equal(Extensions:GetOpposingTeamNumber(nil), nil)
end)

test('Extensions:GetOpposingTeamNumber should return nil if teamNumber is not a number', function(a)
	a.equal(Extensions:GetOpposingTeamNumber("test"), nil)
end)

test('Extensions:GetOpposingTeamNumber should return nil if teamNumber is not 2 or 3', function(a)
	a.equal(Extensions:GetOpposingTeamNumber(4), nil)
	a.equal(Extensions:GetOpposingTeamNumber(1), nil)
end)

test('Extensions:GetOpposingTeamNumber should return Opposing Team Number', function(a)
	a.equal(Extensions:GetOpposingTeamNumber(2), 3)
	a.equal(Extensions:GetOpposingTeamNumber(3), 2)
end)

test('Extensions:CalculateArmorDamageReductionMultiplier should return nil if armor is nil', function(a)
	a.equal(Extensions:CalculateArmorDamageReductionMultiplier(nil), nil)
end)

test('Extensions:CalculateArmorDamageReductionMultiplier should return nil if armor is not a number', function(a)
	a.equal(Extensions:CalculateArmorDamageReductionMultiplier("test"), nil)
end)

test('math.scale calc test', function(a)
	a.equal(math.scale(0,0.6,10), 6.0)
	a.equal(math.scale(0,-1,10), -10.0)
end)

test('math.scale should return nil if values are nil or not numbers', function(a)
	a.equal(math.scale(nil,0.6,10), nil)
	a.equal(math.scale(0,nil,10), nil)
	a.equal(math.scale(0,0.6,nil), nil)
	a.equal(math.scale("test",0.6,10), nil)
	a.equal(math.scale(0,"test",10), nil)
	a.equal(math.scale(0,0.6,"test"), nil)
end)

test('math.map calc test', function(a)
	a.equal(math.map(7,0,10,0,1000), 700.0)
	a.equal(math.map(4.5,0,10,0,1000), 450.0)
	a.equal(math.map(-2,0,10,0,1000), -200.0)
end)

test('math.map should return nil if values are nil or not numbers', function(a)
	a.equal(math.map(nil,0,10,0,1000), nil)
	a.equal(math.map(7,nil,10,0,1000), nil)
	a.equal(math.map(7,0,nil,0,1000), nil)
	a.equal(math.map(7,0,10,nil,1000), nil)
	a.equal(math.map(7,0,10,0,nil), nil)
	a.equal(math.map(7,0,10,0), nil)
	a.equal(math.map("test",0,10,0,1000), nil)
end)

test('math.clamp calc test', function(a)
	a.equal(math.clamp(0,10,7), 7.0)
	a.equal(math.clamp(0,-2,7), 0.0)
end)

test('math.clamp should return nil if values are nil or not numbers or if min > max', function(a)
	a.equal(math.clamp(nil,10,7), nil)
	a.equal(math.clamp(0,nil,7), nil)
	a.equal(math.clamp(0,10,nil), nil)
	a.equal(math.clamp("test",10,7), nil)
	a.equal(math.clamp(0,"test",7), nil)
	a.equal(math.clamp(0,10,"test"), nil)
	a.equal(math.clamp(10,-2,7), nil)
end)

test('math.mapl calc test', function(a)
	a.equal(math.map(7,0,10,0,1000), 700.0)
	a.equal(math.map(4.5,0,10,0,1000), 450.0)
	a.equal(math.mapl(-2,0,10,0,1000), 0.0)
	a.equal(math.map(11,0,10,0,1000), 1000.0)
end)

test('math.mapl should return nil if values are nil or not numbers', function(a)
	a.equal(math.map(nil,0,10,0,1000), nil)
	a.equal(math.map(7,nil,10,0,1000), nil)
	a.equal(math.map(7,0,nil,0,1000), nil)
	a.equal(math.map(7,0,10,nil,1000), nil)
	a.equal(math.map(7,0,10,0,nil), nil)
	a.equal(math.map(7,0,10,0), nil)
	a.equal(math.map("test",0,10,0,1000), nil)
end)

test('math.floor calc test', function(a)
	a.equal(math.round(1.6), 2)
	a.equal(math.round(1.4), 1)
	a.equal(math.round(1), 1)
	a.equal(math.round(-1.1), -1)
	a.equal(math.round(-1.9), -2)
end)

test('math.floor should return nil if values are nil or not numbers', function(a)
	a.equal(math.round(nil), nil)
	a.equal(math.round(), nil)
	a.equal(math.round(test), nil)
	a.equal(math.round("test"), nil)
end)

test('math.truncate calc test', function(a)
	a.equal(math.truncate(1.235623, 2), 1.24)
	a.equal(math.truncate(1.235623, 4), 1.2356)
end)

test('math.truncate should return nil if values are nil or not numbers', function(a)
	a.equal(math.truncate(nil, 2), nil)
	a.equal(math.truncate(1.235623, nil), nil)
	a.equal(math.truncate(1.235623), nil)
	a.equal(math.truncate(), nil)
	a.equal(math.truncate("test", 2), nil)
end)

test('string.split test', function(a)
	a.equal(string.split("testing split/split testing","/")[2], "split testing")
	a.equal(string.split("testing split/split testing","/")[1], "testing split")
	a.equal(string.split("t.e.s.t/.t.s.e.t",".")[8], "t")
end)

test('string.split should return nil if values are nil or not strings', function(a)
	a.equal(string.split()[1], nil)
	a.equal(string.split("testing split/split testing")[1], nil)
end)
