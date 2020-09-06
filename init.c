#include "init.h"
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"

lua_State* luaState;
GLFWwindow* window;
GLuint fontTexture;
GLuint fontProgram;
GLint fontInXY;
GLint fontInST;
GLint fontInMat;
GLint fontInImage;

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

    // font texture
    int width, height, channels;
    stbi_uc* pixels = stbi_load ("font.png", &width, &height, &channels, 0);
    if (!pixels)
        return INIT_ERR_FONT_IMAGE;

    glGenTextures (1, &fontTexture);
    glBindTexture (GL_TEXTURE_2D, fontTexture);
    glTexImage2D (GL_TEXTURE_2D, 0, GL_RGBA, width, height,
                                 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
    glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,
                                    GL_LINEAR_MIPMAP_LINEAR);
    glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,
                                    GL_LINEAR);
    glGenerateMipmap (GL_TEXTURE_2D);

    stbi_image_free  (pixels);

    // font shader
    fontProgram = glCreateProgram ();

    GLuint vertShader = glCreateShader (GL_VERTEX_SHADER);
    const GLchar* vertCode [] =
    {   "#version 130\n"
        "in vec2 inXY;\n"
        "in vec2 inST;\n"
        "uniform mat3 M;\n"
        "out vec2 outST;\n"
        "void main ()\n"
        "{ outST = inST;\n"
        "  vec3 transform = M*vec3 (inXY, 1);\n"
        "  gl_Position = vec4 (transform.xy, 0, 1);\n"
        "}\n"
    };
    glShaderSource (vertShader, 1, vertCode, NULL);
    glCompileShader (vertShader);

    GLuint fragShader = glCreateShader (GL_FRAGMENT_SHADER);
    const GLchar* fragCode [] =
    {   "#version 130\n"
        "in vec2 outST;\n"
        "uniform sampler2D image;\n"
        "out vec4 result;\n"
        "void main ()\n"
        "{\n"
        "  result = vec4 (1,1,1,1-texture (image, outST).r);\n"
        "}\n"
    };
    glShaderSource (fragShader, 1, fragCode, NULL);
    glCompileShader (fragShader);

    GLint res;
    res = GL_TRUE;
    glGetShaderiv (vertShader, GL_COMPILE_STATUS, &res);
    if (res == GL_FALSE)
    {
        GLint ls = 0;
        glGetShaderiv (vertShader, GL_INFO_LOG_LENGTH, &ls);
        GLchar* error = malloc (ls*sizeof(GLchar));
        glGetShaderInfoLog (vertShader, ls, &ls, error);
        printf ("vertex shader compile failed %s\n", error);
        free (error);
    }
    glGetShaderiv (fragShader, GL_COMPILE_STATUS, &res);
    if (res == GL_FALSE)
    {
        GLint ls = 0;
        glGetShaderiv (fragShader, GL_INFO_LOG_LENGTH, &ls);
        GLchar* error = malloc (ls*sizeof(GLchar));
        glGetShaderInfoLog (fragShader, ls, &ls, error);
        printf ("fragment shader compile failed %s\n", error);
        free (error);
    }

    glAttachShader (fontProgram, vertShader);
    glAttachShader (fontProgram, fragShader);
    glLinkProgram (fontProgram);
    glDeleteShader (vertShader);
    glDeleteShader (fragShader);

    glGetProgramiv (fontProgram, GL_LINK_STATUS, &res);
    if(res == GL_FALSE)
    {
        GLint ls = 0;
        glGetProgramiv (fontProgram, GL_INFO_LOG_LENGTH, &ls);
        GLchar* error = malloc (ls*sizeof(GLchar));
        glGetProgramInfoLog (fontProgram, ls, &ls, error);
        printf ("[!]:\tFailed to link program: %s\n", error);
        free (error);
    }

    fontInXY = glGetAttribLocation (fontProgram, "inXY");
    fontInST = glGetAttribLocation (fontProgram, "inST");
    fontInMat = glGetUniformLocation (fontProgram, "M");
    fontInImage = glGetUniformLocation (fontProgram, "image");

    printf ("program: %i\n", fontProgram);
    printf ("attribuate locations: %i, %i\n", fontInXY, fontInST);
    printf ("uniform locations: %i, %i\n", fontInMat, fontInImage);

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
