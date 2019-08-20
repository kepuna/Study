//
//  ZZGLKit2ViewController.m
//  ZZKit
//
//  Created by donews on 2019/5/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZGLKit2ViewController.h"

@interface ZZGLKit2ViewController ()

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *mEffect;
@property (nonatomic, strong) GLKView *glkView;

@end

@implementation ZZGLKit2ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    1、新建OpenGL ES上下文
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

- (void)squareVertexData {
    
    //    //顶点数据，前三个是顶点坐标（x、y、z轴），后面两个是纹理坐标（x，y）
    //    GLfloat squareVertexData[] =
    //    {
    //        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
    //        0.5, 0.5, -0.0f,    1.0f, 1.0f, //右上
    //        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
    //
    //        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
    //        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
    //        -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下
    //    };
    
    //顶点数据，前三个是顶点坐标（x、y、z轴），后面两个是纹理坐标（x，y）
    GLfloat squareVertexData[] =
    {
        0.5, -0.5, 0.0f,
        0.5, 0.5, -0.0f,
        -0.5, 0.5, 0.0f,
        //
        //        0.5, -0.5, 0.0f,
        //        -0.5, 0.5, 0.0f,
        //        -0.5, -0.5, 0.0f,
    };
    
    //   顶点数据缓存
    GLuint buffer;
    glGenBuffers(1, &buffer); // glGenBuffers是给buffer申请一个唯一标识符
    glBindBuffer(GL_ARRAY_BUFFER, buffer); // glBindBuffer把标识符绑定到GL_ARRAY_BUFFER上 说明这个buffer是用来存放数组数据的
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW); // glBufferData把顶点数据从cpu内存复制到gpu内存
    
    glEnableVertexAttribArray(GLKVertexAttribPosition); // 顶点数据缓存 glEnableVertexAttribArray 是开启对应的顶点属性
    // 读取顶点数据交给position
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 3, (GLfloat *)NULL + 0);
    //    glEnableVertexAttribArray(GLKVertexAttribTexCoord0); //纹理
    //    // 读取纹理数据
    //    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3); // glVertexAttribPointer设置合适的格式从buffer里面读取数据
    
    
}


- (void)uploadTexture {
    //纹理贴图 GLKTextureLoader读取图片，创建纹理GLKTextureInfo
    //        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"for_test" ofType:@"jpg"];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"PIC_2" ofType:@"png"];
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];//GLKTextureLoaderOriginBottomLeft 纹理坐标系是相反的
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
    glDrawArrays(GL_TRIANGLES, 0, 3);
}


@end
