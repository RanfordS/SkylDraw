#include "init.h"
#include "font.h"
//#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

lua_State* luaState;
GLFWwindow* window;

InitError init (void)
{
    // lua
    luaState = luaL_newstate ();
    if (!luaState)
        return INIT_ERR_LUA;
    luaL_openlibs (luaState);

    // glfw
    glewExperimental = GL_TRUE;
    if (!glfwInit ())
        return INIT_ERR_GLFW;

    // window
    window = glfwCreateWindow (800, 600, "Skyline Drawer", NULL, NULL);
    if (!window)
        return INIT_ERR_WINDOW;
    glfwMakeContextCurrent (window);

    // glew
    glewInit ();
    glEnable (GL_BLEND);
    glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

	if (!initFont ())
		return INIT_ERR_FONT_IMAGE;

    return INIT_SUCCESS;
}

void quit (InitError err)
{
    switch (err)
    {
        case INIT_SUCCESS:
            quitFont ();
        case INIT_ERR_FONT_IMAGE:
            glfwDestroyWindow (window);
        case INIT_ERR_WINDOW:
            glfwTerminate ();
        case INIT_ERR_GLFW:
            lua_close (luaState);
        case INIT_ERR_LUA:
            break;
    }
}
