//
//  ZZThread3ViewController.m
//  ZZKit
//
//  Created by donews on 2019/5/19.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZThread3ViewController.h"

@interface ZZThread3ViewController ()

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;
@property (nonatomic, strong) UIImageView *imageView4;

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *cancleButton;

@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation ZZThread3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.imageView1];
    [self.view addSubview:self.imageView2];
    [self.view addSubview:self.imageView3];
    [self.view addSubview:self.imageView4];
    
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.cancleButton];

    [self createData];
    
}

- (void)createData {
    self.urls = [NSMutableArray array];
    self.imageViews = [NSMutableArray array];
    //创建请求队列，队列放的是一个个异步请求线程
    self.queue = [[NSOperationQueue alloc]init];
    
    NSString* urlString1 = @"http://gss0.baidu.com/-4o3dSag_xI4khGko9WTAnF6hhy/zhidao/pic/item/838ba61ea8d3fd1f8d0b4913394e251f95ca5f9d.jpg";
    NSString* urlString2 = @"http://uploads.5068.com/allimg/141029/40-141029152001.jpg";
    NSString* urlString3 = @"http://pcs4.clubstatic.lenovo.com.cn/data/attachment/forum/201602/05/163855sti39l3u3iu7c7tw.jpg";
    NSString* urlString4 = @"http://pic1.win4000.com/wallpaper/2017-12-27/5a4360b35710c.jpg";
 
    
    [self.urls addObject:urlString1];
    [self.urls addObject:urlString2];
    [self.urls addObject:urlString3];
    [self.urls addObject:urlString4];
    
    [self.imageViews addObject:self.imageView1];
    [self.imageViews addObject:self.imageView2];
    [self.imageViews addObject:self.imageView3];
    [self.imageViews addObject:self.imageView4];
}

- (void)s_startAction {
    
    for (NSInteger i = 0; i<self.urls.count; i++) {
        NSArray* arr = @[self.urls[i],[NSString stringWithFormat:@"%zd", i]];
        NSInvocationOperation* opertation = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(downloadImage:) object:arr];
        [self.queue addOperation:opertation]; //把线程加载到队列中，让队列去实现开始和结束
    }
}

- (void)downloadImage:(NSArray*)arr {
    
    NSURL* url = [NSURL URLWithString:arr[0]];
    NSData* data = [NSData dataWithContentsOfURL:url];
    UIImage* image = [UIImage imageWithData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView* imageView  = self.imageViews[[arr[1] integerValue]];
        imageView.image = image;
    });
   
}


- (void)s_cancleAction {
    //取消所有线程的执行 (已经开始的无法取消)
    [self.queue cancelAllOperations];
}

#pragma mark - Getters & Setters
- (UIImageView *)imageView1 {
    if (_imageView1 == nil) {
        CGRect frame = CGRectMake(0, 100, self.view.bounds.size.width, 150);
        _imageView1 = [[UIImageView alloc] initWithFrame:frame];
        _imageView1.backgroundColor = [UIColor lightGrayColor];
        _imageView1.tag = 0;
    }
    return _imageView1;
}

- (UIImageView *)imageView2 {
    if (_imageView2 == nil) {
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.imageView1.frame) + 10, self.view.bounds.size.width, 150);
        _imageView2 = [[UIImageView alloc] initWithFrame:frame];
        _imageView2.backgroundColor = [UIColor lightGrayColor];
        _imageView2.tag = 1;
    }
    return _imageView2;
}

- (UIImageView *)imageView3 {
    if (_imageView3 == nil) {
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.imageView2.frame)+ 10, self.view.bounds.size.width, 150);
        _imageView3 = [[UIImageView alloc] initWithFrame:frame];
        _imageView3.backgroundColor = [UIColor lightGrayColor];
        _imageView3.tag = 2;
    }
    return _imageView3;
}

- (UIImageView *)imageView4 {
    if (_imageView4 == nil) {
        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.imageView3.frame)+ 10, self.view.bounds.size.width, 150);
        _imageView4 = [[UIImageView alloc] initWithFrame:frame];
        _imageView4.backgroundColor = [UIColor lightGrayColor];
        _imageView4.tag = 3;
    }
    return _imageView4;
}

- (UIButton *)startButton {
    if (_startButton == nil) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _startButton.frame = CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width * 0.5, 50);
        _startButton.backgroundColor = [UIColor orangeColor];
        [_startButton setTitle:@"开始" forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(s_startAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (UIButton *)cancleButton {
    if (_cancleButton == nil) {
        _cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleButton.frame = CGRectMake(CGRectGetMaxX(self.startButton.frame), self.view.bounds.size.height - 50, self.view.bounds.size.width * 0.5, 50);
        _cancleButton.backgroundColor = [UIColor blueColor];
        [_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleButton addTarget:self action:@selector(s_cancleAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

@end
