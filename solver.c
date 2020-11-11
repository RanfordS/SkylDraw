#include "core.h"

void simplex (size_t numParams, size_t steps, float (*objective)(float*), float* result)
{
    size_t numVerts = numParams + 1;

    size_t* ages = calloc (numVerts, sizeof (size_t));
    float* argsets = calloc (numVerts*numParams, sizeof (float));
    float* values = calloc (numVerts, sizeof (float));
    float* flip = calloc (numParams, sizeof (float));
#define ARG(v,p) argsets[(v)*numParams + (p)]

    // create simplex
    for (size_t i = 0; i < numParams; ++i) ARG(i,i) = 1.0f;

    // evaluate ojective at vertices
    for (size_t i = 0; i < numVerts; ++i)  values[i] = objective (&ARG(i,0));

    while (steps--)
    {
        // manage ages

        size_t maxagekey = 0;
        size_t maxageval = values[0];

        for (size_t i = 1; i < numVerts; ++i)
        {
            size_t v = values[i];
            if (v > maxageval)
            {
                maxagekey = i;
                maxageval = v;
            }
        }

        if (maxageval > numVerts)
        {
            for (size_t i = 0; i < numVerts; ++i)
            {
                if (i == maxagekey) continue;

                for (size_t j = 0; j < numParams; ++j)
                {
                    ARG(i,j) = ARG(maxagekey,j) + (ARG(i,j) - ARG(maxagekey,j))/4;
                }

                values[i] = objective (&ARG(i,0));
            }
            memset (ages, 0, numVerts);
        }
        else
        {
            for (size_t i = 0; i < numVerts; ++i)
            {
                ages[i] += 1;
            }
        }

        // find worst

        size_t maxkey = 0;
        float maxval = values[0];
        for (size_t i = 1; i < numVerts; ++i)
        {
            float v = values[i];
            if (v > maxval)
            {
                maxkey = i;
                maxval = v;
            }
        }

        // calculate flip-point

        for (size_t p = 0; p < numParams; ++p)
        {
            float flip = 0;

            for (size_t v = 0; v < numVerts; ++v)
            {
                if (v == maxkey) continue;

                flip += ARG(v,p);
            }
        }

        memset (flip, 0, numParams);
        for (size_t i = 0; i < numVerts; ++i)
        {
            if (i == maxkey) continue;

            for (size_t j = 0; j < numParams; ++j)
            {
                flip[j] += ARG(i,j);
            }
        }

        // and step

        for (size_t i = 0; i < numParams; ++i)
        {
            // x/numParams = x/(numVerts - 1)
            ARG(maxkey,i) = 2*flip[i]/numParams - ARG(maxkey,i);
        }
        ages[maxkey] = 0;
        values[maxkey] = objective (&ARG(maxkey,0));
    }

    size_t minkey = 0;
    float minval = values[0];
    for (size_t i = 1; i < numVerts; ++i)
    {
        float v = values[i];
        if (v < minval)
        {
            minkey = i;
            minval = v;
        }
    }

    memcpy (result, &ARG(minkey,0), numParams*sizeof (float));

    free (ages);
    free (argsets);
    free (values);
    free (flip);
}

