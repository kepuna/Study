//
//  LinkedList.hpp
//  CPPDemo
//
//  Created by MOMO on 2022/1/11.
//

#ifndef LinkedList_hpp
#define LinkedList_hpp

#include <iostream>
using namespace std;
#define ELEMENT_NOT_FOUND  -1

template <class T>
class LinkedList;

template <class T>
class LNode {
    friend LinkedList<T>;
public:
private:
    T m_data;
    LNode<T> *m_prev;
    LNode<T> *m_next;
    
    LNode(LNode<T> *prev, LNode<T> *next, T data): m_prev(prev), m_next(next), m_data(data) {}
};


template <class T>
class LinkedList {
public:
    LinkedList() {
        m_first = nullptr;
        m_last = nullptr;
        m_size = 0;
    }
    ~LinkedList() {
        // 析构函数，用于删除链表中的所有节点
        LNode<T> *node;
        while (m_first != nullptr) {
            node = m_first->m_next;
            delete m_first;
            m_first = node;
        }
    }
    
    // 在index位置插入元素
    LinkedList<T>& add(const int index, const T& data) {
        rangeCheckForAdd(index);
        
        if(index == m_size) { // 包含 index = 0，size == 0的情况
            LNode<T> *oldLast = m_last;
            m_last = new LNode<T>(oldLast, nullptr, data);
            if (oldLast == nullptr) { // 这是链表添加的第一个元素
                m_first = m_last;
            } else {
                oldLast->m_next = m_last;
            }
        } else { // 正常添加元素
            LNode<T> *next = node(index);
            LNode<T> *prev = next->m_prev;
            LNode<T> *node = new LNode<T>(prev,next,data);
            next->m_prev = node;
            if (prev == nullptr) { // index == 0, size 不等于0的情况
                m_first = node;
            } else {
                prev->m_next = node;
            }
        }
        m_size++;
        return *this;
    }
    
    // 在链表尾部添加元素
    LinkedList<T>& add(const T& data) {
        add(m_size, data);
        return *this;
    }
    
    // 获取index位置的节点
    LNode<T> *node(const int index) const {
        rangeCheck(index);
        if (index < (m_size >> 1)) {  // 索引小于一半从前往后找
            LNode<T> *node = m_first;
            for (int i = 0; i < index; i++) {
                node = node->m_next;
            }
            return node;
        } else { // 索引小于一半从前往后找
            LNode<T> *node = m_last;
            for (int i = m_size - 1; i > index; i--) {
                node = node->m_prev;
            }
            return node;
        }
    }
    
    // 删除index位置的元素，并将元素放入data返回
    LinkedList<T>& remove(const int index, T& data) {
        rangeCheck(index);
        LNode<T> *n = node(index);
        LNode<T> *prev = n->m_prev;
        LNode<T> *next = n->m_next;
        if (prev == nullptr) { // delete element index == 0
            m_first = next;
        } else {
            prev->m_next = next;
        }
        
        if (next == nullptr) { // index == size - 1
            m_last = prev;
        } else {
            next->m_prev = prev;
        }
        data = n->m_data;
        delete n;
        m_size--;
        return *this;
    }
    
    void clear(){
        LNode<T> *node;
        while (m_first != nullptr) {
            node = m_first->m_next;
            delete m_first;
            m_first = node;
        }
        m_size = 0;
    }
    
    int size() const {
        return m_size;
    }
    
    void output(ostream& out) const {
        LNode<T> *node = m_first;
        while (node) {
            LNode<T> *prev = node->m_prev;
            LNode<T> *next = node->m_next;
            if (prev != nullptr) {
                out << prev->m_data << ", ";
            } else {
                out << "nullptr ,";
            }
            out << node->m_data << ", ";
            if (next != nullptr) {
                out << next->m_data << endl;
            } else {
                out << "nullptr ,";
            }
            node = node->m_next;
        }
    }
    
private:
    LNode<T> *m_first;
    LNode<T> *m_last;
    int m_size;
    
    void outOfBounds(int index) const {
        throw index;
    }
    
    void rangeCheck(int index) const {
        if (index < 0 || index >= m_size) {
            outOfBounds(index);
        }
    }
    
    void rangeCheckForAdd(int index) const {
        if (index < 0 || index > m_size) {
            outOfBounds(index);
        }
    }
};

// 重载 <<
template <class T>
ostream& operator<<(ostream& out, const LinkedList<T>& list) {
    list.output(out);
    return out;
}

#endif /* LinkedList_hpp */
