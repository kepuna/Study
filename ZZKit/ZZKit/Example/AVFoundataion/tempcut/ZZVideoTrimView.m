//
//  ZZVideoTrimView.m
//  ZZKit
//
//  Created by donews on 2019/4/29.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZVideoTrimView.h"
#import "AVVideoCutDragView.h"
#import "ZZVideoTrimFrameCell.h"
#import "ZZPublic.h"

static const CGFloat pEditTableViewH = 50;
static const CGFloat pEditTableViewY = 0;
static const CGFloat pBorderViewH = 2;
static const CGFloat pEditTableViewMargin = 20;
static const CGFloat pBorderX = 45;
static const CGFloat pDragViewOffset = 50;

#define EDGE_EXTENSION_FOR_THUMB 20

#define kMaxVideoDuration 15.0  // 视频时长最大限制
#define kMinVideoDuration 2.0 // 视频时长最小限制
#define kDefaultImageCount 10.0 // 默认视频拆分帧数


@interface ZZVideoTrimView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *editTableView;

@property (nonatomic, strong) UIView *topBorderView;
@property (nonatomic, strong) UIView *bottomBorderView;
@property (nonatomic, strong) AVVideoCutDragView *leftDragView; // 左右拖拽截取的条
@property (nonatomic, strong) AVVideoCutDragView *rightDragView;
@property (nonatomic, strong) UIView *progressBar; // 播放进度的bar

//@property (nonatomic, strong) AVAssetImageGenerator *generator;
//@property (nonatomic, strong) AVURLAsset *videoAsset;

@property (nonatomic, assign) CGFloat IMG_Width; // 视频帧宽度

//@property (nonatomic, strong) NSURL *videoUrl; // 视频帧宽度

//----------
//@property (nonatomic)
@property (nonatomic, assign) CGFloat tableViewWidth;
@property (nonatomic, assign) float duration; // 视频时长
@property (nonatomic, assign) NSInteger imageFrameCount; // 拆分后视频帧的数量
@property (nonatomic, assign) NSInteger fps; // 每秒帧率
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) NSInteger currentCount; // 当前某一帧的下标
//@property (nonatomic, strong) NSTimer *progressBarMoveTimer;

@property (nonatomic, assign) CGFloat startPointX;    // 编辑框起始点
@property (nonatomic, assign) CGFloat endPointX;      // 编辑框结束点
@property (nonatomic, assign) CGFloat linePositionX;  // 播放条的位置


@property (nonatomic, assign) CGFloat rightValue;  //
@property (nonatomic, assign) CGFloat leftValue;

@end

@implementation ZZVideoTrimView

//- (instancetype)initWithFrame:(CGRect)frame {
- (instancetype)initWithFrame:(CGRect)frame duration:(Float64)duration {
    self = [super initWithFrame:frame];
    if (self) {
        self.rightValue = duration;
        self.leftValue = 0.0f;
        
        self.IMG_Width = (self.width - 100) / 10; //初始化视频帧宽度
        self.tableViewWidth = self.width - pBorderX * 2;
        self.cellHeight = self.tableViewWidth / kDefaultImageCount;
        self.imagePath = [self createPreviewImageDir]; // 创建存放缩略图的文件夹
        
        self.startPointX = pBorderX;
        self.endPointX = self.width - pBorderX;
        
        [self addSubview:self.editTableView];
        [self addSubview:self.topBorderView];  // 添加编辑框上下边线
        [self addSubview:self.bottomBorderView];
        [self addSubview:self.leftDragView]; // 裁剪时左右拖拽截取的条
        [self addSubview:self.rightDragView];
        [self addSubview:self.progressBar];
    }
    return self;
}


- (NSUInteger)getCurrentIndex{

    if (self.currentCount == self.imageFrameCount - 1) {
        return -1;
    }
    return self.currentCount;
}

- (void)setImageCount:(NSInteger)count {
    if (count <= 0) {
        return;
    }
    _imageFrameCount = count;
    self.cellHeight = self.tableViewWidth / kDefaultImageCount;
    [self.editTableView reloadData];
}

- (NSInteger)imageFrameCountWithVideo:(AVURLAsset *)video {
//- (NSInteger)setImagesWithVideo:(AVURLAsset *)video {
    
    Float64 duration = CMTimeGetSeconds(video.duration); // 获取视频总秒数
    if (duration < kMaxVideoDuration) { // 拆分视频帧的规则
        self.imageFrameCount = kDefaultImageCount;
    } else {
        Float64 perFrameSecond = kMaxVideoDuration / kDefaultImageCount ;// 最大限制时视频每一帧占的时间秒数 = 最大限制秒数 / 默认视频拆分帧数
        self.imageFrameCount = ceil(duration/perFrameSecond); // 视频拆解后的帧数量 = 视频总秒数 / 最大限制时视频每一帧占的时间秒数
    }
    return self.imageFrameCount;
}

