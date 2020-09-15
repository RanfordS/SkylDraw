--[[ luavecmeta.lua ]]--

Vec2.meta = {__index = Vec2}
Vec3.meta = {__index = Vec3}
Vec4.meta = {__index = Vec4}

Mat2.meta = {__index = Mat2}
Mat3.meta = {__index = Mat3}
Mat4.meta = {__index = Mat4}

-- /*/ --

function Vec2.new (x, y)
    local new = {x=x, y=y}
    return setmetatable (new, Vec2.meta)
end

function Vec3.new (x, y, z)
    local new = {x=x, y=y, z=z}
    return setmetatable (new, Vec3.meta)
end

function Vec4.new (x, y, z, w)
    local new = {x=x, y=y, z=z, w=w}
    return setmetatable (new, Vec4.meta)
end

function Mat2.new (new)
    return setmetatble (new, Mat2.meta)
end

function Mat3.new (new)
    return setmetatble (new, Mat3.meta)
end

function Mat4.new (new)
    return setmetatble (new, Mat4.meta)
end

local metaclass = {}
function metaclass.__call (class, ...)
    return class.new (...)
end
setmetatable (Vec2, metaclass)
setmetatable (Vec3, metaclass)
setmetatable (Vec4, metaclass)
setmetatable (Mat2, metaclass)
setmetatable (Mat3, metaclass)
setmetatable (Mat4, metaclass)

-- /*/ --

function Vec2.meta.__unm (a)
    return Vec2.unm (a)
end

function Vec3.meta.__unm (a)
    return Vec3.unm (a)
end

function Vec4.meta.__unm (a)
    return Vec4.unm (a)
end
