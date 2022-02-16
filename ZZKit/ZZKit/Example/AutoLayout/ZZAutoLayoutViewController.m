//
//  ZZAutoLayoutViewController.m
//  ZZKit
//
//  Created by donews on 2019/6/19.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZAutoLayoutViewController.h"

@interface ZZAutoLayoutViewController ()

@end



 /* VFL约束
 * 需求
 *
 * 我们需要布局红(view_1)、绿(view_2)、蓝(view_3)三个view位置如图所示，
 * 他们距离父视图边距以及相互之间的距离都为30px，红色view和绿色view宽度相等，
 * 并且三个view的高度相等。并且在横屏时，他们的位置还是一样保持不变。
 *
 */

/*
 
 注释：
 
 |: 表示父视图
 
 -:表示距离
 
 V:  :表示垂直
 
 H:  :表示水平
 
 >= :表示视图间距、宽度和高度必须大于或等于某个值
 
 <= :表示视图间距、宽度和高度必须小宇或等于某个值
 
 == :表示视图间距、宽度或者高度必须等于某个值
 
 @  :>=、<=、==  限制   最大为  1000
 
 
 1.|-[view]-|:  视图处在父视图的左右边缘内
 
 2.|-[view]  :   视图处在父视图的左边缘
 
 3.|[view]   :   视图和父视图左边对齐
 
 4.-[view]-  :  设置视图的宽度高度
 
 5.|-30.0-[view]-30.0-|:  表示离父视图 左右间距  30
 
 6.[view(200.0)] : 表示视图宽度为 200.0
 
 7.|-[view(view1)]-[view1]-| :表示视图宽度一样，并且在父视图左右边缘内
 
 8. V:|-[view(50.0)] : 视图高度为  50
 
 9: V:|-(==padding)-[imageView]->=0-[button]-(==padding)-| : 表示离父视图的距离
 
 为Padding,这两个视图间距必须大于或等于0并且距离底部父视图为 padding。
 
 10:  [wideView(>=60@700)]  :视图的宽度为至少为60 不能超过  700
 
 11: 如果没有声明方向默认为  水平  V:
 
 
 (NSLayoutFormatOptions) opts:见枚举类型，解释部分。
 
 常用的就这些：
 
 NSLayoutFormatAlignAllLeft//控件之间左对齐
 
 NSLayoutFormatAlignAllRight//控件之间右对齐
 
 NSLayoutFormatAlignAllTop//...上对齐
 
 NSLayoutFormatAlignAllBottom//...下对齐
 
 NSLayoutFormatAlignAllLeading // 使所有视图根据当前区域文字开始的边缘对齐（英语：左边，希伯来语：右边）
 
 NSLayoutFormatAlignAllTrailing // 使所有视图根据当前区域文字结束的边缘对齐（英语：右边，希伯来语：左边）。
 
 NSLayoutFormatAlignAllCenterX // 使所有视图通过设置中心点的 X 值彼此相等来对齐。
 
 (NSString*)format 这就是核心VFL语句了,举例说明(H表示水平方向，V表示垂直方向)
 
 H:|-[view]-|　　　　　　　　//view与superview的左右边界为标准间距
 
 H:|-[view]　　　　　　　　　//view与superview的左边界为标准间距，右边不处理
 
 H:|[view]　　　　　　　　 　//view与superview的左边界对齐，右边不处理
 
 H:|-20.0-[view]-30.0f-|  //view与superview的左边边界间距分别为20，和30
 
 H:[view(100.0)]　　　　　　//view宽度为100
 
 H:|-[button1(button2)]-[button2]-| //button1与button2等宽，之间为标准间距.....
 
 V:|-20.0-[view(30.0)] //view距顶部边界20，自身高度为30.0
 
 //注意：在写两个控件左右边距或者上下边距的时候，控件输写的顺序请按照UI界面的顺序写。
 
 也就是说@“H:[_nameTextField]-20-[button]”表示_nameTextfield与button之间的间距为20，_nameTextField在左边，button在右边；
 
 @“H:[button]－20-[_nameTextField]”表示button与_nametextField之间的距离为20，button在左边，_nameTextField在右边。
 
 //注意：在写两个控件之间的距离时，左右两边不能加两个｜｜
 
 */

