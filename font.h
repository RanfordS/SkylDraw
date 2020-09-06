#pragma once
#include "core.h"

typedef struct
{   GLuint vao;
    GLuint vbo;
    size_t size;
}   TextObject;

extern void createTextObject (char* string, TextObject* result);
extern void deleteTextObject (TextObject* target);
