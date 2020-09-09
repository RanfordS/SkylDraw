#pragma once
#include "vec.h"

typedef struct
{   vec2 center;
    float radius;
    float angleStart;
    float angleRange;
}   Arc;

extern Arc arc3Point (vec2 a, vec2 b, vec2 c);
extern Arc arcPointNormalPoint (vec2 a_pos, vec2 a_norm, vec2 b_pos);
extern void arcFlip (Arc* arc);
extern vec2 arcStartPosition (Arc* arc);
extern vec2 arcEndPosition (Arc* arc);
