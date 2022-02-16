//
//  MBCarStateButtonActionChain.h
//  MBCarRoom-iOS
//
//  Created by MOMO on 2020/7/9.
//

#import <Foundation/Foundation.h>
#import "MBCarStateButtonClickRequest.h"
NS_ASSUME_NONNULL_BEGIN

@protocol MBCarStateButtonActionChain <NSObject>

@property (nonatomic, strong) id <MBCarStateButtonActionChain> nextAction;

/// 抽象请求处理方法
- (void)processRequest:(MBCarStateButtonClickRequest *)request;

@end

NS_ASSUME_NONNULL_END
