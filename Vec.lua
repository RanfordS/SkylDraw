local Vec = {}
Vec.metatable = {__index = Vec, mtype = "vec"}

function Vec.new (x, y)
    return setmetatable (
    {   x = x
    ,   y = y
    },  Vec.metatable)
end

setmetatable (Vec, {__call = Vec.new})

return Vec
