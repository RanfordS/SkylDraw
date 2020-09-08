#include "lineshader.h"
#include "shadertools.h"

GLuint lineVertShader;
GLuint lineFragShader;
GLuint lineProgram;
GLint  lineInXY;
GLint  lineInMat;
GLint  lineInColor;

static const GLchar* vertCode [] =
{
    "#version 130\n"
    "in vec2 inXY;\n"
    "uniform mat3 M;\n"

    "void main ()\n"
    "{\n"
    "  vec3 transform = M*vec3 (inXY, 1);\n"
    "  gl_Position = vec4 (transform.xy, 0, 1);\n"
    "}\n"
};

static const GLchar* fragCode [] =
{
    "#version 130\n"
    "uniform vec4 inColor;\n"
    "out vec4 result;\n"

    "void main ()\n"
    "{\n"
    "  result = vec4 (inColor);\n"
    "}\n"
};

bool initLineShader (void)
{
    // font shader
    lineVertShader = glCreateShader (GL_VERTEX_SHADER);
    glShaderSource (lineVertShader, 1, vertCode, NULL);
    glCompileShader (lineVertShader);

    lineFragShader = glCreateShader (GL_FRAGMENT_SHADER);
    glShaderSource (lineFragShader, 1, fragCode, NULL);
    glCompileShader (lineFragShader);

    if (shaderError (lineVertShader)
    ||  shaderError (lineFragShader))
        return false;

    lineProgram = glCreateProgram ();

    glAttachShader (lineProgram, lineVertShader);
    glAttachShader (lineProgram, lineFragShader);
    glLinkProgram (lineProgram);

    if (programError (lineProgram))
    {
        return false;
    }

    lineInXY = glGetAttribLocation (lineProgram, "inXY");
    lineInMat = glGetUniformLocation (lineProgram, "M");
    lineInColor = glGetUniformLocation (lineProgram, "inColor");

    return true;
}
