//
//  ZZCommonModuleContext.h
//  ZZKit
//
//  Created by MOMO on 2021/10/20.
//  Copyright © 2021 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCommonModuleContext : NSObject

@property (nonatomic, weak)   UIView            *inView;
@property (nonatomic, weak)   UIViewController  *inVC;

@property (nonatomic, copy)   NSString     *businessID;
@property (nonatomic, strong) NSDictionary *sourceInfo;
@property (nonatomic, strong) id           extraObj;

// 是否是小窗
@property (nonatomic, assign, getter=isSuspension) BOOL suspension;

@end

NS_ASSUME_NONNULL_END
