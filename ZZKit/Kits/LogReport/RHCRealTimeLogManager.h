//
//  RHCRealTimeLogManager.h
//  RenrenOfficial-iOS-Concept
//
//  Created by wangyang on 15/6/6.
//  Copyright (c) 2015年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHCRealTimeLogManager : NSObject

@property (nonatomic, assign) BOOL isFromPublishHint;

+ (RHCRealTimeLogManager *)sharedRTLogManager;

- (void)addRecordWithIdentifier:(NSString *)indentifier
                         LParam:(NSString *)lParam
                         RParam:(NSString *)rParam
                          exTra:(NSString *)extra;
- (void)sendData;
/// 发送要备份的数据
- (void)sendBackUpDataWithDic:(NSMutableDictionary *)dic;
@end
