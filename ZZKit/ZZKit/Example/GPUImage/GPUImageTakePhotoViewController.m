//
//  GPUImageTakePhotoViewController.m
//  ZZKit
//
//  Created by donews on 2019/4/25.
//  Copyright © 2019年 donews. All rights reserved.
//

#import "GPUImageTakePhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h> // iOS8 之前判断用户是否有权限访问相册
#import <Photos/PHPhotoLibrary.h>  // iOS8 之后判断用户是否有权限访问相册
#import <AVFoundation/AVCaptureDevice.h> // iOS7之前都可以访问相机，iOS7之后访问相机有权限设置
#import <AVFoundation/AVMediaFormat.h>
#import <GPUImage.h>
#import "ZZPublic.h"

@interface GPUImageTakePhotoViewController ()

// GPUImageStillCamera 继承自 GPUImageVideoCamera 主要用于拍照
@property (nonatomic, strong) GPUImageStillCamera *stillCamera;
// GPUImageView 用来显示相机捕获的画面
@property (nonatomic, strong) GPUImageView *imageView;
@property (nonatomic, strong) GPUImageSaturationFilter *filter;
@property (nonatomic, strong) UIButton *takePhotoBtn; // 拍照的按钮
@property (nonatomic, strong) UIButton *lensBtnBtn; // 切换镜头的按钮

@end

@implementation GPUImageTakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self takePhoto];
}

// 是否有权限访问相机
- (void)takePhoto {

    //    typedef NS_ENUM(NSInteger, AVAuthorizationStatus) {
    //        AVAuthorizationStatusNotDetermined = 0,
    //        AVAuthorizationStatusRestricted    = 1,
    //        AVAuthorizationStatusDenied        = 2,
    //        AVAuthorizationStatusAuthorized    = 3,
    //    } API_AVAILABLE(macos(10.14), ios(7.0)) __WATCHOS_PROHIBITED __TVOS_PROHIBITED;

    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio]; //相机权限
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        [self __alertForCameraAuth];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [self __caputureImage];
                } else {
                    [self __alertForCameraAuth];
                }
            });
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self __caputureImage];
        });
    }
}


/// GPUImage开始捕捉画面拍照
- (void)__caputureImage {
   
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    self.filter = [[GPUImageSaturationFilter alloc] init];
    self.filter.saturation = 3;
    self.imageView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, IPhoneNavH, width, height * .7)];
    [self.view addSubview:self.imageView];
    
    self.stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:(AVCaptureSessionPreset1280x720) cameraPosition:(AVCaptureDevicePositionBack)];
    self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    [self.stillCamera addTarget:self.filter];
    [self.filter addTarget:self.imageView];
    [self.stillCamera startCameraCapture];
    
    // 调解滤镜值
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(50, _imageView.frame.origin.y + _imageView.frame.size.height + 30, width - 100, 30)];
    slider.maximumValue = 5;
    slider.minimumValue = 0;
    slider.value = 3;
    [slider addTarget:self action:@selector(sliderValueChangedAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
    
    // 拍照按钮
    UIButton *takeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    takeBtn.frame = CGRectMake(self.view.bounds.size.width / 2.0 - 80, CGRectGetMaxY(slider.frame), 60, 60);
    [takeBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [takeBtn setTitle:@"拍照" forState:UIControlStateNormal];
    [takeBtn addTarget:self action:@selector(takeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takeBtn];
    
    // 切换镜头按钮
    UIButton *lensBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lensBtn.frame = CGRectMake(self.view.bounds.size.width / 2.0 + 20, CGRectGetMaxY(slider.frame), 60, 60);
    [lensBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [lensBtn setTitle:@"后置" forState:UIControlStateNormal];
    [lensBtn setTitle:@"前置" forState:UIControlStateSelected];
    lensBtn.selected = YES;
    [lensBtn addTarget:self action:@selector(lensBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lensBtn];
    
}

- (void)sliderValueChangedAction:(UISlider *)sender{
    _filter.saturation = sender.value;
}

- (void)takeBtnAction:(UIButton *)sender{
    [self __isCanUsePhoto];
}

- (void)lensBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    [_stillCamera rotateCamera];
}

/// 弹框-》打开访问相机权限
- (void)__alertForCameraAuth {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *actionSetting = [UIAlertAction actionWithTitle:@"设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }];
    [alertVC addAction:actionCancle];
    [alertVC addAction:actionSetting];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)__alertForPhotoLibraryAuth {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"无法使用相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    UIAlertAction *actionSetting = [UIAlertAction actionWithTitle:@"设置" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication]canOpenURL:url]) {
            [[UIApplication sharedApplication]openURL:url];
        }
    }];
    [alertVC addAction:actionCancle];
    [alertVC addAction:actionSetting];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

- (void)__savePhoto {
    // _stillCamera 要添加至少一个 filter target，否则捕获的图片是 null
    [self.stillCamera capturePhotoAsImageProcessedUpToFilter:self.filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        if (processedImage) {
            UIImageWriteToSavedPhotosAlbum(processedImage, nil, nil, nil);
        }
    }];
}

// 是否有权限访问相册、相片
- (BOOL)__isCanUsePhoto {

    //    typedef NS_ENUM(NSInteger, PHAuthorizationStatus) {
    //        PHAuthorizationStatusNotDetermined = 0, // 默认还没做出选择
    //        PHAuthorizationStatusRestricted,        // 此应用程序没有被授权访问的照片数据
    //        PHAuthorizationStatusDenied,            // 用户已经明确否认了这一照片数据的应用程序访问
    //        PHAuthorizationStatusAuthorized         //  用户已经授权应用访问照片数据
    //    } NS_AVAILABLE_IOS(8_0);

    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        ALAuthorizationStatus authStatus =[ALAssetsLibrary authorizationStatus];
        if (authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied) {
            [self __alertForPhotoLibraryAuth];
        } else if (authStatus == ALAuthorizationStatusNotDetermined) {
            [self __isCanUsePhoto];
        } else {
            [self __savePhoto];
        }
#pragma clang diagnostic pop
    } else {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if (authStatus == PHAuthorizationStatusRestricted || authStatus == PHAuthorizationStatusDenied) {
            [self __alertForPhotoLibraryAuth];
            
        } else if (authStatus == PHAuthorizationStatusNotDetermined) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    [self __isCanUsePhoto];
                }];
            });
        } else {
           [self __savePhoto];
        }
    }
    return YES;
}


@end
