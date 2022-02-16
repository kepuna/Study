//
//  ZZPerformanceViewController.m
//  ZZKit
//
//  Created by MOMO on 2021/4/13.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZPerformanceViewController.h"
#import "ZZArticleModel.h"

@interface ZZPerformanceViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation ZZPerformanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.models = @[].mutableCopy;
    [self createModels];
    [self.view addSubview:self.tableView];

}

- (void)createModels {
    
    ZZArticleModel *model0 = [ZZArticleModel modelWithTitle:@"NSInvocation" route:@"ZZInvocationViewController"];
    ZZArticleModel *model1 = [ZZArticleModel modelWithTitle:@"命令模式" route:@"XXXX"];
    ZZArticleModel *model2 = [ZZArticleModel modelWithTitle:@"策略模式" route:@"XXX"];
    

    [self.models addObject:model0];
    [self.models addObject:model1];
    [self.models addObject:model2];
    
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


/*
 
 - (IBAction)textkitAction:(id)sender {

     ZZPhotoAlbumViewController *vc = [ZZPhotoAlbumViewController new];
     [self.navigationController pushViewController:vc animated:YES];
 }

 - (void)gradientColor {
     
     // gradient
     CAGradientLayer *gl = [CAGradientLayer layer];
     gl.frame = self.textKitBtn.bounds;
     gl.startPoint = CGPointMake(1, 0.75);
     gl.endPoint = CGPointMake(0, 0.75);
     
     gl.colors = @[(__bridge id)[UIColor colorWithRed:72/255.0 green:219/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:234/255.0 blue:231/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:243/255.0 green:150/255.0 blue:255/255.0 alpha:1.0].CGColor];
     gl.locations = @[@(0.0), @(0.6f), @(1.0f)];
     
     self.textKitBtn.layer.cornerRadius = self.textKitBtn.bounds.size.height * 0.5;
     self.textKitBtn.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.05].CGColor;
     self.textKitBtn.layer.shadowOffset = CGSizeMake(0,5);
     self.textKitBtn.layer.shadowOpacity = 1;
     self.textKitBtn.layer.shadowRadius = 10;
     [self.textKitBtn.layer insertSublayer:gl atIndex:0];
     self.textKitBtn.clipsToBounds = YES;
 }

 - (void)viewDidLoad {
     [super viewDidLoad];
     
     self.view.backgroundColor = [UIColor blackColor];
     self.textKitBtn.backgroundColor = [UIColor lightGrayColor];
     // Do any additional setup after loading the view, typically from a nib.
 //    [ZZHuman demoHashTable];
 //     [ZZHuman demoMapTable];
   
 //    [self  demo2];
 //    [self demo5];
 //    [self gradientColor];
 //    NSLog(@"开售✅");
 //    [self testPerson];
     
     [self testFilter];

 }

 - (void)testFilter {
     ZZFilterTest *test = [[ZZFilterTest alloc] init];
     [test filterArray];
 }

 - (void)testPerson {
     
     Person *p = [Person new];
     p.age = 20;
     p.height = 180;
     p.name = @"JiaJung";
     
     NSLog(@"name = %@, age = %zd, height = %lf",p.name, p.age,p.height);
     
 }

 - (void)demo5 {

     
     // 队长不做处理
     // 队员 1 和各个阶段做 & 操作
     // 观众 0 和各个阶段做&操作
     ZZOperationModel *model = [ZZOperationModel new];
     model.role = 1;
 //    model.gameState = 0; // 游戏处于第0阶段, 0 & 1 结果还是0
 //    model.gameState = 1; // 游戏处于第1阶段, 1 & 1 结果还是0
 //    model.gameState = 2; // 游戏处于第2阶段, 2 & 1 结果还是0
     model.gameState = 3; // 游戏处于第3阶段, 3 & 1 结果还是0
     NSLog(@"--------%zd",model.buttonTip);
 }

 - (void)demo4 {
 //    typedef NS_ENUM(NSInteger, MBCarRoomGameState) {
 //        MBCarRoomGameStateWaitJoin = 0, // 等待队员加入
 //        MBCarRoomGameStateWaitPrepare = 1, // 等待队员准备
 //        MBCarRoomGameStateDrive = 2,  // 待发车
 //        MBCarRoomGameStateGaming = 3  // 已发车 游戏中
 //    };
     
     // 队长不做处理
     
     // 队员 1 和各个阶段做 & 操作
     // 观众 0 和各个阶段做&操作
     ZZOperationModel *model = [ZZOperationModel new];
     model.role = 0;
 //    model.gameState = 0; // 游戏处于第0阶段, 0 & 0 结果还是0
 //    model.gameState = 1; // 游戏处于第1阶段, 1 & 0 结果还是0
 //    model.gameState = 2; // 游戏处于第2阶段, 1 & 0 结果还是0
     model.gameState = 3; // 游戏处于第3阶段, 3 & 0 结果还是0
     NSLog(@"--------%zd",model.buttonTip);
 }


 - (void)demo3 {
     ZZOperationModel *model = [ZZOperationModel new];
     model.online = 1;
 //    model.seatState = @(0); // 1 左移0位结果还是1 所以helpState打印1
 //    model.seatState = @(1); // 1 左移1位结果是2 所以helpState打印2
     model.seatState = @(2); // 1 左移1位结果是4 所以helpState打印4
     NSLog(@"--------%zd",model.helpState);
 }

 - (void)demo2 {
     ZZOperationModel *model = [ZZOperationModel new];
     model.online = 2;
 //    model.seatState = @(0); // 2 左移0位结果还是2 所以helpState打印2
     model.seatState = @(1); // 2 左移1位结果还是4 所以helpState打印4
     NSLog(@"--------online = %zd,, seatState=%zd, %zd",model.online, [model.seatState integerValue],model.helpState);
 }

 - (void)demo1 {
     ZZOperationModel *model = [ZZOperationModel new];
     model.online = 1;
     
     NSLog(@"--------%zd",model.helpState); // 1
 }
 
 
 
 */

@end
