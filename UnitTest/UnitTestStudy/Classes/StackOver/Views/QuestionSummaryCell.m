//
//  QuestionSummaryCell.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "QuestionSummaryCell.h"



@implementation QuestionSummaryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.scoreLabel];
        [self.contentView addSubview:self.avatarView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.avatarView.frame = CGRectMake(15, 10, 50, 50);
    self.titleLabel.frame = CGRectMake(15 + 50 + 10, CGRectGetMinY(self.avatarView.frame), 250, 20);
    self.nameLabel.frame = CGRectMake(15 + 50 + 10, 40 + 10, 100, 20);
    self.scoreLabel.frame = CGRectMake(self.frame.size.width - 100 - 15, 40 + 10, 50, 20);
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UILabel *)scoreLabel {
    if (_scoreLabel == nil) {
        _scoreLabel = [[UILabel alloc] init];
    }
    return _scoreLabel;
}

- (UIImageView *)avatarView {
    if (_avatarView == nil) {
        _avatarView = [[UIImageView alloc] init];
        _avatarView.backgroundColor = [UIColor lightGrayColor];
    }
    return _avatarView;
}

@end
