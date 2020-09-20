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

static int l_circle_new (lua_State* L)
{
    lua_newtable (L);
    Circle* circle = lua_newuserdata (L, sizeof (Circle));

    circle->center = vec2_l2c (L, 1);
    circle->radius = lua_tonumber (L, 2);

    lua_setfield (L, -2, "data");
    rua_setclass (L, "Circle");
    return 1;
}

static int l_circle_3point (lua_State* L)
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

static int l_circle_pointNormalPoint (lua_State* L)
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

static int l_arc_new (lua_State* L)
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

static int l_arc_3point (lua_State* L)
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

static int l_arc_pointNormalPoint (lua_State* L)
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

static int l_arc_flip (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Arc* arc = lua_touserdata (L, -1);

    arcFlip (arc);
    return 0;
}

static int l_arc_startPos (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Arc* arc = lua_touserdata (L, -1);

    vec2_c2l (L, arcStartPosition (arc));
    return 1;
}

static int l_arc_endPos (lua_State* L)
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

static int l_arc_get_radius (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Arc* arc = lua_touserdata (L, -1);

    lua_pushnumber (L, arc->radius);
    return 1;
}

static int l_arc_set_radius (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Arc* arc = lua_touserdata (L, -1);

    arc->radius = lua_tonumber (L, 2);
    return 0;
}

static int l_arc_get_angleStart (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Arc* arc = lua_touserdata (L, -1);

    lua_pushnumber (L, arc->angleStart);
    return 1;
}

static int l_arc_set_angleStart (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Arc* arc = lua_touserdata (L, -1);

    arc->angleStart = lua_tonumber (L, 2);
    return 0;
}

static int l_arc_get_angleRange (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Arc* arc = lua_touserdata (L, -1);

    lua_pushnumber (L, arc->angleRange);
    return 1;
}

static int l_arc_set_angleRange (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Arc* arc = lua_touserdata (L, -1);

    arc->angleRange = lua_tonumber (L, 2);
    return 0;
}

// - Bezier 3 - //

static int l_bezier3_new (lua_State* L)
{
    lua_newtable (L);

    Bezier3* curve = lua_newuserdata (L, sizeof (Bezier3));
    lua_setfield (L, -2, "data");

    for (int i = 0; i < 3; ++i)
        curve->points[i] = vec2_l2c (L, i+1);

    lua_pushboolean (L, false);
    lua_setfield (L, -2, "uptodate");

    rua_setclass (L, "Bezier3");
    return 1;
}

static int l_bezier3_update (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Bezier3* curve = lua_touserdata (L, -2);
    lua_pop (L, 1);

    bezier3Update (curve);

    lua_pushboolean (L, true);
    lua_setfield (L, 1, "uptodate");
    return 0;
}

static int l_bezier3_geti (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Bezier3* curve = lua_touserdata (L, -2);
    size_t i = lua_tointeger (L, 2) - 1;

    vec2 v = curve->points[i];
    vec2_c2l (L, v);
    return 1;
}

static int l_bezier3_seti (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Bezier3* curve = lua_touserdata (L, -2);
    size_t i = lua_tointeger (L, 2) - 1;
    vec2 v = vec2_l2c (L, 3);

    curve->points[i] = v;

    lua_pushboolean (L, false);
    lua_setfield (L, 1, "uptodate");
    return 0;
}

static int l_bezier3_position (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Bezier3* curve = lua_touserdata (L, -1);
    float t = lua_tonumber (L, 2);

    lua_getfield (L, 1, "uptodate");
    if (lua_toboolean (L, -1) != true)
        l_bezier3_update (L);

    vec2 v = bezier3Position (curve, t);
    vec2_c2l (L, v);
    return 1;
}

static int l_bezier3_velocity (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Bezier3* curve = lua_touserdata (L, -1);
    float t = lua_tonumber (L, 2);

    lua_getfield (L, 1, "uptodate");
    if (lua_toboolean (L, -1) != true)
        l_bezier3_update (L);

    vec2 v = bezier3Velocity (curve, t);
    vec2_c2l (L, v);
    return 1;
}

