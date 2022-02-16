//
//  ZZCommonModuleLifeCycleProtocol.h
//  ZZMedia
//
//  Created by MOMO on 2020/8/31.
//

#import <Foundation/Foundation.h>
@class UIViewController;

@protocol ZZCommonModuleLifeCycleProtocol <NSObject>

@optional

- (void)viewDidLoad:(__kindof UIViewController *)vc;

- (void)viewWillAppear:(__kindof UIViewController *)vc;
- (void)viewDidAppear:(__kindof UIViewController *)vc;

- (void)viewWillDisappear:(__kindof UIViewController *)vc;
- (void)viewDidDisappear:(__kindof UIViewController *)vc;

- (void)didReceiveMemoryWarning;

@end

