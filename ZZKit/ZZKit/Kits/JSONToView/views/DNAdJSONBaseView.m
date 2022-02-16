//
//  DNAdJSONBaseView.m
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNAdJSONBaseView.h"
#import "DNAdJSONModel.h"
#import "DNAdJSONViewModel.h"
#import "DNAdJSONNotificationManager.h"
#import "DNAdJSONLabelModel.h"
#import "DNAdJSONImageModel.h"
#import "DNAdJSONLabel.h"
#import "DNAdJSONImageView.h"
#import "DNAdJSONView.h"
#import "DNAdJSONStackView.h"
#import "DNAdJSONStackViewModel.h"
#import "UIView+DNAdFrame.h"
#import "UIView+DNAdAutoLayout.h"


@interface DNAdJSONBaseView ()

@property (nonatomic, strong) DNAdJSONViewModel *model;
@property (nonatomic, strong) DNAdJSONNotificationManager *manager;
@property (nonatomic, strong) NSMutableDictionary *viewDict;

@end

@implementation DNAdJSONBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _viewDict = @{}.mutableCopy;
        _manager = [DNAdJSONNotificationManager new];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)obtainResult:(resultBlock)result
{
    self.manager.result = result;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setJsonString:(NSString *)jsonString
{
    if (![self validateData:jsonString]) {
        return;
    }
    _jsonString = jsonString;
    _model = [self.class modelWithJsonString:jsonString];
    [self creatJsonTopViewWithModel:_model];
}

- (BOOL)validateData:(NSString *)jsonString
{
    return [jsonString isKindOfClass:[NSString class]] || jsonString == nil;
}

- (void)creatJsonTopViewWithModel:(DNAdJSONViewModel *)model
{
    if (![model isKindOfClass:[DNAdJSONViewModel class]]) return;
    if (!model || ![model.type isEqualToString:@"view"]) {
        self.backgroundColor = [UIColor blackColor];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
    } else {
        
        if (model.backgroundColor) {
            self.backgroundColor = model.backgroundColor;
        }
        if (model.event) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(s_tapEvent)];
            [self addGestureRecognizer:tap];
        }
        self.translatesAutoresizingMaskIntoConstraints = NO; // 布局
        
        [self setWidthInView:self.superview viewModel:model];
        [self setHeightInView:self.superview viewModel:model];
        [self setLeftInView:self.superview relativeView:nil equalView:nil viewModel:model];
        [self setRightInView:self.superview relativeView:nil equalView:nil viewModel:model];
        [self setTopInView:self.superview relativeView:nil equalView:nil viewModel:model];
        [self setBottomInView:self.superview relativeView:nil equalView:nil viewModel:model];
        
        [self creatJsonSubViewsWith:model inView:self];
    }
}

- (void)s_tapEvent {
    NSLog(@"点击了adView");
}

- (UIView *)__relativeViewById:(NSString *)rid {
    if (rid.length) {
        UIView *tempView = [self.viewDict objectForKey:rid];
        if (tempView) {
            return tempView;
        }
    }
    return nil;
}

