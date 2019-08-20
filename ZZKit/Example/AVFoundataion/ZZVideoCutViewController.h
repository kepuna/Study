//
//  ZZVideoCutViewController.h
//  ZZKit
//
//  Created by donews on 2019/5/5.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZZVideoCutViewController : UIViewController

/**
 原视频的URL
 */
@property (nonatomic, strong) NSURL *videoUrl;

/**
 * 视频是否可进行裁剪编辑并显示视频帧 （默认YES  NO表示不显示视频帧且不可编辑）
 */
@property (nonatomic, assign) BOOL isEdit;

@end

