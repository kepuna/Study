//
//  ZZQuestion.h
//  UnitTestStudy
//
//  Created by MOMO on 2020/7/30.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZZPerson;
@class ZZAnswer;
NS_ASSUME_NONNULL_BEGIN

@interface ZZQuestion : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) NSString *title;

/**
 * The body of this question, as an HTML string.
 */
@property (copy) NSString *body;

/**
 * Upvotes received by this question, minus downvotes received.
 */
@property NSInteger score;

/**
 * An ordered collection of answers.
 */
@property (readonly) NSArray *answers;

/**
 * A numeric identifier, relating this question object to its
 * source on the website.
 */
@property NSInteger questionID;


/**
 * The person who asked this question on the website.
 */
@property (strong) ZZPerson *asker;


/**
 * Add another answer to this question's collection of answers.
 */
- (void)addAnswer: (ZZAnswer *)answer;

@end

NS_ASSUME_NONNULL_END
