Group =
{   list = {}
,   default = "Main"
}

local Template = {}
local Tmetatable = {__index = Template, mtype = "Group.Template"}
local Instance = {}
local Imetatable = {__index = Instance, mtype = "Group.Instance"}

-- interface
Group.Template = Template
Template.metatable = Tmetatable
Group.Instance = Instance
Instance.metatable = Imetatable

function Group.define (name, params, gen)
    local aparams = {}
    assert (type (name) == "string", "Group name must be a string")
    assert (Group.list[name] == nil, "Group with that name already exists")
    assert (type (params) == "table", "Group parameters must be given as a table")
    for k, v in pairs (params) do
        assert (type (k) == "string", "Parameter keys must be strings")
        assert (type (v) == "table", "Parameter values must be bounds tables")
        assert (type (v.default) == "number", "Parameter bounds must include a default value")
        local copy = {}
        copy.default = v.default
        copy.lower = type (v.lower) == "number" and v.lower or -math.huge
        copy.upper = type (v.upper) == "number" and v.upper or  math.huge
        aparams[k] = copy
    end
    assert (type (gen) == "function", "Group generator must be a function")

    local new =
    {   parameters = params
    ,   generator = gen
    }
    setmetatable (new, Tmetatable)
    Group.list[name] = new
    return new
end

function Group.instance (name, params)
    params = params or {}
    local template = assert (Group.list[name], "Group name is invalid")
    assert (type (params) == "table", "Params must be table or false")

    local aparams = {}
    for k, v in pairs (template.paramters) do
        local val = params[k] or v.default
        val = math.min (math.max (v.lower, val), v.upper)
        aparams[k] = val
    end

    local result = template.generator (aparams)
    assert (mtype (result) == "Group.Instance", "Generator function did not return a group instance with these args")
    return result
end

function Group.new ()
    local new =
    {   posmarks = {origin = Vec (0,0)}
    ,   vecmarks = {direction = Vec (1,0)}
    ,   options  = {visable = true, color = false}
    }
    return setmetatable (new, Imetatable)
end

function Instance:add (...)
    for i, v in ipairs {...} do
        table.insert (self, v)
    end
    return self
end

function Instance:markpos (name, v)
    assert (type (name) == "string", "Marker name must be string")
    assert (self.posmarks[name] == nil, "Marker with that name is already defined")
    assert (mtype (v) == "vec", "Marker must be a vector")

    self.posmarks[name] = v
    return self
end

function Instance:markvec (name, v)
    assert (type (name) == "string", "Marker name must be string")
    assert (self.vecmarks[name] == nil, "Marker with that name is already defined")
    assert (mtype (v) == "vec", "Marker must be a vector")

    self.vecmarks[name] = v
    return self
end

function Instance:getpos (name)
    name = name or "origin"
    pos = assert (self.posmarks[name], "No pos-marker with that name")
    return Transform.pos (self.transform, pos)
end

function Instance:getvec (name)
    name = name or "direction"
    vec = assert (self.vecmarks[name], "No vec-marker with that name")
    return Transform.vec (self.transform, vec)
end

function Instance:setpos (name, pos)
    local basepos = assert (self.posmarks[name], "No pos-marker with that name")
    assert (mtype (pos) == "vec", "Position must be given as a vector")

    local globalpos = self.transform:pos (basepos)
    return self
end

function Instance:setdualpos (name0, tpos0, name1, tpos1)
    local mpos0 = assert (self.posmarks[name0], "No pos-marker for name0")
    local mpos1 = assert (self.posmarks[name1], "No pos-marker for name1")
    assert (mtype (p0) == "vec", "Target tpos0 is not a vector")
    assert (mtype (p1) == "vec", "Target tpos1 is not a vector")

    local tdist, tangl = Vec.topolar (tpos1 - tpos0)
    local mdist, mangl = Vec.topolar (mpos1 - mpos0)
    local scale = tdist / mdist
    local angle = tangl - mangl

    local T = Transform.translate
    local S = Transform.scaleuniform
    local R = Transform.rotate
    self.transform = T(tpos0) * S(scale) * R(angle) * T(mpos0)
    return self
end
