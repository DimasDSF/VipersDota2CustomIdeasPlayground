--Extensions for various standart libs

--math
function math.scale( min, value, max )
	return value * (max - min) + min
end

function math.map(value, explow, exphigh, outlow, outhigh)
	return outlow + (value - explow) * (outhigh - outlow) / (exphigh - explow)
end

function math.clamp(min, value, max)
	if (value < min) then return min end
	if (value > max) then return max end
	return value
end

function math.isNaN(input)
	return input ~= input
end

function math.round(input)
    if input >= 0 then
		return math.floor(input + 0.5)
	else
		return math.ceil(input - 0.5)
	end
end

function math.truncate(input, num)
	return math.round(input * (10 ^ num)) / (10 ^ num);
end

--string
function string.split(input)
	local output = {}
	for i in string.gmatch(input, "%S+") do
		table.insert(output, i)
	end
	return output
end