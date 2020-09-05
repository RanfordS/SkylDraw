#pragma once
#include "core.h"

typedef enum
{   INIT_SUCCESS = 0
,   INIT_ERR_FONT_IMAGE
,   INIT_ERR_WINDOW
,   INIT_ERR_GLFW
,   INIT_ERR_LUA
}   InitError;

extern GLuint fontTexture;
extern GLuint fontProgram;
extern GLint fontInXY;
extern GLint fontInST;
extern GLint fontInMat;
extern GLint fontInImage;

extern InitError init (void);
extern void quit (InitError err);
