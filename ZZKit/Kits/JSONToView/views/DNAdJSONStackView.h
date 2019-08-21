//
//  DNAdJSONStackView.h
//  JSONToView
//
//  Created by donews on 2019/6/28.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DNAdJSONStackViewModel;

@interface DNAdJSONStackView : UIStackView

@property (nonatomic, strong) DNAdJSONStackViewModel *model;

@end

