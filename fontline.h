#include <stdbool.h>
#include "bezier.h"
#include "vec.h"

typedef struct
{   size_t pointCount;
    vec2* points;
    bool* oncurve;
}   Fontline;
