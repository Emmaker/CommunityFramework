require "/scripts/util.lua"
cfutil = {}

function cfutil.printTable(tbl)
	if type(tbl) == "table" then
		local str = "\n{"
		for k, v in pairs(tbl) do
			local lenFix = ""
			for i = 1, 30 - string.len(tostring(k)) do 
				lenFix = lenFix.." "
			end
			
			str = str .. "\n	" .. tostring(k) .. lenFix .. "=          (" .. type(v) .. ") " .. tostring(v)         
		end
		
		sb.logInfo("\n%s", str.."\n}")
	else
		sb.logInfo("\n%s", tbl)
	end
end

function cfutil.deepPrintTable(tbl)
	sb.logInfo("%s", cfutil._deepPrintTableHelper(tbl, 0))
end

function cfutil._deepPrintTableHelper(toPrint, level)
	level = level or 0
	local str = ""
	
	if type(toPrint) == "table" then
		for k, v in pairs(toPrint) do
			for i = 0, level do
				str = str.."	"
			end
			
			local lenFix = ""
			for i = 1, 30 - string.len(tostring(k)) do 
				lenFix = lenFix.." "
			end
			
			str = str .. tostring(k) .. lenFix .. "=          (" .. type(v) .. ") " .. tostring(v)
			
			if type(v) == "table" then
				str = str .. cfutil._deepPrintTableHelper(v, level +1) .. "\n"
			else
				str = str .. "\n"
			end
		end
	
	else
		str = tostring(toPrint)
	end
	
	return "\n" .. str
end

function cfutil.numToHex(num)
	num = util.clamp(math.floor(num + 0.5), 0, 255)
	
	local hexidecimal = "0123456789ABCDEF"
	local units = num % 16 + 1
	local tens = math.floor(num/16) + 1
	return string.sub(hexidecimal, tens, tens) .. string.sub(hexidecimal, units, units)
end

function cfutil.percToHex(num)
	return cfutil.NumToHex(255 * util.clamp(num, 0, 1))
end

function cfutil.hexToNum(hex)
	hex = string.upper(hex)
	if string.len(hex) == 1 then
		hex = "0" .. hex
	elseif string.len(hex) == 0 then
		return 0
	end
	
	local hexidecimal = "0123456789ABCDEF"
	local tens = string.find(hexidecimal, string.sub(hex, 1, 1))
	local units = string.find(hexidecimal, string.sub(hex, 2, 2))
	return (tonumber(tens) - 1) * 16 + (tonumber(units) - 1)
end

function cfutil.fadeHex(hex, fade, amount, target)
	if target then target = cfutil.hexToNum(hex) end
	amount = math.floor(amount + 0.5)
	fade = string.lower(fade)
	
	local rgbValue = cfutil.hexToNum(hex)
	
	if fade == "out" then
		rgbValue = math.max(target or 0, rgbValue - amount)
	elseif fade == "in" then
		rgbValue = math.min(target or 255, rgbValue + amount)
	else
		sb.logError("'cfutil.fadeHex' 2nd arguement not 'in' or 'out'")
		return "00"
	end
	
	return cfutil.numToHex(rgbValue)
end

function cfutil.rollDice(dice, sides, mod)
	local sum = mod or 0
	
	for i = 1, dice do
		sum = sum + math.random(1, sides)
	end
	
	return sum
end

function cfutil.mergeTable(t1, t2)
	if cfutil.IsArray(t2) then
		for _, v in ipairs(t2) do
			table.insert(t1, v)
		end
	elseif cfutil.IsArray(t1) then
		local length = #t2
		for _, v in ipairs(t2) do
			table.insert(t1, v)
		end
		
		for k, v in pairs(t2) do
			if type(k) ~= "number" or k > length then
				if type(v) == "table" and type(t1[k]) == "table" then
					cfutil.MergeTable(t1[k] or {}, v)
				else
					t1[k] = v
				end
			end
		end
	else
		for k, v in pairs(t2) do
			if type(v) == "table" and type(t1[k]) == "table" then
				cfutil.MergeTable(t1[k] or {}, v)
			else
				t1[k] = v
			end
		end
	end
	return t1
end

function cfutil.isArray(tbl)
	if type(tbl) == "table" then
		local length = #tbl
		for i, _ in pairs(tbl) do
			if type(i) ~= "number" or i > length then
				return false
			end
		end
		return true
	end
	return false
end

function cfutil.positionWhithinBounds(target, startPoint, endPoint)
	return (target[1] >= startPoint[1] and target[1] <= endPoint[1] and target[2] >= startPoint[2] and target[2] <= endPoint[2])
end

function cfutil.positionWhithinBox(target, box)
	return (target[1] >= box[1] and target[1] <= box[3] and target[2] >= box[2] and target[2] <= box[4])
end