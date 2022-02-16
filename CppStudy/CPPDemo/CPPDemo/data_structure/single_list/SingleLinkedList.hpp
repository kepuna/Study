//
//  SingleLinkedList.hpp
//  CPPDemo
//
//  Created by MOMO on 2021/12/31.
//  带虚拟头节点的单链表

#ifndef SingleLinkedList_hpp
#define SingleLinkedList_hpp

#include <iostream>
using namespace std;
#define ELEMENT_NOT_FOUND  -1

template <class T>
class SingleLinkedList;

template <class T>
class SNode {
    // SingleLinkedList<T> 是SNode<T>的一个友类，所以 SingleLinkedList<T> 可以访问SNode<T>的所有成员（尤其是私有成员）
    friend SingleLinkedList<T>;
public:
    SNode(T data, SNode<T> *next):m_data(data), m_next(next) {
        
    }
private:
    T m_data;
    SNode<T> *m_next;
};


template <class T>
class SingleLinkedList {
public:
    SingleLinkedList() {
        // 初始化一个虚拟头结点
        m_first = new SNode<T>(0, nullptr);
    }
    ~SingleLinkedList() {
        // 析构函数，用于删除链表中的所有节点(包括虚拟头节点)
        SNode<T> *node;
        while (m_first != nullptr) {
            node = m_first->m_next;
            delete m_first;
            m_first = node;
        }
    }
    
    // 在index位置插入元素
    SingleLinkedList<T>& add(const int index, const T& data) {
        rangeCheckForAdd(index);
        SNode<T> *prev = nullptr;
        if (index == 0) {
            prev = m_first;
        } else {
            prev = node(index - 1);
        }
        prev->m_next = new SNode<T>(data, prev->m_next);
        m_size++;
        return *this;
    }
    
    SingleLinkedList<T>& add(const T& data) {
        add(m_size, data);
        return *this;
    }
    
    // 删除index位置的元素，并将元素放入data返回
    SingleLinkedList<T>& remove(const int index, T&data) {
        rangeCheck(index);
        SNode<T> *prev = nullptr;
        if (index == 0) {
            prev = m_first;
        } else {
            prev = node(index - 1);
        }
    
        // SNode<T> *node = node(index - 1); 下面的写法更好
        SNode<T> *node = prev->m_next;
        prev->m_next = node->m_next;
        data = node->m_data;
        delete node;
        m_size--;
        return *this;
    }
    
    // 删除链表中的所有节点（不包括虚拟头节点）
    void clear() {
        SNode<T> *node;
        while(m_first->m_next != nullptr) {
            node = m_first->m_next;
            delete m_first;
            m_first = node;
        }
        m_size = 0;
    }
    
    // 获取index位置的元素
    // 因为要给data赋值所以这里不能写成 const T& data
    void get(int index, T& data) const {
        SNode<T> *temp = node(index);
        if (temp) {
            data = temp->m_data;
        }
    }
    
    // 更新index位置的元素
    void set(int index, const T& data) const {
        SNode<T> *temp = node(index);
        if (temp) {
            temp->m_data = data;
        }
    }
    
    // 查找元素的索引
    int indexOf(const T& data) {
        SNode<T> *current = m_first->m_next;
        int index = 0;
        while (current && current->m_data != data) {
            current = current->m_next;
            index++;
        }
        if (current) {
            return index;
        }
        return ELEMENT_NOT_FOUND;
    }
    
    bool isEmpty() const {
        return m_size == 0;
    }
    
    int size() const {
        return m_size;
    }
    
    SNode<T>* node(const int index) const {
        rangeCheck(index);
        // m_first->m_next 因为第一个是无效的虚拟头节点
        SNode<T> *node = m_first->m_next;
        for (int i = 0; i < index; i++) {
            node = node->m_next;
        }
        return node;
    }
    
    void output(ostream& out) const {
        SNode<T> *node = m_first->m_next;
        while (node) {
            out << node->m_data << ", ";
            node = node->m_next;
        }
    }
    
private:
    SNode<T> *m_first; // 指向第一个节点的指针
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
ostream& operator<<(ostream& out, const SingleLinkedList<T>& list) {
    list.output(out);
    return out;
}


#endif /* SingleLinkedList_hpp */
