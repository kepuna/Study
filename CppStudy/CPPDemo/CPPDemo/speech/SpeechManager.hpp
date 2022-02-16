//
//  SpeechManager.hpp
//  CPPDemo
//
//  Created by MOMO on 2021/2/6.
//

/***
 演讲管理类
 
 比赛流程分析：
 
 抽签-》开始演讲比赛-〉显示第一轮比赛结果 -》
 
 抽签-》开始演讲比赛-〉显示前三名结果 -》保存分数
 
 */

#ifndef SpeechManager_hpp
#define SpeechManager_hpp

#include <stdio.h>
#include <iostream>
#include <vector>
#include <map>
#include "Speaker.hpp"

using namespace::std;

class SpeechManager {
    
    
public:
    // 构造函数
    SpeechManager();
    
    // Menu
    void showMenu();
    
    void exitSystem();
    
    // 初始化容器和属性
    void initDefault();
    
    // 创建12个比赛选手
    void createSpeakers();
    
    // 开始比赛 ⚠️ 比赛整个流程控制函数
    void startSpeech();
    
    // 抽签
    void speechDraw();
    
    //  比赛
    void speechContest();
    
    // 显示分数
    void showScore();
    
    ~SpeechManager();
    
// 成员属性
    
    // 保存第一轮比赛选手编号的容器
    vector<int> v1;
    
    // 第一轮晋级选手编号的容器
    vector<int> v2;
    
    // 胜出前三名选手编号的容器
    vector<int> vWiner;
    
    // 存放编号以及对应具体选手的容器
    map<int, Speaker> m_Speackers;
    
    // 存放比赛轮数
    int m_Index;
    
};

#endif /* SpeechManager_hpp */
