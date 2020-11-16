local Line = {}
Line.metatable = {__index = Line, mtype = "line"}

function Line.new (p0, p1)
    assert (mtype (p0) == "vector", "P0 is not vector")
    assert (mtype (p1) == "vector", "P1 is not vector")

    return setmetatable (
    {   p0 = p0
    ,   p1 = p1
    },  Line.metatable)
end

setmetatable (Line, {__call = Line.new})

return Line
