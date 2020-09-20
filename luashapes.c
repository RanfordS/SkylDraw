#include "core.h"
#include "luavec.h"
#include "shapes.h"

void rua_setclass (lua_State* L, const char* name)
{
    lua_getglobal (L, name);
    lua_getfield (L, -1, "meta");
    lua_setmetatable (L, -3);
    lua_pop (L, 1);
}

// - Circle - //

static int l_circleNew (lua_State* L)
{
    lua_newtable (L);
    Circle* circle = lua_newuserdata (L, sizeof (Circle));

    circle->center = vec2_l2c (L, 1);
    circle->radius = lua_tonumber (L, 2);

    lua_setfield (L, -2, "data");
    rua_setclass (L, "Circle");
    return 1;
}

static int l_circle3Point (lua_State* L)
{
    lua_newtable (L);
    Circle* circle = lua_newuserdata (L, sizeof (Circle));

    vec2 a = vec2_l2c (L, 1);
    vec2 b = vec2_l2c (L, 2);
    vec2 c = vec2_l2c (L, 3);
    *circle = circle3Point (a, b, c);

    lua_setfield (L, -2, "data");
    rua_setclass (L, "Circle");
    return 1;
}

static int l_circlePointNormalPoint (lua_State* L)
{
    lua_newtable (L);
    Circle* circle = lua_newuserdata (L, sizeof (Circle));

    vec2 a = vec2_l2c (L, 1);
    vec2 n = vec2_l2c (L, 2);
    vec2 b = vec2_l2c (L, 3);
    *circle = circlePointNormalPoint (a, n, b);

    lua_setfield (L, -2, "data");
    rua_setclass (L, "Circle");
    return 1;
}

//

static int l_circle_get_center (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Circle* circle = lua_touserdata (L, -1);

    vec2_c2l (L, circle->center);
    return 1;
}

static int l_circle_set_center (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Circle* circle = lua_touserdata (L, -1);
    circle->center = vec2_l2c (L, 2);
    return 0;
}

static int l_circle_get_radius (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Circle* circle = lua_touserdata (L, -1);

    lua_pushnumber (L, circle->radius);
    return 1;
}

static int l_circle_set_radius (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Circle* circle = lua_touserdata (L, -1);
    circle->radius = lua_tonumber (L, 2);
    return 0;
}

// - Arc - //

static int l_arcNew (lua_State* L)
{
    lua_newtable (L);
    Arc* arc = lua_newuserdata (L, sizeof (Arc));

    arc->center = vec2_l2c (L, 1);
    arc->radius = lua_tonumber (L, 2);
    arc->angleStart = lua_tonumber (L, 3);
    arc->angleRange = lua_tonumber (L, 4);

    lua_setfield (L, -2, "data");
    rua_setclass (L, "Arc");
    return 1;
}

static int l_arc3Point (lua_State* L)
{
    lua_newtable (L);
    Arc* arc = lua_newuserdata (L, sizeof (Arc));

    vec2 a = vec2_l2c (L, 1);
    vec2 b = vec2_l2c (L, 2);
    vec2 c = vec2_l2c (L, 3);
    *arc = arc3Point (a, b, c);

    lua_setfield (L, -2, "data");
    rua_setclass (L, "Arc");
    return 1;
}

static int l_arcPointNormalPoint (lua_State* L)
{
    lua_newtable (L);
    Arc* arc = lua_newuserdata (L, sizeof (Arc));

    vec2 a = vec2_l2c (L, 1);
    vec2 n = vec2_l2c (L, 2);
    vec2 b = vec2_l2c (L, 3);
    *arc = arcPointNormalPoint (a, n, b);

    lua_setfield (L, -2, "data");
    rua_setclass (L, "Arc");
    return 1;
}

static int l_arcFlip (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Arc* arc = lua_touserdata (L, -1);

    arcFlip (arc);
    return 0;
}

static int l_arcStartPos (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Arc* arc = lua_touserdata (L, -1);

    vec2_c2l (L, arcStartPosition (arc));
    return 1;
}

static int l_arcEndPos (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Arc* arc = lua_touserdata (L, -1);

    vec2_c2l (L, arcEndPosition (arc));
    return 1;
}

//

static int l_arc_get_center (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Arc* arc = lua_touserdata (L, -1);

    vec2_c2l (L, arc->center);
    return 1;
}

static int l_arc_set_center (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Arc* arc = lua_touserdata (L, -1);

    arc->center = vec2_l2c (L, 2);
    return 0;
}
