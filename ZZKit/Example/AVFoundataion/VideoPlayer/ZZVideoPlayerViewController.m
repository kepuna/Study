//
//  ZZVideoPlayerViewController.m
//  ZZKit
//
//  Created by MOMO on 2021/5/13.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZVideoPlayerViewController.h"

@interface ZZVideoPlayerViewController ()

@property (nonatomic, weak) id<ZZPlayerStateDelegate> delegate;

@end

@implementation ZZVideoPlayerViewController{
    CGRect              _contentFrame;
    NSDictionary        *_parameters;
    EAGLSharegroup      *_shareGroup;
}

+ (instancetype)playerWithVideoPath:(NSString *)path playerFrame:(CGRect)frame playerStateDelegate:(id<ZZPlayerStateDelegate>)delegate parameters:(NSDictionary *)parameters {
    return [[ZZVideoPlayerViewController alloc] initWithVideoPath:path playerFrame:frame playerStateDelegate:delegate parameters:parameters];
}

+ (instancetype)playerWithVideoPath:(NSString *)path playerFrame:(CGRect)frame playerStateDelegate:(id<ZZPlayerStateDelegate>)delegate parameters:(NSDictionary *)parameters outputEAGLContextShareGroup:(EAGLSharegroup *)shareGroup {
    return [[ZZVideoPlayerViewController alloc] initWithVideoPath:path playerFrame:frame playerStateDelegate:delegate parameters:parameters outputEAGLContextShareGroup:shareGroup];
}

- (instancetype)initWithVideoPath:(NSString *)path playerFrame:(CGRect)frame playerStateDelegate:(id)delegate parameters:(NSDictionary *)parameters
{
    return [self initWithVideoPath:path playerFrame:frame playerStateDelegate:delegate parameters:parameters outputEAGLContextShareGroup:nil];
}

- (instancetype)initWithVideoPath:(NSString *)path playerFrame:(CGRect)frame playerStateDelegate:(id)delegate parameters:(NSDictionary *)parameters outputEAGLContextShareGroup:(nonnull EAGLSharegroup *)shareGroup
{
    self = [super init];
    if (self) {
        _videoPath = path;
        _contentFrame = frame;
        _parameters = parameters;
        _delegate = delegate;
        _shareGroup = shareGroup;
        
        NSLog(@"++++++++ %@",_videoPath);
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
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
