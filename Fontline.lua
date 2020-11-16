local Fontline = {}
Fontline.metatable = {__index = Fontline, mtype = "fontline"}

function Fontline.new ()
    return setmetatable (
    {   points = {}
    ,   oncurve = {}
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

return Fontline
