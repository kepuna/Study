//
//  ZZLayoutViewController.m
//  ZZKit
//
//  Created by donews on 2019/6/19.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZLayoutViewController.h"
#import "ZZPublic.h"
#import "ZZArticleModel.h"

@interface ZZLayoutViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation ZZLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.models = @[].mutableCopy;
    [self createModels];
    [self.view addSubview:self.tableView];
}

- (void)createModels {
    
    ZZArticleModel *model0 = [ZZArticleModel modelWithTitle:@"VLF自动布局入门" route:@"ZZAutoLayoutViewController"];
    ZZArticleModel *model1 = [ZZArticleModel modelWithTitle:@"小图广告布局" route:@"ZZAutoLayout0ViewController"];
    ZZArticleModel *model2 = [ZZArticleModel modelWithTitle:@"AutoLayout代码布局" route:@"ZZAutoLayout1ViewController"];
    ZZArticleModel *model3 = [ZZArticleModel modelWithTitle:@"AutoLayout大图广告布局" route:@"ZZAutoLayout2ViewController"];
    
    ZZArticleModel *model4 = [ZZArticleModel modelWithTitle:@"UIStackView布局" route:@"ZZUIStackViewListController"];
    
    [self.models addObject:model0];
    [self.models addObject:model1];
    [self.models addObject:model2];
    [self.models addObject:model3];
    [self.models addObject:model4];
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
