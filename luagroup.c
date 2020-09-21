#include "core.h"
#include "buffergen.h"

typedef struct
{   size_t childCount;
    void** children;
    bool visible;
}   Group;

static void group_parse (lua_State* L, Group* parent)
{
    size_t count = lua_rawlen (L, -1);
    parent->childCount = count;
    parent->children = malloc (count*sizeof (void*));

    lua_getfield (L, -1, "visable");
    parent->visible = lua_toboolean (L, -1);
    lua_pop (L, 1);

    for (size_t i = 0; i < count; ++i)
    {

    }
}

static int l_group_export (lua_State* L)
{
    lua_settop (L, 1); // discard any extra arguments

    lua_getglobal (L, "Group");
    lua_getfield (L, 2, "meta");
    lua_remove (L, 2);

    lua_pushnil (L);
    lua_copy (L, 1, 3);

    Group head;
    group_parse (L, &head);
}
