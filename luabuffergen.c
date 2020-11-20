#include "core.h"
//#include "buffergen.h"
#include "luatransform.h"

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
        if (i != 1) idata[++ipos] = ~((GLuint)0);

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
