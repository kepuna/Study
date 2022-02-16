//
//  SpeechManager.cpp
//  CPPDemo
//
//  Created by MOMO on 2021/2/6.
//

#include "SpeechManager.hpp"
#include <unistd.h>
#include <string>
#include <algorithm>
#include <deque>
#include <functional>
#include <numeric>
//#include <>


SpeechManager::SpeechManager() {
    
    // 初始化容器和属性
    this->initDefault();

    this->createSpeakers();
}

void SpeechManager::showMenu() {
    
    cout << "************************" << endl;
    cout << "******** 欢迎参加演讲比赛 ********" << endl;
    cout << "***** 1. 开始演讲比赛  *****" << endl;
    cout << "***** 2. 查询往届记录  *****" << endl;
    cout << "***** 3. 清空比赛记录  *****" << endl;
    cout << "***** 4. 退出比赛程序  *****" << endl;
    cout << "************************" << endl;
}

void SpeechManager::exitSystem() {
    cout << "******* 欢迎下次使用 *******" << endl;
//    system("pause");
    pause();
    exit(0);
    
    //                cout << "欢迎下次使用" << endl;
    //                pause();
    //                return 0;
    //                break;
}

void SpeechManager::initDefault() {
    this->v1.clear();
    this->v2.clear();
    this->vWiner.clear();
    this->m_Speackers.clear();
    
    this->m_Index = 1;
}

void SpeechManager::createSpeakers() {
    
    string nameSeed = "ABCDEFGHIJKL";
    for (int i = 0; i < nameSeed.size(); i++) {
        string name = "选手";
        name += nameSeed[i];
    

        // 创建具体的选手对象
        Speaker sp;
        sp.m_Name = name;

        for (int j = 0; j < 2; j++) {
            sp.m_Score[j] = 0;
        }

        // 创建选手编号， 并放到v1容器中
        this->v1.push_back(i+10001);

        // 选手的编号 & 选手对象 放到map中
        this->m_Speackers.insert(make_pair(i+10001, sp));
    }
}

void SpeechManager::startSpeech() {
    
    // 第一轮比赛开始
    
    // 1. 抽签
    this->speechDraw();
    
    // 2. 比赛
    this->speechContest();
    
    // 3. 显示最终结果
    this->showScore();
}

void SpeechManager::speechDraw() {
    
    cout << "第 【" << this->m_Index << "】轮选手正在抽签" << endl;
    cout << "--------------------" << endl;
    cout << "抽签后演讲顺序如下：" << endl;
    
    if (this->m_Index == 1) {
        // 第一轮
        random_shuffle(v1.begin(), v1.end());
        
        vector<int>::iterator iter;
        for (iter = v1.begin(); iter != v1.end(); iter++) {
            cout << *iter << endl;
        }
        
    } else {
        
        // 第二轮比赛
        random_shuffle(v2.begin(), v2.end());
        
        vector<int>::iterator iter;
        for (iter = v2.begin(); iter != v2.end(); iter++) {
            cout << *iter << endl;
        }
    }
    
    cout << "--------------------" << endl;
//    pause();
    system("pause");
    cout << endl; // 换行
}

void SpeechManager::speechContest() {
    
    cout << "----------- 第 【" << this->m_Index << "】轮比赛正式开始 ----------" << endl;
    
    // 准备临时容器， 存放小组成绩
    multimap<double, int, greater<double>> groupScore;
    int num = 0; // 记录人员个数 6人一组
    
    vector<int> v_player; // 比赛选手容器
    
    if (this->m_Index == 1) {
        v_player = v1;
    } else {
        v_player = v2;
    }
    
    // 遍历所有选手进行比赛
    cout << "--------------------" << endl;
    vector<int>::iterator iter;
    for (iter = v_player.begin(); iter != v_player.end(); iter++) {
        
        num++;
        // 10个评委打分
        deque<double> giveScore;
        for (int i = 0; i < 10; i++) {
            // 随机打分
            double score = (rand() % 401 + 600) / 10.f;
            cout << score << "";
            giveScore.push_back(score);
        }
        
        // 排序
        sort(giveScore.begin(), giveScore.end());
        
        giveScore.pop_front(); // 去除最高分
        giveScore.pop_back(); // 去除最低分
        
        // 去除最高最低分后 计算总分
        double sum = accumulate(giveScore.begin(), giveScore.end(), 0.0f);
        // 平均分
        double avg = sum / (double)giveScore.size();
        
        cout << endl;
        
        cout << "编号：" << *iter << "姓名：" << this->m_Speackers[*iter].m_Name << "平均分：" << avg << endl;

        // 将平均分放到 map容器 ⚠️ 理解一下
        this->m_Speackers[*iter].m_Score[this->m_Index - 1] = avg;
        
        // 将打分数据， 放入到临时的小组容器中
        groupScore.insert(make_pair(avg, *iter)); // key是得分，value 是具体选手编号
        
        // 每6人取出前三名
        if (num % 6 == 0) {
            cout << "------------第" << num / 6 << "小组比赛名次：--------" << endl;
            
            for (multimap<double, int, greater<double>>::iterator iter = groupScore.begin(); iter != groupScore.end(); iter++) {
                cout << "编号:" << iter->second << "姓名：" << this->m_Speackers[iter->second].m_Name << "成绩：" << this->m_Speackers[iter->second].m_Score[this->m_Index - 1] << endl;
            }
            
            // 取走前三名
            int count = 0;
            for (multimap<double, int, greater<double>>::iterator iter = groupScore.begin(); iter != groupScore.end() && count < 3; iter++, count++) {
               
                if (this->m_Index == 1) {
//                    cout << "✅" << (*iter).second << endl;
                    v2.push_back((*iter).second);
                } else {
                    vWiner.push_back((*iter).second);
                }
            }
            
            
            // 某组比赛完后需要清空临时容器
            groupScore.clear();
            
            cout << endl;
        }
    }
    
    cout << "-------- 第：" << this->m_Index << "轮比赛完毕------------" << endl;
    system("pause");
    
}

void SpeechManager::showScore() {
    
    cout << "-------- 第：" << this->m_Index << "轮晋级选手信息如下：------------" << endl;
    
    vector<int> v;
    if (this->m_Index == 1) {
        v = v2;
    } else {
        v = vWiner;
    }
    
    for (vector<int>::iterator iter = v.begin(); iter != v.end(); iter++) {
        cout << "选手编号:" << *iter << "姓名：" << m_Speackers[*iter].m_Name << "得分：" << m_Speackers[*iter].m_Score[this->m_Index - 1] << endl;
    }
    
    cout << endl;
    
    system("pause");
    system("cls");
    this->showMenu();
}

SpeechManager::~SpeechManager() {
    
}
