//
//  HttpServer.c
//  CDemo
//
//  Created by MOMO on 2020/9/27.
//  Copyright © 2020 TriangleDemo. All rights reserved.
//

#include "HttpServer.h"
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
#include <ctype.h>

void zj_accept_request(int);
void zj_error_die(const char *);
int zj_startup(u_short *);
int zj_get_line(int, char *, int);

/*
 struct stat结构体的详解和用法 : https://www.cnblogs.com/yaowen/p/4801541.html
 
 _stat函数用来获取指定路径的文件或者文件夹的信息。
 
 //! 需要包含de头文件
 #include <sys/types.h>
 #include <sys/stat.h>
 int stat(
 　　const char *filename    //文件或者文件夹的路径
 　　, struct stat *buf      //获取的信息保存在内存中
 ); //! prototype,原型

 正确——返回0

 错误——返回-1，具体错误码保存在errno中
 
 */

// struct stat
// {
//     dev_t       st_dev;     /* ID of device containing file -文件所在设备的ID*/
//     ino_t       st_ino;     /* inode number -inode节点号*/
//     mode_t      st_mode;    /* protection -保护模式?*/
//     nlink_t     st_nlink;   /* number of hard links -链向此文件的连接数(硬连接)*/
//     uid_t       st_uid;     /* user ID of owner -user id*/
//     gid_t       st_gid;     /* group ID of owner - group id*/
//     dev_t       st_rdev;    /* device ID (if special file) -设备号，针对设备文件*/
//     off_t       st_size;    /* total size, in bytes -文件大小，字节为单位*/
//     blksize_t   st_blksize; /* blocksize for filesystem I/O -系统块的大小*/
//     blkcnt_t    st_blocks;  /* number of blocks allocated -文件所占块数*/
//     time_t      st_atime;   /* time of last access -最近存取时间*/
//     time_t      st_mtime;   /* time of last modification -最近修改时间*/
//     time_t      st_ctime;   /* time of last status change - */
// };


void zj_accept_request(int client) {
    // 字符数组
    char buf[1024];
    int numchars;
    char method[255];
    char url[255];
    char path[521];
    
    size_t i,j;
    struct stat st;
    
    /* becomes true if server decides this is a CGI
                        * program */
    int cgi = 0;
    
    char *query_string = NULL;
    // 读http 请求的第一行数据（request line），把请求方法存进 method 中
    numchars = zj_get_line(client, buf, sizeof(buf));
    i = 0; j = 0;
    
    
    printf("first = %d", numchars);
}

/*
 头文件：#include <sys/types.h>   #include <sys/socket.h>

 定义函数：int recv(int s, void *buf, int len, unsigned int flags);

 函数说明：recv()用来接收远端主机经指定的socket 传来的数据, 并把数据存到由参数buf 指向的内存空间, 参数len 为可接收数据的最大长度.

 参数 flags 一般设0. 其他数值定义如下:
 1、MSG_OOB 接收以out-of-band 送出的数据.
 2、MSG_PEEK 返回来的数据并不会在系统内删除, 如果再调用recv()会返回相同的数据内容.
 3、MSG_WAITALL 强迫接收到len 大小的数据后才能返回, 除非有错误或信号产生.
 4、MSG_NOSIGNAL 此操作不愿被SIGPIPE 信号中断返回值成功则返回接收到的字符数, 失败返回-1,错误原因存于errno 中.
 
 */
int zj_get_line(int sock, char *buf, int size)
{
    int i = 0;
    char c = '\0';
    ssize_t n;

    while ((i < size-1) && (c != '\n')) {
        
        //recv()包含于<sys/socket.h>,参读《TLPI》P1259,
          //读一个字节的数据存放在 c 中
        n = recv(sock, &c, 1, 0);
        
        printf("%c", c);
//        printf("%02X\n", c);
        /* DEBUG printf("%02X\n", c); */
        if (n > 0) {
            if (c == '\r') {
                n = recv(sock, &c, 1, MSG_PEEK);
                if ((n > 0) && (c == '\n')) {
                    recv(sock, &c, 1, 0);
                } else {
                    c = '\n';
                }
            }
            buf[i] = c;
            i++;
        } else {
            c = '\n';
        }
    }
    buf[i] = '\0';
    return (i);
}



