//
//  QuestionSummaryCell.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//  提问简要的cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuestionSummaryCell : UITableViewCell

/// 提问的标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 得分
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *avatarView;

@end

NS_ASSUME_NONNULL_END
