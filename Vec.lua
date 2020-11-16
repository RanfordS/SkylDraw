local Vec = {}
Vec.metatable = {__index = Vec, mtype = "vec"}

function Vec.new (x, y)
    print ("Vec.new (".. mtype (x) ..": ".. tostring (x) ..", ".. mtype (y) ..": ".. tostring (y) ..")")
    assert (type (x) == "number", "Vec x is not a number")
    assert (type (y) == "number", "Vec y is not a number")

    return setmetatable (
    {   x = x
    ,   y = y
    },  Vec.metatable)
end

local raw = Vec.new
Vec.new = function (...)
    return Parameter.guard (raw, ...)
end

setmetatable (Vec, {__call = function (_, x, y) Vec.new (x, y) end})

function Vec.metatable.__add (a, b)
    if type (a) == "number" then a = Vec (a, a) end
    if type (b) == "number" then b = Vec (b, b) end

    return Vec.new (a.x + b.x, a.y + b.y)
end

function Vec.metatable.__sub (a, b)
    print ("Vec.sub (".. mtype (a) ..": ".. tostring (a) ..", ".. mtype (b) ..": ".. tostring (b) ..")")

    if type (a) == "number" then a = Vec (a, a) end
    if type (b) == "number" then b = Vec (b, b) end

    return Vec.new (a.x - b.x, a.y - b.y)
end

function Vec.metatable.__mul (a, b)
    if type (a) == "number" then a = Vec (a, a) end
    if type (b) == "number" then b = Vec (b, b) end

    return Vec.new (a.x * b.x, a.y * b.y)
end

function Vec.metatable.__div (a, b)
    if type (a) == "number" then a = Vec (a, a) end
    if type (b) == "number" then b = Vec (b, b) end

    return Vec.new (a.x / b.x, a.y / b.y)
end



function Vec.polar (r, t)
    return Vec.new (r*math.cos (t), r*math.sin (t))
end

function Vec:mag ()
    return (self.x^2 + self.y^2)^0.5
end

function Vec:ang ()
    return math.atan2 (self.y, self.x)
end

function Vec:topolar ()
    return self:mag (), self:ang ()
end

return Vec
