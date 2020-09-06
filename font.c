#include "font.h"
#include "init.h"

typedef struct
{   union
    {   GLfloat x;
        GLfloat s;
    };
    union
    {   GLfloat y;
        GLfloat t;
    };
}   GLVec2;
/*
typedef struct
{   GLfloat x;
    GLfloat y;
    GLfloat s;
    GLfloat t;
}   Vertex;
*/
typedef struct
{   GLVec2 pos;
    GLVec2 tex;
}   Vertex;

typedef struct
{   Vertex tl;
    Vertex bl;
    Vertex tr;
    Vertex br;
}   Quad;

void createTextObject (char* string, TextObject* result)
{
    size_t length = strlen (string);

    Quad* data = calloc (length, sizeof (Quad));
    result->size = 4*length;

    for (size_t i = 0; i < length; ++i)
    {
        char c = string[i];
        uint8_t col = 0x0F & c;
        uint8_t row = c >> 4;

        data[i].tl.pos.x = 9*i; data[i].tr.pos.x = 9*(i+1);
        data[i].bl.pos.x = 9*i; data[i].br.pos.x = 9*(i+1);

        data[i].tl.pos.y =  0;  data[i].tr.pos.y =  0;
        data[i].bl.pos.y = 20;  data[i].br.pos.y = 20;

        data[i].tl.tex.s = col/16.0f; data[i].tr.tex.s = (col+1)/16.0f;
        data[i].bl.tex.s = col/16.0f; data[i].br.tex.s = (col+1)/16.0f;

        data[i].tl.tex.t = row/8.0f;     data[i].tr.tex.t = row/8.0f;
        data[i].bl.tex.t = (row+1)/8.0f; data[i].br.tex.t = (row+1)/8.0f;
    }

    glGenVertexArrays (1, &result->vao);
    glGenBuffers (1, &result->vbo);

    glBindVertexArray (result->vao);
    glBindBuffer (GL_ARRAY_BUFFER, result->vbo);
    glBufferData
        (GL_ARRAY_BUFFER, length*sizeof (Quad), (void*)data, GL_STATIC_DRAW);
    free (data);

    glVertexAttribPointer (fontInXY, 2, GL_FLOAT, GL_FALSE,
        sizeof (Vertex), (void*)offsetof (Vertex, pos));
    glEnableVertexAttribArray (fontInXY);

    glVertexAttribPointer (fontInST, 2, GL_FLOAT, GL_FALSE,
        sizeof (Vertex), (void*)offsetof (Vertex, tex));
    glEnableVertexAttribArray (fontInST);

    glBindBuffer (GL_ARRAY_BUFFER, 0);
    glBindVertexArray (0);
}

void deleteTextObject (TextObject* target)
{
    glDeleteBuffers (1, &target->vbo);
    glDeleteVertexArrays (1, &target->vao);
}
