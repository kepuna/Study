//
//  HTTPRequestViewController.m
//  ZZKit
//
//  Created by donews on 2019/4/24.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "HTTPRequestViewController.h"
#import "ZZArticleModel.h"

@interface HTTPRequestViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation HTTPRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.models = @[].mutableCopy;
    [self createModels];
    [self.view addSubview:self.tableView];
    
//    NSURLRequest
//    NSURLSession
//    NSURLSessionConfiguration
//    NSHTTPURLRequest
}

- (void)createModels {
    
    ZZArticleModel *model0 = [ZZArticleModel modelWithTitle:@"NSURLSessionDataTask" route:@"ZZRequest0ViewController"];
    ZZArticleModel *model1 = [ZZArticleModel modelWithTitle:@"原生监听网络状态" route:@"ZZRequet1ViewController"];
    ZZArticleModel *model2 = [ZZArticleModel modelWithTitle:@"cell加载图片" route:@"ZZRequet2ViewController"];
    
//    ZZArticleModel *model2 = [ZZArticleModel modelWithTitle:@"GLKit绘制图片到屏幕" route:@"ZZGLKit1ViewController"];
//    ZZArticleModel *model3 = [ZZArticleModel modelWithTitle:@"顶点数组存顶点数据" route:@"ZZGLKit3ViewController"];
//    ZZArticleModel *model4 = [ZZArticleModel modelWithTitle:@"shader入门" route:@"ZZGLKit4ViewController"];
    
    
    [self.models addObject:model0];
    [self.models addObject:model1];
    [self.models addObject:model2];
//    [self.models addObject:model3];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ZZArticleModel *model =  self.models[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld > %@",indexPath.row + 1,model.title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZArticleModel *model =  self.models[indexPath.row];
    NSString *vcName = model.route;
    Class vcClass = NSClassFromString(vcName);
    UIViewController *vc = [vcClass new];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = model.title;
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
