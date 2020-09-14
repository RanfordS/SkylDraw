
local a = Vec2.new (x0, y0)
local b = Vec2 (x1, y1)

local c = a + b

local A = Matrix3.rotate (30*math.pi/180)
local B = Matrix3.translate (20, -10) -- Matrix.translate (Vec (20, -10))

local v = Vec2Array {a, b}
v = A*v