- (void)creatJsonSubViewsWith:(DNAdJSONViewModel *)model inView:(UIView *)rootView
{
    for (DNAdJSONModel *subModel in model.subViews) {
        if ([subModel isKindOfClass:[DNAdJSONViewModel class]]) {
            DNAdJSONViewModel *viewModel = (DNAdJSONViewModel *)subModel;
            DNAdJSONView *view = [DNAdJSONView new];
            [rootView addSubview:view];
            view.model = viewModel;
            
            UIView *rmlView = [self __relativeViewById:viewModel.rmlId];
            UIView *rmrView = [self __relativeViewById:viewModel.rmrId];
            UIView *rmtView = [self __relativeViewById:viewModel.rmtId];
            UIView *rmbView = [self __relativeViewById:viewModel.rmbId];
            
            UIView *elView = [self __relativeViewById:viewModel.equalLeftId];
            UIView *erView = [self __relativeViewById:viewModel.equalRightId];
            UIView *etView = [self __relativeViewById:viewModel.equalTopId];
            UIView *ebView = [self __relativeViewById:viewModel.equalBottomId];
            UIView *ewView = [self __relativeViewById:viewModel.equalWidthId];
            UIView *ehView = [self __relativeViewById:viewModel.equalHeightId];
            
            UIView *chView = [self __relativeViewById:viewModel.chId];
            UIView *cvView = [self __relativeViewById:viewModel.cvId];
            
            view.translatesAutoresizingMaskIntoConstraints = NO;
            
            [view setCenterXInView:rootView relativeView:cvView viewModel:viewModel]; // 水平
            [view setCenterYInView:rootView relativeView:chView viewModel:viewModel];// 垂直
            [view setWidthInView:rootView viewModel:viewModel];
            [view setHeightInView:rootView viewModel:viewModel];
            [view setLeftInView:rootView relativeView:rmlView equalView:elView viewModel:viewModel];
            [view setRightInView:rootView relativeView:rmrView equalView:erView viewModel:viewModel];
            [view setTopInView:rootView relativeView:rmtView equalView:etView viewModel:viewModel];
            [view setBottomInView:rootView relativeView:rmbView equalView:ebView viewModel:viewModel];
            
            [view equalWidthInView:rootView relativeView:ewView];
            [view equalHeightInView:rootView relativeView:ehView];
            
            
            if (view && viewModel.viewId) {
                [self.viewDict setObject:view forKey:viewModel.viewId]; // 将试图放入字典
            }
            if ([viewModel.subViews count] > 0) {
                [self creatJsonSubViewsWith:(DNAdJSONViewModel *)subModel inView:view];
            }
        }
        
        if ([subModel isKindOfClass:[DNAdJSONStackViewModel class]]) {
            DNAdJSONStackViewModel *viewModel = (DNAdJSONStackViewModel *)subModel;
            DNAdJSONStackView *view = [DNAdJSONStackView new];
            view.model = viewModel;
            [rootView addSubview:view];
            
            
            UIView *rmlView = [self __relativeViewById:viewModel.rmlId];
            UIView *rmrView = [self __relativeViewById:viewModel.rmrId];
            UIView *rmtView = [self __relativeViewById:viewModel.rmtId];
            UIView *rmbView = [self __relativeViewById:viewModel.rmbId];
            
            UIView *elView = [self __relativeViewById:viewModel.equalLeftId];
            UIView *erView = [self __relativeViewById:viewModel.equalRightId];
            UIView *etView = [self __relativeViewById:viewModel.equalTopId];
            UIView *ebView = [self __relativeViewById:viewModel.equalBottomId];
            UIView *ewView = [self __relativeViewById:viewModel.equalWidthId];
            UIView *ehView = [self __relativeViewById:viewModel.equalHeightId];
            
            UIView *chView = [self __relativeViewById:viewModel.chId];
            UIView *cvView = [self __relativeViewById:viewModel.cvId];
            
            view.translatesAutoresizingMaskIntoConstraints = NO;
            
            [view setCenterXInView:rootView relativeView:cvView viewModel:viewModel]; // 水平
            [view setCenterYInView:rootView relativeView:chView viewModel:viewModel];// 垂直
            [view setWidthInView:rootView viewModel:viewModel];
            [view setHeightInView:rootView viewModel:viewModel];
            [view setLeftInView:rootView relativeView:rmlView equalView:elView viewModel:viewModel];
            [view setRightInView:rootView relativeView:rmrView equalView:erView viewModel:viewModel];
            [view setTopInView:rootView relativeView:rmtView equalView:etView viewModel:viewModel];
            [view setBottomInView:rootView relativeView:rmbView equalView:ebView viewModel:viewModel];
            
            [view equalWidthInView:rootView relativeView:ewView];
            [view equalHeightInView:rootView relativeView:ehView];
            
            if (view && viewModel.viewId) {
                [self.viewDict setObject:view forKey:viewModel.viewId]; // 将试图放入字典
            }
        }
        
        // label 控件
        if ([subModel isKindOfClass:[DNAdJSONLabelModel class]]) {
            DNAdJSONLabelModel *viewModel = (DNAdJSONLabelModel *)subModel;
            DNAdJSONLabel *view = [DNAdJSONLabel new];
            [rootView addSubview:view];
            view.model = viewModel;
            
            UIView *rmlView = [self __relativeViewById:viewModel.rmlId];
            UIView *rmrView = [self __relativeViewById:viewModel.rmrId];
            UIView *rmtView = [self __relativeViewById:viewModel.rmtId];
            UIView *rmbView = [self __relativeViewById:viewModel.rmbId];
            
            UIView *elView = [self __relativeViewById:viewModel.equalLeftId];
            UIView *erView = [self __relativeViewById:viewModel.equalRightId];
            UIView *etView = [self __relativeViewById:viewModel.equalTopId];
            UIView *ebView = [self __relativeViewById:viewModel.equalBottomId];
            UIView *ewView = [self __relativeViewById:viewModel.equalWidthId];
            UIView *ehView = [self __relativeViewById:viewModel.equalHeightId];
            
            UIView *chView = [self __relativeViewById:viewModel.chId];
            UIView *cvView = [self __relativeViewById:viewModel.cvId];
            
            view.translatesAutoresizingMaskIntoConstraints = NO;
            
            [view setCenterXInView:rootView relativeView:cvView viewModel:viewModel]; // 水平
            [view setCenterYInView:rootView relativeView:chView viewModel:viewModel];// 垂直
            [view setWidthInView:rootView viewModel:viewModel];
            [view setHeightInView:rootView viewModel:viewModel];
            
            [view setLeftInView:rootView relativeView:rmlView equalView:elView viewModel:viewModel];
            [view setRightInView:rootView relativeView:rmrView equalView:erView viewModel:viewModel];
            [view setTopInView:rootView relativeView:rmtView equalView:etView viewModel:viewModel];
            [view setBottomInView:rootView relativeView:rmbView equalView:ebView viewModel:viewModel];
            
            [view equalWidthInView:rootView relativeView:ewView];
            [view equalHeightInView:rootView relativeView:ehView];
            
            if (view && viewModel.viewId) {
                [self.viewDict setObject:view forKey:viewModel.viewId]; // 将试图放入字典
            }
            
        }
        // imageView 控件
        if ([subModel isKindOfClass:[DNAdJSONImageModel class]]) {
            DNAdJSONImageModel *viewModel = (DNAdJSONImageModel *)subModel;
            DNAdJSONImageView *view = [DNAdJSONImageView new];
            [rootView addSubview:view];
            view.model = viewModel;
            
            UIView *rmlView = [self __relativeViewById:viewModel.rmlId];
            UIView *rmrView = [self __relativeViewById:viewModel.rmrId];
            UIView *rmtView = [self __relativeViewById:viewModel.rmtId];
            UIView *rmbView = [self __relativeViewById:viewModel.rmbId];
            
            UIView *elView = [self __relativeViewById:viewModel.equalLeftId];
            UIView *erView = [self __relativeViewById:viewModel.equalRightId];
            UIView *etView = [self __relativeViewById:viewModel.equalTopId];
            UIView *ebView = [self __relativeViewById:viewModel.equalBottomId];
            UIView *ewView = [self __relativeViewById:viewModel.equalWidthId];
            UIView *ehView = [self __relativeViewById:viewModel.equalHeightId];
            
            UIView *chView = [self __relativeViewById:viewModel.chId];
            UIView *cvView = [self __relativeViewById:viewModel.cvId];
            
            view.translatesAutoresizingMaskIntoConstraints = NO;
            
            [view setCenterXInView:rootView relativeView:cvView viewModel:viewModel]; // 水平
            [view setCenterYInView:rootView relativeView:chView viewModel:viewModel];// 垂直
            [view setWidthInView:rootView viewModel:viewModel];
            [view setHeightInView:rootView viewModel:viewModel];
            [view setLeftInView:rootView relativeView:rmlView equalView:elView viewModel:viewModel];
            [view setRightInView:rootView relativeView:rmrView equalView:erView viewModel:viewModel];
            [view setTopInView:rootView relativeView:rmtView equalView:etView viewModel:viewModel];
            [view setBottomInView:rootView relativeView:rmbView equalView:ebView viewModel:viewModel];
            
            [view equalWidthInView:rootView relativeView:ewView];
            [view equalHeightInView:rootView relativeView:ehView];
            
            if (view && viewModel.viewId) {
                [self.viewDict setObject:view forKey:viewModel.viewId]; // 将试图放入字典
            }
        }
    }
}

+ (DNAdJSONViewModel *)modelWithJsonString:(NSString *)jsonString
{
    NSDictionary *dic = [self.class JSONValue:jsonString];
    return [DNAdJSONViewModel modelWithDictionary:dic];
}

+ (id)JSONValue:(NSString *)s
{
    if (s.length == 0) return @{};
    NSError *error = nil;
    id obj = [NSJSONSerialization JSONObjectWithData:[s dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    if (error)
    {
        NSLog(@"%@", error);
        return nil;
    }
    return obj;
}

@end
