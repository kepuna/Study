//
//  ZZCommonModuleContext.h
//  ZZMedia
//
//  Created by MOMO on 2020/8/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCommonModuleContext : NSObject

@property (nonatomic, weak)   UIView            *inView;
@property (nonatomic, weak)   UIViewController  *inVC;
@property (nonatomic, assign) NSInteger         atIndex;

@property (nonatomic, assign, getter=isSuspension) BOOL suspension;

@property (nonatomic, copy)   NSString     *businessID;
@property (nonatomic, strong) NSDictionary *sourceInfo;
@property (nonatomic, strong) id           extraObj;

@end

NS_ASSUME_NONNULL_END
