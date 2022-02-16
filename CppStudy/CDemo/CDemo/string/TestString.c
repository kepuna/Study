//
//  TestString.c
//  CDemo
//
//  Created by MOMO on 2020/9/18.
//  Copyright © 2020 TriangleDemo. All rights reserved.
//

#include "TestString.h"
#include <string.h>


// 1. 指针和字符串
void demo1() {
    // 字符数组
    char ch[] = "Hello world"; // 栈区字符串
    char *p = ch;

    char *p1 = "JiaJung"; // 数据区常量区字符串
    
    printf("%s \n",p);
    printf("%c\n", *(p+1));
    
    // 字符串数组
    char *arr[] = {"hello", "Jack", "Bobbom"};
    for (int i=0; i<3; i++) {
        printf("数组内容 %s \n",arr[i]);
    }
    
}


int my_strlen(char *ch) {
    
    // 计算字符串有效长度
    int i = 0;
    while (ch[i] != '\0') {
        i++;
    }
    return i;
}

// const 修饰不能改变字符串内容
//int my_strlen2(const char* ch) {
int my_strlen2(char* ch) {

//int my_strlen2(char *ch) {
    char *temp = ch;
    while (*temp) {
        temp++;
    }
    return (int)(temp - ch);
}

// 字符指针作为函数参数
void demo2() {
   
    char ch[] = "Hello world!"; // 栈区字符串
    int len = my_strlen2(ch);
    
    printf("str len = %d\n",len);
}

// 字符串操作函数
void demo3() {
    char ch[] = "Hello world!";
    
    char str[100]; // ⚠️这里大小一定要足够大，大于ch的大小
    // 第一个参数，目的字符串
    // 第二个参数： 被拷贝的字符串
//    strcpy(str, ch);
//    printf("str = %s\n",str);
    
    
    // 字符串有限拷贝
    strncpy(str, ch, 8);
    printf("有限拷贝str = %s\n",str); // str = Hello wo
}


// 字符串 追加
void demo4() {
   
    char dest[100] = "Hello";
    char src[] = "JiaJung";
    
//    strcat(dest, src);
//
//    printf("str = %s\n",dest); // 字符串追加，
    
    // 有限追加
    /*
     第一个参数： 追加到的字符串
     第二参数： 追加的内容字符串
     第三参数： 内容字符串的个数
     */
    strncat(dest, src, 3);
    printf("str = %s\n",dest); // str = HelloJia
    
    
    // 字符串比较  相等返回0
    int res = strcmp(dest, src);
    printf("比较结果= %d\n",res);
    
}

void stringDemo() {
    demo4();
}
