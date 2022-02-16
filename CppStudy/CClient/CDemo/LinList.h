//
//  LinList.h
//  CDemo
//
//  Created by 郑佳 on 2020/4/14.
//  Copyright © 2020 TriangleDemo. All rights reserved.
//

/*
 单链表有带头节点和不带头节点 两种结构,
 指向单链表的指针称为头指针
 
 在链式存储结构中, 任意两个在逻辑上相邻的数据元素在物理上不一定相邻, 数据元素的逻辑次序是通过链中的指针链接来实现的.
 
 ### 带头节点的链表:
 #### 插入新节点
设置头头指针为head, 则在第一个有效节点前插入新节点是,不会改变头指针head的值, 改变的是头指针所指的 ”头节点的指针域的值“, 即改变的是head->next 的值.
 当临时指针变量p等于head时, 改变的是指针p-》next的值.
 这与在其他数据节点前插入新节点的过程是一样的.
 
 #### 删除节点
 若选用的是带头节点的单链表, 则删除第一个有效节点时, 不会改变头指针head的值, 改变的是头指针所指节点的指针域的值. 即改变的是head-》next的值.
  当临时指针变量p等于head时, 改变的是指针p-》next的值.
 这与删除其他位置节点的过程一样.
 
 
 
 */

#ifndef LinList_h
#define LinList_h

#include <stdio.h>
#include <stdlib.h>

#define MaxSize 100
typedef int LinkedDataType;

// 单链表的存储结构
typedef struct Node {
    LinkedDataType data; // 数据域
    struct Node *next; // 指针域
} SLNode;

/*
1. 和顺序存储不太一样, 链式存储在初始化操作前, 头指针head没有具体的地址值
2. 在初始化操作时, 头指针head才得到了具体的地址值,而这个地址值要返回给调用函数 (即: 在初始化函数中,需要改变head的值,并且需要将改变后head的值回调给调用函数, 所以这里需要加一个 *, 而head本身是个指针,存让的地址值,本身有一个*, 所以这里写两个 **)
3. 所以此时头指针head要设计成 指针的指针类型, 如果此时指针参数head设计成指针类型, 那么调用函数将无法得到在初始化函数中被赋值的头指针参数head 的值
 */
void ListInitate (SLNode **head) {
    *head = (SLNode *)malloc(sizeof(SLNode));
    (*head)->next = NULL;
}

/*
 1. 在循环前,指针变量p指针头节点, 计数size等于0
 2. 循环结束条件为p-》next != NULL, 循环中, 每次让指针p指向它的直接后继节点, 让计数size加1
 3. 返回最终的size
   配图:
 */
int ListLength(SLNode *head) {
    SLNode *p = head;
    int size = 0;
    while (p->next != NULL) {
        p = p->next;
        size++;
    }
    return size;
}

/*
 前插法
 在带头节点的单链表head 的第i个节点前, 插入一个存放数据元素x的节点
 - 首先,要在单链表中寻找到i-1个节点并由指针p所指, 然后动态申请一个节点存储空间并由指针q指向, 把数据x赋给新节点q, 修改新节点的next指针 (即 q->next = p->next) ,然后p->next = q 指向新节点
 */
int ListInsert(SLNode *head, int i, LinkedDataType x) {
    SLNode *p, *q;
    int j;
    p = head;
    j = -1;
    while (p->next != NULL && j<i-1) {
        // 最终让指针p指向第i-1个节点
        p = p->next;
        j++;
    }
    if (j != i-1) {
        printf("插入位置参数错误");
        return 0;
    }
    
    q = (SLNode *)malloc(sizeof(SLNode));
    q->data = x;
    q->next = p->next;
    p->next = q;
    return 1;
}

/*
 删除带头节点单链表head的第i个节点, 被删除的节点数据域的值由x带回
 */
int ListDelete(SLNode *head, int i, LinkedDataType *x) {
    SLNode *p, *s;
    int j;
    
    p = head;
    j = -1;
    
    while(p->next != NULL && p->next->next != NULL && j < i -1) {
        p = p->next;
        j++;
    }
    if (j != i-1) {
        printf("删除位置参数错误\n");
        return 0;
    }
    s = p->next;
    *x = s->data;
    p->next = p->next->next; // 删除
    free(s); // 释放指针s所指节点的内存空间
    return 1;
}

/*
 取数据元素和删除基本雷同,主要差别是, 取数据元素函数的循环条件改为 j < i, 并且不能删除ai节点
 */
int ListGet(SLNode *head, int i, LinkedDataType *x) {
    SLNode *p;
    int j;
    p = head;
    j = -1;
    while (p->next != NULL && j < i) {
        p = p->next;
        j++;
    }
    if (j != i) {
        printf("i is error");
        return 0;
    }
    *x = p->data;
    return 1;
}

/*
 因为单链表的节点空间是在运行时malloc动态申请的, 而系统只负责自动回收静态分配的内存, 所以, 单链表需要增加一个销毁单链表的操作, 用来在程序退出前释放动态申请的内存空间
 */
void Destory(SLNode **head) {
    SLNode *p, *p1;
    p = *head;
    while (p != NULL) {
        p1 = p;
        p = p->next;
        free(p1); // 循环释放空间
    }
    *head = NULL;
}

#endif /* LinList_h */
