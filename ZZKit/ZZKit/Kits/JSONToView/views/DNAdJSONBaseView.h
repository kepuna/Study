//
//  DNAdJSONBaseView.h
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNAdJsonNotificationResultModel.h"

typedef void (^resultBlock)(DNAdJsonNotificationResultModel *);

@interface DNAdJSONBaseView : UIView

/** json字符串 */
@property (nonatomic, copy) NSString *jsonString;

- (void)obtainResult:(resultBlock)result;

@end

