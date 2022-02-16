//
//  main.cpp
//  CPPDemo
//
//  Created by MOMO on 2021/1/27.
//

#include <iostream>
#include "TemplateTest.hpp"
#include "SpeechManager.hpp"
#include "Reporter.hpp"
#include "MapTest.hpp"
#include "Chain.hpp"
#include "ArrayList.hpp"
#include "SingleLinkedList.hpp"
#include "LinkedList.hpp"
#include "BinaryTree.hpp"

using namespace::std;
//using namespace::future;

void testSppech() {
    
    SpeechManager sm;
    
    // 打印在构造函数创建的12个选手信息
    map<int, Speaker>::iterator iter;
    for (iter = sm.m_Speackers.begin(); iter != sm.m_Speackers.end(); iter++) {
//        cout << "选手编号" << iter->first << "姓名：" << iter->second.m_Name << "分数: " << iter->second.m_Score[0] << endl;
    }
    
    sm.showMenu();
    
    int choice = 0;
    
    while (true) {
        
        cout << "请输入您的选择：" << endl;
        cin >> choice;
        switch (choice) {
            case 1: // 开始比赛
                sm.startSpeech();
                break;
            case 2:  // 查看往届比赛
                break;
            case 3:  // 清空比赛记录
                break;
            case 0: // 退出系统
                sm.exitSystem();
                break;
                
            default:
                system("cls"); // 清屏
                break;
        }
    }
}

void testTemplate() {
    
    try {
        
        TemplateTest<int> intStack;
        // 操作int类型的栈
        intStack.push("sss");
        intStack.push(4);
        
//        cout << intStack.top() << endl;
//        
//        TemplateTest<string> stringStack;
//        // 操作string类型的栈
//        stringStack.push("string");
//        cout << stringStack.top() << endl;
//        
//        stringStack.pop();
//        stringStack.pop();
        
        
    } catch (exception const &ex) {
        cerr << "Exception: " << ex.what() <<endl;
        return;
    }
    
}

void testReport() {
    future::Reporter *report = new future::Reporter("1111", "src/test/","test", [](int i){
        cout << i << endl;
    });
    
}

// 测试指针和地址
void testPointer() {
    
    int x = 5; // 定义int类型变量 x
    int *px = &x; // 定义指针px，该指针指向的是int类型的变量，px中存放的是变量x的地址
    
    printf("%d\n",x); // x的内容
    printf("%p\n",&x); // x的地址
    printf("%p\n",px); // px的内容
    printf("%p\n",&px); // px的地址
    
    *px = 10;
    printf("%d\n",x); // 10
    
    int **pxx = &px;
    printf("%p\n",pxx); // pxx的内容 （pxx中存的是指针px的地址）
    printf("%p\n",&pxx); // pxx指针的地址
    
    **pxx = 20;
    printf("%d\n",x); // 20
    
    
    int arr[] = {1,2,3,4,5};
    int* p = arr;
    p += 1; // 后移一个元素
    printf("后移一个元素：%d \n", *p);

    p -= 1; // 前移一个元素
    printf("前移一个元素：%d \n", *p);

    // 修改数组元素
    arr[3] = 10;
    *(arr+3) = 10;
    
    for(int i=0; i<5; i++)
    {
        printf("第%d个元素：%d \n",i, arr[i]);
    }

    
    for(int* p= arr; p<arr+5; p++) //
    {
        printf("元素：%d \n", *p);
    }
}


/**
 函数作为函数的参数
 */

// 定义了一个函数指针类型
typedef int (*FuncPointer) (int, int);

int mineFunc(int a, int b, FuncPointer func) {
    return func(a, b);
}

int add(int a, int b) {
    return a + b;
}

int sub(int a, int b) {
    return a - b;
}

/**
 也可以这样写
 */

// 定义了FuncType这种函数数据类型
typedef int FuncType(int, int);

int mineFunc2(int a, int b, FuncType func) {
    return func(a, b);
}

void testArray (){

    ArrayList<int> array;
    array.add(11).add(22).add(33).add(55);
    array.add(2, 44);
    array.set(3, 66);
    int e = 0;
    array.remove(1, e);
    cout << "array size is " << array.size() << endl;
    cout << "delete element is " << e << endl;
    
    cout << "List is： " << array << endl;
    
    array.clear();
    cout << "after clear() array size is " << array.size() << endl;
}

void testLinearList (){
    
    SingleLinkedList<int> list;
    list.add(10).add(12).add(15).add(18).add(22);
    cout << "Create List is： " << list << endl;
    
    int element;
    list.remove(3, element);
    cout << "Delete elment is： " << element << endl;
    cout << "after delete size=" << list.size() << endl;
    
    list.get(2, element);
    cout << "Get index 2 value is： " << element << endl;
    list.set(3, 333);
    cout << "List is： " << list << endl;
    list.clear();
    cout << "after clear() size=" << list.size() << endl;
    cout << "after clear() List is： " << list << endl;


//    int *element;
//    ChainIterator<int> c;
//    element = c.Initialize(list);
//    while (element) {
//        cout<< *element <<' ' << endl;
//        element = c.Next();
//    }
//    int index = list.indexOf(15);
//
//    int setData = 888;
//    list.set(3, setData);
//
//    int updateIndex = 3;
//    int getData;
//    list.get(updateIndex, getData);
//    cout << "update index " << updateIndex << "data:" << getData << endl;
//
//    list.clear();
//    cout << "after clear() size = " << list.size() << endl;
}

int testLinkedList() {
    
    LinkedList<int> list;
    list.add(10).add(12).add(15).add(18).add(22);
   
    
    int element;
    list.remove(3, element);
    cout << "Delete elment is： " << element << endl;
    cout << "after delete size=" << list.size() << endl;
    list.clear();
    cout << "Create List is： " << list << endl;
    
    return 0;
}


int main(int argc, const char * argv[]) {
    // insert code here...
    
//    mapTest();
//    mapSearch();
//    testSppech();
//    testTemplate();
//    testReport();
    
//    testPointer();
    
    testLinkedList();
//    testLinearList();
    return 0;
}





