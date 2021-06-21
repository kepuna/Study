//
//  ZZShortVideoTrimView.m
//  ZZKit
//
//  Created by donews on 2019/5/5.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZShortVideoTrimView.h"
#import "ZZVideoTrimFrameCell.h"
#import "ZZPublic.h"


@interface ZZShortVideoTrimView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger     currentCount;
@property (nonatomic, assign) NSInteger     imageCount;
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) UIImageView   *leftTrimView;
@property (nonatomic, strong) UIImageView   *rightTrimView;
@property (nonatomic, strong) UIView        *playIndicateBar; // 播放进度条
@property (nonatomic, strong) UILabel       *leftBeginLabel;
@property (nonatomic, strong) UILabel       *rightEndLabel;
@property (nonatomic, assign) CGFloat       cellHeight;
@property (nonatomic, assign) CGFloat       secondOffset;//多大的距离为1s
@property (nonatomic, assign) CGFloat       videoDuration;
@property (nonatomic, assign) CGFloat       tableWidth;

@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) double duration;

@end

@implementation ZZShortVideoTrimView

- (id)initWithFrame:(CGRect)frame videoDuration:(float)duration{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:UIColorFromRGBA(0x000000, 0.4)];
        self.tableWidth = SCREEN_WIDTH - 40;
        self.userInteractionEnabled = YES;
        self.videoDuration = duration;
        
  
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 0, 54, self.tableWidth) style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.bounces = NO;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.transform = CGAffineTransformMakeRotation(-M_PI/2);
        [self addSubview:self.tableView];
        [self.tableView registerClass:[ZZVideoTrimFrameCell class] forCellReuseIdentifier:[ZZVideoTrimFrameCell class].description];
        self.tableView.origin = CGPointMake(20,0);
        
        self.playIndicateBar = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 2, 54)];
        self.playIndicateBar.backgroundColor = [UIColor whiteColor];
        
        self.maskImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 167, 54)];
        [self.maskImageView setImage:[[UIImage imageNamed:@"shortVideo_trim1"] stretchableImageWithLeftCapWidth:11 topCapHeight:0]];
        [self.maskImageView setClipsToBounds:YES];
        [self addSubview:self.maskImageView];
        self.rightEndLabel = [[UILabel alloc] initWithFrame:self.maskImageView.bounds];
        self.rightEndLabel.userInteractionEnabled = YES;
        [self.rightEndLabel setTextColor:[UIColor whiteColor]];
        [self.rightEndLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.rightEndLabel setTextAlignment:NSTextAlignmentCenter];
        [self.rightEndLabel setBackgroundColor:UIColorFromRGBA(0xffffff, 0.3)];
        [self.maskImageView addSubview:self.rightEndLabel];
        [self.maskImageView addSubview:self.playIndicateBar];
        
        self.leftTrimView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, 33, 81)];
        self.leftTrimView.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.leftTrimView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.leftTrimView];
        self.leftTrimView.centerX = self.tableView.left;
        self.leftTrimView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panLeftTrimView = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleLeftPan:)];
        [self.leftTrimView addGestureRecognizer:panLeftTrimView];
        
        self.rightTrimView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width - self.leftTrimView.right, self.leftTrimView.top, self.leftTrimView.width, self.leftTrimView.height)];
        self.rightTrimView.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.rightTrimView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.rightTrimView];
        self.rightTrimView.centerX = self.tableView.right;
        self.rightTrimView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panRightTrimView = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleRightPan:)];
        [self.rightTrimView addGestureRecognizer:panRightTrimView];
        
        self.duration = duration;
        self.leftBeginLabel.text = @"0.0s";
        self.leftValue = 0.0;
        self.rightValue = duration;
        if (duration <= kMaxVideoDuration) {
            self.rightEndLabel.text = [self getTextFromeFloat:duration];
            self.secondOffset = self.tableWidth/duration;
            if (fabs(self.rightValue - 5.0) < 0.01) {
                self.rightEndLabel.textColor = UIColorFromRGB(0xff2f60);
            }else {
                self.rightEndLabel.textColor = [UIColor whiteColor];
            }
        }else{
            self.rightEndLabel.text = @"30.0s";
            self.rightEndLabel.textColor = UIColorFromRGB(0xff2f60);
            self.secondOffset = self.tableWidth/kMaxVideoDuration;
        }
        [self setMiddleMaskValue];
        self.maxWidth = self.maskImageView.width;
    }
    return self;
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
    [fileManager removeItemAtPath:imageDir error:nil];
}

