//
//  RHCRealTimeLogManager.m
//  RenrenOfficial-iOS-Concept
//
//  Created by wangyang on 15/6/6.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import "RHCRealTimeLogManager.h"

#define RHCRealTimeKeyRecords @"rtRecords"
NSString * const kRealTimeLogFileName = @"RRRealTimeOfficialLog.plist";  // log持久化的文件

@interface RHCRealTimeLogManager ()

@property (nonatomic, strong) NSMutableDictionary *bufferDict; // 缓存字典
@property (nonatomic, strong) NSTimer *countTimer; //
@property (nonatomic, assign) BOOL isSending; // 数据是否正在发送
@property (nonatomic, assign) BOOL isPersisting; // 是否要持久化

@end

@implementation RHCRealTimeLogManager

static RHCRealTimeLogManager *logManager;
+ (RHCRealTimeLogManager *)sharedRTLogManager {
    if (!logManager) {
        @synchronized(self) {
            if (!logManager) {
                logManager = [[RHCRealTimeLogManager alloc] init];
            }
        }
    }
    return logManager;
}

+ (id)allocWithZone:(NSZone *)zone{
    if (!logManager) {
        logManager = [super allocWithZone:zone];
        return logManager;
    }
    return nil;
}

// 沙盒下Documents文件夹的路径
- (NSString *)AppUser_documentPath {
    NSArray  *searchPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [searchPath objectAtIndex:0];
    return path;
}

- (id)init{
    if (self = [super init]) {
        NSString *path = [self AppUser_documentPath]; //[AppUser documentPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        // 1 获取这个path下的文件列表，因为有多个文件、文件夹
        NSArray *fileList = [fileManager contentsOfDirectoryAtPath:path error:&error];
        
        if (fileList) {
            for (NSString *filename in fileList) {
                // 2 找到文件名包含 rtRecords的文件，然后删除掉
                if ([filename rangeOfString:@"rtRecords"].length > 0) {
                    NSString *deleteFile = [NSString stringWithFormat:@"%@/%@", path, filename];
                    [fileManager removeItemAtPath:deleteFile error:&error];
                }
            }
        }
        // 3 创建一个缓存字典
        self.bufferDict = [NSMutableDictionary dictionaryWithDictionary:[self restore]];
        // 4 从缓存字典中获取 key为 rtRecords的value & 完成records数组的初始化
        NSArray *records = [_bufferDict valueForKey:RHCRealTimeKeyRecords];
        if (!records) {
            records = [NSMutableArray new];
        } else {
            records = [NSMutableArray arrayWithArray:records];
        }
        // 把数据存入缓存字典 key（rtRecords） -》value（records数组）
        [_bufferDict setValue:records forKey:RHCRealTimeKeyRecords];
    }
    return self;
}


#pragma mark - Public method
- (void)addRecordWithIdentifier:(NSString *)indentifier
                         LParam:(NSString *)lParam
                         RParam:(NSString *)rParam
                          exTra:(NSString *)extra {
    //防止传null
    if (indentifier == nil) {
        indentifier = @"";
    }
    if (lParam == nil) {
        lParam = @"";
    }
    if (rParam == nil) {
        rParam = @"";
    }
    if (extra == nil) {
        extra = @"";
    }
    NSString *logString = [NSString stringWithFormat:@"%@|%@|%@|%@",indentifier,lParam,rParam,extra];
    // 获取到之前缓存的log数据
    NSMutableArray *logArray = [self.bufferDict objectForKey:RHCRealTimeKeyRecords];
    @synchronized(logArray){
        [logArray addObject:logString];
        @synchronized (self.bufferDict) {
            [self.bufferDict setValue:logArray forKey:RHCRealTimeKeyRecords];
        }
//        if (ReachableViaWiFi == [APPCONTEXT.netReachability currentReachabilityStatus]) {//wifi下直接发送
        if (1) {
            [self sendData];
        } else {
            [self persist];
            [self starTimer]; // 开启定时器
        }
    }
}

// 持久化方法
- (void)persist {
    if (self.isPersisting) {
        return;
    }
    NSDictionary *dict = nil;
    @synchronized (self.bufferDict) {
        dict = [NSDictionary dictionaryWithDictionary:self.bufferDict];
    }
    [self persistLogData:dict];
}

// 对数据进行持久化存储
- (void)persistLogData:(NSDictionary *)dataDict {
    self.isPersisting = YES;
    NSString *persistantfilePath = [[self AppUser_commonPath] stringByAppendingPathComponent:kRealTimeLogFileName];
    if (persistantfilePath && dataDict) {
        unlink([persistantfilePath UTF8String]);
        [dataDict writeToFile:persistantfilePath atomically:YES];// 将数据字段存入persistantfilePath路径
    }
    self.isPersisting = NO;
}

