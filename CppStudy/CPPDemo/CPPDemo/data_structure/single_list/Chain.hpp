//
//  Chain.hpp
//  CPPDemo
//
//  Created by MOMO on 2021/12/28.
//

#ifndef Chain_hpp
#define Chain_hpp
#include <iostream>
using namespace std;
#define ELEMENT_NOT_FOUND  -1

template <class T>
class Chain;

template <class T>
class ChainNode;

// 链表遍历器类
template <class T>
class ChainIterator {
    
public:
    T* Initialize(const Chain<T>& c) {
        // 因为第一个是虚拟头节点
        location = c.m_first->m_next;
        if (location) {
            // 引用转指针 location->data 返回的是引用类型对象，通过&取地址获得指针
            // return &location->data; 两种写法是一样的
            return &(location->m_data);
        }
        return 0;
    }
    T* Next() {
        if (!location) {
            return 0;
        }
        location = location->m_next;
        if(location) {
            return &(location->m_data);
        }
        return 0;
    }
private:
    ChainNode<T> *location;
};


template <class T>
class ChainNode {
    friend Chain<T>;
    friend ChainIterator<T>;
private:
    T m_data;
    ChainNode<T> *m_next;
public:
    ChainNode(T data, ChainNode<T> *next):m_data(data), m_next(next) {
        
    }
};

template <class T>
class Chain {
    friend ChainIterator<T>;
public:
    Chain(){
        // 初始化一个虚拟头结点
        m_first = new ChainNode<T>(NULL, nullptr);
    }
    
    ~Chain() {
        // 析构函数，用于删除链表中的所有节点
        ChainNode<T> *node;
        while (m_first != nullptr) {
            node = m_first->m_next;
            delete m_first;
            m_first = node;
        }
    }
    
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
    };
    
    bool isEmpty() const {
        return m_size == 0;
    }
    int size() const {
        return m_size;
    }
    // 删除链表中的所有节点
    void clear() {
        ChainNode<T> *node;
        while(m_first != nullptr) {
            node = m_first->m_next;
            delete m_first;
            m_first = node;
        }
        m_size = 0;
    }
 
    // 删除链表中的index位置的节点
    Chain<T>& remove(int index, ChainNode<T>& n) {
        rangeCheck(index);
        ChainNode<T> *prev = nullptr;
        if (index == 0) {
            prev = m_first;
        } else {
            prev = node(index - 1);
        }
        // ChainNode<T> *node = node(index - 1);
        ChainNode<T> *node = prev->m_next;
        prev->m_next = node->m_next;
        n = *node;
        delete node;
        m_size--;
        return *this;
    }

    // 根据索引找到节点对象
    ChainNode<T>* node(int index) const{
        rangeCheck(index);
        // m_first->m_next 因为第一个是无效的虚拟头节点
        ChainNode<T> *node = m_first->m_next;
        for (int i = 0; i < index; i++) {
            node = node->m_next;
        }
        return node;
    }

    // 在链表的尾部添加元素
    Chain<T>& add(const T& data) {
        add(m_size, data);
        return *this;
    }
    
    // 在index位置插入元素
    Chain<T>& add(int index, const T& data) {
        rangeCheckForAdd(index);
        ChainNode<T> *prev = nullptr;
        if (index == 0) {
            prev = m_first;
        } else {
            prev = node(index - 1);
        }
        prev->m_next = new ChainNode<T>(data, prev->m_next);
        m_size++;
        return *this;
    }

    // 查找元素的索引
    int indexOf(const T& data) {
        
        ChainNode<T> *current = m_first->m_next;
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

    // 获取index位置的元素
    void get(int index, T& data) const {
        ChainNode<T> *temp = node(index);
        if (temp) {
            data = temp->m_data;
        }
    }
    
    // 更新index位置的元素
    void set(int index, T& data) const {
        ChainNode<T> *temp = node(index);
        if (temp) {
            temp->m_data = data;
        }
    }
    
    void Output(ostream& out) const {
        
    }
private:
    ChainNode<T> *m_first; // 指向第一个节点的指针
    int m_size;
};

#endif /* Chain_hpp */
