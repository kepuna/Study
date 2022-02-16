//
//  main.c
//  CDemo
//
//  Created by 郑佳 on 2020/4/14.
//  Copyright © 2020 TriangleDemo. All rights reserved.
//

// network
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netdb.h>

// c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "cJSON.h"
#include "SocketTest.h"

//typedef struct Student {
//    long number;
//    char name[10];
//    char sex[3]; // 由于汉字“男,女” 都是占2个字节, 在C语言中,字符数组安字符串处理,还有自动添加一个结束标记, 所以为3
//    int age;
//} StudentType;

//
//typedef StudentType DataType;
//
//#include "SeqList.h" //需要放在typedef下面


void SeqListDemo() {
//    SeqList myList;
//    int i, x;

//    ListInitiate(&myList);
//    for (i=0; i<10; i++) {
//        ListInsert(&myList, i, i+1);
//    }
//    ListDelete(&myList, 10, &x);
//    for (i=0; i<ListLenght(myList); i++) {
//        ListGet(&myList, i, &x);
//        printf("%d\t",x);
//    }
}


void SeqListDemo2() {
    
//    SeqList myList;
//    int i;
//    StudentType x[3] = {
//        {2001, "zhangsan", "男",20},
//        {2002, "lisi", "男",20},
//        {2003, "wangwu", "女",10}
//    };
//
//    StudentType stu;
//    ListInitiate(&myList);
//    ListInsert(&myList, 0, x[0]);
//    ListInsert(&myList, 1, x[1]);
//    ListInsert(&myList, 2, x[2]);
//
//    for (i=0; i< ListLenght(myList); i++) {
//        ListGet(&myList, i, &stu);
//        printf("%ld %s %s %d\n ", stu.number, stu.name, stu.sex, stu.age);
//    }
    
}

//#include "LinList.h"
//void LinListDemo() {
//    SLNode *head;
//    int i, x;
//    ListInitate(&head);
//    for (i=0; i<10; i++) {
//        ListInsert(head, i, i+1);
//    }
//    ListDelete(head, 10, &x);
//    for (i=0; i<ListLength(head); i++) {
//        ListGet(head, i, &x);
//        printf("%d\t",x);
//    }
//    Destory(&head);
//}



/*
 Demo: 优先级队列的应用
 操作系统中的进程管理 是优先级队列的一个应用实例, 操作系统中使用一个优先级队列来管理进程.
 每个进程由进程任务号和优先级值两部分组成, 进程任务号是每个不同进程的唯一标识, 优先级值通常是一个0-40的值, 规定0位优先级最高, 40位优先级最低.
 
 通常认为打印任务的执行队实时性要求不高, 所以打印任务的优先级定为40, 当队列中有若干个进程排队等待时, 进程管理就可根据其优先级值选择优先级最高的进程首先出队列, 从而达到了系统繁忙时, 所有进程都排队等待, 以及实时性要求高的进程 (即优先级高的进程) 先被服务的双重目标.
 
 */

#define MaxQueueSize 100
typedef int ElemType;
#include "PSeqQueue.h"

void OSTaskDemo() {
    
    PSeqQueue myPQueue;
    FILE *fp; // 文件指针
    DataType task;
    int i;
    
    if ((fp = fopen("task.dat", "r")) == NULL) {
        printf("open file faild");
        exit(0);
    }
    QueueInit(&myPQueue); // 初始化顺序优先级队列
    while (!feof(fp)) {
        // C 库函数 int fscanf(FILE *stream, const char *format, ...) 从流 stream 读取格式化输入
//        返回值
//        如果成功，该函数返回成功匹配和赋值的个数。如果到达文件末尾或发生读错误，则返回 EOF。
        int scanrRes = fscanf(fp, "%d %d", &task.elem, &task.priority); // 读数据
        if (scanrRes > 0) {
            QueueAppend(&myPQueue, task);
        }
    }
    
    i = 1;
    printf("序列号\t任务号\t优先级\n");
    // 逐个出队并显示 (出队按照优先级由高到低 ,优先级相同的进程先到先服务)
    while(QueueNotEmpty(&myPQueue)) {
        QueueDelete(&myPQueue, &task);
        printf("%d \t\t",i);
        printf("%d \t\t",task.elem);
        printf("%d \t\t\n",task.priority);
        i++;
    }
    
}


/*
1.  创建socket，返回一个描述符
2. 连接到服务器
3. 发送数据给服务器
4. 从服务器接受数据
5. 通过描述符，关闭socket
*/

void SocketTest (){
    
    // 1. 创建socket
    int clientSocket = socket(AF_INET, SOCK_STREAM, 0);
    
    // 2. 连接服务器
    struct sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_port = htons(12345);
    serverAddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    int connectResult = connect(clientSocket,(const struct sockaddr *) &serverAddr, sizeof(serverAddr));
    if (connectResult == 0) {
        printf("Connect Successful \n");
    } else {
        perror("Connect");
        return;
    }
    
    // 3. 发送数据给服务器
    /*
     参数
     1. 客户端socket
     2. 发送内容地址
     3. 发送内容长度
     4. 发送标志， 一般为0
     
     返回值：如果成功，则返回发送的字节数， 失败则返回SOCKET_ERROR
     
     */
    
    char *sendMsg = "Hello";
    ssize_t sendLen = send(clientSocket, sendMsg, strlen(sendMsg), 0);
    
    printf("send length: %zd \n",sendLen);
    
    // 4. 从服务器接受数据
    /*
     参数
     1. 客户端socket
     2. 接受内容缓存区地址
     3. 接受内容缓存区长度
     4. 接受方式，0表示阻塞，必须等待服务器返回数据
     
     返回值
     如果成功，则返回读入的字节数， 失败则返回 SOCKET_ERROR
     
     */
    
    char buffer[1024 * 1024]={0};
//    char c;
//    int i=0;
//    // 一个字节一个字节的读，避免缓冲区不够
//    while (read(sockfd, &c, 1) == 1) {
//        buffer[i++] = c;
//    }
    
//    uint8_t buffer[1024]; // 声明一个数组，将空间准备出来
    
    ssize_t receviceLen = recv(clientSocket, buffer, sizeof(buffer), 0);
    printf("接受到了 %ld个字节, 接受到内容：%s",receviceLen,buffer);
        
    // 关闭socket
    close(clientSocket);
    
    
}

