-- stack-style declarations

do  Group.open "FontCircle"
    Group.options {color = {1.0, 0.5, 0.2}}

    local radius = Group.parameter ("radius", 1, {lower = 0.1})
    local inner = Fontline ()
    local outer = Fontline ()
    for i = 1, 8 do
        inner.add (Vec.polar (radius,   2*math.pi*i/8), false)
        outer.add (Vec.polar (radius/2,-2*math.pi*i/8), false)
    end
    Group.add (inner, outer)
    Group.mark ("center", Vec (0,0))
end Group.close "FontCirle" -- name not required, used to verify

do  Group.open "Drawing"
    local fcircle1 = Group.instance "FontCircle"
    fcircle1.setmark ("center", Vec (2,1))

    local fcircle2 = Group.instance "FontCircle"
    fcircle2.setmark ("center", Vec (5,3))
    fcircle2.parameter ("radius", 2.5)
end Group.close "Drawing"

Group.default "Drawing"

--[[ Principles

Old convert structures into C when performing expensive operations
-- drawing
-- equation solving/optimization
-- ect

Properties can be edited live

--]]
