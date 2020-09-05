#pragma once

// drawing
/*#include <GL/glew.h>
#include <GL/gl.h>
#include <GL/glu.h>*/
#include <GLFW/glfw3.h>
// lua
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
// standard
#include <stdlib.h>
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <math.h>
#include <string.h>
// custom
#include "vec.h"
// globals
extern lua_State* luaState;
extern GLFWwindow* window;
// dbg
#define TICK printf ("TICK %i\n", __LINE__)