/// 错误信息
void zj_error_die(const char *sc) {
    //包含于<stdio.h>,基于当前的 errno 值，在标准错误上产生一条错误消息。参考《TLPI》P49
    perror(sc);
    exit(1);
}


/// 开启server服务
int zj_startup(u_short *port) {
    int httpd = 0;
    
    //sockaddr_in 是 IPV4的套接字地址结构。定义在<netinet/in.h>,参读《TLPI》P1202
    struct sockaddr_in name;
    //socket()用于创建一个用于 socket 的描述符，函数包含于<sys/socket.h>。参读《TLPI》P1153
     //这里的PF_INET其实是与 AF_INET同义，具体可以参读《TLPI》P946
    httpd = socket(PF_INET, SOCK_STREAM, 0);
    if (httpd == -1) {
        zj_error_die("socket");
    }
    
    /*
     头文件：#include <string.h>
     memset() 函数用来将指定内存的前n个字节设置为特定的值，其原型为：
         void * memset( void * ptr, int value, size_t num );
     
     参数说明：
     ptr 为要操作的内存的指针。
     value 为要设置的值。你既可以向 value 传递 int 类型的值，也可以传递 char 类型的值，int 和 char 可以根据 ASCII 码相互转换。
     num 为 ptr 的前 num 个字节，size_t 就是unsigned int。
     
     函数说明】memset() 会将 ptr 所指的内存区域的前 num 个字节的值都设置为 value，然后返回指向 ptr 的指针。
     */
    memset(&name, 0, sizeof(name));
    
    name.sin_family = AF_INET;
    //htons()，ntohs() 和 htonl()包含于<arpa/inet.h>, 参读《TLPI》P1199
     //将*port 转换成以网络字节序表示的16位整数
    name.sin_port = htons(*port);
    //INADDR_ANY是一个 IPV4通配地址的常量，包含于<netinet/in.h>
    //大多实现都将其定义成了0.0.0.0 参读《TLPI》P1187
    name.sin_addr.s_addr = htonl(INADDR_ANY);
    
    
    //bind()用于绑定地址与 socket。参读《TLPI》P1153
     //如果传进去的sockaddr结构中的 sin_port 指定为0，这时系统会选择一个临时的端口号
    if (bind(httpd, (struct sockaddr *)&name, sizeof(name)) < 0) {
        zj_error_die("bind");
    }
    
    //如果调用 bind 后端口号仍然是0，则手动调用getsockname()获取端口号
    if (*port == 0) {
        socklen_t namelen = sizeof(name);
        
        //getsockname()包含于<sys/socker.h>中，参读《TLPI》P1263
          //调用getsockname()获取系统给 httpd 这个 socket 随机分配的端口号
        if (getsockname(httpd, (struct sockaddr *)&name, &namelen) == -1) {
            zj_error_die("getsockname");
        }
        
        *port = ntohs(name.sin_port);
    }
    
    //最初的 BSD socket 实现中，backlog 的上限是5.参读《TLPI》P1156
    if (listen(httpd, 5) < 0) {
        zj_error_die("listen");
    } else {
        printf("开始监听，等待客户端连接...\n");
    }
    return httpd;
}

void httpServerDemo() {
    
    int server_sock =  -1;
    ushort port = 0;
    int client_sock = -1;
    
    struct sockaddr_in client_name;
    socklen_t client_name_lent = sizeof(client_name);
    
    server_sock = zj_startup(&port);
    printf("httpd running on port %d\n", port);
    
    while (1) {
        //阻塞等待客户端的连接，参读《TLPI》P1157
        client_sock = accept(server_sock,(struct sockaddr *)&client_name, &client_name_lent);
        if (client_sock == -1) {
            zj_error_die("accept");
        } else {
            printf("链接成功。。。\n");
        }
        zj_accept_request(client_sock);
    }
    
    close(server_sock);
}
