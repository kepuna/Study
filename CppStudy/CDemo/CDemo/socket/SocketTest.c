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

#define SERVER_PORT  9992   //端口号
 #define SIZE 1024   //定义的数组大小

#include "SocketTest.h"



/*
 监听后，一直处于accept阻塞状态，
 直到有客户端连接，
 当客户端如数quit后，断开与客户端的连接
 
 socket编程为什么需要htons(), ntohl(), ntohs()，htons() 函数
 https://www.cnblogs.com/orlion/p/6104204.html

 */

int CreateSocket() {
    
    //socket函数，失败返回-1
    //int socket(int domain, int type, int protocol);
    //第一个参数表示使用的地址类型，一般都是ipv4，AF_INET
    //第二个参数表示套接字类型：tcp：面向连接的稳定数据传输SOCK_STREAM
    //第三个参数设置为0 (接收方式是阻塞方式)
    int serverSocket = socket(AF_INET, SOCK_STREAM, 0);
    if (serverSocket < 0) {
        perror("socket");
        return -1;
    }
    // 声明两个套接字sockaddr_in结构体变量，分别表示客户端和服务器, 用来存放地址，端口等信息
    struct sockaddr_in server_addr;
    /*
     bzero() 会将内存块（字符串）的前n个字节清零，其原型为：
     void bzero(void *s, int n);
     参数】s为内存（字符串）指针，n 为需要清零的字节数
     */
//    bzero(&server_addr, sizeof(server_addr)); // 等价
    memset(&server_addr, 0, sizeof(server_addr));
    
    // 初始化服务器端的套接字，并用htons和htonl将端口和地址转成网络字节序
    server_addr.sin_family = AF_INET;
    // 之所以需要这些函数是因为计算机数据表示存在两种字节顺序：NBO与HBO
    server_addr.sin_port = htons(SERVER_PORT);
    
  //ip可是是本服务器的ip，也可以用宏INADDR_ANY代替，代表0.0.0.0，表明所有地址
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY);
    
    //对于bind，accept之类的函数，里面套接字参数都是需要强制转换成(struct sockaddr *)
    //bind三个参数：服务器端的套接字的文件描述符
    int bindResult = bind(serverSocket,(struct sockaddr *)&server_addr, sizeof(server_addr));
    if (bindResult < 0) {
        perror("bind");
        return -1;
    }
    
    // 设置服务器上的socket为监听状态
    /*
     第一个参数：服务端socket
     第二个参数：为请求队列的最大长度
     */
    int listenResult = listen(serverSocket, 5);
    if (listenResult < 0) {
        perror("listen");
        return -1;
    }
    return serverSocket;
}

/// 等待客户端连接
int WaitClient(int serverSocket) {
    struct sockaddr_in client_addr;
    int addr_len = sizeof(client_addr);
    
    printf("等待客户端连接。。。。\n");
    
    // 调用accept函数后，会进入阻塞状态； 调用 accept() 函数，就可以随时响应客户端的请求了。
    /*
     
     accept返回一个套接字的文件描述符，这样服务器端便有两个套接字的文件描述符:serverSocket和client
     
     serverSocket仍然继续在监听状态，client则负责接收和发送数据
     
     ❤️ clientAddr是一个传出参数，accept返回时，传出客户端的地址和端口号
     addr_len是一个传入-传出参数，传入的是调用者提供的缓冲区的clientAddr的长度，以避免缓冲区溢出。
     传出的是客户端地址结构体的实际长度。
     
     */
    int clientSocket = accept(serverSocket, (struct sockaddr *)&client_addr, (socklen_t *) &addr_len);
    
    if (clientSocket < 0) {
        perror("accept");
        return -1;
    }
     printf("成功接收到一个客户端：%s\n", inet_ntoa(client_addr.sin_addr));
    return clientSocket;
}

//  //信息处理函数,功能是将客户端传过来的小写字母转化为大写字母
void hand_client(int serverSocket, int clientSocket) {
    
    char buffer[SIZE] = {0};
    while (1) {
        /*
         头文件：#include <unistd.h>

         定义函数：ssize_t read(int fd, void * buf, size_t count);

         函数说明：read()会把参数fd 所指的文件传送count 个字节到buf 指针所指的内存中. 若参数count 为0, 则read()不会有作用并返回0. 返回值为实际读取到的字节数, 如果返回0, 表示已到达文件尾或是无可读取的数据,此外文件读写位置会随读取到的字节移动.
         */
        ssize_t readRes = read(clientSocket, buffer, SIZE-1);
        if (readRes < 0) {
            perror("read ❌");
            break;
        }
        if (readRes == 0) {
            break;
        }
//        buffer[0] = '\0';
//        int i;
//        for (i=0; i<readRes; i++) {
//            buffer[i] = buffer[i] + ('A' - 'a');
//        }
        printf("发给客户端：%s\n",buffer);
        write(clientSocket, buffer, readRes);
        
        if (strncmp(buffer, "exit", 3) == 0) {
            break;
        }
    }
    close(clientSocket);
}

void SocketServer() {
    
    // 声明两个套接字sockaddr_in结构体变量，分别表示客户端和服务器, 用来存放地址，端口等信息
    
    struct sockaddr_in server_addr;
    struct sockaddr_in client_addr;
    
    int addr_len = sizeof(client_addr);
    
    int client;
    
    char buffer[200];
    
    ssize_t iDataNum;
    
  
   
    // 循环监听有么有客户端连接请求
    while (1) {
        printf("监听端口: %d\n", SERVER_PORT);
       
        printf("等待消息...\n");
        
        //inet_ntoa ip地址转换函数，将网络字节序IP转换为点分十进制IP
        //表达式：char *inet_ntoa (struct in_addr);
        printf("IP is %s\n", inet_ntoa(client_addr.sin_addr));
        printf("Port is %d\n", htons(client_addr.sin_port));
        
        while (1) {
            printf("读取消息:");
            buffer[0] = '\0';
   
            /*
             接收消息:不论是客户还是服务器应用程序都用recv函数从TCP连接的另一端接收数据
             int recv( SOCKET s, char FAR *buf, int len, int flags );
             
             函数说明：recv()用来接收远端主机经指定的socket 传来的数据, 并把数据存到由参数buf 指向的内存空间, 参数len 为可接收数据的最大长度
             
             （1）第一个参数指定接收端套接字描述符；

             （2）第二个参数指明一个缓冲区，该缓冲区用来存放recv函数接收到的数据；

             （3）第三个参数指明buf的长度；

             （4）第四个参数一般置0。
             
             成功：返回接收到的字节数， 失败返回-1
             */
            iDataNum = recv(client, buffer, 1024, 0);
            if (iDataNum < 0) {
                perror("recv null");
                continue;
            }
            
            buffer[iDataNum] = '\0';
            if (strcmp(buffer, "quit") == 0) {
                break;
            }
            
            printf("%s\n", buffer);
            printf("发送消息:");
            
            scanf("%s", buffer);
            printf("\n");
            
            ssize_t sendResult = send(client, buffer, strlen(buffer), 0);
            if (sendResult < 0) {
                perror("send faild");
                continue;
            }
            if (strcmp(buffer, "quit") == 0) {
                break;
            }
        }
    }
    return;
}

void SocketClient() {
    
    
}
