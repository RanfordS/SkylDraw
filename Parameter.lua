local Parameter = {}

setmetatable (Parameter,
{   __call = function (name, value, options)
        assert (type (name) == "string",
            "Parameters require a string name")
        assert (options == nil or type (options) == "table",
            "Parameter options should be passed in a table")

        local new =
        {   value = value
        }
    end
})


return Parameter
