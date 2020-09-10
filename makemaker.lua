

function includesfromfile (filename, deps)
    file = io.open (filename)
    text = file:read "*a"
    file:close ()

    for dep in text:gmatch "#include%s-\"(.-)\"" do
        if not deps[dep] then
            deps[dep] = true
            includesfromfile (dep, deps)
        end
    end
end

for i, filename in ipairs (arg) do
    print ("deps of", filename)
    deps = {}
    includesfromfile (filename, deps)
    for k, v in pairs (deps) do
        print ("-", k)
    end
end
