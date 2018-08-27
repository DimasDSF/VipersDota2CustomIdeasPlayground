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

function math.mapl(value, explow, exphigh, outlow, outhigh)
	if outlow > outhigh then
		return math.clamp(outhigh, math.map(value, explow, exphigh, outlow, outhigh), outlow)
	else
		return math.clamp(outlow, math.map(value, explow, exphigh, outlow, outhigh), outhigh)
	end
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
function string.split(input, delimiter)
	local output = {}
    for match in input:gmatch("([^"..delimiter.."]+)") do
        table.insert(output, match)
    end
    return output
end

--Debug

function debug.PrintTable(debugOver, prefix)
	prefix = prefix or ""
	
	if type(debugOver) == "table" then
		print("Printing Table: "..tostring(debugOver))
		print("vvvvvvvvvvvvvv")
		for idx, data_value in pairs(debugOver) do
			if type(data_value) == "string" then 
				print( string.format( "%s%-32s\t= \"%s\" (%s)", prefix, idx, data_value, type(data_value) ) )
			else 
				print( string.format( "%s%-32s\t= %s (%s)", prefix, idx, tostring(data_value), type(data_value) ) )
			end
		end
		print("--------------")
	else
		print(tostring(debugOver).." is not a Table")
	end
end