// - Bezier 4 - //

static int l_bezier4_new (lua_State* L)
{
    lua_newtable (L);

    Bezier4* curve = lua_newuserdata (L, sizeof (Bezier4));
    lua_setfield (L, -2, "data");

    for (int i = 0; i < 4; ++i)
        curve->points[i] = vec2_l2c (L, i+1);

    lua_pushboolean (L, false);
    lua_setfield (L, -2, "uptodate");

    rua_setclass (L, "Bezier4");
    return 1;
}

static int l_bezier4_update (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Bezier4* curve = lua_touserdata (L, -2);
    lua_pop (L, 1);

    bezier4Update (curve);

    lua_pushboolean (L, true);
    lua_setfield (L, 1, "uptodate");
    return 0;
}

static int l_bezier4_geti (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Bezier4* curve = lua_touserdata (L, -2);
    size_t i = lua_tointeger (L, 2) - 1;

    vec2 v = curve->points[i];
    vec2_c2l (L, v);
    return 1;
}

static int l_bezier4_seti (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Bezier4* curve = lua_touserdata (L, -2);
    size_t i = lua_tointeger (L, 2) - 1;
    vec2 v = vec2_l2c (L, 3);

    curve->points[i] = v;

    lua_pushboolean (L, false);
    lua_setfield (L, 1, "uptodate");
    return 0;
}

static int l_bezier4_position (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Bezier4* curve = lua_touserdata (L, -1);
    float t = lua_tonumber (L, 2);

    lua_getfield (L, 1, "uptodate");
    if (lua_toboolean (L, -1) != true)
        l_bezier4_update (L);

    vec2 v = bezier4Position (curve, t);
    vec2_c2l (L, v);
    return 1;
}

static int l_bezier4_velocity (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Bezier4* curve = lua_touserdata (L, -1);
    float t = lua_tonumber (L, 2);

    lua_getfield (L, 1, "uptodate");
    if (lua_toboolean (L, -1) != true)
        l_bezier4_update (L);

    vec2 v = bezier4Velocity (curve, t);
    vec2_c2l (L, v);
    return 1;
}


// - Generic Bezier - //

static int l_bezier_new (lua_State* L)
{
    lua_getfield (L, 1, "data");
    vec2array* array = lua_touserdata (L, -1);
    lua_pop (L, 1);

    lua_newtable (L);
    Bezier* curve = lua_newuserdata (L, sizeof (Bezier));
    lua_setfield (L, -2, "data");

    curve->pointCount = array->count;
    size_t bytecount = array->count*sizeof (vec2);
    curve->points = malloc (bytecount);
    curve->coefficients = malloc (bytecount);
    memcpy (curve->points, array->verts, bytecount);

    lua_pushboolean (L, false);
    lua_setfield (L, -2, "uptodate");

    rua_setclass (L, "Bezier");
    return 1;
}

static int l_bezier_update (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Bezier* curve = lua_touserdata (L, -2);
    lua_pop (L, 1);

    bezierUpdate (curve);

    lua_pushboolean (L, true);
    lua_setfield (L, 1, "uptodate");
    return 0;
}

static int l_bezier_geti (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Bezier* curve = lua_touserdata (L, -2);
    size_t i = lua_tointeger (L, 2) - 1;

    vec2 v = curve->points[i];
    vec2_c2l (L, v);
    return 1;
}

static int l_bezier_seti (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Bezier* curve = lua_touserdata (L, -2);
    size_t i = lua_tointeger (L, 2) - 1;
    vec2 v = vec2_l2c (L, 3);

    curve->points[i] = v;

    lua_pushboolean (L, false);
    lua_setfield (L, 1, "uptodate");
    return 0;
}

static int l_bezier_position (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Bezier* curve = lua_touserdata (L, -1);
    float t = lua_tonumber (L, 2);

    lua_getfield (L, 1, "uptodate");
    if (lua_toboolean (L, -1) != true)
        l_bezier_update (L);

    vec2 v = bezierPosition (curve, t);
    vec2_c2l (L, v);
    return 1;
}

