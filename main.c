#include "core.h"
#include "init.h"
#include "font.h"

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

    glfwSetKeyCallback (window, key_callback);
    glfwSetErrorCallback (error_callback);

    TextObject text;
    createTextObject ("Hello World!", &text);

    while (!glfwWindowShouldClose(window))
    {
        float ratio;
        int width, height;
        glfwGetFramebufferSize (window, &width, &height);
        ratio = width / (float) height;
        glViewport (0, 0, width, height);

        glClear (GL_COLOR_BUFFER_BIT);
        glMatrixMode (GL_PROJECTION);
        glLoadIdentity ();
        glOrtho (-ratio, ratio, -1.f, 1.f, 1.f, -1.f);

        glMatrixMode (GL_MODELVIEW);
        glLoadIdentity ();
        glRotatef ((float) glfwGetTime ()*50.f, 0.f, 0.f, 1.f);

        glBegin(GL_TRIANGLES);
            glColor3f(1.f, 0.f, -0.1f);
            glVertex3f(-0.6f, -0.4f, -0.1f);
            glColor3f(0.f, 1.f, 0.f);
            glVertex3f(0.6f, -0.4f, -0.1f);
            glColor3f(0.f, 0.f, 1.f);
            glVertex3f(0.f, 0.6f, -0.1f);
        glEnd ();

        glMatrixMode (GL_PROJECTION);
        glLoadIdentity ();

        glMatrixMode (GL_MODELVIEW);
        glLoadIdentity ();

        glColor4f (1.0, 1.0, 1.0, 1.0);
        glUseProgram (fontProgram);
        glEnableVertexAttribArray (fontInXY);
        glEnableVertexAttribArray (fontInST);

        glBindBuffer (GL_ARRAY_BUFFER, text.vbo);
        glVertexAttribPointer (fontInXY, 2, GL_FLOAT, GL_FALSE,
                4*sizeof (GLfloat), (void*)(0*sizeof (GLfloat)));
        glVertexAttribPointer (fontInST, 2, GL_FLOAT, GL_FALSE,
                4*sizeof (GLfloat), (void*)(2*sizeof (GLfloat)));
        glBindBuffer (GL_ELEMENT_ARRAY_BUFFER, text.ibo);

        mat3 matrix = {.m =
            { 1.0f/width, 0, -width/2.0f
            , 0, 1.0f/height,-height/2.0f
            , 0, 0, 1}};
        //mat3 matrix = {.m = {1,0,0,0,1,0,0,0,1}};
        glUniformMatrix3fv (fontInMat, 1, GL_TRUE, matrix.m);

        //glActiveTexture (GL_TEXTURE0);
        glBindTexture (GL_TEXTURE_2D, fontTexture);
        glDrawElements (GL_TRIANGLE_STRIP, text.size, GL_UNSIGNED_INT, NULL);
        glDisableVertexAttribArray (fontInXY);
        glDisableVertexAttribArray (fontInST);
        glUseProgram (0);

        glfwSwapBuffers (window);
        glfwPollEvents ();
    }

    deleteTextObject (&text);

    quit (0);
    return 0;
}
