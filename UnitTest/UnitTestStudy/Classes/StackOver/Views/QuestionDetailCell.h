//
//  QuestionDetailCell.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuestionDetailCell : UITableViewCell

@property (nonatomic
           , weak) UIWebView *bodyWebView;
@property (nonatomic
, weak)  UILabel *titleLabel;
@property (nonatomic
, weak)  UILabel *scoreLabel;
@property (nonatomic
, weak)  UILabel *nameLabel;
@property (nonatomic
           , weak)  UIImageView *avatarView;

@end

NS_ASSUME_NONNULL_END
