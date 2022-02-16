//
//  ViewController.m
//  UnitTestStudy
//
//  Created by donews on 2019/9/26.
//  Copyright © 2019年 HelloWorld. All rights reserved.
//

#import "ViewController.h"
#import "ZZTemperatureViewController.h"
#import "BrowseOverflowViewController.h"
#import "BrowseOverflowObjectConfiguration.h"
#import "ZZTopick.h"
#import "TopicTableDataSource.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton *pushBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.pushBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pushBtn setTitle:@"Click Me" forState:UIControlStateNormal];
    self.pushBtn.backgroundColor = [UIColor blackColor];
    [self.pushBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.pushBtn.frame = CGRectMake(0, 0, 100, 40);
    self.pushBtn.center = self.view.center;
    [self.pushBtn addTarget:self action:@selector(s_pushAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pushBtn];
}

- (void)s_pushAction  {
//    ZZTemperatureViewController *vc = [ZZTemperatureViewController new];
    BrowseOverflowViewController *firstViewController = [[BrowseOverflowViewController alloc] initWithNibName: nil bundle: nil];
    firstViewController.objectConfiguration = [[BrowseOverflowObjectConfiguration alloc] init];
    TopicTableDataSource *dataSource = [[TopicTableDataSource alloc] init]; // 首页的话题列表
    [dataSource setTopics: [self topics]];
    firstViewController.dataSource = dataSource;
   
    [self.navigationController pushViewController:firstViewController animated:YES];
}

- (NSArray *)topics {
    NSString *tags[] = { @"iphone", @"cocoa-touch", @"uikit", @"objective-c", @"xcode" };
    NSString *names[] = { @"iPhone", @"Cocoa Touch", @"UIKit", @"Objective-C", @"Xcode" };
    NSMutableArray *topicList = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i++) {
        // 创建话题
        ZZTopick *thisTopic = [[ZZTopick alloc] initWithName: names[i] tag: tags[i]];
        [topicList addObject: thisTopic];
    }
    return [topicList copy];
}

@end
