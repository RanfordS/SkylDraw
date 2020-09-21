--[[ luashapesmeta.lua ]]--

-- /*/ --

local Shapes = {Circle, Arc, Fontline, Bezier3, Bezier4, Bezier}
local Bezrs = {Bezier3, Bezier4, Bezier}

local metaclass = {}
function metaclass.__call (class, ...)
    return class.new (...)
end
for _, Shape in ipairs (Shapes) do
    Shape.meta = {}
    function Shape.is (a)
        return type (a) == "table" and getmetatable (a) == Shape.meta
    end
    setmetatable (Shape, metaclass)
end

-- /*/ --

function Circle.meta.__index (t, k)
    local switch =
    ({  center = Circle.get_center
    ,   radius = Circle.get_radius
    })[k]
    if switch then return switch (t) end
    if Circle[k] then return Circle[k] end
    error "invalid circle index"
end

function Circle.meta.__newindex (t, k, v)
    local switch =
    ({  center = Circle.set_center
    ,   radius = Circle.set_radius
    })[k]
    assert (switch, "invalid circle assignment")
    switch (t, v)
end

-- /*/ --

function Arc.meta.__index (t, k)
    local switch =
    ({  center = Arc.get_center
    ,   radius = Arc.get_radius
    ,   angleStart = Arc.get_angleStart
    ,   angleRange = Arc.get_angleRange
    ,   startPos = Arc.startPos
    ,   endPos = Arc.endPos
    })[k]
    if switch then return switch (t) end
    if Arc[k] then return Arc[k] end
    error "invalid arc index"
end

function Arc.meta.__newindex (t, k, v)
    local switch =
    ({  center = Arc.set_center
    ,   radius = Arc.set_radius
    ,   angleStart = Arc.set_angleStart
    ,   angleRange = Arc.set_angleRange
    })[k]
    assert (switch, "invalid arc assignment")
    switch (t, v)
end

-- /*/ --

for _, Bezr in ipairs (Bezrs) do
    function Bezr.meta.__index (t, k)
        if type (k) == "number" then
            return Bezr.geti (t, k)
        end
        if Bezr[k] then return Bezr[k] end
        error "invalid bezier index"
    end

    function Bezr.meta.__newindex (t, k, v)
        if type (k) == "number" then
            return Bezr.seti (t, k, v)
        end
        error "invalid bezier assignment"
    end
end

-- /*/ --

Fontline.PosRef = {meta = {}}

function Fontline.PosRef.new (t)
    local new = {fl = t}
    return setmetatable (new, Fontline.PosRef.meta)
end

function Fontline.PosRef.meta.__index (t, k)
    assert (type (k) == "number", "invalid fontline index")
    return Fontline.getvi (t.fl, k)
end
function Fontline.PosRef.meta.__newindex (t, k, v)
    assert (type (k) == "number", "invalid fontline assignment")
    return Fontline.setvi (t.fl, k, v)
end

Fontline.OnCRef = {meta = {}}

function Fontline.OnCRef.new (t)
    local new = {fl = t}
    return setmetatable (new, Fontline.OnCRef.meta)
end

function Fontline.OnCRef.meta.__index (t, k)
    assert (type (k) == "number", "invalid fontline index")
    return Fontline.getbi (t.fl, k)
end
function Fontline.OnCRef.meta.__newindex (t, k, v)
    assert (type (k) == "number", "invalid fontline assignment")
    return Fontline.setbi (t.fl, k, v)
end

Fontline.IdxRef = {meta = {}}

function Fontline.IdxRef.new (t, i)
    local new = {fl = t, i = i}
    return setmetatable (new, Fontline.IdxRef.meta)
end

function Fontline.IdxRef.meta.__index (t, k)
    local switch =
    ({  position = Fontline.getvi
    ,   oncurve  = Fontline.getbi
    })[k]
    assert (switch, "invalid fontline index")
    return switch (t.fl, t.i)
end
function Fontline.IdxRef.meta.__newindex (t, k, v)
    local switch =
    ({  position = Fontline.setvi
    ,   oncurve  = Fontline.setbi
    })[k]
    assert (switch, "invalid fontline assignment")
    return switch (t.fl, t.i, v)
end

-- /*/ --

function Fontline.meta.__index (t, k)
    if type (k) == "number" then
        return Fontline.IdxRef.new (t, k)
    elseif k == "position" then
        return Fontline.PosRef.new (t)
    elseif k == "oncurve" then
        return Fontline.OnCRef.new (t)
    end
    if Fontline[k] then return Fontline[k] end
    error "invalid fontline index"
end
function Fontline.meta.__newindex (t, k)
    error "invalid fontline assignment"
end

-- /*/ --

Group.meta = Group
setmetatable (Group, metaclass)
function Group.is (a)
    return type (a) == "table" and getmetatable (a) == Group.meta
end

function Group.new (t)
    t.visible = true
    return setmetatable (t, Group.meta)
end

