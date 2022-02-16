//
//  ZZThread8ViewController.m
//  ZZKit
//
//  Created by donews on 2019/7/12.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZThread8ViewController.h"
#import "ZZDownloadImage.h"

static int const  kImageViewTag = 1990;

@interface ZZThread8ViewController ()<ZZDownloadImageDelegate>

@end

@implementation ZZThread8ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    for (int i = 0; i < 6; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, i*105, 100, 100)];
        imgView.tag = i + kImageViewTag;
        imgView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:imgView];
    }
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 100, 100, 100)];
    imgView.backgroundColor = [UIColor lightGrayColor];
    imgView.tag = 1234;
    [self.view addSubview:imgView];
    NSLog(@"%@",NSHomeDirectory());
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(100, 200, 100, 40);
    [button1 setTitle:@"多图下载" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(100, 250, 100, 40);
    [button2 setTitle:@"单图下载" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.frame = CGRectMake(100, 300, 100, 40);
    [button3 setTitle:@"清空" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button3];
    
    [button1 addTarget:self action:@selector(clickLoadImages:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(clickLoadSingalImage:) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(cleanAll:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)downloadImageFinishedWith:(UIImage*)image andTag:(int)tag withQueueTag:(int)queueTag{
    NSLog(@">>>>tag= %d---queueTag=%d",tag,queueTag);
    
    if (queueTag == 0) {
        UIImageView *img = [self.view viewWithTag:tag];
        img.image = image;
    } else if (queueTag == 1) {
        UIImageView *imgV = [self.view viewWithTag:1234];
        imgV.image = image;
    }
}

- (void)clickLoadImages:(UIButton *)sender {
    
    //下载多张图片
    ZZDownloadImage *download = [ZZDownloadImage downloadImageWithUrlStrArray:@[@"http://img.hb.aicdn.com/6e004cb3c5f58f016a57b90f8bbb93d7075453f2efd0-anTckt_fw658",@"http://img.hb.aicdn.com/fb18b522caf2821adb7af96f8656787f8d9bdad31bdec-6f6h4X_fw658",@"http://img.hb.aicdn.com/22e4dfd8d135de7ae0d451e351c00bddf732919920840-BMRw4Z_fw658",@"http://img.hb.aicdn.com/536c96af48b38faca5bcad20ba0ea6aba8929b711e5b4-lvdBlI_fw658",@"http://img.hb.aicdn.com/055e5458bd340a52ca0067f5d7c22b6c3b18d119292ae-QLEsYp_fw658",@"http://img.hb.aicdn.com/b50481ab8a2b4e3587068df0552ebad08409f0b3ca23-8gBQ9x_fw658"] withStartTag:kImageViewTag];
    //设置并发数
    download.maxOperationCount = 3;
    download.tag = 0;
    download.delegate = self;
    /*   block 回调 结果
     download.downloadFinishedBlock = ^(UIImage *image,int tag,int queueTag) {
     UIImageView *img = [self.view viewWithTag:tag];
     img.image = image;
     NSLog(@"jicia====%d",tag);
     };
     */
    //开始下载
    [download starDownloadImage];
}

- (void)clickLoadSingalImage:(UIButton *)sender {
    
    //单张下载
    
    ZZDownloadImage *down = [ZZDownloadImage downloadImageWithUrlStr:@"http://img.hb.aicdn.com/b50481ab8a2b4e3587068df0552ebad08409f0b3ca23-8gBQ9x_fw658"];
    down.tag = 1;
    down.delegate = self;
    
    /*   block 回调 结果
     down.downloadFinishedBlock = ^(UIImage *image,int tag,int queueTag) {
     UIImageView *imgV = [self.view viewWithTag:1234];
     imgV.image = image;
     };
     */
    [down starDownloadImage];
    
}

- (void)cleanAll:(UIButton *)sender {
    
    for (int i = 0; i < 6; i++) {
        UIImageView *imgView = [self.view viewWithTag:i + kImageViewTag];
        imgView.image = nil;
    }
    UIImageView *imgView = [self.view viewWithTag:1234];
    imgView.image = nil;
    
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
