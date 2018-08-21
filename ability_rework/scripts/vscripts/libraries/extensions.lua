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
function _DeepPrintTable(debugInstance, prefix, isOuterScope, chaseMetaTables ) 
    prefix = prefix or ""
    local string_accum = ""
    if debugInstance == nil then 
		print( prefix .. "<nil>" )
		return
    end
	local terminatescope = false
	local oldPrefix = ""
    if isOuterScope then  -- special case for outer call - so we dont end up iterating strings, basically
        if type(debugInstance) == "table" then 
            print( prefix .. "{" )
			oldPrefix = prefix
            prefix = prefix .. "   "
			terminatescope = true
        else 
            print( prefix .. " = " .. (type(debugInstance) == "string" and ("\"" .. debugInstance .. "\"") or debugInstance))
        end
    end
    local debugOver = debugInstance

	-- First deal with metatables
	if chaseMetaTables == true then
		if getmetatable( debugOver ) ~= nil and getmetatable( debugOver ).__index ~= nil then
			local thisMetaTable = getmetatable( debugOver ).__index 
			if vlua.find(_deepprint_alreadyseen, thisMetaTable ) ~= nil then 
				print( string.format( "%s%-32s\t= %s (table, already seen)", prefix, "metatable", tostring( thisMetaTable ) ) )
			else
				print(prefix .. "metatable = " .. tostring( thisMetaTable ) )
				print(prefix .. "{")
				table.insert( _deepprint_alreadyseen, thisMetaTable )
				_DeepPrintMetaTable( thisMetaTable, prefix .. "   ", false )
				print(prefix .. "}")
			end
		end
	end

	-- Now deal with the elements themselves
    for idx, data_value in pairs(debugOver) do
        if type(data_value) == "table" then 
            if vlua.find(_deepprint_alreadyseen, data_value) ~= nil then 
                print( string.format( "%s%-32s\t= %s (table, already seen)", prefix, idx, tostring( data_value ) ) )
            else
                local is_array = #data_value > 0
				local test = 1
				for idx2, val2 in pairs(data_value) do
					if type( idx2 ) ~= "number" or idx2 ~= test then
						is_array = false
						break
					end
					test = test + 1
				end
				local valtype = type(data_value)
				if is_array == true then
					valtype = "array table"
				end
                print( string.format( "%s%-32s\t= %s (%s)", prefix, idx, tostring(data_value), valtype ) )
                print(prefix .. (is_array and "[" or "{"))
                table.insert(_deepprint_alreadyseen, data_value)
                _DeepPrintTable(data_value, prefix .. "   ", false, true)
                print(prefix .. (is_array and "]" or "}"))
            end
		elseif type(data_value) == "string" then 
            print( string.format( "%s%-32s\t= \"%s\" (%s)", prefix, idx, data_value, type(data_value) ) )
		else 
            print( string.format( "%s%-32s\t= %s (%s)", prefix, idx, tostring(data_value), type(data_value) ) )
        end
    end
	if terminatescope == true then
		print( oldPrefix .. "}" )
	end
end

function debug.PrintTable(debugOver)
	local prefix = prefix or ""
	local string_accum = ""
	
	for idx, data_value in pairs(debugOver) do
        if type(data_value) == "table" then 
            if vlua.find(_deepprint_alreadyseen, data_value) ~= nil then 
                print( string.format( "%s%-32s\t= %s (table, already seen)", prefix, idx, tostring( data_value ) ) )
            else
                local is_array = #data_value > 0
				local test = 1
				for idx2, val2 in pairs(data_value) do
					if type( idx2 ) ~= "number" or idx2 ~= test then
						is_array = false
						break
					end
					test = test + 1
				end
				local valtype = type(data_value)
				if is_array == true then
					valtype = "array table"
				end
                print( string.format( "%s%-32s\t= %s (%s)", prefix, idx, tostring(data_value), valtype ) )
                print(prefix .. (is_array and "[" or "{"))
                table.insert(_deepprint_alreadyseen, data_value)
                _DeepPrintTable(data_value, prefix .. "   ", false, true)
                print(prefix .. (is_array and "]" or "}"))
            end
		elseif type(data_value) == "string" then 
            print( string.format( "%s%-32s\t= \"%s\" (%s)", prefix, idx, data_value, type(data_value) ) )
		else 
            print( string.format( "%s%-32s\t= %s (%s)", prefix, idx, tostring(data_value), type(data_value) ) )
        end
    end
end