// 公共文件夹路径
- (NSString *)AppUser_commonPath {
    
    // 在沙盒Documents文件夹下创建common文件夹
    NSString *path = [[self AppUser_documentPath] stringByAppendingPathComponent:@"common"];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    if (![fileMgr fileExistsAtPath:path]) { // 如果common文件夹不存在 则通过createDirectoryAtPath创建common文件夹
        NSError *error = nil;
        [fileMgr createDirectoryAtPath:path
            withIntermediateDirectories:YES
                             attributes:nil
                                  error:&error];
        [self addSkipBackupAttributeToItemAtPath:path];
        if (error) {
            // 创建common文件夹失败
            //            LOG_INFO(@"创建 commonPath 失败 %@", error);
        }
    }
    return path;
}

/// 跳过备份
/*
 - (BOOL)setResourceValue:(id)value forKey:(NSString *)key error:(NSError **)error
 
 如果我们的APP需要存放比较大的文件的时候，同时又不希望被系统清理掉，那我么我们就需要把我们的资源保存在Documents目录下
 但是我们又不希望他会被iCloud备份, 因此就有了这个方法
 
 [URL setResourceValue: [NSNumber numberWithBool: YES] forKey: NSURLIsExcludedFromBackupKey error: &error];
 
 NSURLIsExcludedFromBackupKey：不被备份；
 
 */
- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString
{
    NSURL* URL= [NSURL fileURLWithPath: filePathString];
    if(![[NSFileManager defaultManager] fileExistsAtPath: [URL path]]){
        return NO;
    }
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

- (NSDictionary *)restore{
    // 在common文件夹下添加 kRealTimeLogFileName 的plist文件
    NSString *persistantfilePath = [[self AppUser_commonPath] stringByAppendingPathComponent:kRealTimeLogFileName];
    if (persistantfilePath) { // 持久化文件路径
        // dictionaryWithContentsOfFile:方法的功能是创建一个字典，将字典中的内容设置为指定文件中的所有内容
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:persistantfilePath];
        return dict;
    }
    return nil;
}
#pragma mark - Private method
- (void)sendData{
    if (self.isSending) {
        [self persist];
        return;
    }
    self.isSending = YES;
    NSMutableArray *dataArray = nil;
    @synchronized(self.bufferDict){
        dataArray = [NSMutableArray arrayWithArray:[self.bufferDict valueForKey:RHCRealTimeKeyRecords]];
        [self.bufferDict setValue:[NSMutableArray array] forKey:RHCRealTimeKeyRecords]; //清空缓存字典
    }
  
    NSMutableString *logString = [[NSMutableString alloc]init];
    NSUInteger count = 0;
    if (dataArray.count == 0) {
        self.isSending = NO;
        return;
    }
    for (NSString *log in dataArray) {
        
        [logString appendString:log];
        count++;
        if (count != dataArray.count) {
            [logString appendString:@"."];
        }
    }
    if (logString.length == 0) {
        self.isSending = NO;
        return ;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(3);
        [self stopTimer];
        [self persist];
        if (dataArray.count > 0) {
            self.isSending = NO;
            [self sendData];
        }
        
    });
    // 发送数据
//    [request sendCommonRequest:statisticStr param:param onComplete:^(NSInteger errorNum, NSDictionary *info, extError *errorMsg) {
//
//        if (errorNum == kRSBaseRequestSuccess) {
//            [weakSelf stopTimer];
//            [weakSelf persist];
//            if (dataArray.count > 0) {
//                weakSelf.isSending = NO;
//                [weakSelf sendData];
//            }
//        }else{
//            @synchronized(weakSelf.bufferDict){
//                NSMutableArray *oldDataArray = [self.bufferDict objectForKey:RHCRealTimeKeyRecords];
//                [oldDataArray addObjectsFromArray:dataArray];
//                [weakSelf.bufferDict setValue:oldDataArray forKey:RHCRealTimeKeyRecords];
//            }
//            [weakSelf persist];
//            [weakSelf starTimer];
//        }
//
//    }];
}

- (void)starTimer{
    
    if (self.countTimer) {
        return;
    }
    self.countTimer = [NSTimer timerWithTimeInterval:600.0 target:self selector:@selector(sendLog) userInfo:nil repeats:NO];
    NSRunLoop *main=[NSRunLoop currentRunLoop];
    [main addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}
- (void)stopTimer{
    if (self.countTimer) {
        [self.countTimer invalidate];
        self.countTimer = nil;
    }
}
- (void)sendLog {
    [self stopTimer];
    [self sendData];
}

- (void)sendBackUpDataWithDic:(NSMutableDictionary *)dic{
    
//    [dic setValue:@(APPCONTEXT.currentUser.userID) forKey:@"userID"];
//    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
//    [formatter1 setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    NSString *endTimeString = [formatter1 stringFromDate:[NSDate date]];
//    [dic setValue:endTimeString forKey:@"createTime"];
//    MKNetworkOperation *network = [[MKNetworkOperation alloc] initWithURLString:[NSString stringWithFormat:@"https://ios.%@/index.php/cs/evidence",APPCONFIG.baseHost] params:dic httpMethod:@"POST" timeOut:15];
//    [network addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        NSDictionary *resJson = [completedOperation responseJSON];
//        NSNumber *success = [resJson objectForKey:@"success"];
//        if (success) {
//        }
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//
//    }];
//    [APPCONTEXT.networkEngine enqueueOperation:network];
}
@end
