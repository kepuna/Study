//
//  DNCustomPickerView.h
//  MinePage
//
//  Created by donews on 2019/3/22.
//  Copyright © 2019年 donews. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^DNCustomPickerViewBlock)(NSString *selectedItem, NSUInteger selectedIndex);

@interface DNCustomPickerView : UIView

@property (strong, nonatomic) DNCustomPickerViewBlock confirmBlock;

/// 初始化方法
- (instancetype)initWithItems:(NSArray<NSString *> *)items tipTitle:(NSString *)tipTitle;
/// 选中某个item
/// selection. in this case, it means showing the appropriate row in the middle
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;  // scrolls the specified row to center.

- (NSInteger)selectedRowInComponent:(NSInteger)component;                                   // returns selected row. -1 if nothing selected

// Reloading whole view or single component
- (void)reloadAllComponents;
- (void)reloadComponent:(NSInteger)component;


@end


