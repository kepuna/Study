//
//  LinkedStack.h
//  CDemo
//
//  Created by 郑佳 on 2020/4/15.
//  Copyright © 2020 TriangleDemo. All rights reserved.
//  链式堆栈

/**
 1. 链式堆栈的存储结构
 
 单链表的存储结构用节点构造链. 每个节点除数据域外,还有一个指针域.
 链式堆栈的存储结构和单链表的存储结构 [完全相同].
 
 2. 链式堆栈操作实现
 
 》虽然链式堆栈的插入和删除都是在链表的表头进行的, 但是若把链式堆栈设计成带头节点的结构, 则插入和删除操作不会改变头指针的值(即: head的值), 改变的只是头指针所指头节点的next域的值 (即 head->next 的值), 因此, 可把链式堆栈设计成带头节点的结构. 此时, 头指针参数可设计成节点的指针类型.
 
 若把链式堆栈设计成不带头节点的结构, 则插入和删除操作改变的都是头指针的值, 则插入删除的函数中,头指针参数必须设计成节点的双重指针 (即指针的指针类型),如果不这样设计, 则头指针参数值的改变将无法带回到调用函数中.
 
 因此, 这里最好把链式堆栈设计成 带头节点 的结构
 
 
链式堆栈的所有操作也没有循环, 所有操作时间复杂度也均为O(1)
 
 */

#ifndef LinkedStack_h
#define LinkedStack_h


#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
    DataType data;
    struct Node *next;
}LSNode;

/*
1. 和顺序存储不太一样, 链式存储在初始化操作前, 头指针head没有具体的地址值
2. 在初始化操作时, 头指针head才得到了具体的地址值,而这个地址值要返回给调用函数 (即: 在初始化函数中,需要改变head的值,并且需要将改变后head的值回调给调用函数, 所以这里需要加一个 *, 而head本身是个指针,存让的地址值,本身有一个*, 所以这里写两个 **)
3. 所以此时头指针head要设计成 指针的指针类型, 如果此时指针参数head设计成指针类型, 那么调用函数将无法得到在初始化函数中被赋值的头指针参数head 的值
 */

void StackInit(LSNode **head) {
    *head = (LSNode *)malloc(sizeof(LSNode));
    (*head)->next = NULL;
}

init StackNotEmpty(LSNode *head) {
    if (head->next == NULL) {
        printf("stack is empty");
        return 0;
    } else {
        return 1;
    }
}

void StackPush(LSNode *head, DataType x) {
    LSNode *p;
    p = (LSNode *)malloc(sizeof(LSNode));
    p->data = x;
    p->next = head->next; // 新节点链入栈顶
    head->next = p; // 新节点成为新的栈顶
}

/// ⭕️⭕️⭕️
int StackPop(LSNode *head, DataType *d) {
    LSNode *p = head->next;
    if (p == NULL) {
        printf("no data pop");
        return 0;
    } else {
        // ⚠️注意这是删除原栈顶节点的方式
        head->next = p->next; // 删除原栈顶元素
        *d = p->data; // 将原栈顶节点元素赋予d
        free(p);
        return 1;
    }
}

int StackPeek(LSNode *head,  DataType *d) {
    LSNode *p = head->next;
    if (p == NULL) {
        printf("no data pop");
        return 0;
    } else {
        *d = p->data;
        return 1;
    }
}

// 销毁链式堆栈
void DestoryStack(LSNode **head) {
    LSNode *p, *p1;
    p = *head;
    while (p != NULL) {
        p1 = p;
        p = p->next;
        free(p1);
    }
    *head = NULL;
    
}

#endif /* LinkedStack_h */
