


Group.parametric ("FontCircle",
{   radius = {lower = 0, default = 0.5, upper = 1}
}
,   function (args)
    local group = Group ()

    local inner = Fontline ()
    local outer = Fontline ()

    for i = 1, 8 do
        outer:add (Vec.polar (args.radius,   2*math.pi*i/8), false)
        inner:add (Vec.polar (args.radius/2,-2*math.pi*i/8), false)
    end

    group:add (inner, outer)
    group:markpos ("north", outer:getpos (0))
    group:markvec ("north", outer:gettangent (0))

    return group
end
)

do
    local drawing = Group.new ("Drawing")

    local fcircle1 = Group.instance (FontCircle)
    fcircle1:setpos (Vec (2,1))
end
