-- groups
local Group = {}
Group.metatable = {__index = Group, mtype = "group"}

function Group.new (name)
    return setmetatable (
    {   name = name
    ,   children = {}
    ,   elements = {}
    ,   posmarks = {origin = Vec (0,0)}
    ,   vecmarks = {direction = Vec (1,0)}
    ,   parameters = {}
    ,   options =
        {   visable = false
        ,   color = false
        }
    },  Group.metatable)
end

local root = Group.new "Root"
local stack = {}
local current = root

-- creates a new group as the child of the current
-- the new group becomes the active
function Group.open (name)
    assert (type (name) == "string", "Group name in not string")

    local new = Group.new (name)
    current.children[name] = new
    table.insert (stack, current)
    current = new
end

-- sets the given options for the current group
function Group.options (options)
    assert (type (options) == "table", "Options not given as a table")

    for k,v in pairs (options) do
        current.options[k] = v
    end
end

-- makes the current group's parent the active group
function Group.close (name)
    assert (#stack > 0, "No group to close")
    if name then assert (name == current.name, "Group names do not match") end

    current = table.remove (stack)
end

-- adds the given position as a posmark to the current group
function Group.markpos (name, pos)
    assert (type (name) == "string", "Mark name is not a string")
    if mtype (pos) ~= "parameter" then
        assert (mtype (pos) == "vec", "Position is not vector")
    end

    current.posmarks[name] = pos
end

-- adds the given direction vector as a vecmark to the current group
function Group.markvec (name, vec)
    assert (type (name) == "string", "Mark name is not a string")
    if mtype (vec) ~= "parameter" then
        assert (mtype (vec) == "vec", "Vector is not vector")
    end

    current.vecmarks[name] = vec
end

-- adds the given objects to the current group
function Group.add (...)
    for _, object in ipairs {...} do
        table.insert (current.elements, object)
    end
end

-- creates a new group parameter with the given bounds
-- give false or nil for unbounded
function Group.parameter (name, lower, default, upper)
    assert (type (name) == "string", "Name is not string")
    lower = lower or -math.huge
    upper = upper or  math.huge
    assert (type (lower)   == "number", "Lower is not a number")
    assert (type (default) == "number", "Default is not a number")
    assert (type (upper)   == "number", "Upper is not a number")

    --default = math.max (lower, math.min (default, upper))
    table.insert (current.parameters,
    {   lower = lower
    ,   default = default
    ,   upper = upper
    })
    return Parameter.new (default)
end

local Instance = {}
Instance.metatable = {__index = Instance}

function Instance.new (template)
    assert (mtype (template) == "group", "Instance must be of a group")

    local new =
    {   template = template
    ,   parameters = {}
    ,   transform = Transform.identity ()
    }

    for k,v in pairs (template.parameters) do
        new.parameters[k] = Parameter (v.lower, v.default, v.upper)
    end

    return setmetatable (new,  Instance.metatable)
end

function Instance:getpos (name)
    local pos = Vec (0,0)
    if name then
        pos = assert (self.template.posmarks[name],
            "Instance does not have marker with that name")
    end

    return Transform.pos (self.transform, pos)
end

function Instance:getvec (name)
    local vec = Vec (1,0)
    if name then
        vec = assert (self.template.vecmarks[name],
            "Instance does not have marker with that name")
    end

    return Transform.vec (self.transform, vec)
end

function Instance:setpos (name, pos)
    print ("Instance:setpos (".. mtype (name) ..": ".. tostring (name) ..", ".. mtype (pos) ..": ".. tostring (pos) ..")")
    if pos == nil then
        pos = name
        name = "origin"
        print ("Rephrased as    (".. mtype (name) ..": ".. tostring (name) ..", ".. mtype (pos) ..": ".. tostring (pos) ..")")
    end

    assert (self.template.posmarks[name],
        "Instance does not have a position marker with that name")
    assert (mtype (pos) == "vec", "Pos is not a vector")

    local mpos = Transform.pos (self.transform, self.template.posmarks[name])
    self.transform = Transform.translate (pos - mpos) * self.transform
    return self
end

function Instance:setdualpos (n0, p0, n1, p1)
    assert (self.template.posmarks[n0], "Instance does not have a marker of n0")
    assert (mtype (p0) == "vec", "P0 is not a vector")
    assert (self.template.posmarks[n1], "Instance does not have a marker of n1")
    assert (mtype (p1) == "vec", "P1 is not a vector")
    assert (n0 ~= n1, "Markers n0 and n1 are the same")

    local m0 = self.template.posmarks[n0]
    local m1 = self.template.posmarks[n1]
    local pd, pt = Vec.topolar (p1 - p0)
    local md, mt = Vec.topolar (m1 - m0)
    local scale = pd/md
    local angle = pt - mt

    local T = Transform.translate
    local S = Transform.scaleuniform
    local R = Transform.rotate
    self.transform = T(p0)*S(scale)*R(angle)*T(-m0)
    return self
end

function Instance:parameter (name, value)
    assert (self.parameters[name], "Group does not have a parameter of that name")
end

-- creates an instance of the group at the given path
-- navigate paths with `.`
-- leading `.` for relative path
function Group.instance (path)
    assert (type (path) == "string", "Group instance path is not string")

    local template = path:sub(1,1) == "." and current or root
    for name in path:gmatch ("[^%.]+") do
        template = template.children[name]
        assert (template, "Group instance could not find the requested group")
    end
    return Instance.new (template)
end



return Group
