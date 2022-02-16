//
//  ZZServiceManager.h
//  ZZMedia
//
//  Created by MOMO on 2020/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZServiceManager : NSObject

+ (ZZServiceManager *)sharedFYIServiceManager;

- (void)requestDataWithTextString:(NSString *)text
                             data:(void (^)(id response))data;

@end

NS_ASSUME_NONNULL_END
