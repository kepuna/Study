//
//  TopicTableDataSource.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

extern NSString *TopicTableDidSelectTopicNotification;

@interface TopicTableDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

- (void)setTopics: (NSArray *)newTopics;

@end

NS_ASSUME_NONNULL_END
