//
//  PSeqQueue.h
//  CDemo
//
//  Created by 郑佳 on 2020/4/17.
//  Copyright © 2020 TriangleDemo. All rights reserved.
//  顺序优先级队列

/*
 优先级队列:
 队列是数据元素的先进先出表,即最先进入队列的元素将最先被删除.
 但是有些软件系统中,有时也需要把进入队列中的元素分优先级, 出队列时首先选择优先级最高的元素出队列, 对于优先级相同的元素则按先进先出的原则出队列.
 
 * 优先级队列和普通队列的区别: 优先级队列的出队操作不是把队头元素出队列, 而是把队列中优先级最高的数据元素出队列.
 
 优先级队列的存储结构:
 - 顺序优先级队列
 - 链式优先级队列
 
 优先级队列数据元素:
 有两部分组成, 一部分是元素的优先级, 一部分是数据元素的其他内容.
 
 顺序优先级队列出队列的方法是: 首先在遍历队列数据元素的基础上找出优先级最高的数据元素, 然后依次把从原队列中第二个元素到队尾的所有元素前移一个位置, 最后把队列的数据元素个数减1. 由于顺序优先级队列每次出队列操作后, 有一个前移数据元素过程, 这样,数据元素都集中在顺序队列的前边部分, 因为,顺序优先级队列不存在像顺序队列那样的 “假溢出” 问题
 
 */

#ifndef PSeqQueue_h
#define PSeqQueue_h

#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int priority; // 优先级 (数值越小优先级越高)
    ElemType elem; // 其他内容 (用户可以根据实际情况定义elem数据类型)
} DataType;

typedef struct {
    DataType queue[MaxQueueSize];
    int size;
} PSeqQueue;

void QueueInit(PSeqQueue *Q) {
    Q->size = 0;
}

int QueueNotEmpty(PSeqQueue *Q) {
    if (Q->size > 0) {
        return 1;
    } else {
        return 0;
    }
}

/*
 入队列
 */

int QueueAppend(PSeqQueue *Q, DataType x) {
    if (Q->size >= MaxQueueSize) {
        printf(" Queue is full");
        return 0;
    } else {
        Q->queue[Q->size] = x;
        Q->size++;
        return 1;
    }
}

/*
 删除优先级队列Q中 优先级最高的元素并赋值给d,
 */
int QueueDelete(PSeqQueue *Q, DataType *d) {
    DataType min;
    int minIndex, i;
    if (Q->size <= 0) {
        printf("queue is empty , no data to delete");
        return 0;
    } else { // 找到优先级最高的
        
        min = Q->queue[0]; // 初始选queue[0] 为优先级最高的元素
        minIndex = 0; // 优先级最高元素的下表
        for (i=0; i<Q->size; i++) { // 寻找优先级最该元素
            if (Q->queue[i].priority < min.priority) {
                min = Q->queue[i];
                minIndex = i;
            }
        }
        *d = Q->queue[minIndex];
        // 数据元素依次前移
        for (i=minIndex+1; i<Q->size; i++) {
            Q->queue[i-1] = Q->queue
            [i];
        }
        Q->size--;
        return 1;
        
    }
}

/*
 取出队列中优先级最高的元素 赋值给d
 */
int QueueGet(PSeqQueue *Q, DataType *x) {
    DataType min;
    int minIndex, i;
    
    if (Q->size <= 0) {
        printf("no data");
        return 0;
    } else {
        min = Q->queue[0];
        minIndex = 0;
        for (i=0; i<Q->size; i++) {
            if (Q->queue[Q->size].priority < min.priority) {
                min = Q->queue[i];
                minIndex = i;
            }
        }
        *x = Q->queue[minIndex];
        return 1;
    }
}


#endif /* PSeqQueue_h */
