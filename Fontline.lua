local Fontline = {}
Fontline.metatable = {__index = Fontline, mtype = "fontline"}

function Fontline.new ()
    return setmetatable (
    {   points = {}
    ,   oncurve = {}
    ,   closed = false
    ,   resolution = 16
    },  Fontline.metatable)
end

setmetatable (Fontline, {__call = Fontline.new})

function Fontline:add (pos, on)
    assert (mtype (pos) == "vector", "Pos in not vector")
    assert (type (on) == "boolean", "On is not boolean")

    table.insert (self.points, pos)
    table.insert (self.oncurve, on)
    return self
end

function Fontline:verify ()
    if not self.closed then
        return self.oncurve[1] and self.oncurve[#self.oncurve]
    end
    return true
end

function Fontline:getpos (p)
    local count = #self.points
    p = math.min (math.max (0, p), count)

    local t = p % 1
    local i = math.floor (p) - 1
    --TODO
end

-- add generate method using c

return Fontline