static int l_bezier_velocity (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Bezier* curve = lua_touserdata (L, -1);
    float t = lua_tonumber (L, 2);

    lua_getfield (L, 1, "uptodate");
    if (lua_toboolean (L, -1) != true)
        l_bezier_update (L);

    vec2 v = bezierVelocity (curve, t);
    vec2_c2l (L, v);
    return 1;
}

// - Fontline - //

static int l_fontline_new (lua_State* L)
{
    lua_getfield (L, 1, "data");
    vec2array* array = lua_touserdata (L, -1);
    lua_pop (L, 1);

    lua_newtable (L);
    Fontline* curve = lua_newuserdata (L, sizeof (Fontline));
    lua_setfield (L, -2, "data");

    curve->pointCount = array->count;
    curve->points = malloc (array->count*sizeof (vec2));
    curve->oncurve = malloc (array->count*sizeof (bool));
    memcpy (curve->points, array->verts, array->count*sizeof (vec2));

    for (size_t i = 0; i < array->count; ++i)
    {
        lua_geti (L, 2, i+1);
        curve->oncurve[i] = lua_toboolean (L, -1);
        lua_pop (L, 1);
    }

    lua_pushboolean (L, false);
    lua_setfield (L, -2, "uptodate");

    rua_setclass (L, "Bezier");
    return 1;
}

static int l_fontline_getvi (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Fontline* curve = lua_touserdata (L, -1);
    size_t i = lua_tointeger (L, 2) - 1;

    vec2 v = curve->points[i];
    vec2_c2l (L, v);
    return 1;
}

static int l_fontline_setvi (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Fontline* curve = lua_touserdata (L, -1);
    size_t i = lua_tointeger (L, 2) - 1;
    vec2 v = vec2_l2c (L, 3);

    curve->points[i] = v;
    return 0;
}

static int l_fontline_getbi (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Fontline* curve = lua_touserdata (L, -1);
    size_t i = lua_tointeger (L, 2) - 1;

    bool b = curve->oncurve[i];
    lua_pushboolean (L, b);
    return 1;
}

static int l_fontline_setbi (lua_State* L)
{
    lua_getfield (L, 1, "data");
    Fontline* curve = lua_touserdata (L, -1);
    size_t i = lua_tointeger (L, 2) - 1;
    bool b = lua_toboolean (L, 3);

    curve->oncurve[i] = b;
    return 0;
}

// - Register - //

