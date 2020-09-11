--[[ makemaker ]]--

-- params

target = "SkylDraw"
objdir = "objs/"
docdir = "doc/"
flags = "-Wall -Wextra -Og -ggdb"
links = "-lm -lGL -lGLU -lGLEW -lglfw -llua5.3"

-- tools

function includesfromfile (filename, deps)
    local mute = filename:gsub ("%.(.-)", ".lm%1")
    local file = io.open (mute, "r")
    if not file then
        file = io.open (filename, "r")
    end
    text = file:read "*all"
    file:close ()

    for dep in text:gmatch "#include%s-\"(.-)\"" do
        if not deps[dep] then
            deps[dep] = true
            includesfromfile (dep, deps)
        end
    end
end

function printf (form, ...)
    print (form:format (...))
end

function table.keytocat (t)
    local new = {}
    for k,v in pairs (t) do
        table.insert (new, k)
    end
    return table.concat (new, " ")
end

-- collect filenames

cls = io.popen "ls *.c -1"
cfs = {}
while true do
    local filename = cls:read "*line"
    if filename == nil then break end
    cfs[filename] = true
end
cls:close ()

hls = io.popen "ls *.h -1"
hfs = {}
while true do
    local filename = hls:read "*line"
    if filename == nil then break end
    hfs[filename] = true
end
hls:close ()

lmls = io.popen "ls *.lm* -1"
lmfs = {}
while true do
    local filename = lmls:read "*line"
    if filename == nil then break end
    lmfs[filename] = true

    local sub = ((filename:sub (-1) == "c") and cfs) or hfs
    filename = filename:gsub ("%.lm", ".")
    sub[filename] = true
end
lmls:close ()

-- target

objs = {}
for obj, _ in pairs (cfs) do
    table.insert (objs, objdir .. obj:gsub ("%.c", ".o"))
end
objs = table.concat (objs, " ")

printf ("%s : %s %s", target, objs, table.keytocat (hfs, " "))
printf ("\t@echo -e '\\033[1;36m- Linking %s -\\033[0m'", target)
printf ("\t@gcc %s -o %s %s %s", flags, target, objs, links)
printf ("\t@echo -e '\\033[1;4m- Done -\\033[0m'")
print ""

-- c files

for filename, _ in pairs (cfs) do
    local deps = {}
    includesfromfile (filename, deps)
    local headers = table.keytocat (deps)

    local target = objdir..filename:gsub ("%.c", ".o")
    printf ("%s : %s %s", target, filename, headers, " ")
    printf ("\t@echo -e '\\033[1;33m- Building %s -\\033[0m'", filename)
    printf ("\t@gcc %s -o %s -c %s", flags, target, filename)
    print ()
end

-- luamacros

for filename, _ in pairs (lmfs) do
    local target = filename:gsub ("%.lm", ".")
    printf ("%s : %s", target, filename)
    printf ("\t@echo -e '\\033[1;34m- Generating %s -\\033[0m'", target)
    printf ("\t@lua luamacro.lua %s %s", filename, target)
    print ""
end

-- phonys

printf (".PHONY : doc")
printf ("doc : %s %s", table.keytocat (cfs), table.keytocat (hfs))
printf ("\t@echo -e '\\033[1;32m- Documenting -\\033[0m'")
printf ("\t@doxygen doxyfile")
printf ("\t@echo -e '\\033[1;4m- Done -\\033[0m'")
print ""

printf (".PHONY : cleanobjs")
printf ("cleanobjs :")
printf ("\t@echo -e '\\033[1;35m- Cleaning object files -\\033[0m'")
printf ("\t@rm -f %s*", objdir)
print ""

printf (".PHONY : cleanmacro")
printf ("cleanmacro :")
printf ("\t@echo -e '\\033[1;35m- Cleaning macro files -\\033[0m'")
printf ("\t@rm -f %s", table.keytocat (lmfs))
print ""

printf (".PHONY : cleandoc")
printf ("cleandoc :")
printf ("\t@echo -e '\\033[1;35m- Cleaning documentation -\\033[0m'")
printf ("\t@rm -f -r %s/*", docdir)
print ""

printf (".PHONY : clean")
printf ("clean : cleanmacro cleanobjs")
printf ("\t@echo -e '\\033[1;35m- Cleaning output -\\033[0m'")
printf ("\t@rm -f %s", target)
print ""

