//
//  BinaryTree.hpp
//  CPPDemo
//
//  Created by MOMO on 2022/1/12.
//

#ifndef BinaryTree_hpp
#define BinaryTree_hpp

template <class T>
class BinaryTreeNode {
    friend void Visit(BinaryTreeNode<T> *);
    friend void InOrder(BinaryTreeNode<T> *t) {
        if (t) {
            InOrder(t->leftChild);
            Visit(t);
            InOrder(t->rightChild);
        }
    }
    friend void PreOrder(BinaryTreeNode<T> *t){
        // 对*t 进行前序遍历
        if (t) {
            Visit(t); // 访问根节点
            PreOrder(t->leftChild);
            PreOrder(t->rightChild);
        }
    }
    friend void PostOrder(BinaryTreeNode<T> *t) {
        if (t) {
            PostOrder(t->leftChild);
            PostOrder(t->rightChild);
            Visit(t); // 访问根节点
        }
    }
    friend void LevelOrder(BinaryTreeNode<T> *);
//    friend void main(void);
    
public:
    BinaryTreeNode() {
        leftChild = nullptr;
        rightChild = nullptr;
    }
    BinaryTreeNode(const T& data) {
        leftChild = nullptr;
        rightChild = nullptr;
        data = data;
    }
    BinaryTreeNode(const T& data, BinaryTreeNode<T> *left, BinaryTreeNode<T> *right):data(data), leftChild(left), rightChild(right) {
       
    }
    
private:
    T data;
    BinaryTreeNode<T> *leftChild;
    BinaryTreeNode<T> *rightChild;
};

template <class T>
class BinaryTree {
    
public:
    BinaryTree(){
        root = nullptr;
    }
    ~BinaryTree() {}
    bool isEmpty() const {
        return (root) ? false : true;
    }
    // 共享成员函数 Root，MakeTree，BreakTree
    // 取 x 为根节点;如果操作失败，则返回 f a l s e，否则返回 t r u e
    bool Root(T& x) const {
        // 取根节点的 data域，放入 x
        //如果没有根节点，则返回 false
        if (root) {
            x = root->data;
            return true;
        } else {
            return false;
        }
    }
    // 创建一个二叉树，root作为根节点
    void MakeTree(const T& data, BinaryTree<T>& left, BinaryTree<T>& right) {
        // 将left, right和element 合并成一棵新树
        // left , right 和 this 必须是不同的树
        // 创建新树
        root = new BinaryTreeNode<T>(data, left.root, right.root);
        
        // 阻止访问 l e f t和 r i g h t
        left.root = right.root = nullptr;
    }
    // 拆分二叉树
    void BreakTree(const T& data, BinaryTree<T>& left, BinaryTree<T>& right) {
        // left , right 和 this 必须是不同的树
        // 检查树是否为空
    }
    
    // 函数Visit作为遍历函数的参数
    void PreOrder(void (*Visit)(BinaryTreeNode<T> *u)) {
        PreOrder(Visit,root);
    }
private:
    BinaryTreeNode<T> *root; // 根节点
};

#endif /* BinaryTree_hpp */
