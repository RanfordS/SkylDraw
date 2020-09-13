#include "vec.h"
#include <stdbool.h>
#include <stdint.h>

typedef enum
{   LINE_TYPE_FINITE
,   LINE_TYPE_PARTIAL
,   LINE_TYPE_INFINITE
}   LineType;

typedef struct
{   vec2 start;
    union
    {   vec2 end;
        vec2 dir;
    };
    uint8_t type;
}   Line;

void lineClip (Line* line, Line* to, bool side)
{
    vec2 linedir = line->type == LINE_TYPE_FINITE
                 ? vec2sub (line->end, line->start)
                 : line->dir;
    vec2 todir = to->type == LINE_TYPE_FINITE
               ? vec2sub (to->end, to->start)
               : to->dir;

    mat2 A = {};
    mat2setcol (A, 0, linedir);
    mat2setcol (A, 1, vec2unm (todir));
    vec2 b = vec2sub (line->start, to->start);

    vec2 lambda = vec2cramers (A, b);
}
