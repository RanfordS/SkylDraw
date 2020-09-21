local u = Vec2 (1, 1)
print (u, tostring (u))
local v = -Vec2 (2, 3)
print (v, tostring (v))
v = 1/(u + v)
print (v, tostring (v))

local A = Mat3.translation (Vec2 (1,1)) * Mat3.rotation (1)
print (A*v)

local points = Vec2Array
{ Vec2 (-1.0,-1.0)
, Vec2 (-0.5,-1.0)
, Vec2 ( 1.0,-1.0)
, Vec2 ( 1.0, 1.0)
, Vec2 ( 0.5, 1.0)
, Vec2 (-0.5, 1.0)
, Vec2 (-1.0, 1.0)
, Vec2 (-1.0, 0.0)
}

local onoffs =
{ true
, true
, false
, false
, true
, true
, false
, true
}

local fontline = Fontline (points, onoffs)

local drawing = Group {fontline}
drawing:export ()
