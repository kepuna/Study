//
//  ZZHuman.m
//  HighPerformance
//
//  Created by MOMO on 2020/6/29.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZHuman.h"

@implementation ZZHuman

+ (instancetype) humanWithName:(NSString *)name
{
    ZZHuman *human = [[ZZHuman alloc] init];
    human.name = name;
    return human;
}

+ (instancetype) humanCycleWithName:(NSString *)name
{
    ZZHuman *human = [[ZZHuman alloc] init];
    human.name = name;
//    human.family = [[NSMutableArray alloc] init]; // 造成循环引用
//    [human.family addObject:human];
    return human;
    
    // 在以上代码中,一个human的实例对象中包含一个strong修饰的family属性，但是在family属性中，又添加了human自身对象，这样会造成循环持有的问题，而导致内存泄漏。
//    但是项目需求又要求我们在该Model对象中完成如此代码，我们不得已会多创建一个类HHHumanRelationShip
}

+ (instancetype) humanHashTableWithName:(NSString *)name
{
    ZZHuman *human = [[ZZHuman alloc] init];
    human.name = name;
    human.family = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
    [human.family addObject:human];
    return human;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@'s retainCount is %lu",self.name,CFGetRetainCount((__bridge CFTypeRef)(self))];
}

+ (void)demoTest {
    
    ZZHuman *human_1 = [ZZHuman humanWithName:@"lilei"];
    ZZHuman *human_2 = [ZZHuman humanWithName:@"hanmeimei"];
    ZZHuman *human_3 = [ZZHuman humanWithName:@"lewis"];
    ZZHuman *human_4 = [ZZHuman humanWithName:@"xiaohao"];
    ZZHuman *human_5 = [ZZHuman humanWithName:@"beijing"];
    
    id list = @[human_1,human_2,human_3,human_4,human_5];
    id dict = @{@"excellent":human_1};
    NSLog(@"%@",list);
    
    // 通过上述两个例子我们能够发现一个问题，即将对象添加到容器时，会对该对象的引用技术+1
    
//    这样就会有可能发生循环持有的问题，例如如下代码:
}

+ (void)demoTestCycle {
    
}

/*
 
 NSHashTable可以使用的函数
 
 typedef struct {NSUInteger _pi; NSUInteger _si; void *_bs;} NSHashEnumerator;

 FOUNDATION_EXPORT void NSFreeHashTable(NSHashTable *table);
 FOUNDATION_EXPORT void NSResetHashTable(NSHashTable *table);
 FOUNDATION_EXPORT BOOL NSCompareHashTables(NSHashTable *table1, NSHashTable *table2);
 FOUNDATION_EXPORT NSHashTable *NSCopyHashTableWithZone(NSHashTable *table, NSZone *zone);
 FOUNDATION_EXPORT void *NSHashGet(NSHashTable *table, const void *pointer);
 FOUNDATION_EXPORT void NSHashInsert(NSHashTable *table, const void *pointer);
 FOUNDATION_EXPORT void NSHashInsertKnownAbsent(NSHashTable *table, const void *pointer);
 FOUNDATION_EXPORT void *NSHashInsertIfAbsent(NSHashTable *table, const void *pointer);
 FOUNDATION_EXPORT void NSHashRemove(NSHashTable *table, const void *pointer);
 FOUNDATION_EXPORT NSHashEnumerator NSEnumerateHashTable(NSHashTable *table);
 FOUNDATION_EXPORT void *NSNextHashEnumeratorItem(NSHashEnumerator *enumerator);
 FOUNDATION_EXPORT void NSEndHashTableEnumeration(NSHashEnumerator *enumerator);
 FOUNDATION_EXPORT NSUInteger NSCountHashTable(NSHashTable *table);
 FOUNDATION_EXPORT NSString *NSStringFromHashTable(NSHashTable *table);
 FOUNDATION_EXPORT NSArray *NSAllHashTableObjects(NSHashTable *table);
 */

+ (void)demoHashTable {
    //创建一个NSHashTableWeakMemory特性的HashTable对象
    // NSHashTableStrongMemory 将HashTable容器内的对象引用计数+1一次
    // NSHashTableWeakMemory 不会修改HashTable容器内对象元素的引用计数，并且对象释放后，会被自动移除
    // NSHashTable 类似 NSMutableArray 的用法和数据结构
    NSHashTable *hash_tab = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
//    NSMutableArray *array = [NSMutableArray array];
    @autoreleasepool {
        //通过便利构造器获取一个name属性是lewis的human对象
        ZZHuman *human = [ZZHuman humanHashTableWithName:@"lewis"];
        //将该对象添加到HashTable容器中
        [hash_tab addObject:human];
//        [array addObject:human];
        //释放之前打印human
        NSLog(@"before pool:%@",human);
    }
    NSLog(@"after pool:%@",hash_tab);
//    NSLog(@"after pool:%@",array);
    
}