// 从api获取数据
// NSString *path = @"/caipiao/history";
//NSString *querys = @"?caipiaoid=13&issueno=2014127&num=10&start=0";

///caipiao/history?caipiaoid=13&issueno=2014127&num=10&start=0

// http 请求头，由方法行 + 换行符 + 头部

char *request = "GET /caipiao/history?caipiaoid=13&issueno=2014127&num=10&start=0 HTTP/1.1\r\n"
    "Host:jisucpkj.market.alicloudapi.com\r\n"
    "Authorization:APPCODE c90516c46e834f308b7a50ebafe04f39\r\n\r\n";


void Network() {
    // 1. 创建socket （创建的是 要连接到服务器的socket ）， 返回一个描述符
    /*
    参数：
     domain： 协议域， AF_INET -》 IPV4
     type ： Socket类型， SOCK_STREAM （TCP） / SOCK_DGRAM （报文UDP）
     protocol： IPPROTO_TCP, 如果传入0， 会自动根据第二个参数，选择合适的协议
     */
    int sockfd = socket(AF_INET, SOCK_STREAM, 0);
    
    // 通过域名拿到服务器的ip
    struct hostent *serverIp = gethostbyname("jisucpkj.market.alicloudapi.com");
    if (serverIp == NULL) {
        printf("Error \n");
        return;
    }
    
    // 创建服务器地址结构体 并填充
    struct sockaddr_in serverAddr;
    bzero(&serverAddr, sizeof(serverAddr)); // clear first
    
    serverAddr.sin_family = AF_INET; // ipv4
    serverAddr.sin_port = htons(54093); // default use 80 prot， 要转换成大端，是16位，不是32位
    
    serverAddr.sin_addr.s_addr = htonl(INADDR_ANY);
    inet_aton("127.0.0.1", &(serverAddr.sin_addr));
    
//    serverAddr.sin_addr = *(struct in_addr *)serverIp->h_addr; // ip地址
//
//    // ip地址没有，需要通过域名 转换出ip
//    char ipaddr[20] = {0};
//
//
//    // 从ip二进制转换成点分十进制
//    inet_ntop(AF_INET, serverIp->h_addr, ipaddr, 20);
//    printf("ip地址： %s \n", ipaddr);
    
    // 到此，地址结构体就完成了填充，接下来就可以连接服务器了
    /*
     2. 连接到服务器
     参数
     1 》 上面创建的 要连接到服务器的socket
     2 〉 指向数据结构 sockaddr 的指针，其中包含了目的端口和ip地址 （这里传的即： 服务器地址 的指针）
     3 》 结构体的长度
     返回值： 0代表成功，其他 ，错误代号
     
     */
    int res = connect(sockfd, (struct sockaddr *)&serverAddr, sizeof(serverAddr));
    if (res == -1) {
        perror("connect"); // 输出错误的原因
    } else {
        printf("Connect Successful \n");
    }
    
    // 发送Http请求
    ssize_t wlen = write(sockfd, request, strlen(request));
    if (wlen < 0) {
        perror("write");
    }
    // 读取网站回来的数据
    char buffer[1024 * 1024]={0};
    char c;
    int i=0;
    // 一个字节一个字节的读，避免缓冲区不够
    while (read(sockfd, &c, 1) == 1) {
        buffer[i++] = c;
    }
    
    char *content = strstr(buffer, "\r\n\r\n");
    
    // 解析字符串 构建json对象
    cJSON *jsonObj = cJSON_Parse(content+4);
    
    // 变成可以打印的版本，输出看看
//    char *jsondata = cJSON_Print(listArray);
//    if (jsondata) {
//        printf("%s \n", jsondata);
//    } else {
//        printf("json data is nil");
//    }
    
    cJSON *resultDict = cJSON_GetObjectItem(jsonObj, "result");
    cJSON *listArray = cJSON_GetObjectItem(resultDict, "list");
    
   // 获取数组元素的个数
    int count = cJSON_GetArraySize(listArray);
    
    for (int i=0; i<count; i++) {
        // 拿到listArray数组的 i号元素
        cJSON *element = cJSON_GetArrayItem(listArray, i);
        cJSON *opendate = cJSON_GetObjectItem(element, "opendate");
        cJSON *redNum = cJSON_GetObjectItem(element, "number");
        cJSON *blueNum = cJSON_GetObjectItem(element, "refernumber");
        
        printf(" %s 期开奖号码是 红：%s ， 蓝：%s \n", opendate->valuestring, redNum->valuestring, blueNum->valuestring);

    }
    
    close(sockfd);
    
}


int main(int argc, const char * argv[]) {
    // insert code here...
//    LinListDemo();
//    OSTaskDemo();
    Network();
//    SocketTest();
    
//    CreateClientSocket();
    
    return 0;
}

