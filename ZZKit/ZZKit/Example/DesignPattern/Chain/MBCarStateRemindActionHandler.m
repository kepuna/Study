//
//  MBCarStateRemindActionHandler.m
//  MBCarRoom-iOS
//
//  Created by MOMO on 2020/7/9.
//

#import "MBCarStateRemindActionHandler.h"

@implementation MBCarStateRemindActionHandler
@synthesize nextAction = _nextAction;

//具体请求处理方法
- (void)processRequest:(MBCarStateButtonClickRequest *)request {
    if (request.gameState == MBCarRoomGameStateWaitJoin) { // 提醒队员加入
        NSLog(@"✅ 点击提醒用户准备 - MBCarRoomGameStateWaitJoin 待加入处理");
    } else {
        // 交给下一个处理
        [self.nextAction processRequest:request];
    }
}
@end
