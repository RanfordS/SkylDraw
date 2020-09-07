#pragma once
#include "core.h"

typedef struct
{   GLuint vao;
    GLuint vbo;
    size_t size;
}   TextObject;

extern bool initFont (void);
extern void quitFont (void);

extern void createTextObject (char* string, TextObject* result);
extern void deleteTextObject (TextObject* target);

extern GLuint fontTexture;
extern GLuint fontProgram;
extern GLint fontInXY;
extern GLint fontInST;
extern GLint fontInMat;
extern GLint fontInColor;
extern GLint fontInImage;
