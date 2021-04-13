//
//  MBCarStateEndDriveActionHandler.m
//  MBCarRoom-iOS
//
//  Created by MOMO on 2020/7/9.
//

#import "MBCarStateEndDriveActionHandler.h"

@implementation MBCarStateEndDriveActionHandler
@synthesize nextAction = _nextAction;

//具体请求处理方法
- (void)processRequest:(MBCarStateButtonClickRequest *)request {
    if (request.gameState == MBCarRoomGameStateGaming) { // 已发车游戏中
        NSLog(@"✅ 点击结束发车 - MBCarRoomGameStateDriving 处理");
    } else {
        // 交给下一个处理
        [self.nextAction processRequest:request];
    }
}
@end
