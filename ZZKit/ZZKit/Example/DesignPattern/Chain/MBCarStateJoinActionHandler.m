//
//  MBCarStateJoinActionHandler.m
//  MBCarRoom-iOS
//
//  Created by MOMO on 2020/7/9.
//。加入车队

#import "MBCarStateJoinActionHandler.h"

@implementation MBCarStateJoinActionHandler
@synthesize nextAction = _nextAction;

//具体请求处理方法
- (void)processRequest:(MBCarStateButtonClickRequest *)request {
    
    if (request.gameState == MBCarRoomGameStateWaitJoin) { // 等待加入的状态
         NSLog(@"✅ 队员点击 - 加入 - ");
    } else {
        // 交给下一个处理
        [self.nextAction processRequest:request];
    }
}
@end
