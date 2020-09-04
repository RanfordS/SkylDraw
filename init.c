#include "init.h"
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

lua_State* luaState;
GLFWwindow* window;
unsigned int fontTexture;

InitError init (void)
{
    // lua
    luaState = luaL_newstate ();
    if (!luaState)
        return INIT_ERR_LUA;
    luaL_openlibs (luaState);

    // glfw
    if (!glfwInit ())
        return INIT_ERR_GLFW;

    // window
    window = glfwCreateWindow (800, 600, "Skyline Drawer", NULL, NULL);
    if (!window)
        return INIT_ERR_WINDOW;
    glfwMakeContextCurrent (window);

    // font
    int width, height, channels;
    stbi_uc* pixels = stbi_load ("font.png", &width, &height, &channels, 0);
    if (!pixels)
        return INIT_ERR_FONT_IMAGE;

    glGenTextures (1, &fontTexture);
    glBindTexture (GL_TEXTURE_2D, fontTexture);
    glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D (GL_TEXTURE_2D, 0, GL_RGB, width, height, 0, GL_RGB, GL_UNSIGNED_BYTE, pixels);
    glGenerateMipmap (GL_TEXTURE_2D);

    stbi_image_free  (pixels);

    return INIT_SUCCESS;
}

void quit (InitError err)
{
    switch (err)
    {
        case INIT_SUCCESS:
            glDeleteTextures (1, &fontTexture);
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
