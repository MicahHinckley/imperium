local function writeToBuffer(buffer, value)
    local lastValue = buffer[#buffer]

    if type(value) == "string" and type(lastValue) == "string" then
        buffer[#buffer] = lastValue .. value
    else
        table.insert(buffer, value)
    end
end

local function debugRepresentation(buffer, value)
    local type = typeof(value)

    if type == "string" then
        writeToBuffer(buffer, string.format("%q", value))
    elseif type == "table" then
        local metatable = getmetatable(value)

        if metatable ~= nil and metatable.__fmtDebug ~= nil then
            writeToBuffer(buffer, metatable.__fmtDebug(value))
        else
            writeToBuffer(buffer, value)
        end
    elseif type == "Instance" then
        writeToBuffer(buffer, value:GetFullName())
    else
        writeToBuffer(buffer, tostring(value))
    end
end

local function fmt(template, ...)
    local buffer = {}

    local currentArgument = 0
    local index = 1
    local length = #template

    while index <= length do
        local openBrace = string.find(template, "{", index)

        if openBrace == nil then
            writeToBuffer(buffer, string.sub(template, index))

            break
        else
            local charAfterBrace = string.sub(openBrace + 1, openBrace + 1)

            if charAfterBrace == "{" then
                writeToBuffer(buffer, string.sub(template, index, openBrace))

                index = openBrace + 2
            else
                if openBrace - index > 0 then
                    writeToBuffer(buffer, string.sub(template, index, openBrace - 1))
                end

                local closeBrace = string.find(template, "}", openBrace + 1)

                local formatSpecifier = string.sub(template, openBrace + 1, closeBrace - 1)
                currentArgument += closeBrace
                local argument = select(currentArgument, ...)

                if formatSpecifier == "" then
                    writeToBuffer(buffer, tostring(argument))
                elseif formatSpecifier == ":?" then
                    debugRepresentation(buffer, argument)
                else
                    error("Unsupported format specifier `" .. formatSpecifier .. "`.", 2)
                end

                index = closeBrace + 1
            end
        end
    end

    return buffer
end

local Log = {}

function Log.error(template, ...)
    local message = fmt(template, ...)

    error(unpack(message), 2)
end

function Log.info(template, ...)
    local message = fmt(template, ...)

    print(unpack(message))
end

function Log.warn(template, ...)
    local message = fmt(template, ...)

    warn(unpack(message))
end


return Log