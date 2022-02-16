//
//  ZZYTwitterViewController.m
//  UnitTestStudy
//
//  Created by donews on 2019/9/27.
//  Copyright © 2019年 HelloWorld. All rights reserved.
//

#import "ZZYTwitterViewController.h"


@interface ZZYTwitterViewController ()



@end

@implementation ZZYTwitterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)updateTweetView{
    NSArray *tweets = [self.connection fetchTweets];
    if (tweets != nil) {
        for (ZZYTweet *tweet in tweets) {
            [self.tweetView addTweet:tweet];
        }
        /* display tweets */
    } else {
        /* handle error cases */
    }
}

- (void)updateTweetView2{
    NSArray *tweets = [ZZYTwitterConnection fetchTweets];
    if (tweets != nil) {
        for (ZZYTweet *tweet in tweets) {
            [self.tweetView addTweet:tweet];
        }
    } else {
        /* handle error cases */
    }

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
