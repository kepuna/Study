//
//  ZZGLKit3ViewController.m
//  ZZKit
//
//  Created by donews on 2019/5/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZGLKit3ViewController.h"

//首先定义一个结构体,用来保存顶点数据. 用一个三维向量来保存(x,y,z)坐标, 一个二维向量来保存(u,v)坐标
/**
 定义顶点类型
 */
typedef struct {
    GLKVector3 positionCoord; // (X, Y, Z)
    GLKVector2 textureCoord; // (U, V)
} CustomVertexInfo;

@interface ZZGLKit3ViewController ()

//定义一个顶点数组, 来保存4个顶点:
@property (nonatomic, assign) CustomVertexInfo *verticesArray; //!< 顶点数组

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *mEffect;
@property (nonatomic, strong) GLKView *glkView;

@end

@implementation ZZGLKit3ViewController {
    GLuint buffer; // 申请一个唯一标识符
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  1、新建OpenGL ES上下文
    [self setConfig];
    //    顶点数组和索引数组
    [self squareVertexData];
    //    纹理贴图
    [self uploadTexture];
}

- (void)setConfig {
    //新建OpenGLES 上下文
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    GLKView *glkview = (GLKView *)self.view;
    glkview.context = self.context;
    //    self.glkView = [[GLKView alloc] initWithFrame:self.view.bounds context:self.context];
    glkview.drawableColorFormat =  GLKViewDrawableColorFormatRGBA8888; //颜色缓冲区格式
    [EAGLContext setCurrentContext:glkview.context];
}

//
//
////顶点数据，前三个是顶点坐标（x、y、z轴），后面两个是纹理坐标（x，y）
//GLfloat squareVertexData[] =
//{
//    0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
//    0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
//    -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
//
//    0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
//    -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
//    -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
//};

- (void)squareVertexData {
    
//    初始化顶点数据:
    self.verticesArray = malloc(sizeof(CustomVertexInfo) * 4);
    self.verticesArray[0] = (CustomVertexInfo){{-1, 1, 0}, {0, 1}}; //!< 左上角
    self.verticesArray[1] = (CustomVertexInfo){{-1, -1, 0}, {0, 0}}; //!< 左下角
    self.verticesArray[2] = (CustomVertexInfo){{1, 1, 0}, {1, 1}}; //!< 右上角
    self.verticesArray[3] = (CustomVertexInfo){{1, -1, 0}, {1, 0}}; //!< 右下角
    
    //   顶点数据缓存
    glGenBuffers(1, &buffer); // glGenBuffers是给buffer申请一个唯一标识符
    glBindBuffer(GL_ARRAY_BUFFER, buffer); // glBindBuffer把标识符绑定到GL_ARRAY_BUFFER上 说明这个buffer是用来存放数组数据的
    GLsizeiptr bufferSizeBytes = sizeof(CustomVertexInfo) * 4;
    glBufferData(GL_ARRAY_BUFFER, bufferSizeBytes, self.verticesArray, GL_STATIC_DRAW); // glBufferData把顶点数据从cpu内存复制到gpu内存
    
    glEnableVertexAttribArray(GLKVertexAttribPosition); // 顶点数据缓存 glEnableVertexAttribArray 是开启对应的顶点属性
    // 读取顶点数据交给position
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(CustomVertexInfo), NULL + + offsetof(CustomVertexInfo, positionCoord));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0); //纹理
    // 读取纹理数据
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(CustomVertexInfo) , NULL + offsetof(CustomVertexInfo, textureCoord)); // glVertexAttribPointer设置合适的格式从buffer里面读取数据
    
    
}


- (void)uploadTexture {
    //纹理贴图 GLKTextureLoader读取图片，创建纹理GLKTextureInfo
    //        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"for_test" ofType:@"jpg"];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"PIC_2" ofType:@"png"];
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];//GLKTextureLoaderOriginBottomLeft 纹理坐标系是相反的
    
    //    GLKTextureInfo封装了刚创建的纹理缓存相关的信息，包括他的尺寸以及是否包含MIP贴图。我们这里只需要OpenGL ES标识符、名字和用于纹理的OpenGL ES目标。
    GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    // 创建着色器GLKBaseEffect，把纹理赋值给着色器
    self.mEffect = [[GLKBaseEffect alloc] init];
    self.mEffect.texture2d0.enabled = GL_TRUE;
    self.mEffect.texture2d0.name = textureInfo.name;
}

/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //启动着色器
    [self.mEffect prepareToDraw];
    // 开始绘制
    glDrawArrays(GL_TRIANGLES, 0, 4);
    
}

- (void)dealloc {
    
    NSLog(@">>>> %s 销毁",__func__);
    
    //!< 删除顶点缓存
    glDeleteBuffers(1, &buffer);  // !< 7：删除
    buffer = 0;
    
    if ([EAGLContext currentContext] == self.glkView.context) {
        [EAGLContext setCurrentContext:nil];
    }
    if (_verticesArray) {
        free(_verticesArray);
        _verticesArray = nil;
    }
}


@end