// NSMapTable对象类似与NSDictionary的数据结构，但是NSMapTable功能比NSDictionary对象要多的功能就是可以设置key和value的NSPointerFunctionsOptions特性!
/*
 和 NSDictionary/NSMutableDictionary 相比具有如下特性：

 NSDictionary/NSMutableDictionary 会复制 keys 并且通过强引用 values 来实现存储；
 NSMapTable 是可变的；
 NSMapTable 可以通过弱引用来持有 keys 和 values，所以当 key 或者 value 被 deallocated 的时候，所存储的实体也会被移除；
 NSMapTable 可以在添加 value 的时候对 value 进行复制；
 
 NSMapTable可以使用的函数
 
 FOUNDATION_EXPORT void NSFreeMapTable(NSMapTable *table);
 FOUNDATION_EXPORT void NSResetMapTable(NSMapTable *table);
 FOUNDATION_EXPORT BOOL NSCompareMapTables(NSMapTable *table1, NSMapTable *table2);
 FOUNDATION_EXPORT NSMapTable *NSCopyMapTableWithZone(NSMapTable *table, NSZone *zone);
 FOUNDATION_EXPORT BOOL NSMapMember(NSMapTable *table, const void *key, void **originalKey, void **value);
 FOUNDATION_EXPORT void *NSMapGet(NSMapTable *table, const void *key);
 FOUNDATION_EXPORT void NSMapInsert(NSMapTable *table, const void *key, const void *value);
 FOUNDATION_EXPORT void NSMapInsertKnownAbsent(NSMapTable *table, const void *key, const void *value);
 FOUNDATION_EXPORT void *NSMapInsertIfAbsent(NSMapTable *table, const void *key, const void *value);
 FOUNDATION_EXPORT void NSMapRemove(NSMapTable *table, const void *key);
 FOUNDATION_EXPORT NSMapEnumerator NSEnumerateMapTable(NSMapTable *table);
 FOUNDATION_EXPORT BOOL NSNextMapEnumeratorPair(NSMapEnumerator *enumerator, void **key, void **value);
 FOUNDATION_EXPORT void NSEndMapTableEnumeration(NSMapEnumerator *enumerator);
 FOUNDATION_EXPORT NSUInteger NSCountMapTable(NSMapTable *table);
 FOUNDATION_EXPORT NSString *NSStringFromMapTable(NSMapTable *table);
 FOUNDATION_EXPORT NSArray *NSAllMapTableKeys(NSMapTable *table);
 FOUNDATION_EXPORT NSArray *NSAllMapTableValues(NSMapTable *table);
 */

+ (void)demoMapTable {
    
    /*
     总结起来一共有 4 种可能：

     key 为 strong，value 为 strong
     key 为 strong，value 为 weak
     key 为 weak，value 为 strong
     key 为 weak，value 为 weak
     
     weakToStrongObjectsMapTable 相当于
     
     NSPointerFunctionsOptions weakOptions = NSPointerFunctionsWeakMemory | NSPointerFunctionsObjectPointerPersonality;
         NSPointerFunctionsOptions strongOptions = NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPointerPersonality;
         weakKeyStrongObjectsMapTable = [NSMapTable mapTableWithKeyOptions:weakOptions valueOptions:strongOptions];
     
     */
    
//    NSMapTable的keys或者values是可选地持有weak类型对象的。当NSMapTable中的weak类性的key或者value释放的时候，相应的键值对会自动从NSMapTable中移除。
    
    NSMapTable *mapTable = [NSMapTable mapTableWithKeyOptions:(NSMapTableStrongMemory) valueOptions:(NSMapTableWeakMemory)];
    
    @autoreleasepool {
        NSObject *key = [NSObject new];
        NSObject *value = [NSObject new];
        
        [mapTable setObject:value forKey:key];
         NSLog(@"mapTable is: %@", mapTable); // mapTable is: NSMapTable {<NSObject: 0x6000008df890> -> <NSObject: 0x6000008df870>}
    }
    NSLog(@"mapTable is: %@", mapTable); // mapTable is: NSMapTable {}; key 是 weak 引用，所以析构之后 NSMapTable 就会移除对应的项
    
}

@end