#pragma mark - methods
- (NSInteger)setImagesWithVideo:(AVAsset *)video{
    self.imagePath = [self createPreviewImageDir]; // 存放视频解析后缩略图的文件夹
    CGFloat duration = CMTimeGetSeconds(video.duration);
    if (duration < kMaxVideoDuration) {
        self.imageCount = kDefaultImageCount;
    }else{
        self.imageCount = ceil(duration/(kMaxVideoDuration/kDefaultImageCount));
    }
    self.cellHeight = self.tableWidth / kDefaultImageCount;
    return self.imageCount;
}

- (void)setImageCount:(NSInteger)count{
    if (count <= 0) {
        return;
    }
    _imageCount = count;
    self.cellHeight = self.tableWidth / 17;
    [self.tableView reloadData];
}

- (NSUInteger)getCurrentIndex{
    if (self.currentCount == self.imageCount - 1) {
        return -1;
    }
    return self.currentCount;
}

- (void)reloadImageWithCount:(NSInteger)count{
    self.currentCount = count;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:count inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSString *)getMiddleText{
    float time = self.rightValue - self.leftValue;
    NSString *timeString = [NSString stringWithFormat:@"%.1fs",time];
    return timeString;
}

- (NSString *)getTextFromeFloat:(float)time{
    NSInteger minute = time/60;
    CGFloat second = time - minute*60;
    return [NSString stringWithFormat:@"%.1fs",second];
}

- (void)setLabelText{
    self.leftValue = (self.tableView.contentOffset.y + self.leftTrimView.centerX - self.tableView.left)/self.secondOffset;
    self.leftBeginLabel.text = [self getTextFromeFloat:self.leftValue];
    self.rightValue = (self.tableView.contentOffset.y + self.rightTrimView.centerX - self.tableView.left)/self.secondOffset;
    
    CGFloat duration = self.rightValue - self.leftValue;
    UIColor *rightEndLabelColor = (fabs(duration - 5.0) < 0.01 || fabs(duration - 30.0) < 0.01) ? UIColorFromRGB(0xff2f60) : [UIColor whiteColor];
    self.rightEndLabel.text = [self getTextFromeFloat:duration];
    self.rightEndLabel.textColor = rightEndLabelColor;
    [self setMiddleMaskValue];
}

- (void)setLeftLabelText{
    self.leftValue = (self.tableView.contentOffset.y + self.leftTrimView.centerX - self.tableView.left)/self.secondOffset;
    self.leftBeginLabel.text = [self getTextFromeFloat:self.leftValue];
    [self setMiddleMaskValue];
}

- (void)setMiddleMaskValue{
    self.maskImageView.left = self.leftTrimView.centerX - 2;
    self.maskImageView.width = self.rightTrimView.centerX - self.leftTrimView.centerX + 4;
    self.rightEndLabel.frame = self.maskImageView.bounds;
}

- (CGFloat)maskWidth:(CGFloat)centerX left:(BOOL)left{
    if (left) {
        return self.rightTrimView.centerX - centerX + 4;
    }
    return centerX - self.leftTrimView.centerX + 4;
}

- (void)setRightLabelText{
    self.rightValue = (self.tableView.contentOffset.y + self.rightTrimView.centerX - self.tableView.left)/self.secondOffset;
    self.rightEndLabel.text = [self getTextFromeFloat:self.rightValue];
    [self setMiddleMaskValue];
}

- (void)handleDelegate{
    if (self.delegate && [self.delegate respondsToSelector:@selector(trimControlDidChangeLeftValue:rightValue:)]) {
        [self.delegate trimControlDidChangeLeftValue:self.leftValue rightValue:self.rightValue];
    }
}

