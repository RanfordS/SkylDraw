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
    assert (switch, "invalid circle index")
    switch (t, v)
end



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
    assert (switch, "invalid arc index")
    switch (t, v)
end
