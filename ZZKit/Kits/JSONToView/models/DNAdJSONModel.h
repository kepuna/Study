//
//  DNAdJSONModel.h
//  JSONToView
//
//  Created by donews on 2019/6/11.
//  Copyright © 2019年 donews. All rights reserved.
//

/*
 iOS的基础控件都是基于UIView的，所以我们也需要针对UIView的公共属性，抽象出一层顶层JsonModel，这些包括UIView的x、y、width、Height、background等，当然还有很多属性等待着未来扩展
 为了区别生成不同的UIView控件，在此model中还有个type属性，根据此字端来判断需要渲染哪种控件，以后所有子ViewModel都要继承此基类Model
 */

#import "DNAdJSONBaseModel.h"
#import <UIKit/UIKit.h>

@interface DNAdJSONModel : DNAdJSONBaseModel

/** 控件的唯一id */
@property (nonatomic, copy) NSString *viewId;

/** 指定控件的left等于某个控件的left */
@property (nonatomic, copy) NSString *equalLeftId;
/** 指定控件的right等于某个控件的right */
@property (nonatomic, copy) NSString *equalRightId;
/** 指定控件的top等于某个控件的top */
@property (nonatomic, copy) NSString *equalTopId;
/** 指定控件的bottom等于某个控件的bottom */
@property (nonatomic, copy) NSString *equalBottomId;
/** 指定控件的width等于某个控件的width */
@property (nonatomic, copy) NSString *equalWidthId;
/** 指定控件的height等于某个控件的height */
@property (nonatomic, copy) NSString *equalHeightId;

/** 距离左边的参照控件的id*/
@property (nonatomic, copy) NSString *rmlId;
/** 距离右边的参照控件的id*/
@property (nonatomic, copy) NSString *rmrId;
/** 距离上边的参照控件的id*/
@property (nonatomic, copy) NSString *rmtId;
/** 距离下边的参照控件的id*/
@property (nonatomic, copy) NSString *rmbId;

/** CenterH的参照控件的id*/
@property (nonatomic, copy) NSString *chId;
/** CenterV的参照控件的id*/
@property (nonatomic, copy) NSString *cvId;

/** 控件类型*/
@property (nonatomic, copy) NSString *type;

/** 距离父控件的margin left */
@property (nonatomic, strong) NSNumber *ml;
/** 距离父控件的margin top*/
@property (nonatomic, strong) NSNumber *mt;
/** 距离父控件的margin right */
@property (nonatomic, strong) NSNumber *mr;
/** 距离父控件的margin bottm */
@property (nonatomic, strong) NSNumber *mb;

/** 视图宽度*/
@property (nonatomic, strong) NSNumber *width;
/** 视图高度*/
@property (nonatomic, strong) NSNumber *height;

/**
 控件相对于父控件水平居中 距离 0时表示水平居中 大于0时表示控件水平向下偏移 小于0是水平向上偏移
 */
@property (nonatomic, strong) NSNumber *centerH;

/**
 控件相对于父控件垂直居中 距离 0时表示垂直居中 大于0时表示控件垂直向下偏移 小于0是垂直向上偏移
 */
@property (nonatomic, strong) NSNumber *centerV;

/** 背景颜色*/
@property (nonatomic, strong) UIColor *backgroundColor;
/**控件的圆角半径*/
@property (nonatomic, assign) CGFloat corner;
/**控件的边框*/
@property (nonatomic, assign) CGFloat border;
/**控件的边框颜色*/
@property (nonatomic, strong) UIColor *borderColor;


/**
 控件事件
 */
@property (nonatomic, copy) NSString *event;

@end

