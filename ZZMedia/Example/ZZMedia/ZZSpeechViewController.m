//
//  ZZSpeechViewController.m
//  ZZMedia_Example
//
//  Created by MOMO on 2020/8/5.
//  Copyright © 2020 iPhoneHH. All rights reserved.
//

#import "ZZSpeechViewController.h"
#import <Speech/Speech.h>

@interface ZZSpeechViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation ZZSpeechViewController

- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.frame  = CGRectMake(15,100, self.view.bounds.size.width - 30, self.view.bounds.size.height - 200);
        _textView.backgroundColor = [UIColor yellowColor];
    }
    return _textView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textView];
    [self _requestSpeechRecognizer];
    
}

- (void)changeAudioToText {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1111" ofType:@"mp3"];
    NSLog(@"filePath=%@",filePath);
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self changeAudioToText:filePath success:^(NSString *text) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.textView.text = text;
            });
        } faild:^{
            
        }];
    });
    
}


// 识别语音文件的内容
- (void)changeAudioToText:(NSString*)filePath success:(void(^)(NSString * text))success faild:(void(^)(void))faild {

    NSFileManager * manager = [NSFileManager defaultManager];
    NSURL * destinationURL = [NSURL fileURLWithPath:filePath];
    NSLocale *local =[[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    if (![manager fileExistsAtPath:filePath]) {
        if (faild) {
            faild(); // 语音文件不存在
        }
        return;
    }
    if (@available(iOS 10.0, *)) {

       if ([SFSpeechRecognizer authorizationStatus] == SFSpeechRecognizerAuthorizationStatusAuthorized) {
          [self convertSoundToText:destinationURL Local:local success:success faild:faild];  //允许音频识别
       } else {
           NSLog(@"请先开启语音识别权限");
       }
    } else {
       // Fallback on earlier versions
    }

}

- (void)convertSoundToText:(NSURL*)url Local:(NSLocale*)local success:(void(^)(NSString * text))success faild:(void(^)(void))faild {

    if (@available(iOS 10.0, *)) {
        SFSpeechRecognizer *localRecognizer =[[   SFSpeechRecognizer alloc] initWithLocale:local];
        SFSpeechURLRecognitionRequest *res =[[SFSpeechURLRecognitionRequest alloc] initWithURL:url];
        
        [localRecognizer recognitionTaskWithRequest:res resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            if (error) {
                if (faild) {
                    faild(); // 语音文件不存在
                }
            } else {
                success(result.bestTranscription.formattedString);
//                NSLog(@"------------------------语音识别解析======成功,%@",result.bestTranscription.formattedString);
            }
        }];
    }
}

- (void)_requestSpeechRecognizer{

    if (@available(iOS 10.0, *)) {

       [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {

          switch (status) {
             case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                 NSLog(@"NotDetermined");
                 break;

             case SFSpeechRecognizerAuthorizationStatusDenied:

                 NSLog(@"Denied");

                 break;

             case SFSpeechRecognizerAuthorizationStatusRestricted:

                 NSLog(@"Restricted");

                 break;

             case SFSpeechRecognizerAuthorizationStatusAuthorized:

                 NSLog(@"Authorized");
                  [self changeAudioToText];
                 break;

              default:

                 break;

           }

       }];

    } else {

       // Fallback on earlier versions

    }
}


@end
