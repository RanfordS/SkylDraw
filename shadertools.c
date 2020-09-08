#include "shadertools.h"

bool shaderError (GLuint shader)
{
    GLint res;
    res = GL_TRUE;
    glGetShaderiv (shader, GL_COMPILE_STATUS, &res);

    if (res == GL_FALSE)
    {
        GLint ls = 0;
        glGetShaderiv (shader, GL_INFO_LOG_LENGTH, &ls);
        GLchar* error = malloc (ls*sizeof (GLchar));

        glGetShaderInfoLog (shader, ls, &ls, error);
        printf ("[!] Failed to compile shader: %s\n", error);
        free (error);

        return true;
    }
    return false;
}

bool programError (GLuint program)
{
    GLint res;
    res = GL_TRUE;
    glGetProgramiv (program, GL_LINK_STATUS, &res);

    if (res == GL_FALSE)
    {
        GLint ls = 0;
        glGetProgramiv (program, GL_INFO_LOG_LENGTH, &ls);
        GLchar* error = malloc (ls*sizeof(GLchar));

        glGetProgramInfoLog (program, ls, &ls, error);
        printf ("[!] Failed to link program: %s\n", error);
        free (error);

        return true;
    }
    return false;
}
