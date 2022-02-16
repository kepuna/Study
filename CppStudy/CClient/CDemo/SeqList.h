//
//  SeqList.h
//  CDemo
//
//  Created by 郑佳 on 2020/4/14.
//  Copyright © 2020 TriangleDemo. All rights reserved.
//

/*
 顺序表
 实现顺序表存储结构的方法是使用数组. 数组有静态数组和动态数组, 静态数组存储空间的申请和释放由系统自动完成. 动态数组存储空间的申请和释放由程序员通过调用系统函数自己完成. 不论动态数组、还是静态数组,其功能都是向系统申请一块地址连续的有限空间、只是申请的方法不同.
 
 顺序表操纵实现
 * 初始化时元素个数size初始化为0, 当有1个元素是size就是1
 * 数据元素个数size比数组下标i的值大1, 所以插入位置参数i:  0 <= i <= size, 并且数组的存储空间是有限的,若当前数组已经存满Maxsize个时,则不能继续插入
 * 插入元素时需要从后往前依次移动数据,为插入做准备: for(int j=L->size; j>i; j--) { L->[j] = L[j-1]}
 * 删除数据:
 ....
 
 顺序表操作效率分析:
 > 顺序表上的插入和删除时顺序表中时间复杂度最高的操作.
 
 * 在顺序表中插入一个数据元素时,算法中时间复杂度最高的操作是循环移动数据元素. 循环移动数据元素的效率与插入位置i有关, 最坏的情况i=0, 需要移动size个元素,
 最好的情况i=size,移动0个元素
 
 * 在顺序表中插入和删除一个数据元素的平均时间复杂度均为 O(n), 其余操作和元素个数n无关,时间复杂度是O(1)
 
 顺序表主要优点: 算法简单, 内存单元利用率高,
 主要缺点: 需要预先确定数据元素个数
    
 
 */

#ifndef SeqList_h
#define SeqList_h

#include <stdio.h>
#include <stdlib.h>


typedef struct {
    DataType list[MaxSize];
    int size;
} SeqList;

// ******* 顺序表操纵实现 ********

// 初始化 (最终是往数组里放数据)
// 由于函数中要改变参数L的size域的值, 所以参数L应该设计为输出型参数 (即参数L设计为SeqList的指针类型), 否则,size域值的修改不能带回去
void ListInitiate(SeqList *L) {
    L->size = 0; // 定义初始数组元素个数
}

int  ListLenght(SeqList L) {
    return L.size;
}

// 在顺序表第i个位置前插入数据元素值x, 插入成功返回1, 失败返回0
// (0 <= i <= size)
int ListInsert(SeqList *L, int i, DataType x) {
    // 找到第i个位置
    int j;
    if (L->size >= MaxSize) {
        printf(" 顺序表已满无法插入");
        return 0;
    } else if (i< 0 || i > L->size) {
        printf("参数i不合法");
        return 0;
    } else {
        // 依次向后移数据,为插入做准备
        for (int j = L->size; j>i; j--) {
            L->list[j] = L->list[j-1];
        }
        L->list[i] = x;
        L->size++;
        return 1;
    }
}

// 删除顺序表L中位置i上的元素, 并保存到x中
// 0 <= i <= size
int ListDelete(SeqList *L, int i, DataType *x) {
    if (L->size <= 0) {
        printf("no data delete");
        return 0;
    } else if (i <0 || i > L->size-1) {
        printf("i is error");
        return 0;
    } else {
        *x = L->list[i];
        // 从前向后 依次前移 从存储位置i到存储位置size-1中的元素
        //
        for (int j=i ; j < L->size; j++) {
            L->list[j] = L->list[j+1];
        }
        L->size--;
        return 1;
    }
}

// 取顺序表L中第i个数据元素,存到x中,成功1 ,失败0
int ListGet(SeqList *L, int i, DataType *x) {
    if (i <0 || i > L->size) {
        printf("i is error");
        return 0;
    } else {
        *x = L->list[i];
        return 1;
    }
}


#endif /* SeqList_h */
