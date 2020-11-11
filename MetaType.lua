
function mtype (object)
    local t = type (object)
    if t == "table" then
        local m = getmetatable (object)
        if m and m.mtype then
            return m.mtype
        end
    end
    return t
end

