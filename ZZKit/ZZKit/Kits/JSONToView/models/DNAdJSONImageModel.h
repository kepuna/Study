//
//  DNAdJSONImageModel.h
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNAdJSONModel.h"

@interface DNAdJSONImageModel : DNAdJSONModel

/**url*/
@property(nonatomic, copy) NSString *url;
/**本地图片*/
@property(nonatomic, copy) NSString *localImageName;
/**是否需要回调*/
@property(nonatomic, assign) BOOL isNeedCallBack;

@end

