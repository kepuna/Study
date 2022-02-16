//
//  Study0ViewController.m
//  OpenGLES_1
//
//  Created by 郑佳 on 2021/6/19.
//  Copyright © 2021 CC老师. All rights reserved.
//

#import "Study0ViewController.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface Study0ViewController ()<GLKViewDelegate>

@end

@implementation Study0ViewController{
    EAGLContext *_context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setupConfig];
    // 2. 加载顶点数据
    [self uploadVertexArray];
}

- (void)setupConfig {
    
    NSLog(@">>>>>>>> 1 创建可以用来显示OpenGL ES的上下文 & 图层");
    // Create OpenGL ES Context
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    
    if (_context == nil) {
        NSLog(@"Create Context Error");
        exit(0);
    }
    
    // Create GLKView
    GLKView *view = (GLKView *)self.view;
    view.context = _context;
    
    // 深度
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    
    // 配置颜色缓冲区格式
//    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    
    [EAGLContext setCurrentContext:_context];
    
    glEnable(GL_DEPTH_TEST);
//    glClearColor(0.0f, 1.0f, 1.0f, 1.0f);
    glClearColor(0.2f, 0.3f, 0.4f, 1.0f);
}

- (void)uploadVertexArray {
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
