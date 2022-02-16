//
//  TemplateTest.hpp
//  CPPDemo
//
//  Created by MOMO on 2021/1/27.
//   详细文章： https://www.jianshu.com/p/70ca94872418
// C++ 模版 https://www.runoob.com/cplusplus/cpp-templates.html

/***
 C++中有一个重要特性，那就是模板类型。类似于Objective-C中的泛型。C++通过类模板来实现泛型支持。
 

 
 ### 类模板
 通常使用template来声明， 正如我们定义函数模板一样，我们也可以定义类模板。泛型类声明的一般形式如下所示：
 
 template <class type> class class-name {
 .
 .
 .
 }
 
 在这里，type 是占位符类型名称，可以在类被实例化的时候进行指定。您可以使用一个逗号分隔的列表来定义多个泛型数据类型。
 
 */

#ifndef TemplateTest_hpp
#define TemplateTest_hpp

#include <stdio.h>
#include <vector>
#include <cstdlib>
#include <string>
#include <stdexcept>
#include <iostream>
using namespace std;

//namespace ZJ {

//template <typename T>
//
//class StackTest{
//public:
//    void push(T);
//
//};
//
//}

/// ⚠️ 很多c++编译器并不支持模板的分离编译，你可以把模板声明和模板实现

/// 类模版


template <typename T> class TemplateTest {
private:
    std::vector<T> elements; // 元素

public:
    template <class T2> void push(T2 const& e){
        //lements.push_back(e);
        cout<< "栈 :=" << e << endl;
    }; // 入栈
    void pop(); // 出栈
    T top() const;  // 返回栈顶元素
    bool empty() const {
        return elements.empty();
    }

};


#endif /* TemplateTest_hpp */
