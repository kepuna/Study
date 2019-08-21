//
//  DNAdJsonNotificationResultModel.h
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DNAdJsonNotificationResultModel : NSObject

/**
 名称
 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSError *error;

@end

