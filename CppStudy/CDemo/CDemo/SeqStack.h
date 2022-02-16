//
//  SeqStack.h
//  CDemo
//
//  Created by 郑佳 on 2020/4/15.
//  Copyright © 2020 TriangleDemo. All rights reserved.
//  顺序堆栈


/**
堆栈

堆栈和队列都是特殊的线性表, 线性表、堆栈和队列三者的数据元素以及数据元素之间的逻辑关系完全相同.

- 差别是:线性表的插入和删除操作不受限制; 而堆栈只能在栈顶插入和删除; 队列只能在队尾插入, 在队头删除.

- 堆栈和队列都可以分别用顺序存储 和 链式存储
- 堆栈和队列在各种软件应用十分广泛, 堆栈可以用来完成数据元素序列的特定转换; 队列可以用作数据元素序列的缓冲存储.

1. 堆栈的基本概念
堆栈中插入和删除元素都是在栈顶, 所以堆栈也称作后进先出的线性表.

2. 堆栈的操作

- 初始化
- 判断栈是否为空
- 入栈
- 出栈
- 获取栈顶元素

3. 堆栈实现方式

- 顺序存储结构的堆栈称作顺序堆栈
- 链式存储结构的堆栈称作链式堆栈

 4. 顺序堆栈的实现
 
 》 顺序堆栈和顺序表的数据成员是相同的, 不同的是, 顺序堆栈的入栈和出栈只能对 [当前栈顶] 元素进行操作.
 
 - 顺序堆栈操作所有函数中, 都没有循环语句, 所以, 所有操作的时间复杂度都是O(1)

*/

#ifndef SeqStack_h
#define SeqStack_h

#include <stdio.h>
#include <stdlib.h>

#define MaxStackSize 100;

typedef struct {
    DataType stack[MaxStackSize],
    int top; // 指针top实际就是当前数据元素的个数size
} SeqStack;


void SeqStackInit(SeqStack *S) {
    S->top = 0;  // 初始化栈顶下标值
}

int SeqStackNotEmptry(SeqStack *S) {
    if (S->top <=0) {
        return 0;
    } else {
        return 1;
    }
}

// 在堆栈S的当前栈顶top位置插入数据元素x
int SeqStackPush(SeqStack *S, DataType x) {
    if (S->top >= MaxStackSize) {
        printf("stack is full");
        return 0;
    } else {
        S->stack[S->top] = x;
         S->top++;
        return 1;
        
    }
}

// 取出顺序堆栈S 的栈顶元素值 由参数d带回
int SeqStackPop(SeqStack *S, DataType *d) {
    if (S->top <= 0) {
        printf("stack no data");
        return 0;
    } else {
         // ⚠️ 注意需要先进行减操作, 因为当前top指针指的位置是没有值的,top--之后才是栈顶元素值的位置
        S->top--;
        *d = S->stack[S->top];
        return 1;
    }
}

int SeqStackPeek(SeqStack *S, DataType *d) {
    if (S->top <= 0) {
        printf("stack no data");
        return 0;
    } else {
        *d = S->stack[S->top-1]; // 这里只是去栈顶元素
        return 1;
    }
}


#endif /* SeqStack_h */
