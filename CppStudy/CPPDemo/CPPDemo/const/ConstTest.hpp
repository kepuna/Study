//
//  ConstTest.hpp
//  CPPDemo
//
//  Created by MOMO on 2021/2/8.
//

#ifndef ConstTest_hpp
#define ConstTest_hpp

#include <stdio.h>
#include <iostream>

using namespace std;

/***
 1. const 修饰 成员变量
 -  const 修饰成员变量 必须初始化
 - static只是说明只占一份内存
 - const说明不可以修改
 
 2. const 修饰成员函数
  
 - const 关键字需要写在参数列表后面， 函数的声明和实现都必须带const
 - const修饰的成员函数内部不能修改非static成员变量
 - 内部只能调用const成员函数、static成员函数
 - ⚠️ const 修饰的成员函数，内部不能修改外部变量
 
 3. const修饰形参
 - 一般是结合常量引用，来防止误操作
 - 在函数形参列表中，可以加const修饰形参，防止形参改变实参
 
 */

class Car {
    
public:
    const int m_price = 0; // 方式一、声明同时初始化
    const int m_width; // 方式2 在构造函数里初始化
    // static 和 const修饰同一个变量 ,需要在声明同时初始化
    static const int m_height = 100;
    
    
    const string brand = "BMW";
    
    Car():m_width(120) {
        
    }
    
    // const修饰成员函数
    void eat() const; // 声明
    
    void run(string &km, const string &brand) {
//        brand = "XXXX"; 不可修改
        km = "1000"; // 可修改
        cout << "run()" << endl;
    }
    
};

// const修饰成员函数
// 声明和实现分离的情况，实现必须写在类外面
// - ⚠️ const 修饰的成员函数，内部不能修改外部变

int age = 10;
void Car::eat() const {
    cout << "eat()" << endl;
//    age = 20;  ❌
}



#endif /* ConstTest_hpp */
