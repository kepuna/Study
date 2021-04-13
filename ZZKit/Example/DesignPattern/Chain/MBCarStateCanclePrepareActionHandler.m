//
//  MBCarStateCanclePrepareActionHandler.m
//  MBCarRoom-iOS
//
//  Created by MOMO on 2020/7/9.
//

#import "MBCarStateCanclePrepareActionHandler.h"

@implementation MBCarStateCanclePrepareActionHandler
@synthesize nextAction = _nextAction;

//具体请求处理方法
- (void)processRequest:(MBCarStateButtonClickRequest *)request {
    
    if (request.gameState == MBCarRoomGameStateWaitPrepare && request.isPrepared) { // 队员视角 -  如果是待队员准备状态 && 已准备， 所以可以取消准备
        NSLog(@"✅ 队员点击 - 取消准备 - ");
    } else {
        // 交给下一个处理
        [self.nextAction processRequest:request];
    }
}

@end
