//
//  TopicTableDataSource.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "TopicTableDataSource.h"
#import "ZZTopick.h"

NSString *TopicTableDidSelectTopicNotification = @"TopicTableDidSelectTopicNotification";
NSString *topicCellReuseIdentifier = @"Topic";

@implementation TopicTableDataSource {
     NSArray *topics;
}

- (void)setTopics:(NSArray *)newTopics  {
    topics = newTopics;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSParameterAssert(section == 0);
    return [topics count];
}

- (ZZTopick *)topicForIndexPath:(NSIndexPath *)indexPath {
    return [topics objectAtIndex: [indexPath row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSParameterAssert([indexPath section] == 0);
    NSParameterAssert([indexPath row] < [topics count]);
    UITableViewCell *topicCell = [tableView dequeueReusableCellWithIdentifier: topicCellReuseIdentifier];
    if (!topicCell) {
        topicCell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: topicCellReuseIdentifier];
    }
    topicCell.textLabel.text = [[self topicForIndexPath: indexPath] name];
    return topicCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNotification *note = [NSNotification notificationWithName: TopicTableDidSelectTopicNotification object: [self topicForIndexPath: indexPath]];
    [[NSNotificationCenter defaultCenter] postNotification: note];
}

@end
