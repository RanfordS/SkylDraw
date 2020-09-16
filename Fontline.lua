local u = Vec2 (1, 1)
local v = -Vec2 (2, 3)
v = 1/(u + v)
print (tostring (v))

local A = Mat2 {{1,0},{0,1}}
print (A*v)

--[[
points = VecArray
{ Vec (-1.0,-1.0)
, Vec (-0.5,-1.0)
, Vec ( 1.0,-1.0)
, Vec ( 1.0, 1.0)
, Vec ( 0.5, 1.0)
, Vec (-0.5, 1.0)
, Vec (-1.0, 1.0)
, Vec (-1.0, 0.0)
}

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
