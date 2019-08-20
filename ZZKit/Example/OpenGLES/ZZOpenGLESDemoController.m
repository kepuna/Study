//
//  ZZOpenGLESDemoController.m
//  ZZKit
//
//  Created by donews on 2019/5/9.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZOpenGLESDemoController.h"
#import "ZZArticleModel.h"

@interface ZZOpenGLESDemoController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation ZZOpenGLESDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.models = @[].mutableCopy;
    [self createModels];
    [self.view addSubview:self.tableView];
}

- (void)createModels {
    
    ZZArticleModel *model0 = [ZZArticleModel modelWithTitle:@"画一个简单的三角形" route:@"ZZGLKit0ViewController"];
    ZZArticleModel *model1 = [ZZArticleModel modelWithTitle:@"画三角形2" route:@"ZZGLKit2ViewController"];
    ZZArticleModel *model2 = [ZZArticleModel modelWithTitle:@"GLKit绘制图片到屏幕" route:@"ZZGLKit1ViewController"];
    ZZArticleModel *model3 = [ZZArticleModel modelWithTitle:@"顶点数组存顶点数据" route:@"ZZGLKit3ViewController"];
    ZZArticleModel *model4 = [ZZArticleModel modelWithTitle:@"shader入门" route:@"ZZGLKit4ViewController"];
    
//    ZZArticleModel *model1 = [ZZArticleModel modelWithTitle:@"GPUImageVideoCamera视频" route:@"GPUImageVideoCameraDemoController"];
//    ZZArticleModel *model2 = [ZZArticleModel modelWithTitle:@"GPUImageFilterGroup组合滤镜" route:@"GPUImageMutiFilterViewController"];
//    ZZArticleModel *model3 = [ZZArticleModel modelWithTitle:@"GPUImageFilterPipeline组合滤镜" route:@"GPUImageMutiFilterViewController2"];
//    ZZArticleModel *model4 = [ZZArticleModel modelWithTitle:@"GPUImageFilterGroup组合实时滤镜" route:@"GPUImageMutiFilterViewController3"];
//    ZZArticleModel *model5 = [ZZArticleModel modelWithTitle:@"美颜拍视频" route:@"GPUImageTakeVideoViewController"];
    
    
    [self.models addObject:model0];
    [self.models addObject:model1];
    [self.models addObject:model2];
    [self.models addObject:model3];
//    [self.models addObject:model4];
//    [self.models addObject:model5];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ZZArticleModel *model =  self.models[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%d > %@",indexPath.row + 1,model.title];
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
