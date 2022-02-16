//
//  BrowseOverflowViewController.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/8/13.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StackOverManagerDelegate;
@class StackOverManager;
@class BrowseOverflowObjectConfiguration;

NS_ASSUME_NONNULL_BEGIN

@interface BrowseOverflowViewController : UIViewController <StackOverManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (strong) BrowseOverflowObjectConfiguration *objectConfiguration;
@property (strong) NSObject <UITableViewDataSource, UITableViewDelegate> *dataSource;

@property (nonatomic, strong) StackOverManager *manager;


/// 用户选择话题的通知
- (void)userDidSelectTopicNotification: (NSNotification *)note;

/// 用户选择问题的通知
- (void)userDidSelectQuestionNotification: (NSNotification *)note;

@end

NS_ASSUME_NONNULL_END
