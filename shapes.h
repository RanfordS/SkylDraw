#pragma once
#include <stdbool.h>
#include "vec.h"
#include "rmath.h"

// Circle

typedef struct
{   vec2 center;
    float radius;
}   Circle;

extern Circle circle3Point (vec2 a, vec2 b, vec2 c);
extern Circle circlePointNormalPoint (vec2 a_pos, vec2 a_norm, vec2 b_pos);

// Arc

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



typedef struct
{   vec2 points[3];
    vec2 coefficients[3];
}   Bezier3;

extern void bezier3Update (Bezier3* curve);
extern vec2 bezier3Position (Bezier3* curve, float t);
extern vec2 bezier3Velocity (Bezier3* curve, float t);



typedef struct
{   vec2 points[4];
    vec2 coefficients[4];
}   Bezier4;

extern void bezier4Update (Bezier4* curve);
extern vec2 bezier4Position (Bezier4* curve, float t);
extern vec2 bezier4Velocity (Bezier4* curve, float t);


typedef struct
{   size_t pointCount;
    vec2* points;
    vec2* coefficients;
}   Bezier;

extern void bezierUpdate (Bezier* curve);
extern vec2 bezierPosition (Bezier* curve, float t);
extern vec2 bezierVelocity (Bezier* curve, float t);

// Fontline

typedef struct
{   size_t pointCount;
    vec2* points;
    bool* oncurve;
}   Fontline;
