//
//  QuestionListTableDataSource.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//  提问列表 数据源

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *QuestionListDidSelectQuestionNotification;

@class ZZTopick;
@class AvatarStore;
@class QuestionSummaryCell;

@interface QuestionListTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) ZZTopick *topic;
@property (nonatomic, strong) AvatarStore *avatarStore;
@property (strong) NSNotificationCenter *notificationCenter;

@property (weak) UITableView *tableView;
@property (nonatomic, strong) QuestionSummaryCell *summaryCell;


- (void)registerForUpdatesToAvatarStore: (AvatarStore *)store;
- (void)removeObservationOfUpdatesToAvatarStore: (AvatarStore *)store;
- (void)avatarStoreDidUpdateContent: (NSNotification *)notification;

@end

