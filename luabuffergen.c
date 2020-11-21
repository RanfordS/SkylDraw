#include "core.h"
#include "luatransform.h"
#include "shapes.h"

typedef struct
{   size_t vertCount;
    vec2* verts;
    bool closed;
}   VertexInfo;

void fontlineVertexInfo (VertexInfo* info, Fontline* line)
{
    size_t count = 0;
    for (size_t c = 0, p = line->pointCount - 1; c < line->pointCount; p = c++)
    {
        if (line->oncurve[c])
        {   if (line->oncurve[p])
                ++count;
        }
        else
            count += line->resolution;
    }

    info->vertCount = count;
    info->verts = malloc (count*sizeof (vec2));

    // fill data
    size_t vindex = 0;
    for (size_t c0 = 0; c0 < line->pointCount; ++c0)
    {
        size_t c1 = (c0 + 1) % count;

        if (line->oncurve[c0] && line->oncurve[c1])
        {
            info->verts[vindex++] = line->points[c0];
        }
        else
        if (line->oncurve[c1])
        {
            size_t c2 = (c0 + 2) % count;

            Bezier3 curve = {};
            curve.points[0] = line->points[c0];
            curve.points[1] = line->points[c1];
            curve.points[2] = line->points[c2];

            if (line->oncurve[c0]) curve.points[0] =
                vec2scalardiv (vec2add (curve.points[c0], curve.points[c1]), 2);
            if (line->oncurve[c2]) curve.points[2] =
                vec2scalardiv (vec2add (curve.points[c2], curve.points[c1]), 2);

            bezier3Update (&curve);
            for (size_t j = 0; j < line->resolution; ++j)
            {
                float t = j / (float) line->resolution;
                info->verts[vindex++] = bezier3Position (&curve, t);
            }
        }
    }
}

typedef struct
{   size_t vertCount;
    size_t indexCount;
    GLuint vao;
    GLuint vbo;
    GLuint ibo;
}   BufferInfo;

void createBuffer (BufferInfo* buffer, vec2* vdata, GLuint* idata)
{
    glGenVertexArrays (1, &buffer->vao);
    glGenBuffers (1, &buffer->vbo);
    glGenBuffers (1, &buffer->ibo);

    glBindVertexArray (buffer->vao);
    glBindBuffer (GL_ARRAY_BUFFER, buffer->vbo);
    glBindBuffer (GL_ELEMENT_ARRAY_BUFFER, buffer->ibo);

    glBufferData (GL_ARRAY_BUFFER,
        buffer->vertCount*sizeof (vec2), vdata, GL_STATIC_DRAW);
    glBufferData (GL_ELEMENT_ARRAY_BUFFER,
        buffer->indexCount*sizeof (GLuint), idata, GL_STATIC_DRAW);

    glVertexAttribPointer
    (   0
    ,   2, GL_FLOAT
    ,   GL_FALSE
    ,   sizeof (vec2), NULL);
    glEnableVertexAttribArray (0);

    glBindVertexArray (0);
    glBindBuffer (GL_ARRAY_BUFFER, 0);
    glBindBuffer (GL_ELEMENT_ARRAY_BUFFER, 0);
}

// takes the inputted vertex infos an writes the data into a single buffer info
void createVertexBuffer (BufferInfo* buffer, size_t infoCount, VertexInfo* infos)
{
    // calculate buffer sizes
    size_t vertCount = 0;
    size_t indexCount = infoCount - 1;

    for (size_t i = 0; i < infoCount; ++i)
    {
        vertCount  += infos[i].vertCount;
        indexCount += infos[i].vertCount + infos[i].closed;
    }

    // allocate
    vec2*   vdata = malloc (vertCount*sizeof (vec2));
    GLuint* idata = malloc (indexCount*sizeof (GLuint));

    size_t vindex = 0;
    size_t iindex = 0;

    for (size_t i = 0; i < infoCount; ++i)
    {
        if (i != 0) idata[iindex++] = ~((GLuint) 0);

        memcpy (vdata + vindex, infos[i].verts, infos[i].vertCount*sizeof (vec2));

        size_t sindex = vindex;
        for (size_t j = 0; j < infos[i].vertCount; ++j)
        {
            idata[iindex++] = vindex++;
        }
        if (infos[i].closed)
        {
            idata[iindex++] = sindex;
        }
    }

    buffer->vertCount = vertCount;
    buffer->indexCount = indexCount;
    createBuffer (buffer, vdata, idata);
}

// to be called with the table of tables at the top of the stack
void lcreatebuffer (lua_State* L, BufferInfo* buffer)
{
    size_t root = lua_gettop (L);
    size_t numobjs = lua_rawlen (L, root);

    size_t numverts = 0;
    for (size_t i = 1; i <= numobjs; ++i)
    {
        lua_rawgeti (L, root, i);
        numverts += lua_rawlen (L, root + 1);
        lua_pop (L, 1);
    }

    buffer->vertCount = numverts;
    buffer->indexCount = numverts + numobjs - 1;

    vec2* vdata = malloc (buffer->vertCount*sizeof (vec2));
    GLuint* idata = malloc (buffer->indexCount*sizeof (GLuint));

    size_t vpos = 0;
    size_t ipos = 0;
    for (size_t i = 1; i <= numobjs; ++i)
    {
        // restart primitive
        if (i != 1) idata[ipos++] = ~((GLuint)0);

        lua_rawgeti (L, -1, i);
        size_t sublen = lua_rawlen (L, root + 1);

        for (size_t j = 1; j <= sublen; ++j)
        {
            lua_rawgeti (L, root + 1, j);
            vdata[vpos] = lvec_lua2c (L, root + 2);
            idata[ipos] = vpos;

            ++vpos; ++ipos;
        }

        lua_pop (L, -1);
    }

    createBuffer (buffer, vdata, idata);
}
