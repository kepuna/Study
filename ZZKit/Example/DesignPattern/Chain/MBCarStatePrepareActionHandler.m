//
//  MBCarStatePrepareActionHandler.m
//  MBCarRoom-iOS
//
//  Created by MOMO on 2020/7/9.
//

#import "MBCarStatePrepareActionHandler.h"

@implementation MBCarStatePrepareActionHandler
@synthesize nextAction = _nextAction;

//具体请求处理方法
- (void)processRequest:(MBCarStateButtonClickRequest *)request {
    
     NSLog(@"✅ 队员点击 - 准备 ");
    
    if (request.gameState == MBCarRoomGameStateWaitPrepare && !request.isPrepared) { // 队员视角 -  如果是待队员准备状态
        NSLog(@"✅ 队员点击 - 准备 - ");
    } else {
        // 交给下一个处理
        [self.nextAction processRequest:request];
    }
}

@end
