//
//  DNAdJSONLabelModel.h
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "DNAdJSONModel.h"

@interface DNAdJSONLabelModel : DNAdJSONModel

/**字体颜色*/
@property(nonatomic, strong) UIColor *textColor;
/**字体大小*/
@property(nonatomic, assign) double textSize;
/**文字*/
@property(nonatomic, copy) NSString *text;
/** 行数 */
@property(nonatomic, assign) NSInteger numberOfLines;
/** 行间距 */
@property(nonatomic, assign) double lineSpacing;

@end
