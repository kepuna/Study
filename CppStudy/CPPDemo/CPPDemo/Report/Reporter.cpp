//
//  Reporter.cpp
//  CPPDemo
//
//  Created by MOMO on 2021/2/18.
//

#include "Reporter.hpp"
#include <iostream>

namespace future {

Reporter::Reporter(const string &uuid, const string &cachePath, const string &encryptyKey, function<void(int)> func):m_UUid(uuid), m_cachePath(cachePath),m_EncryptKey(encryptyKey),m_func() {
    
    cout << uuid << endl;
    cout << cachePath << endl;
    
    m_func(10);
    
}

}
