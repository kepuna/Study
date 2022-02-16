//
//  ZZTemperatureViewController.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/29.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZTemperatureViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel  *fahrenheitLabel;


@end

NS_ASSUME_NONNULL_END
