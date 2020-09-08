#include "font.h"
//#include "init.h"
#define STB_IMAGE_IMPLEMENTATION
#include "stb_image.h"
#include "shadertools.h"

typedef struct
{   union
    {   GLfloat x;
        GLfloat s;
    };
    union
    {   GLfloat y;
        GLfloat t;
    };
}   GLVec2;

typedef struct
{   GLVec2 pos;
    GLVec2 tex;
}   Vertex;

typedef struct
{   Vertex tl;
    Vertex bl;
    Vertex tr;
    Vertex br;
}   Quad;

GLuint fontTexture;
GLuint fontVertShader;
GLuint fontFragShader;
GLuint fontProgram;
GLint  fontInXY;
GLint  fontInST;
GLint  fontInMat;
GLint  fontInColor;
GLint  fontInImage;

// -*- //

bool initFontTexture (void)
{
    // font texture
    int width, height, channels;
    stbi_uc* pixels = stbi_load ("font.png", &width, &height, &channels, 0);

    if (!pixels)
        return false;

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
    return true;
}

static const GLchar* vertCode [] =
{
    "#version 130\n"

    "in vec2 inXY;\n"
    "in vec2 inST;\n"

    "uniform mat3 M;\n"

    "out vec2 outST;\n"

    "void main ()\n"
    "{\n"
    "  outST = inST;\n"
    "  vec3 transform = M*vec3 (inXY, 1);\n"
    "  gl_Position = vec4 (transform.xy, 0, 1);\n"
    "}\n"
};

static const GLchar* fragCode [] =
{
    "#version 130\n"

    "in vec2 outST;\n"
    "in float outScale;\n"

    "uniform vec3 inColor;\n"
    "uniform sampler2D image;\n"

    "out vec4 result;\n"

    "void main ()\n"
    "{\n"
    "  result = vec4 (inColor, 1 - texture (image, outST).r);\n"
    "}\n"
};

bool initFontShader (void)
{
    // font shader
    fontVertShader = glCreateShader (GL_VERTEX_SHADER);
    glShaderSource (fontVertShader, 1, vertCode, NULL);
    glCompileShader (fontVertShader);

    fontFragShader = glCreateShader (GL_FRAGMENT_SHADER);
    glShaderSource (fontFragShader, 1, fragCode, NULL);
    glCompileShader (fontFragShader);

    if (shaderError (fontVertShader)
    ||  shaderError (fontFragShader))
        return false;

    fontProgram = glCreateProgram ();

    glAttachShader (fontProgram, fontVertShader);
    glAttachShader (fontProgram, fontFragShader);
    glLinkProgram (fontProgram);

    if (programError (fontProgram))
    {
        return false;
    }

    fontInXY = glGetAttribLocation (fontProgram, "inXY");
    fontInST = glGetAttribLocation (fontProgram, "inST");
    fontInMat = glGetUniformLocation (fontProgram, "M");
    fontInColor = glGetUniformLocation (fontProgram, "inColor");
    fontInImage = glGetUniformLocation (fontProgram, "image");

    return true;
}

bool initFont (void)
{
    if (!initFontShader ())
        return false;
    return initFontTexture ();
}

void quitFont (void)
{
    glDeleteProgram (fontProgram);
    glDeleteShader (fontVertShader);
    glDeleteShader (fontFragShader);
    glDeleteTextures (1, &fontTexture);
}

// -*- //

void createTextObject (char* string, TextObject* result)
{
    size_t length = strlen (string);

    Quad* data = calloc (length, sizeof (Quad));
    result->size = 4*length;

    for (size_t i = 0; i < length; ++i)
    {
        char c = string[i];
        uint8_t col = 0x0F & c;
        uint8_t row = c >> 4;

        data[i].tl.pos.x = 9*i; data[i].tr.pos.x = 9*(i+1);
        data[i].bl.pos.x = 9*i; data[i].br.pos.x = 9*(i+1);

        data[i].tl.pos.y =  0;  data[i].tr.pos.y =  0;
        data[i].bl.pos.y = 20;  data[i].br.pos.y = 20;

        data[i].tl.tex.s = col/16.0f; data[i].tr.tex.s = (col+1)/16.0f;
        data[i].bl.tex.s = col/16.0f; data[i].br.tex.s = (col+1)/16.0f;

        data[i].tl.tex.t = row/8.0f;     data[i].tr.tex.t = row/8.0f;
        data[i].bl.tex.t = (row+1)/8.0f; data[i].br.tex.t = (row+1)/8.0f;
    }

    glGenVertexArrays (1, &result->vao);
    glGenBuffers (1, &result->vbo);

    glBindVertexArray (result->vao);
    glBindBuffer (GL_ARRAY_BUFFER, result->vbo);
    glBufferData
        (GL_ARRAY_BUFFER, length*sizeof (Quad), (void*)data, GL_STATIC_DRAW);
    free (data);

    glVertexAttribPointer
    (   fontInXY
    ,   2, GL_FLOAT
    ,   GL_FALSE
    ,   sizeof (Vertex), (void*) offsetof (Vertex, pos));
    glEnableVertexAttribArray (fontInXY);

    glVertexAttribPointer
    (   fontInST
    ,   2, GL_FLOAT
    ,   GL_FALSE
    ,   sizeof (Vertex), (void*) offsetof (Vertex, tex));
    glEnableVertexAttribArray (fontInST);

    glBindBuffer (GL_ARRAY_BUFFER, 0);
    glBindVertexArray (0);
}

void deleteTextObject (TextObject* target)
{
    glDeleteBuffers (1, &target->vbo);
    glDeleteVertexArrays (1, &target->vao);
}
