//
//  ZZRequet2ViewController.m
//  ZZKit
//
//  Created by donews on 2019/6/26.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZRequet2ViewController.h"
#import "ZZArticleModel.h"

@interface ZZRequet2ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation ZZRequet2ViewController

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
    
    NSString *img0 = @"http://a.hiphotos.baidu.com/image/pic/item/a71ea8d3fd1f41347fe08ef12b1f95cad0c85e6e.jpg";
    NSString *img1 = @"http://f.hiphotos.baidu.com/zhidao/pic/item/dbb44aed2e738bd4f69c4f49a58b87d6277ff90d.jpg";
    NSString *img2 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561436458726&di=381a1172c8b9986ee361b00c2cd90e24&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20171218%2F1a47b1758cc74f3f9f5ea9c546095f9c.jpeg";
    NSString *img3 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561436458726&di=1fa8eb11f0addfa4801e174bc6ce509b&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201601%2F14%2F20160114161349_BaMCA.jpeg";
    NSString *img4 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561436458726&di=a48dc4f988914c994e69517f6867e348&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20180204%2F87185614364a48a2b3d32bc9db18e5b1.jpeg";
    NSString *img5 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561436458726&di=7d1658d91aff06a8d48777631e00179c&imgtype=0&src=http%3A%2F%2Fpic.rmb.bdstatic.com%2F4782639e33f9e4e1f6d629dd846be465.jpeg";
    NSString *img6 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561436458726&di=c842f3c714a761d7d5af86670f711c9e&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20180720%2F9787561c8eaf42ddadb5a4e297c94838.jpeg";
    NSString *img7 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561436931835&di=ca1fb09817213c5b3666a0bc7802ae45&imgtype=0&src=http%3A%2F%2Fpic.rmb.bdstatic.com%2F2844be249c71870bb76929a7c30d24b6.jpeg";
    NSString *img8 = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561436458725&di=2fbfd459e194a8c98ebc034d43227ca9&imgtype=0&src=http%3A%2F%2Fimg.mp.sohu.com%2Fupload%2F20170725%2F7bfc2b4debd745b49441a8b34903e731_th.png";
    NSString *img9 = @"http://g.hiphotos.baidu.com/image/pic/item/c2cec3fdfc03924590b2a9b58d94a4c27d1e2500.jpg";
    NSString *img10 = @"http://e.hiphotos.baidu.com/image/pic/item/b812c8fcc3cec3fdb850efcfdc88d43f87942719.jpg";
    NSString *img11 = @"http://f.hiphotos.baidu.com/image/pic/item/f2deb48f8c5494eefd4b47a327f5e0fe99257e1a.jpg";
    NSString *img12 = @"http://b.hiphotos.baidu.com/image/pic/item/908fa0ec08fa513db777cf78376d55fbb3fbd9b3.jpg";
    
    ZZArticleModel *model0 = [ZZArticleModel modelWithTitle:@"大战罗率" route:img0];
    ZZArticleModel *model1 = [ZZArticleModel modelWithTitle:@"哈哈哈哈" route:img1];
    ZZArticleModel *model2 = [ZZArticleModel modelWithTitle:@"超级麻辣1" route:img2];
    ZZArticleModel *model3 = [ZZArticleModel modelWithTitle:@"超级麻辣2" route:img3];
    ZZArticleModel *model4 = [ZZArticleModel modelWithTitle:@"超级麻辣3" route:img4];
    ZZArticleModel *model5 = [ZZArticleModel modelWithTitle:@"超级麻辣4" route:img5];
    ZZArticleModel *model6 = [ZZArticleModel modelWithTitle:@"忍者神龟" route:img6];
    ZZArticleModel *model7 = [ZZArticleModel modelWithTitle:@"不再犹豫" route:img7];
    ZZArticleModel *model8 = [ZZArticleModel modelWithTitle:@"超级好网" route:img8];
    ZZArticleModel *model9 = [ZZArticleModel modelWithTitle:@"地对地导弹" route:img9];
    ZZArticleModel *model10 = [ZZArticleModel modelWithTitle:@"手动阀" route:img10];
    ZZArticleModel *model11 = [ZZArticleModel modelWithTitle:@"大沙发上发送" route:img11];
    ZZArticleModel *model12 = [ZZArticleModel modelWithTitle:@"都是麻辣" route:img12];

    
    [self.models addObject:model0];
    [self.models addObject:model1];
    [self.models addObject:model2];
    [self.models addObject:model3];
    [self.models addObject:model4];
    [self.models addObject:model5];
    [self.models addObject:model6];
    [self.models addObject:model7];
    [self.models addObject:model8];
    [self.models addObject:model9];
    [self.models addObject:model10];
    [self.models addObject:model11];
    [self.models addObject:model12];
    
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
//    ZZArticleModel *model =  self.models[indexPath.row];
//    NSString *vcName = model.route;
//    Class vcClass = NSClassFromString(vcName);
//    UIViewController *vc = [vcClass new];
//    vc.view.backgroundColor = [UIColor whiteColor];
//    vc.title = model.title;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.rowHeight = 80;
    }
    return _tableView;
}

@end
