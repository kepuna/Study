//
//  ZZCocurrentDemoOperation.h
//  ZZKit
//
//  Created by donews on 2019/7/16.
//  Copyright © 2019年 donews. All rights reserved.
//  实战

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol ZZCocurrentDemoOperationDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface ZZCocurrentDemoOperation : NSOperation {
    BOOL executing; // 是否执行中  默认是NO
    BOOL finished; // 是否执行完毕 默认是NO
}

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<ZZCocurrentDemoOperationDelegate> delegate;

@end

NS_ASSUME_NONNULL_END


@protocol ZZCocurrentDemoOperationDelegate <NSObject>

- (void)downLoadOperation:(ZZCocurrentDemoOperation *)operation didFishedDownLoad:(UIImage *)image;

@end
