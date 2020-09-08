#include "vec.h"

typedef struct
{   vec2 center;
    float radius;
}   Circle;

extern Circle circle3Point (vec2 a, vec2 b, vec2 c);
extern Circle circlePointNormalPoint (vec2 a_pos, vec2 a_norm, vec2 b_pos);
