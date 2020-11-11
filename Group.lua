-- groups
local Group = {}
Group.metatable = {__index = Group, mtype = "group"}

function Group.new (name)
    return setmetatable (
    {   name = name
    ,   children = {}
    ,   elements = {}
    ,   marks = {}
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

function Group.mark (name, point)
    assert (type (name) == "string", "Mark name is not a string")
    assert (mtype (point) == "vec", "Point is not vector")

    current.marks[name] = point
end

function Group.add (...)
    for _, object in ipairs {...} do
        table.insert (current.elements, object)
    end
end

local Instance = {}
Instance.metatable = {__index = Instance}

function Instance.new (template)
    assert (mtype (template) == "group", "Instance must be of a group")

    local new =
    {   template = template
    ,   parameters = {}
    ,   offset = Vec (0,0)
    }

    return setmetatable (new,  Instance.metatable)
end

function Group.instance (path)
    assert (type (path) == "string", "Group instance path is not string")

    local template = root
    for name in path:gmatch ("[^%.]+") do
        template = template[name]
        assert (selection, "Group instance could not find the requested group")
    end
    return Instance.new (selection)
end


return Group