- (void)reloadImageAtIndex:(NSInteger)index {
    self.currentCount = index;
    [self.editTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSString*)createPreviewImageDir{
    [self removePreviewImageDir];
    NSString *imageDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/Caches/PreviewPictures"];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ){
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return imageDir;
}

- (void)removePreviewImageDir{
    NSString *imageDir = [NSTemporaryDirectory() stringByAppendingPathComponent:@"/Caches/PreviewPictures"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:imageDir]) {
        [fileManager removeItemAtPath:imageDir error:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageFrameCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZVideoTrimFrameCell class].description forIndexPath:indexPath];
    if (indexPath.row < self.imageFrameCount) {
        [((ZZVideoTrimFrameCell *)cell) setImageWithCount:indexPath.row imagePath:self.imagePath imageHeight:self.cellHeight];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

- (void)startPlayIndicateBarAnimationWithStartTime:(CGFloat)startTime {
    self.progressBar.hidden = NO;
//    [self.progressBar.layer removeAllAnimations];
    CGFloat animationDuration = self.rightValue - startTime;
    CGFloat maskDistance = self.endPointX - self.startPointX;
    
    CGFloat animationOriginX = 10 + (maskDistance - 20) * (startTime - self.leftValue)/(self.rightValue - self.leftValue);
    
    
//    NSLog(@"-----animationDuration = %lf",animationDuration);
//    NSLog(@"-----maskDistance = %lf ",maskDistance);
//    [self.progressBar setLeft:animationOriginX];
//    self.progressBar.left = self.startPointX;
    
//    [self.progressBar setLeft:50];
//     [UIView setAnimationsEnabled:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"线程 %@",[NSThread currentThread]);
        [UIView animateWithDuration:5.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            //        [self.progressBar setLeft:300];
            self.progressBar.frame = CGRectMake(self.endPointX, pEditTableViewY, 3, pEditTableViewH);
        } completion:nil];
    });
 
    
//     self.progressBarMoveTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(s_progressBarMoveAction) userInfo:nil repeats:YES];
}

//- (void)s_progressBarMoveAction {
////    NSLog(@"111111111111111");
//
//    double duarationTime = (self.endPointX - self.startPointX - 20) / SCREEN_WIDTH * 10;
//
////     NSLog(@"========%lf",duarationTime);
//    self.linePositionX += 0.01 * (self.endPointX - self.startPointX-20)/duarationTime;
//    if (self.linePositionX >= CGRectGetMinX(self.rightDragView.frame)-3) {
//        self.linePositionX = CGRectGetMaxX(self.leftDragView.frame)+3;
//    }
//    self.progressBar.frame = CGRectMake(self.linePositionX, pEditTableViewY, 3, pEditTableViewH);
//}

#pragma mark - Getters & Setters
- (UITableView *)editTableView {
    if (_editTableView == nil) {
        _editTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, pBorderX, pEditTableViewH, self.tableViewWidth) style:UITableViewStylePlain];
        _editTableView.dataSource = self;
        _editTableView.delegate = self;
        _editTableView.bounces = NO;
        _editTableView.showsVerticalScrollIndicator = NO;
        _editTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _editTableView.backgroundColor = [UIColor clearColor];
        _editTableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        _editTableView.origin = CGPointMake(40,0);
        [_editTableView registerClass:[ZZVideoTrimFrameCell class] forCellReuseIdentifier:[ZZVideoTrimFrameCell class].description];
    }
    return _editTableView;
}

- (UIView *)topBorderView {
    if (_topBorderView == nil) {
        _topBorderView = [[UIView alloc] initWithFrame:CGRectMake(pBorderX, 0, SCREEN_WIDTH - 2 * pBorderX, pBorderViewH)];
        _topBorderView.backgroundColor = [UIColor whiteColor];
    }
    return _topBorderView;
}

- (UIView *)bottomBorderView {
    if (_bottomBorderView == nil) {
        _bottomBorderView = [[UIView alloc] initWithFrame:CGRectMake(pBorderX, CGRectGetMaxY(self.editTableView.frame) - pBorderViewH, self.topBorderView.bounds.size.width, self.topBorderView.bounds.size.height)];
        _bottomBorderView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomBorderView;
}

- (AVVideoCutDragView *)leftDragView {
    if (_leftDragView == nil) {
        _leftDragView = [[AVVideoCutDragView alloc] initWithFrame:CGRectMake(-(SCREEN_WIDTH - pDragViewOffset), pEditTableViewY, SCREEN_WIDTH, pEditTableViewH) Left:YES];
        _leftDragView.hitTestEdgeInsets = UIEdgeInsetsMake(0, -EDGE_EXTENSION_FOR_THUMB, 0, -EDGE_EXTENSION_FOR_THUMB);
    }
    return _leftDragView;
}

- (AVVideoCutDragView *)rightDragView {
    if (_rightDragView == nil) {
        _rightDragView = [[AVVideoCutDragView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - pDragViewOffset), pEditTableViewY, SCREEN_WIDTH, pEditTableViewH) Left:NO];
    }
    return _rightDragView;
}

- (UIView *)progressBar {
    if (_progressBar == nil) {
        _progressBar = [[UIView alloc] initWithFrame:CGRectMake(pEditTableViewMargin, pEditTableViewY, 3, pEditTableViewH)];
        _progressBar.backgroundColor =  [UIColor colorWithRed:214/255.0 green:230/255.0 blue:247/255.0 alpha:1.0];
        _progressBar.hidden = YES;
    }
    return _progressBar;
}

@end
