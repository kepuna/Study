//
//  SocketTest.h
//  CDemo
//
//  Created by MOMO on 2020/9/24.
//  Copyright © 2020 TriangleDemo. All rights reserved.
//

#ifndef SocketTest_h
#define SocketTest_h

#include <stdio.h>

int CreateSocket(void);
int WaitClient(int serverSocket);
void hand_client(int serverSocket, int clientSocket);

#endif /* SocketTest_h */
