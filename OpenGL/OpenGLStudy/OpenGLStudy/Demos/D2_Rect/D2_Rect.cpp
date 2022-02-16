//
//  D2_Rect.cpp
//  OpenGLStudy
//
//  Created by MOMO on 2021/7/30.
//  Copyright © 2021 TriangleDemo. All rights reserved.
//  画矩形


/*

#define GL_SILENCE_DEPRECATIO
#include "glfw3.h"
#include "glad.h"

#include <iostream>
#include <stdio.h>

// settings

const unsigned int SCR_WIDTH = 800;
const unsigned int SCR_HEIGHT = 600;


void processInput(GLFWwindow *window);
void framebuffer_size_callback(GLFWwindow* window, int width, int height);


const char *vertexShaderSource = "#version 330 core\n"
"layout (location = 0) in vec3 aPos;\n"
"void main()\n"
"{\n"
"   gl_Position = vec4(aPos.x, aPos.y, aPos.z, 1.0);\n"
"}\0";

const char *fragmentShaderSource = "#version 330 core\n"
"out vec4 FragColor;\n"
"void main()\n"
"{\n"
"   FragColor = vec4(1.0f, 0.5f, 0.2f, 1.0f);\n"
"}\n\0";


int main(int argc,char* argv[]) {
    
    // 实例化GLFW：
    // glfw: initialize and configure
    // ------------------------------
    
    // 初始化GLFW
    glfwInit();
    // 使用glfwWindowHint函数来配置GLFW
    // OpenGL 3.3版本 将主版本号(Major)和次版本号(Minor)都设为3
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    // 明确告诉GLFW我们使用的是核心模式(Core-profile)
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
    
    // 如果使用的是Mac OS X系统,需要加下面这行代码到你的初始化代码中这些配置才能起作用
#ifdef __APPLE__
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif
    
    //创建一个窗口对象
    // glfw window creation
    // --------------------
    
    GLFWwindow *window = glfwCreateWindow(SCR_WIDTH, SCR_HEIGHT, "LearnOpenGL", nullptr, nullptr);
    if (window == nullptr) {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    
    // 创建完窗口通知GLFW将窗口的上下文设置为当前线程的主上下文了。
    glfwMakeContextCurrent(window);
    
    // 还需要注册这个函数 告诉GLFW我们希望每当窗口调整大小的时候调用这个函数：
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);
    
    // GLAD是用来管理OpenGL的函数指针的
    // 调用任何OpenGL的函数之前我们需要初始化GLAD
    // 给GLAD传入了用来加载系统相关的OpenGL函数指针地址的函数, GLFW给我们的是glfwGetProcAddress，它根据我们编译的系统定义了正确的函数
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress)) {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return -1;
    }
    glViewport(0, 0, SCR_WIDTH, SCR_HEIGHT);
    
    
    // 顶点着色器 vertex shader
    // 创建一个着色器对象
    unsigned int vertexShader;
    vertexShader = glCreateShader(GL_VERTEX_SHADER);
    
    // 把这个着色器源码附加到着色器对象上，然后编译它：
    glShaderSource(vertexShader, 1, &vertexShaderSource, NULL);
    glCompileShader(vertexShader);
    
    // check for shader compile errors
    int success;
    char infoLog[512];
    glGetShaderiv(vertexShader, GL_COMPILE_STATUS, &success);
    
    if (!success) {
        glGetShaderInfoLog(vertexShader, 512, NULL, infoLog);
        std::cout << "ERROR::SHADER::VERTEX::COMPILATION_FAILED\n" << infoLog << std::endl;
    }
    
    // fragment shader
    unsigned int fragementShader = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(fragementShader, 1, &fragmentShaderSource, NULL);
    glCompileShader(fragementShader);
    
    // check for shader compile errors
    glGetShaderiv(fragementShader, GL_COMPILE_STATUS, &success);
    if (!success) {
        glGetShaderInfoLog(fragementShader, 512, NULL, infoLog);
        std::cout << "ERROR::SHADER::FRAGMENT::COMPILATION_FAILED\n" << infoLog << std::endl;
    }
    
    // 两个着色器现在都编译了. 剩下的事情是把两个着色器对象链接到一个用来渲染的着色器程序(Shader Program)中
    // 着色器程序对象是多个着色器合并之后并最终链接完成的版本。
    
    // 创建一个程序对象很简单
    unsigned int shaderProgram;
    shaderProgram = glCreateProgram();
    
    // 现在我们需要把之前编译的着色器附加到程序对象上，然后用glLinkProgram链接它们：
    glAttachShader(shaderProgram, vertexShader);
    glAttachShader(shaderProgram, fragementShader);
    glLinkProgram(shaderProgram);
    
    glGetProgramiv(shaderProgram, GL_LINK_STATUS, &success);
    if (!success) {
        glGetProgramInfoLog(shaderProgram, 512, NULL, infoLog);
        std::cout << "ERROR::SHADER::PROGRAM::LINKING_FAILED\n" << infoLog << std::endl;
    }
    // 把着色器对象链接到程序对象以后，记得删除着色器对象，我们不再需要它们了
    glDeleteShader(vertexShader);
    glDeleteShader(fragementShader);
    
    
    //✅ 第二步： 顶点数据 - 绘制矩形
    float vertices[] = {
        0.5f, 0.5f, 0.0f,   // 右上角
        0.5f, -0.5f, 0.0f,  // 右下角
        -0.5f, -0.5f, 0.0f, // 左下角
        -0.5f, 0.5f, 0.0f   // 左上角
    };
    
    // 注意索引从0开始!
    unsigned int indices[] = {
        0,1,3, // 第一个三角形
        1, 2, 3  // 第二个三角形
    };
    
    

    // 顶点缓冲区
    // 顶点缓冲对象的缓冲类型是GL_ARRAY_BUFFER
    unsigned int VBO, VAO, EBO;
    glGenVertexArrays(1, &VAO);
    glGenBuffers(1, &VBO);
    glGenBuffers(1, &EBO);
    
    // bind the Vertex Array Object first, then bind and set vertex buffer(s), and then configure vertex attributes(s).
    glBindVertexArray(VAO);
    
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

    
    //使用glVertexAttribPointer函数告诉OpenGL该如何解析顶点数据
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 3 * sizeof(float), (void *)0);
    // 使用glEnableVertexAttribArray，以顶点属性位置值作为参数，启用顶点属性；
    // 顶点属性默认是禁用的
    glEnableVertexAttribArray(0);
    
    // note that this is allowed, the call to glVertexAttribPointer registered VBO as the vertex attribute's bound vertex buffer object so afterwards we can safely unbind
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    
    // You can unbind the VAO afterwards so other VAO calls won't accidentally modify this VAO, but this rarely happens. Modifying other
    // VAOs requires a call to glBindVertexArray anyways so we generally don't unbind VAOs (nor VBOs) when it's not directly necessary.
    glBindVertexArray(0);
    
    
    // 要想用 ✅【线框模式】绘制你的三角形，你可以通过glPolygonMode
    glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
    
    // 实现了一个简单的渲染循环：
    while (!glfwWindowShouldClose(window)) {
        
        // input
        // -----
        processInput(window);
        
        // render ⚠️⚠️⚠️ 不加这个就会出现屏幕闪动
        glClearColor(0.2, 0.3, 0.4, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        
        // draw our first triangle
        glUseProgram(shaderProgram);
        
        glBindVertexArray(VAO);
        
        // 用glDrawElements来替换glDrawArrays函数. 来指明我们从索引缓冲渲染
        // 使用glDrawElements时，我们会使用当前绑定的索引缓冲对象中的索引进行绘制
//        glDrawArrays(GL_TRIANGLES, 0, 3);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);
        
        
        
        // glBindVertexArray(0); // no need to unbind it every time
        
        // glfw: swap buffers and poll IO events (keys pressed/released, mouse moved etc.)
        // -------------------------------------------------------------------------------
        glfwSwapBuffers(window);
        glfwPollEvents();
    }
    
    // optional: de-allocate all resources once they've outlived their purpose:
    // ------------------------------------------------------------------------
    
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
    glDeleteBuffers(1, &EBO);
    glDeleteProgram(shaderProgram);
    
    // 当渲染循环结束后我们需要正确释放/删除之前的分配的所有资源
    glfwTerminate();
    return 0;
}

// 当窗口调整大小时就会回调到这里
void framebuffer_size_callback(GLFWwindow *window,int width,int height) {
    glViewport(0, 0, width, height);
}

// GLFW中实现一些输入控制
// 按ESC键退出
void processInput(GLFWwindow *window) {
    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
        glfwSetWindowShouldClose(window, true);
    }
}
 
*/
