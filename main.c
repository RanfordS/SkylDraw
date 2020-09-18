#include "core.h"
#include "init.h"
#include "font.h"
#include "lineshader.h"
#include "buffergen.h"
#include "transform.h"
#include "luavec.h"

void error_callback (int error, const char* description)
{
    printf ("[!] glfw error %i: %s\n", error, description);
}

void key_callback (GLFWwindow* window,
    int key, int scancode, int action, int mods)
{
    (void)scancode;
    (void)mods;
    if (key == GLFW_KEY_ESCAPE && action == GLFW_PRESS)
        glfwSetWindowShouldClose(window, GL_TRUE);
}

int main(void)
{
    InitError initError = init ();
    if (initError)
    {
        printf ("[!] init error: %i\n", initError);
        quit (initError);
        return 1;
    }
    initLuaVec ();
    initLineShader ();

    glfwSetKeyCallback (window, key_callback);
    glfwSetErrorCallback (error_callback);

    // -*- //

    int lua_res = luaL_dofile (luaState, "Fontline.lua");

    if (lua_res != LUA_OK)
    {
        printf ("luaerr: %s\n", lua_tostring (luaState, -1));
    }

    // -*- //

    TextObject text;
    createTextObject ("Giffib Callas", &text);

    // -*- //
    /*
    Bezier4 bezier = {.points =
    {   {.v = {-1.0f, -1.0f}}
    ,   {.v = {-1.0f,  0.0f}}
    ,   {.v = { 1.0f, -0.0f}}
    ,   {.v = { 1.0f,  1.0f}}}};
    bezier4Update (&bezier);

    BufferInfo bezierBuffer = {};
    bezierBuffer.vertCount = 65;
    createBezier4Buffer (&bezier, &bezierBuffer);

    // -*- //

    Circle circle = {};
    circle.radius = 1.0f;

    BufferInfo circleBuffer = {};
    circleBuffer.vertCount = 64;
    createCircleBuffer (&circle, &circleBuffer);

    // -*- //

    Arc arc = {};
    arc.radius = 0.75f;
    arc.angleStart = 0.25f*M_PI;
    arc.angleRange = 1.50f*M_PI;

    BufferInfo arcBuffer = {};
    arcBuffer.vertCount = 64;
    createArcBuffer (&arc, &arcBuffer);
    */
    // -*- //

    Fontline fl = {};
    fl.pointCount = 8;
    fl.points = calloc (8, sizeof (vec2));
    fl.oncurve = calloc (8, sizeof (bool));

    fl.points[0].v[0] = -1.0f; fl.points[0].v[1] = -1.0f; fl.oncurve[0] = true;
    fl.points[1].v[0] =  0.5f; fl.points[1].v[1] = -1.0f; fl.oncurve[1] = true;
    fl.points[2].v[0] =  1.0f; fl.points[2].v[1] = -1.0f; fl.oncurve[2] = false;
    fl.points[3].v[0] =  1.0f; fl.points[3].v[1] =  1.0f; fl.oncurve[3] = false;
    fl.points[4].v[0] =  0.5f; fl.points[4].v[1] =  1.0f; fl.oncurve[4] = true;
    fl.points[5].v[0] = -0.5f; fl.points[5].v[1] =  1.0f; fl.oncurve[5] = true;
    fl.points[6].v[0] = -1.0f; fl.points[6].v[1] =  1.0f; fl.oncurve[6] = false;
    fl.points[7].v[0] = -1.0f; fl.points[7].v[1] =  0.0f; fl.oncurve[7] = true;

    BufferInfo flBuffer = {};
    createFontline (&fl, &flBuffer, 16);

    // -*- //

    while (!glfwWindowShouldClose(window))
    {
        glfwPollEvents ();

        int width, height;
        glfwGetFramebufferSize (window, &width, &height);
        glViewport (0, 0, width, height);

        vec2 dim = {.v = {2.0f/width, -2.0f/height}};

        Transform uimapping;
        {
            Transform scale = transformScale (dim);
            vec2 pos = {.v = {1.0f, -1.0f}};
            Transform trans = transformTranslate (pos);
            uimapping = transformMul (trans, scale);
        }

        dim.v[1] = -dim.v[1];
        dim = vec2scalarmul (dim, 0.5*(width < height ? width : height));

        Transform aspect = transformScale (dim);

        // -*- //

        vec3 fontColor = {.v = {1.0f, 1.0f, 1.0f}};
        mat3 fontMat = mat3multranspose (uimapping.mat, mat3scale_uniform (1.0f));

        glClearColor (0.10f, 0.20f, 0.15f, 1.00f);
        glClear (GL_COLOR_BUFFER_BIT);

        glUseProgram (fontProgram);
        glBindTexture (GL_TEXTURE_2D, fontTexture);
        glUniformMatrix3fv (fontInMat, 1, GL_FALSE, fontMat.m);
        glUniform3fv (fontInColor, 1, fontColor.v);
        glBindVertexArray (text.vao);

        glDrawArrays (GL_TRIANGLE_STRIP, 0, text.size);

        glBindVertexArray (0);

        vec4 lineColor = {.v = {1.0f, 1.0f, 1.0f, 1.0f}};
        Transform lineMat = transformMul (aspect, transformScaleUniform (0.5f));

        // -*- //

        int state = glfwGetMouseButton (window, GLFW_MOUSE_BUTTON_LEFT);
        if (state == GLFW_PRESS)
        {
            deleteBuffer (&flBuffer);

            double xpos, ypos;
            glfwGetCursorPos (window, &xpos, &ypos);

            vec3 pos = {.v = {xpos, ypos, 1}};
            mat3 uitoworld = mat3mul (lineMat.inv, uimapping.mat);
            pos = mat3vecmul (uitoworld, pos);
            fl.points[0] = vec3drop (pos, 2);
            fl.oncurve[0] = true;

            createFontline (&fl, &flBuffer, 16);
        }

        state = glfwGetMouseButton (window, GLFW_MOUSE_BUTTON_RIGHT);
        if (state == GLFW_PRESS)
        {
            deleteBuffer (&flBuffer);

            double xpos, ypos;
            glfwGetCursorPos (window, &xpos, &ypos);

            vec3 pos = {.v = {xpos, ypos, 1}};
            mat3 uitoworld = mat3mul (lineMat.inv, uimapping.mat);
            pos = mat3vecmul (uitoworld, pos);
            fl.points[0] = vec3drop (pos, 2);
            fl.oncurve[0] = false;

            createFontline (&fl, &flBuffer, 16);
        }

        // -*- //

        glUseProgram (lineProgram);
        glUniformMatrix3fv (lineInMat, 1, GL_TRUE, lineMat.mat.m);
        glUniform4fv (lineInColor, 1, lineColor.v);

        /*
        glBindVertexArray (bezierBuffer.vao);
        glDrawArrays (GL_LINE_STRIP, 0, bezierBuffer.vertCount);
        glBindVertexArray (circleBuffer.vao);
        glDrawArrays (GL_LINE_LOOP, 0, circleBuffer.vertCount);
        glBindVertexArray (arcBuffer.vao);
        glDrawArrays (GL_LINE_STRIP, 0, arcBuffer.vertCount);
        */
        glBindVertexArray (flBuffer.vao);
        glDrawArrays (GL_LINE_LOOP, 0, flBuffer.vertCount);

        glBindVertexArray (0);

        glUseProgram (0);
        glfwSwapBuffers (window);
    }

    deleteBuffer (&flBuffer);
    deleteTextObject (&text);

    quit (0);
    return 0;
}
