//
//  ZZCommonModuleLifeCycleProtocol.h
//  ZZKit
//
//  Created by MOMO on 2021/10/25.
//  Copyright © 2021 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class UIViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol ZZCommonModuleLifeCycleProtocol <NSObject>

@optional;

- (void)viewDidLoad:(__kindof UIViewController *)vc;

- (void)viewWillAppear:(__kindof UIViewController *)vc;
- (void)viewDidAppear:(__kindof UIViewController *)vc;

- (void)viewWillDisappear:(__kindof UIViewController *)vc;
- (void)viewDidDisappear:(__kindof UIViewController *)vc;

- (void)didReceiveMemoryWarning;

@end

NS_ASSUME_NONNULL_END
