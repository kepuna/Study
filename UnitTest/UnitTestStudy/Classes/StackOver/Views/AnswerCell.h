//
//  AnswerCell.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/9/17.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnswerCell : UITableViewCell

@property (nonatomic, strong)  UILabel *scoreLabel;
@property (nonatomic, strong)  UILabel *acceptedIndicator;
@property (nonatomic, strong)  UILabel *personName;
@property (nonatomic, strong)  UIImageView *personAvatar;
@property (nonatomic, strong)  UIWebView *bodyWebView;

@end

NS_ASSUME_NONNULL_END
