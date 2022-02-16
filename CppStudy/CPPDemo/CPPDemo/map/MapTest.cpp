//
//  MapTest.cpp
//  CPPDemo
//
//  Created by MOMO on 2021/1/27.
//

#include "MapTest.hpp"
#include <map>
#include <string>
#include <iostream>

using  namespace std;

void mapTest(void) {
    cout << "=======Test Map ==========" << endl;
    
    // ✅ 数据插入方式1: 用insert函数插入pair数据
    map<int, string> mapStudent;
    
    mapStudent.insert(pair<int, string>(1, "stu_1"));
    mapStudent.insert(pair<int, string>(2, "stu_2"));
    mapStudent.insert(pair<int, string>(3, "stu_3"));
    mapStudent.insert(pair<int, string>(3, "stu_3")); // ⚠️并不生效
    
    
    // ✅ 数据插入方式2: 用insert函数插入value_type数据
    
    mapStudent.insert(map<int, string>::value_type (4, "stu_4"));
    mapStudent.insert(map<int, string>::value_type (5, "stu_5"));
    mapStudent.insert(map<int, string>::value_type (5, "stu_5")); //⚠️并不生效
    
    //    可以用pair来获得是否插入成功
    pair<map<int, string>::iterator, bool> Insert_Pair;

    Insert_Pair = mapStudent.insert(pair<int, string>(3, "stu_3"));
    
    Insert_Pair =  mapStudent.insert(map<int, string>::value_type (5, "stu_5"));
    
    // ✅ 数据插入方式3: 用数组方式插入数据
    mapStudent[6] = "stu_6";
    mapStudent[7] = "stu_7";

    
    // 遍历map
    map<int, string>::iterator iter;
    
    for (iter = mapStudent.begin(); iter != mapStudent.end(); iter++) {
        
        cout << iter->first << ' ' << iter->second << endl;
    }
    /*
    虽然都可以实现数据的插入，但是它们是有区别的:
-》 第1种和第2种在效果上一样的，用insert函数插入数据，在数据的 插入上涉及到集合的唯一性这个概念， 即当map中有这个关键字时，❤️ insert操作是插入数据不了的
     
-》 但是用数组方式就不同了，它❤️可以覆盖以前该关键字对 应的值，用程序说明
     
     */
    
//    可以用size函数 获取map的大小
    size_t size = mapStudent.size();
    
    cout << "map size = " << size << endl;
    
}


void mapSearch(void) {
    
//    给出三种数据查找方法
    map<int, string> mapStudent;
    mapStudent.insert(pair<int, string>(1, "stu_1"));
    mapStudent.insert(pair<int, string>(2, "stu_2"));
    mapStudent.insert(map<int, string>::value_type (3, "stu_3"));
//    第一种：用count函数来判定关键字是否出现，其缺点是无法定位数据出现位置,由于map的特性，一对一的映射关系，就决定了count函数的返回值只有两个，要么是0，要么是1，出现的情况，当然是返回1了
    
//    第二种：用find函数来定位数据出现位置，它返回的一个迭代器，当数据出现时，它❤️返回数据所在位置的迭代器，如果map中没有要查找的数据，它返回的迭代器 ❤️等于end函数返回的迭代器。
    
    map<int, string>::iterator iter;
    
//    通过map对象的方法获取的iterator数据类型是一个std::pair对象
//    包括两个数据 iterator->first和 iterator->second分别代表关键字和存储的数据。
//     既： first是代表key； second则代表value
    iter = mapStudent.find(2);
    
    // 等于end函数返回的迭代器说明没找到
    if (iter != mapStudent.end()) {
        cout<<"✅ Find, the value is "<< iter->second <<endl;
    } else {
        cout<<"❌ Do not Find"<<endl;
    }
    
    // 删除元素： 移除某个map中某个条目用erase（）
//    iterator erase（iterator it);//通过一个条目对象删除
    
//    iterator erase（iterator first，iterator last）//删除一个范围
    
}
