//
//  ZZArticleListViewController.m
//  ZZKit
//
//  Created by donews on 2019/4/29.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZArticleListViewController.h"
#import "ZZWebViewController.h"
#import "ZZArticleModel.h"
@interface ZZArticleListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation ZZArticleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.models = @[].mutableCopy;
    [self.view addSubview:self.tableView];
    [self createModels];
}

- (void)createModels {
    
    ZZArticleModel *model0 = [ZZArticleModel modelWithTitle:@"图片的填充模式" route:@"ZZImageModeListViewController"];
    ZZArticleModel *model1 = [ZZArticleModel modelWithTitle:@"UIStackView的使用" route:@"ZZUIStackViewListController"];
    ZZArticleModel *model2 = [ZZArticleModel modelWithTitle:@"iOS 聊聊present和dismiss" route:@"https://www.jianshu.com/p/455d5f0b3656"];
    ZZArticleModel *model3 = [ZZArticleModel modelWithTitle:@"拦截所有WKWKWebView的的css,js,png等网络请求" route:@"https://github.com/LiuShuoyu/HybirdWKWebVIew"];
    ZZArticleModel *model4 = [ZZArticleModel modelWithTitle:@"腾讯小哥开发SDK总结&原则" route:@"https://blog.bihe0832.com/sdk_experience_Demo.html"];
    
    
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
    ZZArticleModel *model =  self.models[indexPath.row];
    NSString *vcName = model.route;
    Class vcClass = NSClassFromString(vcName);
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
