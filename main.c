#include "core.h"
#include "init.h"

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
            glColor3f(1.f, 0.f, 0.f);
            glVertex3f(-0.6f, -0.4f, 0.f);
            glColor3f(0.f, 1.f, 0.f);
            glVertex3f(0.6f, -0.4f, 0.f);
            glColor3f(0.f, 0.f, 1.f);
            glVertex3f(0.f, 0.6f, 0.f);
        glEnd ();

        glfwSwapBuffers (window);
        glfwPollEvents ();
    }

    quit (0);
    return 0;
}
