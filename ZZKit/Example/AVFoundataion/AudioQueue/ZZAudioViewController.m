//
//  ZZAudioViewController.m
//  ZZKit
//
//  Created by MOMO on 2021/4/30.
//  Copyright © 2021 donews. All rights reserved.
//

#import "ZZAudioViewController.h"
#import "UIView+DNAdFrame.h"
#import "ZZAudioQueueCaptureManager.h"
#import "ZZAudioUnitCaptureManager.h"
#import <AVFoundation/AVFoundation.h>
#import "ZZAudioUnitFileHandler.h"

static CGFloat kBtnWidth = 150;

@interface ZZAudioViewController ()<ZZAudioUnitCaptureDelegate>

@property (nonatomic, strong) UIButton *recordBtn;

@property (nonatomic, strong) UIButton *unitRecordBtn;

@property (nonatomic, assign) BOOL isRecordVoice;

@end


@implementation ZZAudioViewController

- (void)dealloc {
    [[ZZAudioQueueCaptureManager getInstance] stopAudioCapture];
    [[ZZAudioUnitCaptureManager getInstance] stopAudioCapture];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.recordBtn];
    [self.view addSubview:self.unitRecordBtn];

    // Audio Queue
    [[ZZAudioQueueCaptureManager getInstance] startAudioCapture];
    
    // Audio Unit
    [ZZAudioUnitCaptureManager getInstance].delegate = self;
    [[ZZAudioUnitCaptureManager getInstance] startAudioCapture];
}

#pragma mark - Handle Event


- (void)s_recordAction:(UIButton *)sender {
    if (self.recordBtn == sender) {
        [[ZZAudioQueueCaptureManager getInstance] startRecordFile];
    }
   
    if (self.unitRecordBtn == sender) {
        [self startRecordFile];
    }
}

#pragma mark - Record

- (void)startRecordFile {
    AudioStreamBasicDescription audioFormat = [[ZZAudioUnitCaptureManager getInstance] getAudioDataFormat];
    [[ZZAudioUnitFileHandler getInstance] startRecordVoiceByAudioUnitByAudioConverter:nil needMagicCookie:NO audioDesc:audioFormat];
    self.isRecordVoice = YES;
}

- (void)stopRecordFile {
    self.isRecordVoice = NO;
    [[ZZAudioUnitFileHandler getInstance] stopVoiceRecordAudioConverter:nil needMagicCookie:NO];
}

#pragma mark - ZZAudioUnitCaptureDelegate

- (void)receiveAudioDataByDevice:(ZZCaptureAudioDataRef)audioDataRef {
    if (self.isRecordVoice) {
        [[ZZAudioUnitFileHandler getInstance]  writeFileWithInNumBytes:audioDataRef->size
                                                          ioNumPackets:audioDataRef->inNumberFrames
                                                              inBuffer:audioDataRef->data
                                                          inPacketDesc:NULL];
    }
}

#pragma mark - Getters

- (UIButton *)recordBtn {
    if (_recordBtn == nil) {
        _recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordBtn.frame = CGRectMake((self.view.width - kBtnWidth) * 0.5, 120, kBtnWidth, 40);
        [_recordBtn setTitle:@"Audio Queue 录制" forState:UIControlStateNormal];
        [_recordBtn addTarget:self action:@selector(s_recordAction:) forControlEvents:UIControlEventTouchUpInside];
        _recordBtn.backgroundColor = [UIColor darkTextColor];
    }
    return _recordBtn;
}

- (UIButton *)unitRecordBtn {
    if (_unitRecordBtn == nil) {
        _unitRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _unitRecordBtn.frame = CGRectMake((self.view.width - kBtnWidth) * 0.5, CGRectGetMaxY(self.recordBtn.frame) + 20, kBtnWidth, 40);
        [_unitRecordBtn setTitle:@"Audio Unit 录制" forState:UIControlStateNormal];
        [_unitRecordBtn addTarget:self action:@selector(s_recordAction:) forControlEvents:UIControlEventTouchUpInside];
        _unitRecordBtn.backgroundColor = [UIColor darkTextColor];
    }
    return _unitRecordBtn;
}

@end
