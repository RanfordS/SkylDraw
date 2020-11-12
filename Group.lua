-- groups
local Group = {}
Group.metatable = {__index = Group, mtype = "group"}

function Group.new (name)
    return setmetatable (
    {   name = name
    ,   children = {}
    ,   elements = {}
    ,   posmarks = {}
    ,   vecmarks = {}
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

function Group.open (name)
    assert (type (name) == "string", "Group name in not string")

    local new = Group.new (name)
    current.children[name] = new
    table.insert (stack, current)
    current = new
end

function Group.options (options)
    assert (type (options) == "table", "Options not given as a table")
end

function Group.close (name)
    assert (#stack > 0, "No group to close")
    if name then assert (name == current.name, "Group names do not match") end

    current = table.remove (stack)
end

function Group.mark (name, point, vector)
    assert (type (name) == "string", "Mark name is not a string")
    assert (mtype (point) == "vec", "Point is not vector")
    if vector then
        assert (mtype (point) == "vec", "Vector is not vector")
    end

    current.posmarks[name] = point
    current.vecmarks[name] = vector
end

function Group.add (...)
    for _, object in ipairs {...} do
        table.insert (current.elements, object)
    end
end

function Group.parameter (name, lower, default, upper)
    lower = lower or -math.huge
    upper = upper or  math.huge
    assert (type (lower)   == "number", "Lower is not a number")
    assert (type (default) == "number", "Default is not a number")
    assert (type (upper)   == "number", "Upper is not a number")

    table.insert (current.parameters, {lower = lower, default = default, upper = upper})
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

function Group.instance (path)
    assert (type (path) == "string", "Group instance path is not string")

    local template = root
    for name in path:gmatch ("[^%.]+") do
        template = template[name]
        assert (template, "Group instance could not find the requested group")
    end
    return Instance.new (template)
end



return Group
