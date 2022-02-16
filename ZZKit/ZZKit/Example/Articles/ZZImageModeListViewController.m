//
//  ZZImageModeListViewController.m
//  ZZKit
//
//  Created by donews on 2019/6/28.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZImageModeListViewController.h"
#import "ZZArticleModel.h"
#import "ZZImageModalViewController.h"

@interface ZZImageModeListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *models;
@property (nonatomic, strong) NSMutableDictionary *modaDict;

@end

@implementation ZZImageModeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.models = @[].mutableCopy;
    self.modaDict = @{}.mutableCopy;
    [self.view addSubview:self.tableView];
    [self createModels];
}

- (void)createModels {
    
//    typedef NS_ENUM(NSInteger, UIViewContentMode) {
//        UIViewContentModeScaleToFill,
//        UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
//        UIViewContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.
//        UIViewContentModeRedraw,              // redraw on bounds change (calls -setNeedsDisplay)
//        UIViewContentModeCenter,              // contents remain same size. positioned adjusted.
//        UIViewContentModeTop,
//        UIViewContentModeBottom,
//        UIViewContentModeLeft,
//        UIViewContentModeRight,
//        UIViewContentModeTopLeft,
//        UIViewContentModeTopRight,
//        UIViewContentModeBottomLeft,
//        UIViewContentModeBottomRight,
//    };
 
/*
 
 枚举最前面三个属性是会拉伸(缩放)图片的,其余的属性是不会拉伸图片.
 同时可以总结出两点
 1.凡是带有scale单词的属性,图片都会被拉伸.
 2.凡是带有Ascept单词属性,图片会保持原来的宽高比,即图片不会变形
 
 最后如果想让图片占满整个父容器,并且不变形,可以采用一种折中的方式
 
 超出容器范围的切除掉
 self.imageView.clipsToBounds = YES;
 
 */
  
    
    ZZArticleModel *model0 = [ZZArticleModel modelWithTitle:@"UIViewContentModeScaleToFill 默认填充模式  图片拉伸填充至整个UIImageView(图片可能会变形)" route:@"UIViewContentModeScaleToFill"]; // 5
    ZZArticleModel *model1 = [ZZArticleModel modelWithTitle:@"UIViewContentModeScaleAspectFit 图片拉伸至完全显示在UIImageView里面为止(图片不会变形) 等比例缩放" route:@"UIViewContentModeScaleAspectFit"]; // 2 3
    ZZArticleModel *model2 = [ZZArticleModel modelWithTitle:@"UIViewContentModeScaleAspectFill 图片拉伸至图片的的宽度或者高度等于UIImageView的宽度或者高度为止.看图片的宽高哪一边最接近UIImageView的宽高,一个属性相等后另一个就停止拉伸. 图片等比例缩放并不会变形,但可能超出了容器的范围 ;用图片内容来填充视图的大小，多余得部分可以被修剪掉来填充整个视图边界(需要设置clipsToBounds为yes)" route:@"UIViewContentModeScaleAspectFill"]; // 1
    
    ZZArticleModel *model3 = [ZZArticleModel modelWithTitle:@"UIViewContentModeRedraw 内容模式有利于重复使用view的内容，如果你想自定义视图并在缩放和计算操作期间重绘它们，可以使用UIViewContentModeRedraw值，设置该值将使系统调用drawRect:方法来响应视图的几何结构的改变，一般情况下，应该尽量避免使用该值" route:@"UIViewContentModeRedraw"];
    
    ZZArticleModel *model4 = [ZZArticleModel modelWithTitle:@"UIViewContentModeCenter 中间模式 图片并没有被拉伸,原尺寸显示,中点与imageView 的中点相等.由于原图的尺寸比imageView 的尺寸要大很多,所以完全超出了父容器的显示范围" route:@"UIViewContentModeCenter"]; // 7
    
     ZZArticleModel *model5 = [ZZArticleModel modelWithTitle:@"UIViewContentModeTop 顶部 不会拉伸图片 原理和center一样" route:@"UIViewContentModeTop"];
    
     ZZArticleModel *model6 = [ZZArticleModel modelWithTitle:@"UIViewContentModeBottom 底部 不会拉伸图片  原理和center一样" route:@"UIViewContentModeBottom"];
    
    ZZArticleModel *model7 = [ZZArticleModel modelWithTitle:@"UIViewContentModeLeft 左边 不会拉伸图片  原理和center一样" route:@"UIViewContentModeLeft"]; // 4
    
    ZZArticleModel *model8 = [ZZArticleModel modelWithTitle:@"UIViewContentModeRight 右边 不会拉伸图片  原理和center一样" route:@"UIViewContentModeRight"];
    
    ZZArticleModel *model9 = [ZZArticleModel modelWithTitle:@"UIViewContentModeTopLeft 左上 不会拉伸图片  原理和center一样" route:@"UIViewContentModeTopLeft"]; // 6
    
    ZZArticleModel *model10 = [ZZArticleModel modelWithTitle:@"UIViewContentModeTopRight 右上  不会拉伸图片  原理和center一样" route:@"UIViewContentModeTopRight"];
    
    ZZArticleModel *model11 = [ZZArticleModel modelWithTitle:@"UIViewContentModeBottomLeft 左下 不会拉伸图片  原理和center一样" route:@"UIViewContentModeBottomLeft"];
    
    ZZArticleModel *model12 = [ZZArticleModel modelWithTitle:@"UIViewContentModeBottomRight 右下 不会拉伸图片  原理和center一样" route:@"UIViewContentModeBottomRight"]; // 8

    
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
    
    [self.modaDict setObject:@(UIViewContentModeScaleToFill) forKey:model0.route];
    [self.modaDict setObject:@(UIViewContentModeScaleAspectFit) forKey:model1.route];
    [self.modaDict setObject:@(UIViewContentModeScaleAspectFill) forKey:model2.route];
    [self.modaDict setObject:@(UIViewContentModeRedraw) forKey:model3.route];
    [self.modaDict setObject:@(UIViewContentModeCenter) forKey:model4.route];
    [self.modaDict setObject:@(UIViewContentModeTop) forKey:model5.route];
    [self.modaDict setObject:@(UIViewContentModeBottom) forKey:model6.route];
    [self.modaDict setObject:@(UIViewContentModeLeft) forKey:model7.route];
    [self.modaDict setObject:@(UIViewContentModeRight) forKey:model8.route];
    [self.modaDict setObject:@(UIViewContentModeTopLeft) forKey:model9.route];
    [self.modaDict setObject:@(UIViewContentModeTopRight) forKey:model10.route];
    [self.modaDict setObject:@(UIViewContentModeBottomLeft) forKey:model11.route];
    [self.modaDict setObject:@(UIViewContentModeBottomRight) forKey:model12.route];
}

- (CGFloat)__heightWithModel:(ZZArticleModel *)model {
    if (!model) {
        return 0;
    }
    UIFont *font = [UIFont systemFontOfSize:16];
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc]init];
    NSDictionary *attrDic= @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle};
    CGSize constrainSize = CGSizeMake(self.view.bounds.size.width, MAXFLOAT);
    CGSize size= [model.title boundingRectWithSize:constrainSize options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine) attributes:attrDic context:nil].size;
    return size.height;
}


#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ZZArticleModel *model = self.models[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd -> %@",indexPath.row,model.title];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    ZZImageModalViewController *vc = [[ZZImageModalViewController alloc] init];
    ZZArticleModel *model = self.models[indexPath.row];
    vc.title = model.route;
    vc.contentMode = [self.modaDict[model.route] integerValue];
    //超出容器范围的切除掉
    vc.clipsToBounds = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     ZZArticleModel *model = self.models[indexPath.row];
    return [self __heightWithModel:model] + 50;
}

#pragma mark - Getters & Setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
