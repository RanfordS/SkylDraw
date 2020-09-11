#include "shapes.h"

static Arc anglesFromEnds (Arc arc, vec2 s, vec2 e)
{
    vec2 os = vec2sub (s, arc.center);
    vec2 oe = vec2sub (e, arc.center);
    float theta_s = atan2 (os.v[1], os.v[0]);
    float theta_e = atan2 (oe.v[1], oe.v[0]);

    arc.angleStart = theta_s;
    arc.angleRange = theta_e - theta_s;
    if (arc.angleRange < 0)
        arc.angleRange += M_PI;

    return arc;
}

Arc arc3Point (vec2 a, vec2 b, vec2 c)
{
    Circle circle = circle3Point (a, b, c);

    Arc arc = {};
    arc.center = circle.center;
    arc.radius = circle.radius;
    return anglesFromEnds (arc, a, c);
}

Arc arcPointNormalPoint (vec2 a_pos, vec2 a_norm, vec2 b_pos)
{
    Circle circle = circlePointNormalPoint (a_pos, a_norm, b_pos);

    Arc arc = {};
    arc.center = circle.center;
    arc.radius = circle.radius;
    return anglesFromEnds (arc, a_pos, b_pos);
}

void arcFlip (Arc* arc)
{
    arc->angleStart += arc->angleRange;
    arc->angleRange = 2.0f*M_PI - arc->angleRange;
}

vec2 arcStartPosition (Arc* arc)
{
    vec2 rel = vec2polar (arc->angleStart, arc->radius);
    return vec2add (arc->center, rel);
}

vec2 arcEndPosition (Arc* arc)
{
    vec2 rel =  vec2polar (arc->angleStart + arc->angleRange, arc->radius);
    return vec2add (arc->center, rel);
}
