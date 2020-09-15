local v = -Vec2 (2, 3)
print (v.y)

--[[
points =
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
