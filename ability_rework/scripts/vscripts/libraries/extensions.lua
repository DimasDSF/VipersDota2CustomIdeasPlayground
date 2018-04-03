--Extensions for various standart libs

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

function string.split(input)
	local output = {}
	for i in string.gmatch(input, "%S+") do
		table.insert(output, i)
	end
	return output
end