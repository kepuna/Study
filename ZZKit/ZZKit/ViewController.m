//
//  ViewController.m
//  ZZKit
//
//  Created by donews on 2019/4/9.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *controllers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[@"知识点 & 文章",@"PickerView工具",@"GPUImage",@"AVFoundation音视频",@"OpenGL ES学习",@"多线程例子",@"网络",@"自动布局",@"Animation",@"JSON模板转视图", @"设计模式",@"高性能"];
    self.controllers = @[@"ZZArticleListViewController",@"ZZPickerViewDemoController",@"GPUImageDemoViewController",@"AVFoundationViewController",@"ZZOpenGLESDemoController",@"ThreadViewController",@"HTTPRequestViewController",@"ZZLayoutViewController",@"ZZAnimationViewController",@"ZZJSONToViewController",@"ZZDesignPatternViewController",@"ZZPerformanceViewController"];
    
    [self.view addSubview:self.tableView];
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *vcName = self.controllers[indexPath.row];
    Class vcClass = NSClassFromString(vcName);
    UIViewController *vc = [vcClass new];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = [NSString stringWithFormat:@"%zd-》%@",indexPath.row+1,self.titles[indexPath.row]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
