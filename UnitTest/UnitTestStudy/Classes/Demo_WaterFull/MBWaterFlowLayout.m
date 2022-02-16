//
//  MBWaterFlowLayout.m
//  UnitTestStudy
//
//  Created by MOMO on 2021/1/23.
//  Copyright © 2021 HelloWorld. All rights reserved.
//

#import "MBWaterFlowLayout.h"
#import "MBWaterModel.h"

@interface MBWaterFlowLayout ()

@property (nonatomic, assign) CGFloat remmenberW;

// 所有item的属性的数组
@property (nonatomic, copy) NSArray *layoutAttributesArray;  // 定义布局属性的数组, 用来存放布局item 的属性

@end

@implementation MBWaterFlowLayout

- (NSArray *)layoutAttributesArray {
    if (_layoutAttributesArray == nil) {
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSInteger index = 0; index<20; index++) {
            MBWaterModel *model = [MBWaterModel new];
            model.width = 100 + 10;
            model.height = 100;
            [tempArray addObject:model];
        }
        _layoutAttributesArray = tempArray.copy;
    }
    return _layoutAttributesArray;
}

/**
 *  布局准备方法 当collectionView的布局发生变化时 会被调用
 *  通常是做布局的准备工作 itemSize.....
 *  UICollectionView 的 contentSize 是根据 itemSize 动态计算出来的
 */

- (void)prepareLayout {
    [super prepareLayout];
    
    // 根据行数 计算item的高度 所有item 的高度是一样的
    // 内容页的高度
    CGFloat contenHeight = self.collectionView.bounds.size.height - self.sectionInset.top - self.sectionInset.bottom;
    
    // 行与行之间的距离
    CGFloat marginY = self.minimumLineSpacing;
    
    // item 的高度
    CGFloat itemHeight = (contenHeight - marginY * (self.rowCount - 1)) / self.rowCount;
    
    // 计算布局属性
    [self computeAttributesWithItemWith:itemHeight];
}

// 根据itemHeight 计算布局属性
- (void)computeAttributesWithItemWith:(CGFloat)itemHeight {
    // 定义一个行宽数组 记录每一行的总宽度
    CGFloat rowWidth[self.rowCount];
    
    // 定义一个记录每一行的总item个数数组
    NSInteger rowItemCount[self.rowCount];
    
    for (int i = 0; i < self.rowCount; i++) {
        rowWidth[i] = self.sectionInset.left; // 行宽 要加上分区距离左边的距离 所以初始距离 只有分区距左边的距离
        rowItemCount[i] = 0;                  // 初始化时, 是每一行item 的个数为零, 清空数组元素内容
    }
    
    // 遍历modelList 数组, 计算相关属性
    NSInteger index = 0;  // 定义索引变量, 初始值为零
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:self.modelList.count];  // 定义一个可变存储布局属性的数组, 并开辟空间大小为self.modelList.count个空间
    
    // 遍历self.modelList 数组, 得到model 类, 获取属性
    for (MBWaterModel *model in self.modelList) {
        
        // 创建路径, 记录item 所在分区分区和位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        
        // 根据路径创建对应的布局属性
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        // 找出最短的行号
        NSInteger row = [self shortestRow:rowWidth];
        
        // 追加在最短行, 使记录每一行的总item个数数组中最短行对应的元素个数 +1
        rowItemCount[row]++;
        
        // X值
        CGFloat itemX = rowWidth[row]; // 最短行的总宽度
        
        // Y值
        CGFloat itemY = (itemHeight + self.minimumLineSpacing) * row + self.sectionInset.top; // 计算, 注意逻辑性
        
        // 等比例缩放 计算item 的宽度
        CGFloat itemW = (model.width / model.height) * itemHeight; // 显示宽 / 显示高 = 实际宽 / 实际高
        // 赋给布局属性的frame
        attributes.frame = CGRectMake(itemX, itemY, itemW, itemHeight);
        
        // 添加到布局属性的数组中
        [attributesArray addObject:attributes];
        
        // 使列宽增加, 增量为item 自身的宽度, 加上两个item 之间的最小距离
        rowWidth[row] += itemW + self.minimumInteritemSpacing;
        
        // 是索引+1
        index++;
    }
    
    //     找出 最宽行的行号
    NSInteger row = [self widthestRow:rowWidth];
    
    self.remmenberW =  rowWidth[row];
    
    // 根据最宽行设置itemSize 使用总宽度的平均值
    CGFloat itemW = (rowWidth[row] - self.minimumInteritemSpacing * rowItemCount[row]) / rowItemCount[row];
    
    self.itemSize = CGSizeMake(itemW, itemHeight);
    
    // 给属性数组设置数值
    self.layoutAttributesArray = attributesArray.copy;
    
}

// 找出rowWidth 数组中最短行号 追加数据的时候 追加在最短行中
- (NSInteger)shortestRow:(CGFloat *)rowWidth {
    CGFloat max = CGFLOAT_MAX;
    NSInteger row = 0;
    for (int i = 0; i < self.rowCount; i++) {
        if (rowWidth[i] < max) {
            max = rowWidth[i];
            row = i;
        }
    }
    return row;  // 返回最短的行
}

// 找出rowWidth 数组中最宽的行号
- (NSInteger)widthestRow:(CGFloat *)rowWidth {
    CGFloat min = 0;
    NSInteger row = 0;
    for (int i = 0; i < self.rowCount; i++) {
        if (rowWidth[i] > min) {
            min = rowWidth[i];
            row = i;
        }
    }
    return row;
}

/**
 *  跟踪效果：当到达要显示的区域时 会计算所有显示item的属性
 *           一旦计算完成 所有的属性会被缓存 不会再次计算
 *  @return 返回布局属性(UICollectionViewLayoutAttributes)数组
*/

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    // 直接返回计算好的布局属性数组
    return self.layoutAttributesArray;
}

// 重写此方法, 改变collectionView的contentSize
- (CGSize )collectionViewContentSize{
    return CGSizeMake(self.remmenberW, self.collectionView.bounds.size.height);
}

@end
