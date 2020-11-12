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

function Parameter.call (f, ...)
    local new = {...}
    new.f = f
    return setmetatable (new, Parameter.metatable)
end

for k, f in pairs (def) do
    Parameter.metatable[k] = function (a, b)
        return Parameter.call (f, a, b)
    end
end

function Parameter.evaluate (p, defs)
    if type (p.f) == "string" then return defs[p.f] end

    local results = {}
    for i, v in ipairs (p) do
        local vt = mtype (v)
        if vt == "parameter" then v = Parameter.evaluate (v, defs) end
        results[i] = v
    end

    return p.f (table.unpack (results))
end

function Parameter.new (name)
    return setmetatable ({f = name}, Parameter.metatable)
end

return Parameter
