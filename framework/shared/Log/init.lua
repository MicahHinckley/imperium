local Fmt = require(script.Parent.Fmt)

local Log = {}

function Log.error(template, ...)
    error(Fmt.output(template, ...), 2)
end

function Log.info(template, ...)
    print(Fmt.output(template, ...))
end

function Log.warn(template, ...)
    warn(Fmt.output(template, ...))
end

return Log