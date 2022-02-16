//
//  SocketTest.c
//  CDemo
//
//  Created by MOMO on 2020/9/24.
//  Copyright © 2020 TriangleDemo. All rights reserved.
//


#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#define PORT  54058  //端口号
 #define SIZE 1024   //定义的数组大小

#include "SocketTest.h"



void CreateClientSocket() {
    
    //socket函数，失败返回-1
    //int socket(int domain, int type, int protocol);
    //第一个参数表示使用的地址类型，一般都是ipv4，AF_INET
    //第二个参数表示套接字类型：tcp：面向连接的稳定数据传输SOCK_STREAM
    //第三个参数设置为0 (接收方式是阻塞方式)
    int clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (clientSocket < 0) {
        perror("client socket");
        return;
    }
    
    struct sockaddr_in client_addr;
    
    
    /*
    bzero() 会将内存块（字符串）的前n个字节清零，其原型为：
    void bzero(void *s, int n);
    参数】s为内存（字符串）指针，n 为需要清零的字节数
    */
//    bzero(&client_addr, sizeof(client_addr));
    
    memset(&client_addr, 0, sizeof(client_addr));
    client_addr.sin_family = AF_INET;
    client_addr.sin_port = htons(PORT);
    client_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    inet_aton("127.0.0.1", &(client_addr.sin_addr));
    
    int addrlen = sizeof(client_addr);
    int connRes = connect(clientSocket, (struct sockaddr *)&client_addr, addrlen);
    if (connRes < 0) {
        perror("connet");
        return;
    }
    printf("成功连接到一个服务器\n");
    
    char buffer[SIZE] = {0};
    
    //向服务器发送数据，并接收服务器转换后的大写字母
    while (1) {
        printf("请输入你相输入的：");
        scanf("%s", buffer);
        write(clientSocket, buffer, strlen(buffer));
        ssize_t readRes = read(clientSocket, buffer, strlen(buffer));
        if (readRes < 0) {
            perror("client read");
        }
        printf("\n 服务端发送来的数据 = %s\n", buffer);
        if (strncmp(buffer, "exit",3) == 0) {
            break;
        }
    }
    close(clientSocket);
}

