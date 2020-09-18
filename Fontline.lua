local u = Vec2 (1, 1)
print (u, tostring (u))
local v = -Vec2 (2, 3)
print (v, tostring (v))
v = 1/(u + v)
print (v, tostring (v))

local A = Mat2 {{1,0},{0,-1}}
print (A*v)

points = Vec2Array
{ Vec2 (-1.0,-1.0)
, Vec2 (-0.5,-1.0)
, Vec2 ( 1.0,-1.0)
, Vec2 ( 1.0, 1.0)
, Vec2 ( 0.5, 1.0)
, Vec2 (-0.5, 1.0)
, Vec2 (-1.0, 1.0)
, Vec2 (-1.0, 0.0)
}

for i, point in ipairs (A*points) do
    print (i, point)
end
--[[
points = VecArray
{ {-1.0,-1.0}
, {-0.5,-1.0}
, { 1.0,-1.0}
, { 1.0, 1.0}
, { 0.5, 1.0}
, {-0.5, 1.0}
, {-1.0, 1.0}
, {-1.0, 0.0}
}

onoffs =
{ true
, true
, false
, false
, true
, true
, false
, true
}

Export (Fontline (points, onoffs))
--]]
