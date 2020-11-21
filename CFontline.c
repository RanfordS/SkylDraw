#include "core.h"
#include "luatransform.h"
#include "shapes.h"
#include "buffergen.h"

void l_fontline_lua2c (lua_State* L, size_t i, Fontline* line)
{
    i = lua_absindex (L, i);

    lua_pushstring (L, "points");
        lua_rawget (L, i);

        lua_rawlen (L, -1);
            line->pointCount = lua_tointeger (L, -1);
        lua_pop (L, 1);

        line->points  = malloc (line->pointCount*sizeof (vec2));
        line->oncurve = malloc (line->pointCount*sizeof (bool));

        for (size_t i = 0; i < line->pointCount; ++i)
        {
            lua_rawgeti (L, -1, i+1);
                line->points[i] = lvec_lua2c (L, -1);
            lua_pop (L, 1);
        }

    lua_pop (L, 1);

    lua_pushstring (L, "oncurve");
        lua_rawget (L, i);

        for (size_t i = 0; i < line->pointCount; ++i)
        {
            lua_rawgeti (L, -1, i+1);
                line->oncurve[i] = lua_toboolean (L, -1);
            lua_pop (L, 1);
        }

    lua_pop (L, 1);

    lua_pushstring (L, "closed");
        lua_rawget (L, i);
        line->closed = lua_toboolean (L, -1);
    lua_pop (L, 1);
}


