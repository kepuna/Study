//
//  ZZRecognizeCardViewController.m
//  ZZMedia_Example
//
//  Created by MOMO on 2020/9/16.
//  Copyright © 2020 iPhoneHH. All rights reserved.
//

#import "ZZRecognizeCardViewController.h"
#import <Masonry/Masonry.h>
#import "ZZRecogizeCardManager.h"

@interface ZZRecognizeCardViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    UIImagePickerController *imagePickerController;
}

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *selectPicture;
@property (nonatomic, strong) UIButton *takePicture;
@end

@implementation ZZRecognizeCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textLabel];
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.selectPicture];
    [self.view addSubview:self.takePicture];
    
    self.textLabel.text = @"请选择图片";
    
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.modalPresentationStyle
    = UIModalTransitionStyleFlipHorizontal;
    imagePickerController.allowsEditing = YES;
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
        make.height.mas_equalTo(60);
    }];
    
    [self.selectPicture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.view);
        make.width.equalTo(self.view).multipliedBy(0.5);
        make.height.mas_equalTo(40);
    }];
    
    [self.takePicture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectPicture.mas_right);
        make.top.width.height.equalTo(self.selectPicture);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.textLabel.mas_bottom).offset(1);
        make.bottom.equalTo(self.takePicture.mas_top).offset(-1);
    }];
}

//相册
- (void)s_selectPictureAction {
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//拍照
- (void)s_takePictureAction {
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置摄像头模式（拍照，录制视频）为拍照
        imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"设备不能打开相机" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
}

//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {

    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    UIImage *srcImage = nil;
    if ([mediaType isEqualToString:@"public.image"]) {
        srcImage = info[UIImagePickerControllerEditedImage];
        self.imgView.image = srcImage;
        //识别身份证
        self.textLabel.text = @"图片插入成功，正在识别中...";
        
        [[ZZRecogizeCardManager recognizeCardManager] recognizeCardWithImage:srcImage compleate:^(NSString *text) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (text != nil) {
                    self.textLabel.text = [NSString stringWithFormat:@"识别结果：%@",text];
                } else {
                    self.textLabel.text = @"请选择照片";
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"照片识别失败，请选择清晰、没有复杂背景的身份证照片重试！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                    [alert show];
                }
            });
            
        }];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor darkTextColor];
        _textLabel.textColor = [UIColor
                                whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:20];
        _textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _textLabel;
}

- (UIButton *)selectPicture {
    if (_selectPicture == nil) {
        _selectPicture = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectPicture setTitle:@"Photo" forState:UIControlStateNormal];
        [_selectPicture setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _selectPicture.backgroundColor = [UIColor blackColor];
        [_selectPicture addTarget:self action:@selector(s_selectPictureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectPicture;
}

- (UIButton *)takePicture {
    if (_takePicture == nil) {
        _takePicture = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takePicture setTitle:@"Camera" forState:UIControlStateNormal];
        [_takePicture setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _takePicture.backgroundColor = [UIColor darkGrayColor];
        [_takePicture addTarget:self action:@selector(s_takePictureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePicture;
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor lightGrayColor];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
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
