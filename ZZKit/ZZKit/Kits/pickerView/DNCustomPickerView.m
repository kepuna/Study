//
//  DNCustomPickerView.m
//  MinePage
//
//  Created by donews on 2019/3/22.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNCustomPickerView.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define kHPercentage(a) (kScreenWidth*((a)/667.00))
#define kWPercentage(a) (kScreenHeight *((a)/375.00))

static const CGFloat pBottomViewH = 213;
static const CGFloat pToolBarViewH = 54;
static const CGFloat pBtnH = 23;
static const CGFloat pBtnW = 40;
static const CGFloat pBtnLeft = 12;
static const CGFloat pBtnTop = 13;

@interface DNCustomPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *confirmButton;
@property (nonatomic, strong) UILabel *titleView;

@property (nonatomic, strong) UIView *toolBarView;

@property (strong, nonatomic) NSString *seletedItem; // 选中的item
@property (assign, nonatomic) NSUInteger seletedIndex; // 选中的index
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, copy) NSString *tipTitle;

@end

@implementation DNCustomPickerView

- (instancetype)initWithItems:(NSArray<NSString *> *)items tipTitle:( NSString *)tipTitle{
    if (self = [super init]) {
        self.tipTitle = tipTitle;
        self.items = items;
        self.seletedItem = items.firstObject;
        self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.618];
        
        [self addSubview:self.bottomView];
        self.bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, pBottomViewH);
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.frame = CGRectMake(0, kScreenHeight - pBottomViewH, kScreenWidth, pBottomViewH);
            [self.bottomView layoutIfNeeded];
        }];
        
    }
    return self;
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated {
    self.seletedIndex = row;
    [self.pickerView selectRow:row inComponent:component animated:animated];
}

- (NSInteger)selectedRowInComponent:(NSInteger)component {
    return [self.pickerView selectedRowInComponent:component];
}

- (void)reloadComponent:(NSInteger)component {
    [self.pickerView reloadComponent:component];
}

- (void)reloadAllComponents {
    [self.pickerView reloadAllComponents];
}

#pragma mark - action
- (void)cancelButtonAction:(UIButton *)button {
    
    self.bottomView.frame = CGRectMake(0, kScreenHeight - pBottomViewH, kScreenWidth, pBottomViewH);
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, pBottomViewH);
        [self.bottomView layoutIfNeeded];
        self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)confirmButtonAction:(UIButton *)button {
    
    self.confirmBlock(self.seletedItem,self.seletedIndex);
    self.bottomView.frame = CGRectMake(0, kScreenHeight - pBottomViewH, kScreenWidth, pBottomViewH);
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, pBottomViewH);
        [self.bottomView layoutIfNeeded];
        
        self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


#pragma mark - pickerView 代理方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.items.count;
}

// 显示什么
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.items[row];
}

// 选中时
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.seletedItem = self.items[row];
    self.seletedIndex = row;
    UILabel *pickerLabel = (UILabel *)[pickerView viewForRow:row forComponent:component];
//    pickerLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    pickerLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 16];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
        }
    }
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
//        pickerLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        if (row == self.seletedIndex) {
             [pickerLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size: 16]];
        } else {
            [pickerLabel setFont:[UIFont fontWithName:@"PingFangSC-Thin" size: 14.5]];
        }
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    NSString *title = self.items[row];
//
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:title];
//    NSRange range = [title rangeOfString:title];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range];
//    return attributedString;
//}


#pragma mark - Getters & Setters
- (UIView *)toolBarView {
    if (_toolBarView == nil) {
        _toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, pToolBarViewH)];
        _toolBarView.backgroundColor = [UIColor whiteColor];
        UIView *marginView = [[UIView alloc] initWithFrame:CGRectMake(0, pToolBarViewH - 5, [UIScreen mainScreen].bounds.size.width, 5)];
        marginView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        [_toolBarView addSubview:marginView];
        [_toolBarView addSubview:self.cancelButton];
        [_toolBarView addSubview:self.confirmButton];
        [_toolBarView addSubview:self.titleView];
        
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_toolBarView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10,10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _toolBarView.bounds;
        maskLayer.path = maskPath.CGPath;
        _toolBarView.layer.mask = maskLayer;
    }
    return _toolBarView;
}



- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor clearColor];
        [_bottomView addSubview:self.toolBarView];
        [_bottomView addSubview:self.pickerView];
    }
    
    return _bottomView;
}

- (UILabel *)titleView {
    if (_titleView == nil) {
        CGFloat x = CGRectGetMaxX(self.cancelButton.frame);
        CGRect frame = CGRectMake(x, 0, kScreenWidth - x * 2, 49);
        _titleView = [[UILabel alloc] initWithFrame:frame];
        _titleView.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        _titleView.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _titleView.text = self.tipTitle;
        _titleView.textAlignment = NSTextAlignmentCenter;
    }
    return _titleView;
}

- (UIButton *)cancelButton {
    
    if (!_cancelButton) {
        
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(pBtnLeft, pBtnTop, pBtnW, pBtnH)];
        _cancelButton.backgroundColor = [UIColor clearColor];
        [_cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
        _cancelButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        [_cancelButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _cancelButton;
}

- (UIButton *)confirmButton {
    
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - pBtnW - pBtnLeft, pBtnTop, pBtnW, pBtnH)];
        _confirmButton.backgroundColor = [UIColor clearColor];
        [_confirmButton setTitle:@"确认" forState:(UIControlStateNormal)];
        _confirmButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 16];
        [_confirmButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _confirmButton;
}

- (UIPickerView *)pickerView {
    
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,pToolBarViewH, kScreenWidth, pBottomViewH - pToolBarViewH)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.tintColor = [UIColor greenColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:[UIScreen mainScreen].bounds];
}



@end

