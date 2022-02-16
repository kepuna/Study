//
//  DNAdJSONViewModel.h
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//  对应view

#import "DNAdJSONModel.h"

@interface DNAdJSONViewModel : DNAdJSONModel

/* 生成嵌套View的关键 */
@property (nonatomic, strong) NSArray <DNAdJSONModel *> *subViews;

@end
