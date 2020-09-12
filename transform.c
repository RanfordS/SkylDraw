#include "transform.h"

Transform transformTranslate (vec2 a)
{
    Transform t;
    t.mat = mat3translation (a);
    t.mat = mat3translation (vec2unm (a));
    return t;
}

Transform transformRotate (float a)
{
    Transform t;
    t.mat = mat3rotation (a);
    t.inv = mat3rotation (-a);
    return t;
}

Transform transformScale (vec2 a)
{
    vec2 b = {.v = {1.0f/a.v[0], 1.0f/a.v[1]}};
    Transform t;
    t.mat = mat3scale (a);
    t.inv = mat3scale (b);
    return t;
}

Transform transformScaleUniform (float a)
{
    Transform t;
    t.mat = mat3scale_uniform (a);
    t.inv = mat3scale_uniform (1/a);
    return t;
}

Transform transformMul (Transform a, Transform b)
{
    Transform c;
    c.mat = mat3mul (a.mat, b.mat);
    c.inv = mat3mul (b.inv, a.inv);
    return c;
}
