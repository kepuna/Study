//
//  MBWaterFlowLayout.h
//  UnitTestStudy
//
//  Created by MOMO on 2021/1/23.
//  Copyright © 2021 HelloWorld. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBWaterFlowLayout : UICollectionViewFlowLayout

// 总行数
@property (nonatomic, assign) NSInteger rowCount;
// 商品数据数组
@property (nonatomic, strong) NSArray *modelList;

@end

NS_ASSUME_NONNULL_END
