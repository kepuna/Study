//
//  MapTest.hpp
//  CPPDemo
//
//  Created by MOMO on 2021/1/27.
//

/*
 
 Map是STL的一个关联容器
 这里说下map内部数据的组织，map内部自建一颗红黑树(一 种非严格意义上的平衡二叉树)，这颗树具有对数据自动排序的功能，所以在map内部所有的数据都是有序的
 
 map是一类关联式容器。它的特点是增加和删除节点对迭代器的影响很小，除了那个操作节点，对其他的节点都没有什么影响。
 
 ### map的功能
 
 自动建立Key － value的对应。key 和 value可以是任意你需要的类型。
 
 根据key值快速查找记录，查找的复杂度基本是Log(N)，如果有1000个记录，最多查找10次，1,000,000个记录，最多查找20次。

 快速插入Key -Value 记录。

 快速删除记录

 根据Key 修改value记录。

 遍历所有记录。
 
 map共提供了6个构造函数
 
 map的基本操作函数：

     C++ maps是一种关联式容器，包含“关键字/值”对

     begin()         返回指向map头部的迭代器

     clear(）        删除所有元素

     count()         返回指定元素出现的次数

     empty()         如果map为空则返回true

     end()           返回指向map末尾的迭代器

     equal_range()   返回特殊条目的迭代器对

     erase()         删除一个元素

     find()          查找一个元素

     get_allocator() 返回map的配置器

     insert()        插入元素

     key_comp()      返回比较元素key的函数

     lower_bound()   返回键值>=给定元素的第一个位置

     max_size()      返回可以容纳的最大元素个数

     rbegin()        返回一个指向map尾部的逆向迭代器

     rend()          返回一个指向map头部的逆向迭代器

     size()          返回map中元素的个数

     swap()           交换两个map

     upper_bound()    返回键值>给定元素的第一个位置

     value_comp()     返回比较元素value的函数
 
 */

#ifndef MapTest_hpp
#define MapTest_hpp

// ✅ 更多用法： https://www.cnblogs.com/fnlingnzb-learner/p/5833051.html
#include <stdio.h>

/// 添加数据测试
void mapTest(void);

/// 查找
void mapSearch(void);

#endif /* MapTest_hpp */
