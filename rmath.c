#include "rmath.h"

size_t rm_factorial (size_t n)
{
    size_t r = 1;
    while (n > 1)
        r *= n--;
    return r;
}

size_t rm_choose (size_t n, size_t k)
{
    size_t num = 1;
    size_t den = 1;

    for (size_t i = 0; i < k; ++i)
    {
        num *= n - i;
        den *= i + 1;
    }
    return num/den;
}

float rm_sign (float a)
{
    if (a == 0.0f) return 0.0f;
    return copysignf (1.0f, a);
}
