--[[ luavecmeta.lua ]]--

local Vecs = {Vec2, Vec3, Vec4}
local Mats = {Mat2, Mat3, Mat4}
local Arrays = {Vec2Array, Vec3Array, Vec4Array}

for _, Vec in ipairs (Vecs) do
    Vec.meta = {__index = Vec}
end

for _, Mat in ipairs (Mats) do
    Mat.meta = {__index = Mat}
end

for _, Array in ipairs (Arrays) do
    Array.meta = {}
end

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

-- /*/ --

for n, Mat in ipairs (Mats) do
    n = n + 1
    function Mat.new (new)
        assert (#new == n, "incorrect number of rows")
        for i = 1, n do
            assert (#new[i] == n, "incorrect number of cols in row".. i)
        end
        return setmetatable (new, Mat.meta)
    end
end

-- /*/ --

for n, Array in ipairs (Arrays) do
    local Vec = Vecs[n]
    function Array.new (new)
        for i, v in ipairs (new) do
            assert (Vec.is (v), "all elements must be vector ".. tostring (n+1))
        end
        return Array.pack (new)
    end
end

-- /*/ --

local metaclass = {}
function metaclass.__call (class, ...)
    return class.new (...)
end
for _, Vec in ipairs (Vecs) do
    setmetatable (Vec, metaclass)
end
for _, Mat in ipairs (Mats) do
    setmetatable (Mat, metaclass)
end
for _, Array in ipairs (Arrays) do
    setmetatable (Array, metaclass)
end

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

for _, Vec in ipairs (Vecs) do
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

for n, Mat in ipairs (Mats) do
    local Vec = Vecs[n]
    local Array = Arrays[n]
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
        elseif Vec.is (b) then
            return Mat.vecmul (a, b)
        elseif Array.is (b) then
            return Mat.vecarraymul (a, b)
        end
        -- general case
        assert (Mat.is (a) and Mat.is (b),
            "matrix addition called unsupported types")
        return Mat.add (a, b)
    end
end

-- /*/ --

for n, Array in ipairs (Arrays) do
    local Vec = Vecs[n]
    -- helper
    function Array.is (v)
        return type (v) == "table" and getmetatable (v) == Array.meta
    end
    -- metatable events
    function Array.meta.__len (array)
        return Array.length (array)
    end
    function Array.meta.__index (array, key)
        for k, v in pairs (Array) do
            if key == k then
                return v
            end
        end
        print ("key:", key, type (key))
        assert (type (key) == "number", "invalid index")
        assert ((0 < key) and (key <= #array), "index is out of range")
        return Array.geti (array, key)
    end
    function Array.meta.__newindex (array, key, value)
        assert (type (key) == number, "invalid index")
        assert (0 < key and key <= #array, "index is out of range")
        assert (Vec.is (value), "cannot assign non-vector to vector array")
        return Array.seti (array, key, value)
    end
    function Array.meta.__ipairs (array)
        local len = Array.length (array)
        local function iterator (array, i)
            i = i + 1
            if i > len then
                return
            end
            return i, Array.geti (array, i)
        end
        return iterator, array, 0
    end
end

