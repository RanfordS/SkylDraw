#pragma once
#include "vec.h"

typedef struct
{   mat3 mat;
    mat3 inv;
}   Transform;

extern Transform transformTranslate (vec2 a);
extern Transform transformRotate (float a);
extern Transform transformScale (vec2 a);
extern Transform transformScaleUniform (float a);
extern Transform transformMul (Transform a, Transform b);