void initLuaShapes (void)
{
    lua_newtable (luaState);

        lua_pushcfunction (luaState, l_circle_new);
        lua_setfield (luaState, -2, "new");

        lua_pushcfunction (luaState, l_circle_3point);
        lua_setfield (luaState, -2, "3point");

        lua_pushcfunction (luaState, l_circle_pointNormalPoint);
        lua_setfield (luaState, -2, "pointNormalPoint");

        lua_pushcfunction (luaState, l_circle_get_center);
        lua_setfield (luaState, -2, "get_center");

        lua_pushcfunction (luaState, l_circle_set_center);
        lua_setfield (luaState, -2, "set_center");

        lua_pushcfunction (luaState, l_circle_get_radius);
        lua_setfield (luaState, -2, "get_radius");

        lua_pushcfunction (luaState, l_circle_set_radius);
        lua_setfield (luaState, -2, "set_radius");

    lua_setglobal (luaState, "Circle");

    lua_newtable (luaState);

        lua_pushcfunction (luaState, l_arc_new);
        lua_setfield (luaState, -2, "new");

        lua_pushcfunction (luaState, l_arc_3point);
        lua_setfield (luaState, -2, "3point");

        lua_pushcfunction (luaState, l_arc_pointNormalPoint);
        lua_setfield (luaState, -2, "pointNormalPoint");

        lua_pushcfunction (luaState, l_arc_flip);
        lua_setfield (luaState, -2, "flip");

        lua_pushcfunction (luaState, l_arc_get_center);
        lua_setfield (luaState, -2, "get_center");

        lua_pushcfunction (luaState, l_arc_set_center);
        lua_setfield (luaState, -2, "set_center");

        lua_pushcfunction (luaState, l_arc_get_radius);
        lua_setfield (luaState, -2, "get_radius");

        lua_pushcfunction (luaState, l_arc_set_radius);
        lua_setfield (luaState, -2, "set_radius");

        lua_pushcfunction (luaState, l_arc_get_angleStart);
        lua_setfield (luaState, -2, "get_angleStart");

        lua_pushcfunction (luaState, l_arc_set_angleStart);
        lua_setfield (luaState, -2, "set_angleStart");

        lua_pushcfunction (luaState, l_arc_startPos);
        lua_setfield (luaState, -2, "startPos");

        lua_pushcfunction (luaState, l_arc_endPos);
        lua_setfield (luaState, -2, "endPos");

        lua_pushcfunction (luaState, l_arc_get_angleRange);
        lua_setfield (luaState, -2, "get_angleRange");

        lua_pushcfunction (luaState, l_arc_set_angleRange);
        lua_setfield (luaState, -2, "set_angleRange");

    lua_setglobal (luaState, "Arc");

    lua_newtable (luaState);

        lua_pushcfunction (luaState, l_bezier3_new);
        lua_setfield (luaState, -2, "new");

        lua_pushcfunction (luaState, l_bezier3_update);
        lua_setfield (luaState, -2, "update");

        lua_pushcfunction (luaState, l_bezier3_geti);
        lua_setfield (luaState, -2, "geti");

        lua_pushcfunction (luaState, l_bezier3_seti);
        lua_setfield (luaState, -2, "seti");

        lua_pushcfunction (luaState, l_bezier3_position);
        lua_setfield (luaState, -2, "position");

        lua_pushcfunction (luaState, l_bezier3_velocity);
        lua_setfield (luaState, -2, "velocity");

    lua_setglobal (luaState, "Bezier3");
    lua_newtable (luaState);

        lua_pushcfunction (luaState, l_bezier4_new);
        lua_setfield (luaState, -2, "new");

        lua_pushcfunction (luaState, l_bezier4_update);
        lua_setfield (luaState, -2, "update");

        lua_pushcfunction (luaState, l_bezier4_geti);
        lua_setfield (luaState, -2, "geti");

        lua_pushcfunction (luaState, l_bezier4_seti);
        lua_setfield (luaState, -2, "seti");

        lua_pushcfunction (luaState, l_bezier4_position);
        lua_setfield (luaState, -2, "position");

        lua_pushcfunction (luaState, l_bezier4_velocity);
        lua_setfield (luaState, -2, "velocity");

    lua_setglobal (luaState, "Bezier4");
    lua_newtable (luaState);

        lua_pushcfunction (luaState, l_bezier_new);
        lua_setfield (luaState, -2, "new");

        lua_pushcfunction (luaState, l_bezier_update);
        lua_setfield (luaState, -2, "update");

        lua_pushcfunction (luaState, l_bezier_geti);
        lua_setfield (luaState, -2, "geti");

        lua_pushcfunction (luaState, l_bezier_seti);
        lua_setfield (luaState, -2, "seti");

        lua_pushcfunction (luaState, l_bezier_position);
        lua_setfield (luaState, -2, "position");

        lua_pushcfunction (luaState, l_bezier_velocity);
        lua_setfield (luaState, -2, "velocity");

    lua_setglobal (luaState, "Bezier");

    lua_newtable (luaState);

        lua_pushcfunction (luaState, l_fontline_new);
        lua_setfield (luaState, -2, "new");

        lua_pushcfunction (luaState, l_fontline_getvi);
        lua_setfield (luaState, -2, "getvi");

        lua_pushcfunction (luaState, l_fontline_setvi);
        lua_setfield (luaState, -2, "setvi");

        lua_pushcfunction (luaState, l_fontline_getbi);
        lua_setfield (luaState, -2, "getbi");

        lua_pushcfunction (luaState, l_fontline_setbi);
        lua_setfield (luaState, -2, "setbi");

    lua_setglobal (luaState, "Fontline");
}

