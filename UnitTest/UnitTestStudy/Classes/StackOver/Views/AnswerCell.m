//
//  AnswerCell.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "AnswerCell.h"

@implementation AnswerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.personName];
        [self.contentView addSubview:self.acceptedIndicator];
        [self.contentView addSubview:self.scoreLabel];
        [self.contentView addSubview:self.personAvatar];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.personAvatar.frame = CGRectMake(15, 10, 50, 50);
    self.personName.frame = CGRectMake(15 + 50 + 10, CGRectGetMinY(self.personAvatar.frame), 250, 20);
    self.acceptedIndicator.frame = CGRectMake(15 + 50 + 10, 40 + 10, 100, 20);
    self.scoreLabel.frame = CGRectMake(self.frame.size.width - 100 - 15, 40 + 10, 50, 20);
}

- (UILabel *)acceptedIndicator {
    if (_acceptedIndicator == nil) {
        _acceptedIndicator = [[UILabel alloc] init];
    }
    return _acceptedIndicator;
}

- (UILabel *)personName {
    if (_personName == nil) {
        _personName = [[UILabel alloc] init];
        _personName.font = [UIFont systemFontOfSize:14];
    }
    return _personName;
}

- (UILabel *)scoreLabel {
    if (_scoreLabel == nil) {
        _scoreLabel = [[UILabel alloc] init];
    }
    return _scoreLabel;
}

- (UIImageView *)personAvatar {
    if (_personAvatar == nil) {
        _personAvatar = [[UIImageView alloc] init];
        _personAvatar.backgroundColor = [UIColor lightGrayColor];
    }
    return _personAvatar;
}

@end
