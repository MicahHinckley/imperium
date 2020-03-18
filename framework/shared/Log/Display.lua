--< Variables >--
local Display = nil

--< Functions >--
local function Indent(str)
	return str:gsub("\n", "\n" .. "    ")
end

local function DisplayTable(tbl)
    local Buffer = {"\n{"}

	for key,value in pairs(tbl) do
		local displayKey = Display(key)
		local displayValue = Indent(Display(value))
		local pair = ("    [%s] = %s,"):format(displayKey, displayValue)
		table.insert(Buffer, pair)
	end

	table.insert(Buffer, "}")

	return table.concat(Buffer, "\n")
end

--< Module >--
function Display(value)
    local Type = type(value)

    if Type == "string" then
        return string.format("%q", value)
    elseif Type == "table" then
        local Meta = getmetatable(value)

        if Meta ~= nil and Meta.__tostring ~= nil then
            return tostring(value)
        end

        return DisplayTable(value)
    else
        return tostring(value)
    end
end

return Display