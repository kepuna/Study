//
//  ZZFilterTest.m
//  HighPerformance
//
//  Created by MOMO on 2021/3/24.
//  Copyright © 2021 HelloWorld. All rights reserved.
//

#import "ZZFilterTest.h"
#import "Person.h"

@implementation ZZFilterTest

- (void)filterArray {
    
//    NSArray *stringArray = [[NSArray alloc]initWithObjects:@"beijing",@"shanghai",@"guangzou",@"wuhan", nil];
//    NSString *string = @"ang";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",string];
//
//    NSArray *tempArray = [stringArray filteredArrayUsingPredicate:pred];
    
    Person *person = [Person new];
    person.age = 0;
    
    Person *person1 = [Person new];
    person1.age = 1;
    
    Person *person2 = [Person new];
    person2.age = 2;
    
    Person *person3 = [Person new];
    person3.age = 3;
    
    Person *person4 = [Person new];
    person4.age = 4;
    
    NSString *filterNum = @"{1, 5}";
    NSArray *stringArray = @[person,person1,person2,person3,person4];
    if (![person respondsToSelector:@selector(age)]) {
        return;
    }
    NSString *string = [NSString stringWithFormat:@"NOT (age IN %@ )",filterNum];
    NSPredicate *pred = [NSPredicate predicateWithFormat:string];
    
    NSArray *tempArray = [stringArray filteredArrayUsingPredicate:pred];
//
    for (Person *p in tempArray) {
        NSLog(@"%zd",p.age);
    }
   

    
}

@end
