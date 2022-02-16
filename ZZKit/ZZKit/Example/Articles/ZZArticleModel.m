//
//  ZZArticleModel.m
//  ZZKit
//
//  Created by donews on 2019/4/29.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZArticleModel.h"

@interface ZZArticleModel ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *route;

@end

@implementation ZZArticleModel

+ (instancetype)modelWithTitle:(NSString *)title route:(NSString *)route {
    ZZArticleModel *model = [[ZZArticleModel alloc] init];
    model.title = title;
    model.route  = route;
    return model;
}

@end
