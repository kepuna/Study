//
//  MMLog.m
//  HighPerformance
//
//  Created by MOMO on 2021/3/3.
//  Copyright © 2021 HelloWorld. All rights reserved.
//

#import "MMLog.h"
#import "MMLogView.h"

static NSString * const MMLogFileName = @"MMLogInfo.log";

#define MMWeakSelf __weak typeof(self) weakSelf = self;
#define MMStrongSelf __strong typeof(weakSelf) self = weakSelf;

@interface MMLog ()

@property (nonatomic, strong) MMLogView *logView;

@property (nonatomic, strong) NSTimer *time;

@property(nonatomic, assign) BOOL logEnabled;

@property (nonatomic, assign) NSInteger index;

@end

@implementation MMLog

+ (instancetype)shareLog {
    static MMLog *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MMLog alloc] init];
//        [log readCarshInfo];
    });
    return _instance;
}

+ (void)setLogEnabled:(BOOL)enable {
    [MMLog shareLog].logEnabled = enable;
    [MMLog startRecord];
}

+ (void)changeVisible {
    if (![MMLog shareLog].logEnabled) {
        return;
    }
    
#if DEBUG
    MMLog *log = [MMLog shareLog];
    log.time ? [log hideLogView] : [log showLogView];
#else
#endif
}

#pragma mark - Private Method

//void UncaughtExceptionHandler(NSException *exception) {
//
//    NSArray *arr = [exception callStackSymbols];
//    NSString *reason = [exception reason];
//    NSString *name = [exception name];
//
//    NSString *crashInfo = [NSString stringWithFormat:@"Crash date: %@ \nNexception type: %@ \nCrash reason: %@ \nStack symbol info: %@ \n",[[DCLog shareLog] getCurrentDate], name, reason, arr];
//
//    [[DCLog shareLog] saveCrashInfo:crashInfo];
//}

+ (void)startRecord {
    if ([MMLog shareLog].logEnabled == YES) {

#if DEBUG
//        NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
        [[MMLog shareLog] _cacheLog];
#else
#endif
    }
}

- (void)_cacheLog {
    
    NSString *filePath = [self _filePathWithName:MMLogFileName];
    [[NSFileManager defaultManager]removeItemAtPath:filePath error:nil];
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"SIMULATOR DEVICE");
#else
    freopen([filePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stdout); //c printf
    freopen([filePath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr); //oc  NSLog
#endif
    
}

- (NSString *)_readLog {
    NSData *fileData = [NSData dataWithContentsOfFile:[self _filePathWithName:MMLogFileName]];
    NSString *log = [[NSString alloc]initWithData:fileData encoding:NSUTF8StringEncoding];
    return [self deleteCharacters:log];
//    NSLog(@"XXXXXX = %@",log);
    
//    \d{4}[年|-|.]\d{1-12}[月|-|.]\d{1-31}日?
//    return log;
}

- (NSString *)deleteCharacters:(NSString *)targetString{
    
    if (targetString.length==0 || !targetString) {
        return nil;
    }
    
    NSError *error = nil;
    NSString *pattern = @"((((19|20)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((19|20)\d{2})-(0?[469]|11)-(0?[1-9]|[12]\d|30))|(((19|20)\d{2})-0?2-(0?[1-9]|1\d|2[0-8])))";//正则取反
    NSRegularExpression *regularExpress = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];//这个正则可以去掉所有特殊字符和标点
    NSString *string = [regularExpress stringByReplacingMatchesInString:targetString options:0 range:NSMakeRange(0, [targetString length]) withTemplate:@""];
    
    return string;
}


- (void)showLogView {
    
    [UIView animateWithDuration:0.4 animations:^{
        self.logView.alpha = 1.0f;
    }];
    self.time = [NSTimer scheduledTimerWithTimeInterval:0.35 target:self selector:@selector(refreshLogText) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.time forMode:NSRunLoopCommonModes];

    MMWeakSelf;
    [self.logView setIndexBlock:^(NSInteger index) {
        MMStrongSelf;
        self.index = index;
    }];

    [self.logView setCleanButtonIndexBlock:^(NSInteger index) {
        MMStrongSelf;
        if (index == 0) {
            [[NSFileManager defaultManager] removeItemAtPath:[self _filePathWithName:MMLogFileName] error:nil];
            [self _cacheLog];
        }else if (index == 1) {
            [[NSFileManager defaultManager] removeItemAtPath:[self _filePathWithName:MMLogFileName] error:nil];
        }
    }];
  
}

- (void)hideLogView {
    
    [UIView animateWithDuration:0.4 animations:^{
        self.logView.alpha = 0.0f;
    }];
    [self.time invalidate];
    self.time = nil;
}

- (void)refreshLogText {
    if (self.index == 0) {
        [self.logView updateLog:[self _readLog]];
    } else if (self.index == 1) {
//        [self.logView updateLog:[self readCarshInfo]];
    }
}

- (NSString *)_filePathWithName:(NSString *)fileName {
    NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return[documentDirPath stringByAppendingPathComponent:fileName];
}

- (NSDate *)_getCurrentDate {
    NSDate *now = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger seconds = [zone secondsFromGMTForDate:now];
    return [now dateByAddingTimeInterval:seconds];
}


#pragma mark - Getters

- (MMLogView *)logView {
    
    if (!_logView) {
        _logView = [[MMLogView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _logView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [[UIApplication sharedApplication].keyWindow addSubview:self.logView];
        _logView.alpha = 0.0f;
    }
    return _logView;
}



@end
