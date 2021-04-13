//
//  ZZDesignPatternViewController.m
//  ZZKit
//
//  Created by MOMO on 2021/4/13.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZDesignPatternViewController.h"
#import "ZZArticleModel.h"


//#import "MBCarStateButtonClickRequest.h"
//#import "MBCarStateRemindActionHandler.h"
//#import "MBCarStateDriveActionHandler.h"
//#import "MBCarStateEndDriveActionHandler.h"
//#import "MBCarStateJoinActionHandler.h"
//#import "MBCarStatePrepareActionHandler.h"
//#import "MBCarStateActionChainHeader.h"
//#import "MBCarStateActionChainTail.h"
//#import "MBCarStateCanclePrepareActionHandler.h"

@interface ZZDesignPatternViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation ZZDesignPatternViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.models = @[].mutableCopy;
    [self createModels];
    [self.view addSubview:self.tableView];

}

- (void)createModels {
    
    ZZArticleModel *model0 = [ZZArticleModel modelWithTitle:@"工厂模式" route:@"XXXX"];
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

//
//- (void)buttonAction:(UIButton *)sender {
//    // 游戏4个阶段 0(等待队员加入)  1(等待队员准备)  2(待发车)  3(进行中)
//    // 角色 ： 观众 0  队员1 队长2， 如果是队长不做处理
//
//    // 队员 1 和各个阶段做 & 操作
//    // 观众 0 和各个阶段做&操作
//
//
//
//    id <MBCarStateButtonActionChain> remindActionHandler, driveActionHandler, endDriveActionHandler, joinActionHandler, prepareActionHandler, canclePrepareActionHandler;
//
//    remindActionHandler = [MBCarStateRemindActionHandler new];
//    driveActionHandler = [MBCarStateDriveActionHandler new];
//    endDriveActionHandler = [MBCarStateEndDriveActionHandler new];
//    joinActionHandler = [MBCarStateJoinActionHandler new];
//    prepareActionHandler = [MBCarStatePrepareActionHandler new];
//    canclePrepareActionHandler = [MBCarStateCanclePrepareActionHandler new];
//
//    //创建请求
//    MBCarStateButtonClickRequest *clickRequest = [[MBCarStateButtonClickRequest alloc] initWithGameState:self.currentGameState];
//    if (self.currentRole == 2) {
//        //创建职责链
//        [remindActionHandler setNextAction:driveActionHandler];
//        [driveActionHandler setNextAction:endDriveActionHandler];
//        // 处理请求
//        [remindActionHandler processRequest:clickRequest];
//    } else {
//        [joinActionHandler setNextAction:prepareActionHandler];
//        [prepareActionHandler setNextAction:canclePrepareActionHandler];
//        // 处理请求
//        [joinActionHandler processRequest:clickRequest];
//    }
//}
//
//- (void)updateBtnActionWithGameState:(NSInteger)gameState {
//
//        id <MBCarStateButtonActionChain> remindActionHandler, driveActionHandler, endDriveActionHandler, joinActionHandler, prepareActionHandler, canclePrepareActionHandler, handerHandler, tailHandler ;
//
//    handerHandler = [MBCarStateActionChainHeader new];
//    tailHandler = [MBCarStateActionChainTail new];
//        remindActionHandler = [MBCarStateRemindActionHandler new];
//        driveActionHandler = [MBCarStateDriveActionHandler new];
//        endDriveActionHandler = [MBCarStateEndDriveActionHandler new];
//        joinActionHandler = [MBCarStateEndDriveActionHandler new];
//        prepareActionHandler = [MBCarStatePrepareActionHandler new];
//        canclePrepareActionHandler = [MBCarStateCanclePrepareActionHandler new];
//
//        //创建职责链
//        [remindActionHandler setNextAction:driveActionHandler];
//        [driveActionHandler setNextAction:endDriveActionHandler];
//
//        [joinActionHandler setNextAction:prepareActionHandler];
//        [prepareActionHandler setNextAction:canclePrepareActionHandler];
//
//        //创建请求
//        MBCarStateButtonClickRequest *clickRequest = [[MBCarStateButtonClickRequest alloc] initWithGameState:gameState];
//
//        // 处理请求
//        [remindActionHandler processRequest:clickRequest];
//
//}

@end
