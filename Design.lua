-- stack-style declarations

do  Group.open "FontCircle"
    Group.options {color = {1.0, 0.5, 0.2}}

    local radius = Group.parameter ("radius", 0.1, 1, math.huge)
    local inner = Fontline ()
    local outer = Fontline ()
    for i = 1, 8 do
        outer.add (Vec.polar (radius,   2*math.pi*i/8), false)
        inner.add (Vec.polar (radius/2,-2*math.pi*i/8), false)
    end
    Group.add (inner, outer)
    Group.markpos ("north", outer:getpos (0))
    Group.markvec ("north", outer:gettangent (0))
end Group.close "FontCirle" -- name not required, used to verify

do  Group.open "Drawing"
    local fcircle1 = Group.instance "FontCircle"
    fcircle1:setpos (Vec (2,1))

    local rline = Line (fcircle1:getpos (), fcircle1:getpos ("north"))
    local tang_center = fcircle1:getpos ("north")
    local tang_dir = fcircle1:getvec ("north")
    local tline = Line (tang_center - 10*tang_dir, tang_center + 10*tang_dir)

    local fcircle2 = Group.instance "FontCircle"
    fcircle2:setpos (Vec (5,3))
    fcircle2:parameter ("radius", 2.5)

    Group.add (fcircle1, fcircle2, rline, tline)
end Group.close "Drawing"

Group.default "Drawing"

--[[ Principles

Old convert structures into C when performing expensive operations
-- drawing
-- equation solving/optimization
-- ect

Properties can be edited live

--]]
