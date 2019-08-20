//
//  ZZPickerViewDemoController.m
//  ZZKit
//
//  Created by donews on 2019/4/9.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZPickerViewDemoController.h"
#import "HooDatePicker.h"
#import "DNCustomPickerView.h"

@interface ZZPickerViewDemoController () <HooDatePickerDelegate>

@property (nonatomic, strong) HooDatePicker *zndatePicker1; //新的日期选择控件

@end

@implementation ZZPickerViewDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(100, 100, 200, 40);
    [button1 setTitle:@"自定义pickerview" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(100, 160, 200, 40);
    [button2 setTitle:@"时间日期picker" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:button2];
    
    [button1 addTarget:self action:@selector(s_btn1ClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(s_btn2ClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
    //配置日期选择控件
    _zndatePicker1 = [[HooDatePicker alloc] initWithSuperView:self.view title:@"选择日期"];
    _zndatePicker1.delegate = self;
    _zndatePicker1.isHasTabBar = YES;
    _zndatePicker1.year = nil;
    _zndatePicker1.month = nil;
    [self setMyDataPicker:_zndatePicker1];
    
}

- (void)s_btn1ClickEvent {
    
    DNCustomPickerView *picker = [[DNCustomPickerView alloc] initWithItems:@[@"小学",@"初中",@"高中",@"大学"] tipTitle:@"学校类型"];
    [picker setConfirmBlock:^(NSString * _Nonnull selectedItem, NSUInteger selectedIndex) {

    }];
    [[[UIApplication sharedApplication] keyWindow] addSubview:picker];
    
}

- (void)s_btn2ClickEvent {
    [self.zndatePicker1 show];
}



- (void)setMyDataPicker:(HooDatePicker *)datePicker{
    
    //  datePicker.datePickerMode = HooDatePickerModeYearAndMonth;
    datePicker.datePickerMode = HooDatePickerModeTime;  // 设置日期样式
    NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
    [dateFormatter setDateFormat:kDateFormatYYYYMMDD];
    NSDate *minDate = [dateFormatter dateFromString:@"1900-01-01"];
    datePicker.minimumDate = minDate;
    datePicker.maximumDate = [NSDate date];
    datePicker.title = @"选择日期";
}

#pragma mark - 日期控件代理方法 -
- (void)datePicker:(HooDatePicker *)datePicker dateDidChange:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == HooDatePickerModeDate) {  // 显示的方式
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    } else if (datePicker.datePickerMode == HooDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else if (datePicker.datePickerMode == HooDatePickerModeYearAndMonth){
        [dateFormatter setDateFormat:@"yyyy-MM"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    
}

- (void)datePicker:(HooDatePicker *)datePicker didCancel:(UIButton *)sender {}
- (void)datePicker:(HooDatePicker *)datePicker didSelectedDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    if (datePicker.datePickerMode == HooDatePickerModeDate) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    } else if (datePicker.datePickerMode == HooDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else if (datePicker.datePickerMode == HooDatePickerModeYearAndMonth){
        [dateFormatter setDateFormat:@"yyyy-MM"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    NSString *value = [dateFormatter stringFromDate:date];
    NSLog(@"#### 选中内容: %@",value);
}



@end
