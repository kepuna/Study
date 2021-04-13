//
//  MBCarStateDriveActionHandler.m
//  MBCarRoom-iOS
//
//  Created by MOMO on 2020/7/9.
//

#import "MBCarStateDriveActionHandler.h"

@implementation MBCarStateDriveActionHandler
@synthesize nextAction = _nextAction;

//具体请求处理方法
- (void)processRequest:(MBCarStateButtonClickRequest *)request {
    if (request.gameState == MBCarRoomGameStateDrive) {
        NSLog(@"✅ 点击发车 - MBCarRoomGameStateDrive 处理");
    } else {
        // 交给下一个处理
        [self.nextAction processRequest:request];
    }
}
@end
