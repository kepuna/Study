//
//  ZZTemperatureViewController.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/29.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZTemperatureViewController.h"

@interface ZZTemperatureViewController () 

@end

@implementation ZZTemperatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor darkTextColor];
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, self.view.bounds.size.width - 100, 40)];
    self.textField.backgroundColor = [UIColor lightGrayColor];
    self.textField.delegate = self;
    
    self.fahrenheitLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.textField.frame) + 10, 100, 30)];
    self.fahrenheitLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.fahrenheitLabel];
    [self.view addSubview:self.textField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    double celsius = [[textField text] doubleValue];
    double fahrenheit = celsius * (9.0 / 5.0) + 32.0;
    self.fahrenheitLabel.text = [NSString stringWithFormat:@"%.0f",fahrenheit];
    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
