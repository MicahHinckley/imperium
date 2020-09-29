--< Functions >--
local function WriteToBuffer(buffer, value)
    local LastValue = buffer[#buffer]

    if type(value) == "string" and type(LastValue) == "string" then
        buffer[#buffer] = LastValue .. value
    else
        table.insert(buffer, value)
    end
end

local function DebugRepresentation(buffer, value)
    local Type = typeof(value)

    if Type == "string" then
        WriteToBuffer(buffer, string.format("%q", value))
    elseif Type == "table" then
        local Metatable = getmetatable(value)

        if Metatable ~= nil and Metatable.__fmtDebug ~= nil then
            WriteToBuffer(buffer, Metatable.__fmtDebug(value))
        else
            WriteToBuffer(buffer, value)
        end
    elseif Type == "Instance" then
        WriteToBuffer(buffer, value:GetFullName())
    else
        WriteToBuffer(buffer, tostring(value))
    end
end

local function fmt(template, ...)
    local Buffer = {}

    local CurrentArgument = 0
    local Index = 1
    local Length = #template

    while Index <= Length do
        local OpenBrace = string.find(template, "{", Index)

        if OpenBrace == nil then
            WriteToBuffer(Buffer, string.sub(template, Index))

            break
        else
            local CharAfterBrace = string.sub(OpenBrace + 1, OpenBrace + 1)

            if CharAfterBrace == "{" then
                WriteToBuffer(Buffer, string.sub(template, Index, OpenBrace))

                Index = OpenBrace + 2
            else
                if OpenBrace - Index > 0 then
                    WriteToBuffer(Buffer, string.sub(template, Index, OpenBrace - 1))
                end

                local CloseBrace = string.find(template, "}", OpenBrace + 1)

                local FormatSpecifier = string.sub(template, OpenBrace + 1, CloseBrace - 1)
                CurrentArgument += 1
                local Argument = select(CurrentArgument, ...)

                if FormatSpecifier == "" then
                    WriteToBuffer(Buffer, tostring(Argument))
                elseif FormatSpecifier == ":?" then
                    DebugRepresentation(Buffer, Argument)
                else
                    error("Unsupported format specifier `" .. FormatSpecifier .. "`.", 2)
                end

                Index = CloseBrace + 1
            end
        end
    end

    return Buffer
end

--< Module >--
local Log = {}

function Log.Error(template, ...)
    local Message = fmt(template, ...)
    error(unpack(Message), 2)
end

function Log.Warn(template, ...)
    local Message = fmt(template, ...)
    warn(unpack(Message))
end

function Log.Info(template, ...)
    local Message = fmt(template, ...)
    print(unpack(Message))
end

return Log