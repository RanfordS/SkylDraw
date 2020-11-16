local Transform = {}
Transform.metatable = {__index == Transform, mtype = "transform"}

function Transform.new ()
    return setmetatable ({}, Transform.metatable)
end

Transform.translate = Transform.new
Transform.scaleuniform = Transform.new
Transform.rotate = Transform.new
Transform.identity = Transform.new

function Transform.metatable.__mul (a, b)
    if mtype (b) == "vec" then return b end
    return Transform.new ()
end

Transform.pos = Transform.metatable.__mul
Transform.vec = Transform.metatable.__mul

return Transform
