//
//  main.cpp
//  OpenGLStudy
//
//  Created by 郑佳 on 2021/4/11.
//  Copyright © 2021 TriangleDemo. All rights reserved.
//

#define GL_SILENCE_DEPRECATIO

#include "glfw3.h"
#include "glad.h"

#include <iostream>


//void progressInput(GLFWwindow *window) {
//    if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS) {
//        glfwSetWindowShouldClose(window, GLFW_TRUE);
//    }
//}

//int main(int argc,char* argv[]) {
//
//    glfwInit();
//    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
//    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
//    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
//    // Mac OS X系统，需要加下面这行代码到你的初始化代码中这些配置才能起作用
//    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
//    
//  
//    GLFWwindow *window = glfwCreateWindow(800, 600, "Learn OpenGL", nullptr, nullptr);
//    if (window == nullptr) {
//        std::cout << "Failed to Create GLFW Window" << std::endl;
//        glfwTerminate();
//        return -1;
//    }
//    
//    // 2
//    glfwMakeContextCurrent(window);
//    
//    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
//    {
//        std::cout << "Failed to initialize GLAD" << std::endl;
//        return -1;
//    }
//    // 3
//    glViewport(0, 0, 800, 600);
//    
//    while(!glfwWindowShouldClose(window)) {
//        // Input ESC close window
//        progressInput(window);
//        
//        // render
//        glClearColor(0.2, 0.3, 0.4, 1.0f);
//        glClear(GL_COLOR_BUFFER_BIT);
//        
//        glfwSwapBuffers(window);
//        glfwPollEvents();
//    }
//    
//    // last
//    glfwTerminate();
//    
//    return 0;
//}
