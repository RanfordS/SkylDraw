#include "luatransform.h"

// abs index only
vec2 lvec_lua2c (lua_State* L, int i)
{
    vec2 a;

    lua_pushstring (L, "x"); lua_rawget (L, i); a.v[0] = lua_tonumber (L, -1);
    lua_pushstring (L, "y"); lua_rawget (L, i); a.v[1] = lua_tonumber (L, -1);
    /*
    lua_getfield (L, i, "x"); a.v[0] = lua_tonumber (L, -1);
    lua_getfield (L, i, "y"); a.v[1] = lua_tonumber (L, -1);
    */
    lua_pop (L, 2);

    return a;
}

void lvec_c2lua (lua_State* L, vec2 a)
{
    lua_createtable (L, 0, 2);

    lua_pushstring (L, "x"); lua_pushnumber (L, a.v[0]); lua_rawset (L, -3);
    lua_pushstring (L, "y"); lua_pushnumber (L, a.v[1]); lua_rawset (L, -3);
    /*
    lua_pushnumber (L, a.v[0]); lua_setfield (L, -2, "x");
    lua_pushnumber (L, a.v[1]); lua_setfield (L, -2, "y");
    */
    lua_getglobal (L, "Vec");
    lua_pushstring (L, "metatable");
    lua_rawget (L, -2);
    lua_setmetatable (L, -3);
    lua_pop (L, 1);
}

mat3* ltransform_new (lua_State* L)
{
    mat3* transform = lua_newuserdata (L, 2*sizeof (mat3));
    lua_getglobal (L, "Transform");
    lua_pushstring (L, "metatable");
    lua_rawget (L, -2);
    lua_setmetatable (L, -3);
    lua_pop (L, 1);

    return transform;
}

int l_transform_identity (lua_State* L)
{
    mat3* transform = ltransform_new (L);

    for (size_t i = 0; i < 3; ++i)
        for (size_t j = 0; j < 3; ++j)
            M3ID(transform[0],i,j) = i == j;

    transform[1] = transform[0];

    return 1;
}

int l_transform_mul (lua_State* L)
{
    mat3* a = lua_touserdata (L, 1);
    mat3* b = lua_touserdata (L, 2);
    mat3* c = ltransform_new (L);
    lua_pop (L, 1);

    c[0] = mat3mul (a[0], b[0]);
    c[1] = mat3mul (b[1], a[1]);

    return 1;
}

int l_transform_translate (lua_State* L)
{
    vec2 v = lvec_lua2c (L, 1);
    mat3* M = ltransform_new (L);

    M[0] = mat3translation (v);
    M[1] = mat3translation (vec2unm (v));
    return 1;
}

int l_transform_rotate (lua_State* L)
{
    float a = lua_tonumber (L, 1);
    mat3* M = ltransform_new (L);

    M[0] = mat3rotation (a);
    M[1] = mat3rotation (-a);
    return 1;
}

int l_transform_scale (lua_State* L)
{
    vec2 s = lvec_lua2c (L, 1);
    vec2 t; t.v[0] = 1.0f/s.v[0]; t.v[1] = 1.0f/s.v[1];
    mat3* M = ltransform_new (L);

    M[0] = mat3scale (s);
    M[1] = mat3scale (t);
    return 1;
}

int l_transform_scale_uniform (lua_State* L)
{
    float s = lua_tonumber (L, 1);
    mat3* M = ltransform_new (L);

    M[0] = mat3scale_uniform (s);
    M[1] = mat3scale_uniform (1/s);
    return 1;
}

// 1 - transform
// 2 - array of vectors
// 3 - output array
// 4 - current vector
int l_transform_mpos (lua_State* L)
{
    lua_settop (L, 2);
    mat3*  M = lua_touserdata (L, 1);
    size_t n = lua_rawlen (L, 2);
    lua_createtable (L, n, 0);

    for (size_t i = 1; i <= n; ++i)
    {
        lua_rawgeti (L, 2, i);
        vec2 v = lvec_lua2c (L, 4);
        lua_pop (L, 1);

        v = vec3drop (mat3vecmul (M[0], vec2homogeneous (v)), 2);

        lvec_c2lua (L, v);
        lua_rawseti (L, 3, i);
    }
    return 1;
}

int l_transform_mvec (lua_State* L)
{
    lua_settop (L, 2);
    mat3*  M = lua_touserdata (L, 1);
    size_t n = lua_rawlen (L, 2);
    lua_createtable (L, n, 0);

    for (size_t i = 1; i <= n; ++i)
    {
        lua_rawgeti (L, 2, i);
        vec2 v = lvec_lua2c (L, 4);
        lua_pop (L, 1);

        v = vec3drop (mat3vecmul (M[0], vec2raise (v, 2, 0)), 2);

        lvec_c2lua (L, v);
        lua_rawseti (L, 3, i);
    }
    return 1;
}

int l_transform_pos (lua_State* L)
{
    mat3* M = lua_touserdata (L, 1);
    vec2  u = lvec_lua2c (L, 2);
    vec2  v = vec3drop (mat3vecmul (M[0], vec2raise (u, 3, 1.0f)), 3);
    lvec_c2lua (L, v);
    return 1;
}

int l_transform_vec (lua_State* L)
{
    mat3* M = lua_touserdata (L, 1);
    vec2  u = lvec_lua2c (L, 2);
    vec2  v = vec3drop (mat3vecmul (M[0], vec2raise (u, 3, 0.0f)), 3);
    lvec_c2lua (L, v);
    return 1;
}



void registerTransform (lua_State* L)
{
    lua_newtable (L); // Transform

    lua_pushcfunction (L, l_transform_identity);
    lua_setfield (L, -2, "identity");

    lua_pushcfunction (L, l_transform_translate);
    lua_setfield (L, -2, "translate");

    lua_pushcfunction (L, l_transform_rotate);
    lua_setfield (L, -2, "rotate");

    lua_pushcfunction (L, l_transform_scale);
    lua_setfield (L, -2, "scale");

    lua_pushcfunction (L, l_transform_scale_uniform);
    lua_setfield (L, -2, "scaleuniform");

    lua_pushcfunction (L, l_transform_pos);
    lua_setfield (L, -2, "pos");

    lua_pushcfunction (L, l_transform_vec);
    lua_setfield (L, -2, "vec");

    lua_pushcfunction (L, l_transform_mpos);
    lua_setfield (L, -2, "pos_array");

    lua_pushcfunction (L, l_transform_mvec);
    lua_setfield (L, -2, "vec_array");

    lua_newtable (L); // metatable

    lua_pushcfunction (L, l_transform_mul);
    lua_setfield (L, -2, "__mul");

    lua_setfield (L, -2, "metatable");
    lua_setglobal (L, "Transform");
}