- (void)startPlayIndicateBarAnimationWithStartTime:(CGFloat)startTime {
    
    [self.playIndicateBar.layer removeAllAnimations];
    CGFloat animationDuration = self.rightValue - startTime;
    CGFloat animationOriginX = 10 + (self.maskImageView.width - 20) * (startTime - self.leftValue)/(self.rightValue - self.leftValue);
    [self.playIndicateBar setLeft:animationOriginX];
    
    NSLog(@"--animationOriginX=%lf",animationOriginX);
    NSLog(@"--animationDuration = %lf",animationDuration);
    [UIView animateWithDuration:animationDuration delay:0.05 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.playIndicateBar setLeft:self.maskImageView.width - 10];
    } completion:nil];
}

- (void)stopPlayIndicateBarAnimation {
    [self.playIndicateBar.layer removeAllAnimations];
}

#pragma mark - gesture
- (void)handleLeftPan:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan || gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        CGFloat leftCenterX = self.leftTrimView.centerX;
        if (self.leftTrimView.centerX > self.tableView.left || (self.leftTrimView.centerX <= self.tableView.left && translation.x > 0.0)) {
            if ((self.leftValue >= self.rightValue - kMinVideoDuration && translation.x < 0.0) || self.leftValue < self.rightValue - kMinVideoDuration) {
                if (self.leftTrimView.centerX + translation.x < self.tableView.left) {
                    leftCenterX = self.tableView.left;
                }else if (self.leftTrimView.centerX + translation.x > self.rightTrimView.centerX - kMinVideoDuration*self.secondOffset){
                    leftCenterX = self.rightTrimView.centerX - kMinVideoDuration*self.secondOffset;
                }else{
                    leftCenterX += translation.x;
                }
                if ([self maskWidth:leftCenterX left:YES] <= self.maxWidth) {
                    self.leftTrimView.centerX = leftCenterX;
                    [self setLabelText];
                }
            }
        }else{
            if ([self maskWidth:leftCenterX left:YES] <= self.maxWidth) {
                self.leftTrimView.centerX = leftCenterX;
                [self setLabelText];
            }
        }
        [gesture setTranslation:CGPointZero inView:self];
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        [self handleDelegate];
        [gesture setTranslation:CGPointZero inView:self];
    }
}

- (void)handleRightPan:(UIPanGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [gesture translationInView:self];
        CGFloat rightCenterX = self.rightTrimView.centerX;
        if (self.rightTrimView.centerX < self.tableView.right || (self.rightTrimView.centerX >= self.tableView.right && translation.x < 0.0)) {
            if((self.rightValue <= self.leftValue + kMinVideoDuration && translation.x > 0.0) || self.rightValue > self.leftValue + kMinVideoDuration){
                if (self.rightTrimView.centerX + translation.x > self.tableView.right) {
                    rightCenterX = self.tableView.right;
                }else if (self.rightTrimView.centerX + translation.x < self.leftTrimView.centerX + kMinVideoDuration*self.secondOffset){
                    rightCenterX = self.leftTrimView.centerX + kMinVideoDuration*self.secondOffset;
                }else{
                    rightCenterX += translation.x;
                }
                if ([self maskWidth:rightCenterX left:NO] <= self.maxWidth) {
                    self.rightTrimView.centerX = rightCenterX;
                    [self setLabelText];
                }
            }
        }else{
            if ([self maskWidth:rightCenterX left:NO] <= self.maxWidth) {
                self.rightTrimView.centerX = rightCenterX;
                [self setLabelText];
            }
        }
        [gesture setTranslation:CGPointZero inView:self];
    }else if (gesture.state == UIGestureRecognizerStateEnded){
        [self handleDelegate];
        [gesture setTranslation:CGPointZero inView:self];
    }
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self setLabelText];
    [self handleDelegate];
}

#pragma mark - UITableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imageCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZZVideoTrimFrameCell class].description forIndexPath:indexPath];
    if (indexPath.row < self.imageCount) {
        [((ZZVideoTrimFrameCell *)cell) setImageWithCount:indexPath.row imagePath:self.imagePath imageHeight:self.cellHeight];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
