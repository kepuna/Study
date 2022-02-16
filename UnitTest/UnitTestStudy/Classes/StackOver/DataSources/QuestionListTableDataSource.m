//
//  QuestionListTableDataSource.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "QuestionListTableDataSource.h"

#import "QuestionSummaryCell.h"
#import "ZZTopick.h"
#import "ZZQuestion.h"
#import "ZZPerson.h"
#import "AvatarStore.h"

NSString *QuestionListDidSelectQuestionNotification = @"QuestionListDidSelectQuestionNotification";

@implementation QuestionListTableDataSource

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    return [[self.topic recentQuestions] count] ?: 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (self.topic.recentQuestions.count) {
        ZZQuestion *question = [self.topic.recentQuestions objectAtIndex:indexPath.row];
        self.summaryCell = [tableView dequeueReusableCellWithIdentifier:@"question"];
        if (self.summaryCell == nil) {
            self.summaryCell = [[QuestionSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionSummaryCell"];
        }
        self.summaryCell.titleLabel.text = question.title;
        self.summaryCell.scoreLabel.text = [NSString stringWithFormat: @"%zd", question.score];
        self.summaryCell.nameLabel.text = question.asker.name;
   
        NSData *avatarData = [self.avatarStore dataForURL:question.asker.avatarURL];
        if (avatarData) {
            self.summaryCell.avatarView.image = [UIImage imageWithData:avatarData];
        }
        cell = self.summaryCell;
        self.summaryCell = nil;
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier: @"placeholder"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"placeholder"];
        }
        cell.textLabel.text = @"There was a problem.";
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.topic recentQuestions] count] > 0) {
        NSNotification *notification = [NSNotification notificationWithName: QuestionListDidSelectQuestionNotification object: [self.topic.recentQuestions objectAtIndex: indexPath.row]];
        [self.notificationCenter postNotification: notification];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 132.0f;
}

- (void)registerForUpdatesToAvatarStore:(AvatarStore *)store {
    [self.notificationCenter addObserver:self selector:@selector(avatarStoreDidUpdateContent:) name:AvatarStoreDidUpdateContentNotification object:store];
}

- (void)removeObservationOfUpdatesToAvatarStore:(AvatarStore *)store {
    [self.notificationCenter removeObserver:self name:AvatarStoreDidUpdateContentNotification object:store];
}

- (void)avatarStoreDidUpdateContent:(NSNotification *)notification {
    [self.tableView reloadData];
}

@end
