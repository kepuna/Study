//
//  ZZArticleModel.h
//  ZZKit
//
//  Created by donews on 2019/4/29.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ZZArticleModel : NSObject

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *route;

+ (instancetype)modelWithTitle:(NSString *)title route:(NSString *)route;

@end