@implementation ZZAutoLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self demo1_layout];
    [self demo2_layout];
    
}

- (void)demo1_layout {
    
    //1.首先，创建视图控件，添加到self.view上
    UIView *view_1 = [[UIView alloc] init];
    view_1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view_1];
    UIView *view_2 = [[UIView alloc] init];
    view_2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view_2];
    UIView *view_3 = [[UIView alloc] init];
    view_3.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view_3];
    
    //2.然后，记得要把AutoresizingMask布局关掉
    view_1.translatesAutoresizingMaskIntoConstraints = NO;
    view_2.translatesAutoresizingMaskIntoConstraints = NO;
    view_3.translatesAutoresizingMaskIntoConstraints = NO;
    
    //3.接着，添加约束
    NSNumber *margin = @(30);
    NSNumber *spacing = @(30);
    NSDictionary *views = NSDictionaryOfVariableBindings(view_1,view_2,view_3);
    
    // 添加水平方向的约束1
    NSString *vfl = @"H:|-margin-[view_1]-spacing-[view_2(==view_1)]-margin-|";
    NSDictionary *mertrics = NSDictionaryOfVariableBindings(margin,spacing);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:mertrics views:views];
    [self.view addConstraints:constraints];
    
    // 添加水平方向的约束2
    NSString *vfl1 = @"H:|-margin-[view_3]-margin-|";
    NSDictionary *mertrics1 = NSDictionaryOfVariableBindings(margin,spacing);
    NSArray *constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:kNilOptions metrics:mertrics1 views:views];
    [self.view addConstraints:constraints1];
    
    // 添加竖直方向的约束
    NSString *vfl2 = @"V:|-margin-[view_1]-spacing-[view_3(==view_1)]-margin-|";
    NSDictionary *mertrics2 = NSDictionaryOfVariableBindings(margin, spacing);
    NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:kNilOptions metrics:mertrics2 views:views];
    [self.view addConstraints:constraints2];
}

- (void)demo2_layout {
    
    //1.首先，创建视图控件，添加到self.view上
    UIView *view_1 = [[UIView alloc] init];
    view_1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view_1];
    UIView *view_2 = [[UIView alloc] init];
    view_2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view_2];
    UIView *view_3 = [[UIView alloc] init];
    view_3.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view_3];
    
    //2.然后，记得要把AutoresizingMask布局关掉
    view_1.translatesAutoresizingMaskIntoConstraints = NO;
    view_2.translatesAutoresizingMaskIntoConstraints = NO;
    view_3.translatesAutoresizingMaskIntoConstraints = NO;
    
    //3.接着，添加约束
    NSNumber *margin = @(10);
    NSNumber *spacing = @(20);
    NSDictionary *views = NSDictionaryOfVariableBindings(view_1,view_2,view_3);
    
    // 添加水平方向的约束1
    NSString *vfl = @"H:|-margin-[view_1]-spacing-[view_2(==view_1)]-margin-|";
    NSDictionary *mertrics = NSDictionaryOfVariableBindings(margin,spacing);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:vfl options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:mertrics views:views];
    [self.view addConstraints:constraints];
    
    // 添加水平方向的约束2
    NSString *vfl1 = @"H:|-margin-[view_3]-margin-|";
    NSDictionary *mertrics1 = NSDictionaryOfVariableBindings(margin,spacing);
    NSArray *constraints1 = [NSLayoutConstraint constraintsWithVisualFormat:vfl1 options:kNilOptions metrics:mertrics1 views:views];
    [self.view addConstraints:constraints1];
    
    // 添加竖直方向的约束
    NSString *vfl2 = @"V:|-margin-[view_1(<=300)]-margin-[view_3]-spacing-|";
    NSDictionary *mertrics2 = NSDictionaryOfVariableBindings(margin, spacing);
    NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:kNilOptions metrics:mertrics2 views:views];
    [self.view addConstraints:constraints2];
    
    
}


@end
