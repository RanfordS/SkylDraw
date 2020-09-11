#include "shapes.h"

Circle circle3Point (vec2 a, vec2 b, vec2 c)
{
    vec2 tangent_ab = vec2perp (vec2sub (b, a));
    vec2 tangent_ac = vec2perp (vec2sub (c, a));
    vec2 halfDiff = vec2scalardiv (vec2sub (c, b), 2.0f);
    mat2 tangents;
    mat2setcol (tangents, 0, tangent_ab);
    mat2setcol (tangents, 1, tangent_ac);
    vec2 lambda = vec2cramers (tangents, halfDiff);

    Circle circle;
    circle.center = vec2add (vec2scalarmul (vec2add (a, b), 0.5f),
                             vec2scalarmul (tangent_ab, lambda.v[0]));
    circle.radius = vec2mag (vec2sub (a, circle.center));
    return circle;
}

Circle circlePointNormalPoint (vec2 a_pos, vec2 a_norm, vec2 b_pos)
{
    vec2 diff = vec2sub (a_pos, b_pos);
    float lambda = 0.5f*vec2mag2 (diff) / vec2dot (diff, a_norm);

    Circle circle;
    circle.center = vec2sub (a_pos, vec2scalarmul (a_norm, lambda));
    circle.radius = vec2mag (vec2sub (a_pos, circle.center));
    return circle;
}
