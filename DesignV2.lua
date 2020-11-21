


Group.define ("FontCircle",
{   radius = {lower = 0, default = 0.5, upper = 1}
}
,   function (args)
    local r = args.radius
    local group = Group.new ()

    local inner = Fontline ()
    local outer = Fontline ()

    for i = 1, 8 do
        outer:add (Vec.polar (1,  2*math.pi*i/8), false)
        inner:add (Vec.polar (r, -2*math.pi*i/8), false)
    end

    group:add (inner, outer)
    group:markpos ("north", outer:getpos (0))
    group:markvec ("north", outer:gettangent (0))

    return group
end)

Group.define ("Drawing",
false
,   function (args)
    local drawing = Group.new ()

    local fcircle1 = Group.instance ("FontCircle")
    fcircle1:setpos (Vec (2,1))

    local rline = Line (fcircle1:getpos (), fcircle1:getpos "north")
    local tang_center = fcircle1:getpos "north"
    local tang_dir    = fcircle1:getvec "north"
    local tline = Line (tang_center - 10*tang_dir, tang_center + 10*tang_dir)

    local fcircle2 = Group.instance ("FontCircle", {radius = 0.2})
    fcircle2:setpos ("north", Vec (5,3))
    Group:color (1.0, 0.5, 0.2)

    drawing:add (fcircle1, fcircle2, rline, tline)
    return drawing
end)

Group.default "Drawing"

--[[ Principles

All groups defined with functions
Table of args and their respective bounds provided
- bounds are used for both UI and instance construction

--]]

--[[ Differences

No explicit group tree
Parameter type made redundant
Group.action removed in favour of instance:action

--]]
