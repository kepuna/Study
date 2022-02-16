//
//  Reporter.hpp
//  CPPDemo
//
//  Created by MOMO on 2021/2/18.
//

#ifndef Reporter_hpp
#define Reporter_hpp

#include <string>
#include <functional>

using namespace::std;

namespace future {

class Reporter {
    
public:
    Reporter(const string &uuid, const string &cachePath, const string &encryptyKey, function<void(int)> func);
    
private:
    
    const string m_UUid;
    const string m_cachePath;
    string m_EncryptKey;
    
//    function<void *(void *, std::size_t, std::size_t &)> m_EncryptFun;
    function<void(int)> m_func;
    
};

}

#endif /* Reporter_hpp */
