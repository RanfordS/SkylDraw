local Vec = {}
Vec.metatable = {__index = Vec, mtype = "vec"}

function Vec.new (x, y)
    return setmetatable (
    {   x = x
    ,   y = y
    },  Vec.metatable)
end

setmetatable (Vec, {__call = Vec.new})

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
