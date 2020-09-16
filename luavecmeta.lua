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
    assert (#new == 2, "incorrect number of rows")
    for i = 1, 2 do
        assert (#new[i] == 2, "incorrect number of cols in row".. i)
    end
    return setmetatable (new, Mat2.meta)
end

function Mat3.new (new)
    assert (#new == 3, "incorrect number of rows")
    for i = 1, 3 do
        assert (#new[i] == 3, "incorrect number of cols in row".. i)
    end
    return setmetatable (new, Mat3.meta)
end

function Mat4.new (new)
    assert (#new == 4, "incorrect number of rows")
    for i = 1, 4 do
        assert (#new[i] == 4, "incorrect number of cols in row".. i)
    end
    return setmetatable (new, Mat4.meta)
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

function Vec2.unpack (a)
    return a.x, a.y
end

function Vec3.unpack (a)
    return a.x, a.y, a.z
end

function Vec4.unpack (a)
    return a.x, a.y, a.z, a.w
end

-- /*/ --

for _, Vec in ipairs {Vec2, Vec3, Vec4} do
    -- helper
    function Vec.is (v)
        return type (v) == "table" and getmetatable (v) == Vec.meta
    end
    -- tostring
    function Vec.meta.__tostring (a)
        local list = {a:unpack ()}
        for i, v in ipairs (list) do
            list[i] = tostring (v)
        end
        return "(".. table.concat (list, ",") ..")"
    end
    -- operators
    Vec.meta.__unm = Vec.unm
    function Vec.meta.__add (a, b)
        -- scalar cases
        if     type (a) == "number" then
            return Vec.scalaradd (b, a)
        elseif type (b) == "number" then
            return Vec.scalaradd (a, b)
        end
        -- general case
        assert (Vec.is (a) and Vec.is (b),
            "vector addition called unsupported types")
        return Vec.add (a, b)
    end
    function Vec.meta.__sub (a, b)
        -- scalar cases
        if     type (a) == "number" then
            return Vec.scalaradd (-b, a)
        elseif type (b) == "number" then
            return Vec.scalarsub (a, b)
        end
        -- general case
        assert (Vec.is (a) and Vec.is (b),
            "vector subtraction called unsupported types")
        return Vec.sub (a, b)
    end
    function Vec.meta.__mul (a, b)
        -- scalar cases
        if     type (a) == "number" then
            return Vec.scalarmul (b, a)
        elseif type (b) == "number" then
            return Vec.scalarmul (a, b)
        end
        -- general case
        assert (Vec.is (a) and Vec.is (b),
            "vector multiplication called unsupported types")
        return Vec.mul (a, b)
    end
    function Vec.meta.__div (a, b)
        -- scalar cases
        if     type (a) == "number" then
            local list = {b:unpack ()}
            for i, v in ipairs (list) do
                list[i] = a/v
            end
            return Vec.new (table.unpack (list))
        elseif type (b) == "number" then
            return Vec.scalardiv (a, b)
        end
        -- general case
        assert (Vec.is (a) and Vec.is (b),
            "vector division called unsupported types")
        return Vec.mul (a, b)
    end
end

function Vec2.meta.__concat (a, b)
    if Vec2.is (a) then
        if     type (b) == "number" then
            return Vec3.new (a.x, a.y, b)
        elseif Vec2.is (b) then
            return Vec4.new (a.x, a.y, b.x, b.y)
        else
            error "vector concat called on unsupported types"
        end
    else
        assert (type (a) == "number",
            "vector concat called on unsupported types")
        return Vec3.new (a, b.x, b.y)
    end
end

function Vec3.meta.__concat (a, b)
    if Vec3.is (a) then
        assert (type (b) == "number",
            "concat called on unsupported types")
        return Vec4.new (a.x, a.y, a.z, b)
    else
        assert (type (a) == "number",
            "concat called on unsupported types")
        return Vec4.new (a, b.x, b.y, b.z)
    end
end

-- /*/ --

local VecMatch = {}
VecMatch[Mat2] = Vec2
VecMatch[Mat3] = Vec3
VecMatch[Mat4] = Vec4

for _, Mat in ipairs {Mat2, Mat3, Mat4} do
    -- helper
    function Mat.is (v)
        return type (v) == "table" and getmetatable (v) == Mat.meta
    end
    -- operators
    Mat.meta.__unm = Mat.unm
    function Mat.meta.__add (a, b)
        if     type (a) == "number" then
            return Mat.scalaradd (b, a)
        elseif type (b) == "number" then
            return Mat.scalaradd (a, b)
        end
        -- general case
        assert (Mat.is (a) and Mat.is (b),
            "matrix addition called unsupported types")
        return Mat.add (a, b)
    end
    function Mat.meta.__sub (a, b)
        if     type (a) == "number" then
            return Mat.scalaradd (-b, a)
        elseif type (b) == "number" then
            return Mat.scalarsub (a, b)
        end
        -- general case
        assert (Mat.is (a) and Mat.is (b),
            "matrix addition called unsupported types")
        return Mat.add (a, b)
    end
    function Mat.meta.__mul (a, b)
        if     type (a) == "number" then
            return Mat.scalarmul (b, a)
        elseif type (b) == "number" then
            return Mat.scalarmul (a, b)
        elseif VecMatch[Mat].is (b) then
            return Mat.vecmul (a, b)
        end
        -- general case
        assert (Mat.is (a) and Mat.is (b),
            "matrix addition called unsupported types")
        return Mat.add (a, b)
    end
end
