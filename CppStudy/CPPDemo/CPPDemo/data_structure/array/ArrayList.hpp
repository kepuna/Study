//
//  ArrayList.hpp
//  CPPDemo
//
//  Created by MOMO on 2021/12/30.
//

#ifndef ArrayList_hpp
#define ArrayList_hpp

#include <iostream>

using namespace std;
#define ELEMENT_NOT_FOUND  -1

template <class T>
class ArrayList {
public:
    ArrayList(int capacity = 10) {
        m_capacity = capacity > 10 ? capacity : 10;
        m_elements = new T[m_capacity];
    }
    ~ArrayList() {
        delete [] m_elements;
    }
    
    ArrayList<T>& add(const int index, const T& data) {
        rangeCheckForAdd(index);
        ensureCapacity(m_size + 1);
        for (int i = m_size; i > index; i--) {
            m_elements[i] = m_elements[i - 1];
        }
        m_elements[index] = data;
        m_size++;
        return *this;
    }
    
    ArrayList<T>& add(const T& data) {
        add(m_size, data);
        return *this;
    }
    
    // 把index位置的元素放入element中，然后删除index位置的元素
    // cosnt T& data , 因为这里要修改data的值，所以前面不能加const
    ArrayList<T>& remove(const int index, T& data) {
        rangeCheck(index);
        data = m_elements[index];
        for (int i = index + 1; i < m_size; i++) {
            m_elements[i - 1] = m_elements[i];
        }
        m_size--;
        m_elements[m_size] = NULL;
        return *this;
    }
    
    T& set(const int index, const T& data) const {
        rangeCheck(index);
        T& old = m_elements[index];
        m_elements[index] = data;
        return old;
    }
    
    T& get(const int index) const {
        rangeCheck(index);
        return m_elements[index];
    }
    
    // 查找某个元素，如果找到，返回元素的索引
    int indexOf(const T& data) const {
        for (int i = 0; i < m_size; i++) {
            if (m_elements[i] == data) {
                return i;
            }
        }
        return ELEMENT_NOT_FOUND;
    }
    
    bool isEmpty() const{
        return m_size == 0;
    }
    
    int size() const {
        return m_size;
    }
    
    ArrayList<T>& clear() {
        for (int i = 0; i < m_size; i++) {
            m_elements[i] = NULL;
        }
        m_size = 0;
        return *this;
    }
    
    void output(ostream& out) const {
        for (int i = 0; i < m_size; i++) {
            out << m_elements[i] << ", ";
        }
    }
    
private:
    int m_size;
    int m_capacity;
    T *m_elements;
    
    void outOfBounds(const int index) const {
        throw "out of bounds";
    }
    void rangeCheck(const int index) const {
        if (index < 0 || index >= m_size) {
            outOfBounds(index);
        }
    }
    void rangeCheckForAdd(const int index) const {
        if (index < 0 || index > m_size) {
            outOfBounds(index);
        }
    }
    
    // void ensureCapacity(int capacity) const
    // 因为这个函数里面会修改成员变量 m_elements 和 m_capacity 的值，所以不能用const修饰了
    void ensureCapacity(const int capacity) {
        int oldCapacity = m_capacity;
        if (oldCapacity >= capacity) {
            return;
        }
        // 新容量为旧容量的1.5倍
        int newCapacity = oldCapacity + (oldCapacity >> 1);
        T *newElements = new T[newCapacity];
        // 拷贝数据
        for (int i = 0; i < m_size; i++) {
            newElements[i] = m_elements[i];
        }
        delete [] m_elements;
        m_elements = newElements;
        m_capacity = newCapacity;
        cout << oldCapacity << "扩容为" << newCapacity << endl;
    }
};

// 重载 <<
template <class T>
ostream& operator<<(ostream& out, const ArrayList<T>& list) {
    list.output(out);
    return out;
}

#endif /* ArrayList_hpp */
