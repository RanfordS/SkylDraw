#include "font.h"

typedef struct
{   GLfloat x;
    GLfloat y;
    GLfloat s;
    GLfloat t;
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
    GLuint* id = calloc (4*length, sizeof (GLuint));
    result->size = 4*length;

    for (size_t i = 0; i < length; ++i)
    {
        char c = string[i];
        uint8_t row = 0x0F & c;
        uint8_t col = c >> 4;

        data[i].tl.x = 9*i; data[i].tr.x = 9*(i+1);
        data[i].bl.x = 9*i; data[i].br.x = 9*(i+1);

        data[i].tl.y =  0;  data[i].tr.y =  0;
        data[i].bl.y = 20;  data[i].bl.y = 20;

        data[i].tl.s = col/16.0f; data[i].tr.s = (col+1)/16.0f;
        data[i].bl.s = col/16.0f; data[i].br.s = (col+1)/16.0f;

        data[i].tl.t = row/8.0f;     data[i].tr.t = row/8.0f;
        data[i].bl.t = (row+1)/8.0f; data[i].br.t = (row+1)/8.0f;

        data[i].tl.x = 0; data[i].tl.y = 0; data[i].tr.x = 1; data[i].tr.y = 0;
        data[i].bl.x = 0; data[i].bl.y = 1; data[i].br.x = 1; data[i].br.y = 1;
    }

    for (size_t i = 0; i < 4*length; ++i)
        id[i] = i;

    glGenBuffers (1, &result->vbo);
    glBindBuffer (GL_ARRAY_BUFFER, result->vbo);
    glBufferData
        (GL_ARRAY_BUFFER, length*sizeof (Quad), (void*)data, GL_STATIC_DRAW);
    free (data);

    glGenBuffers (1, &result->ibo);
    glBindBuffer (GL_ELEMENT_ARRAY_BUFFER, result->ibo);
    glBufferData
        (GL_ELEMENT_ARRAY_BUFFER, 4*length*sizeof (GLuint), id, GL_STATIC_DRAW);
    free (id);

    printf ("buffer objects: %i, %i\n", result->vbo, result->ibo);
}

void deleteTextObject (TextObject* target)
{
    glDeleteBuffers (1, &target->vbo);
    glDeleteBuffers (1, &target->ibo);
}
