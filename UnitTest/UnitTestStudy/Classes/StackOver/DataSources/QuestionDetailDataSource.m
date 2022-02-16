//
//  QuestionDetailDataSource.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "QuestionDetailDataSource.h"
#import "ZZAnswer.h"
#import "ZZQuestion.h"
#import "ZZPerson.h"

#import "AnswerCell.h"
#import "QuestionDetailCell.h"
#import "AvatarStore.h"



enum {
questionSection = 0,
answerSection = 1,
sectionCount
};

@implementation QuestionDetailDataSource

- (NSString *)HTMLStringForSnippet:(NSString *)snippet {
    return [NSString stringWithFormat: @"<html><head></head><body>%@</body></html>", snippet];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == answerSection) ? [self.question.answers count] : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (indexPath.section == questionSection) {
        QuestionDetailCell *detailCell = [[QuestionDetailCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"QuestionDetailCell"];
        NSString *htmlString = [self HTMLStringForSnippet:self.question.body];
        [detailCell.bodyWebView loadHTMLString:htmlString baseURL:nil];
        detailCell.titleLabel.text = self.question.title;
        detailCell.scoreLabel.text = [NSString stringWithFormat: @"%zd", self.question.score];
        detailCell.nameLabel.text = self.question.asker.name;
        detailCell.avatarView.image = [UIImage imageWithData: [self.avatarStore dataForURL: self.question.asker.avatarURL]];
        cell = detailCell;
        self.detailCell = nil;
    } else if (indexPath.section == answerSection) {
        ZZAnswer *thisAnswer = [self.question.answers objectAtIndex:indexPath.row];
        AnswerCell *answerCell = [[AnswerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AnswerCell"];
       answerCell.scoreLabel.text = [NSString stringWithFormat: @"%zd", thisAnswer.score];
        answerCell.acceptedIndicator.hidden = !thisAnswer.accepted;
        ZZPerson *answerer = thisAnswer.person;
        answerCell.personName.text = answerer.name;
        answerCell.personAvatar.image = [UIImage imageWithData: [self.avatarStore dataForURL: answerer.avatarURL]];
        [answerCell.bodyWebView loadHTMLString: [self HTMLStringForSnippet: thisAnswer.text] baseURL: nil];
        cell = answerCell;
        self.answerCell = nil;
        
    } else {
        NSParameterAssert(indexPath.section < sectionCount);
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == questionSection) {
        return 276.0f;
    }
    else {
        return 201.0f;
    }
}

@end
