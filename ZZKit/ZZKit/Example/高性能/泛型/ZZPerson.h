//
//  ZZPerson.h
//  HighPerformance
//
//  Created by MOMO on 2020/6/23.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
泛型使用场景:

在集合(数组、字典、NSSet)中使用泛型比较常见。
当声明一个类，类里面的某些属性的类型不确定，这时候我们才使用泛型。
 
 __covariant(协变):用于泛型数据强转类型，可以向上强转，子类可以转成父类。
 __contravariant(逆变):用于泛型数据强转类型，可以向下强转，父类可以转成子类。
 
 */


// __covariant 协变，子类转父类；泛型名字是ObjectType
// __contravariant 可以逆变,父类转子类   泛型名字是ObjectType;  逆变要求父类和子类能够提供同样的行为，所以通过父类的接口创建的范型类，可以用来处理子类。

// 也可以为范型增加轻量级的约束，比如要求ObjectType实现NSCopying协议：

//@interface ZZPerson<ObjectType:id<NSCopying>> : NSObject

@interface ZZPerson<__contravariant ObjectType> : NSObject
//@interface ZZPerson<__covariant ObjectType> : NSObject

/// 语言
@property (nonatomic, strong) ObjectType language;

@property (nonatomic, assign) NSInteger seatId;


@end

NS_ASSUME_NONNULL_END



/*
 泛型方法
 
 
 
 */
