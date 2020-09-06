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
    createTextObject ("Giffib Callas", &text);

    while (!glfwWindowShouldClose(window))
    {
        glfwPollEvents ();

        int width, height;
        glfwGetFramebufferSize (window, &width, &height);
        glViewport (0, 0, width, height);

        mat3 uimapping = {.m =
            { 2.0f/width, 0.0f,       -1.0f
            , 0.0f,      -2.0f/height, 1.0f
            , 0.0f,       0.0f,        1.0f}};

        vec3 fontColor = {.v = {1.0f, 0.5f, 0.5f}};
        mat3 fontMat = mat3multranspose (uimapping, mat3scale_uniform (1.0f));

        glClearColor (0.1f, 0.3f, 0.2f, 1.0f);
        glClear (GL_COLOR_BUFFER_BIT);

        glUseProgram (fontProgram);
        glBindTexture (GL_TEXTURE_2D, fontTexture);
        glUniformMatrix3fv (fontInMat, 1, GL_FALSE, fontMat.m);
        glUniform3fv (fontInColor, 1, fontColor.v);
        glBindVertexArray (text.vao);

        glDrawArrays (GL_TRIANGLE_STRIP, 0, text.size);

        glBindVertexArray (0);

        glfwSwapBuffers (window);
    }

    deleteTextObject (&text);

    quit (0);
    return 0;
}
