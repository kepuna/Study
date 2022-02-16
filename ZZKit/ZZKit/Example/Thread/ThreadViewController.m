//
//  ThreadViewController.m
//  ZZKit
//
//  Created by donews on 2019/4/23.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ThreadViewController.h"
#import "ZZPublic.h"
#import "ZZArticleModel.h"

@interface ThreadViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation ThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.models = @[].mutableCopy;
    [self createModels];
    [self.view addSubview:self.tableView];
}

- (void)createModels {
    
    ZZArticleModel *model0 = [ZZArticleModel modelWithTitle:@"GCD多个网络请求顺序返回" route:@"ZZThread0ViewController"];
    ZZArticleModel *model1 = [ZZArticleModel modelWithTitle:@"NSOperationQueue多个网络请求顺序返回" route:@"ZZThread1ViewController"];
     ZZArticleModel *model3 = [ZZArticleModel modelWithTitle:@"NSOperationQueue多线程请求队列" route:@"ZZThread3ViewController"];
    ZZArticleModel *model4 = [ZZArticleModel modelWithTitle:@"线程安全之@synchronized的用法" route:@"ZZThread4ViewController"];
    ZZArticleModel *model5 = [ZZArticleModel modelWithTitle:@"定时器和线程问题(卡住主线程案例)" route:@"ZZThread5ViewController"];
    ZZArticleModel *model6 = [ZZArticleModel modelWithTitle:@"异步+串行 & 回调线程" route:@"ZZThread6ViewController"];
    ZZArticleModel *model7 = [ZZArticleModel modelWithTitle:@"自定义非并发 & 并发的NSOPeration" route:@"ZZThread7ViewController"];
    ZZArticleModel *model8 = [ZZArticleModel modelWithTitle:@"自定义并发NSOPeration实战" route:@"ZZThread8ViewController"];
    
    [self.models addObject:model0];
    [self.models addObject:model1];
    [self.models addObject:model3];
    [self.models addObject:model4];
    [self.models addObject:model5];
    [self.models addObject:model6];
    [self.models addObject:model7];
    [self.models addObject:model8];
}



#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ZZArticleModel *model = self.models[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd -> %@",indexPath.row,model.title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZArticleModel *model = self.models[indexPath.row];
    Class vcClass = NSClassFromString(model.route);
    UIViewController *vc = [vcClass new];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Getters & Setters
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
