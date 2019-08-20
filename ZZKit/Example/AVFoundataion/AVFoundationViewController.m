//
//  AVFoundationViewController.m
//  ZZKit
//
//  Created by donews on 2019/4/24.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "AVFoundationViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ZZVideoCutViewController.h"

@interface AVFoundationViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, copy) NSArray *controllers;

@end

@implementation AVFoundationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titles = @[@"视频截取",@"视频合成",@"美颜拍视频"];
    self.controllers = @[@"ZZVideoCutViewController",@"AVVideoCompositionController",@"GPUImageTakeVideoViewController"];
    [self.view addSubview:self.tableView];
}

/// 选择一个视频
- (void)__seleteVideo {
    
    UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerVC.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    pickerVC.delegate = self;
    pickerVC.editing = NO;
    [self presentViewController:pickerVC animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
            ZZVideoCutViewController *videoEditVC = [[ZZVideoCutViewController alloc] init];
            videoEditVC.videoUrl = url;
//            [self presentViewController:videoEditVC animated:YES completion:nil];
            [self.navigationController pushViewController:videoEditVC animated:YES];
        });
    }];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *vcName = self.controllers[indexPath.row];
    if ([vcName isEqualToString:@"ZZVideoCutViewController"]) {
        [self __seleteVideo];
    }  else {
        Class vcClass = NSClassFromString(vcName);
        UIViewController *vc = [vcClass new];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.title = self.titles[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Getters & Setters
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}


@end
