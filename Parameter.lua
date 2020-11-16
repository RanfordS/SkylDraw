-- parameter
local Parameter = {}
Parameter.metatable = {__index = Parameter, mtype = "parameter"}

local def = {}

function def.__add (a, b) return a + b end
function def.__sub (a, b) return a - b end
function def.__mul (a, b) return a * b end
function def.__div (a, b) return a / b end
function def.__pow (a, b) return a ^ b end
function def.__unm (a)    return  -a   end

function def.__call (a, ...) return a (...) end
function def.__index (a, b) return a[b] end
function def.__newindex (a, b, c) a[b] = c end

function Parameter.call (f, ...)
    local new = {...}
    new.PAR__f = f
    return setmetatable (new, Parameter.metatable)
end

for k, f in pairs (def) do
    Parameter.metatable[k] = function (...)
        return Parameter.call (f, ...)
    end
end

function Parameter.guard (f, ...)
    for _, v in ipairs {...} do
        if mtype (v) == "parameter" then
            print ("Call guarded")
            return Parameter.call (f, ...)
        end
    end
    print ("Call now")
    return f (...)
end

function Parameter.evaluate (p, defs)
    if type (p.PAR__f) == "string" then return defs[p.PAR__f] end

    local results = {}
    for i, v in ipairs (p) do
        local vt = mtype (v)
        if vt == "parameter" then v = Parameter.evaluate (v, defs) end
        results[i] = v
    end

    return p.PAR__f (table.unpack (results))
end

function Parameter.new (name)
    return setmetatable ({PAR__f = name}, Parameter.metatable)
end

setmetatable (Parameter, {__call = Parameter.new})

return Parameter
