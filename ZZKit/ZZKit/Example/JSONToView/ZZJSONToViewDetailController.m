//
//  ZZJSONToViewDetailController.m
//  ZZKit
//
//  Created by donews on 2019/8/21.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "ZZJSONToViewDetailController.h"
#import "DNAdJSONBaseView.h"

@interface ZZJSONToViewDetailController ()

@property (nonatomic, strong) DNAdJSONBaseView *jsonView;

@end

@implementation ZZJSONToViewDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *files = @[@"adview_video",@"adview_big",@"adview_small",@"adview_group"];
    
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:files[self.index] ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSData *datapars = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    // 转换成json字符串
    NSString *jsonString = [[NSString alloc]initWithData:datapars encoding:NSUTF8StringEncoding];
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    NSData *jsonData = [mutStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    _jsonView = [DNAdJSONBaseView new];
    [self.view addSubview:_jsonView];
    [_jsonView obtainResult:^(DNAdJsonNotificationResultModel *result) {
        NSLog(@">>>%@",result);
    }];
    _jsonView.jsonString = jsonStr;
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
