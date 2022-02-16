//
//  ZZTextKitController.m
//  HighPerformance
//
//  Created by MOMO on 2020/7/12.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "ZZTextKitController.h"
#import "ZZLabel.h"
#import "ZZServiceManager.h"
#import <Speech/Speech.h>
#import<AVFoundation/AVFoundation.h>//添加依赖库
#import <MobileCoreServices/MobileCoreServices.h>

#define kTimeOutInterval 60

static NSString *keyfrom = @"JFFanYi";
static NSString *key = @"972519001";

@interface ZZTextKitController () <AVSpeechSynthesizerDelegate>

@property (nonatomic, strong) ZZLabel *label;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) AVSpeechSynthesizer *synthesizer;
@property (nonatomic, strong) AVSpeechUtterance *utterance;

@end

@implementation ZZTextKitController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self setupUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.label.frame = CGRectMake(50, 100, 300, 90);
    self.infoLabel.frame = CGRectMake(50, 400, 300, 40);
}

- (BOOL)judgeTextFieldInputCStringASCII:(int)ascii{
    
    int ascii_a = [@"a" characterAtIndex:0];//转ASCII码
    int ascii_z = [@"z" characterAtIndex:0];
    
    int ascii_A = [@"A" characterAtIndex:0];
    int ascii_Z = [@"Z" characterAtIndex:0];
    
    int ascii_0 = [@"0" characterAtIndex:0];
    int ascii_9 = [@"9" characterAtIndex:0];
    
    int asscii_slsh = [@"\\" characterAtIndex:0];
    int asscii_hx = [@"-" characterAtIndex:0];
    int asscii_Bai = [@"%" characterAtIndex:0];
    
//    int ascii = [string characterAtIndex:0];
    if( ascii >= ascii_A && ascii <= ascii_Z){
//        NSLog(@"A-Z: %d",ascii);
        return YES;
    }else if( ascii >= ascii_a && ascii <= ascii_z){
//        NSLog(@"a-z :%d",ascii);
        return YES;
    }else if( ascii >= ascii_0 && ascii <= ascii_9){
//        NSLog(@"0-9 :%d",ascii);
        return YES;
    }else if (ascii == asscii_slsh || ascii == asscii_hx || ascii ==  asscii_Bai) {
        return YES;
    }
    return NO;
}


- (NSMutableArray *)componentsWithString1:(NSString *)str{
    NSMutableArray *wordArray = [NSMutableArray arrayWithCapacity:10];
    NSString *wordStr = @"";
    for (int k=0; k<strlen(str.UTF8String); k++) {
        
        if ([self judgeTextFieldInputCStringASCII:[str characterAtIndex:k]]) {
            wordStr = [wordStr stringByAppendingFormat:@"%c",str.UTF8String[k]];
        } else {
            if (wordStr.length) {
                [wordArray addObject:wordStr];
                wordStr = @"";
            }
            if ([str characterAtIndex:k]) {
                [wordArray addObject:[NSString stringWithFormat:@"%c",[str characterAtIndex:k]]];
            }
//            NSLog(@"--------❌= %c -- %d --- %d",str.UTF8String[k],[str characterAtIndex:k],k);
        }
        
    }
    return wordArray;
}


- (void)setupUI {
    
    
    self.synthesizer = [[AVSpeechSynthesizer alloc] init];
    self.synthesizer.delegate = self;

    //详情label
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.backgroundColor = [UIColor yellowColor];
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.infoLabel];
    
    //展示label
    self.label = [[ZZLabel alloc] init];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.backgroundColor = [UIColor greenColor];
    self.label.numberOfLines = 0;
    [self.view addSubview:self.label];
    
    
    /*
     THE WIND AND THE SUN.\nOnce the Wind and the Sun had an argument. I am stronger than you said the Wind. No, you are not, said the Sun. Just at that moment they saw a traveler walking across the road. He was wrapped in a shawl. The Sun and the Wind agreed that whoever could separate the traveller from his shawl was stronger. The Wind took the first turn. He blew with all his might to tear the traveller’s shawl from his shoulders. But the harder he blew, the tighter the traveller gripped the shawl to his body. The struggle went on till the Wind’s turn was over. Now it was the Sun’s turn. The Sun smiled warmly. The traveller felt the warmth of the smiling Sun. Soon he let the shawl fall open. The Sun’s smile grew warmer and warmer... hotter and hotter. Now the traveller no longer needed his shawl. He took it off and dropped it on the ground. The Sun was declared stronger than the Wind. \nMoral: Brute force can’t achieve what a gentle smile can.
     
     */
    
    NSString *labelText = @"Do the any the additional setup after loading the view, typically from a nil. \n TextKit provides a number of classes to control the layout of text, such as NSTextStorage, NSLayoutManager, and NSTextContainer.";

    
    NSArray *testArray = [self componentsWithString1:labelText];
    
    for (NSString *word in testArray) {
         NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:word];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, attrString.length)];
        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attrString.length)];
        
        [self.label appendString:attrString attrStringBlock:^(NSAttributedString * _Nonnull attributeString) {
            NSLog(@"✅=====%@",attributeString.string);
            self.infoLabel.text = attributeString.string;
            
          
            
            // AVSpeechUtterance：这个类就是用来将字符串合成为语音对象提供给AVSpeechSynthesizer来播放
            // 用来控制语速，音调等等
            self.utterance = [AVSpeechUtterance speechUtteranceWithString:attributeString.string];    //需要转化的文本
//            self.utterance.rate *= 0.5; //设置语速
            self.utterance.volume = 0.6; //设置音量
            
            //  //设置哪国语言 zh-CN
            // AVSpeechSynthesisVoice：用来配置发音,支持的发音非常多
//            [AVSpeechSynthesisVoice speechVoices];  可用看到支持的发音种类
            AVSpeechSynthesisVoice *voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
            self.utterance.voice = voiceType;
            
                      
            [self.synthesizer speakUtterance:self.utterance]; //添加进入发出声音类
            
            [[ZZServiceManager sharedFYIServiceManager] requestDataWithTextString:attributeString.string data:^(id  _Nonnull response) {
                
            }];
        }];
    }
    
    
//     NSStringEnumerationByLines 换行是按照 \n 来的
//     NSStringEnumerationByWords 按照单词
//    [labelText enumerateSubstringsInRange:NSMakeRange(0, labelText.length-1) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *word, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:word];
//
//        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(0, attrString.length)];
//        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, attrString.length)];
//
//        [self.label appendString:attrString attrStringBlock:^(NSAttributedString * _Nonnull attributeString) {
//            self.infoLabel.text = attributeString.string;
//        }];
//
//
////        NSLog(@"✅ 单词:%@ Range:%@，，， %@ \n",word,NSStringFromRange(substringRange),NSStringFromRange(enclosingRange));
//        //        NSLog(@"substringRange:%@",NSStringFromRange(substringRange));
//    }];
    
    
    
    
//
    
//    // 创建富文本字符串 1
//   NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:@"让我们"];
//
//    // 设置字符串 1 的颜色
//    [attributedString1 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, attributedString1.length)];
//
//      [self.label appendString:attributedString1 attrStringBlock:^(NSAttributedString *attributeString) {
//          self.infoLabel.text = attributeString.string;
////          NSLog(@"%@", attributedString1);
//      }];
//
//      NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:@"荡起"];
//      [attributedString2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attributedString2.length)];
//      [self.label appendString:attributedString2 attrStringBlock:^(NSAttributedString *attributeString) {
//          self.infoLabel.text = attributeString.string;//@"荡起";
//          NSLog(@"%@", attributedString2);
//      }];
//
//      NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:@"双桨"];
//      [attributedString3 addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, attributedString3.length)];
//      [self.label appendString:attributedString3 attrStringBlock:^(NSAttributedString *attributeString) {
//          self.infoLabel.text = attributedString3.string;//@"双桨";
//          NSLog(@"%@", attributedString3);
//      }];
      
}

//开始朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
NSLog(@"✅didStartSpeechUtterance->%@",utterance.speechString);
}
//结束朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
NSLog(@"✅didFinishSpeechUtterance->%@",utterance.speechString);
}
//暂停朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
NSLog(@"✅didPauseSpeechUtterance->%@",utterance.speechString);
}
//继续朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{
NSLog(@"✅didContinueSpeechUtterance->%@",utterance.speechString);
}
//取消朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{
NSLog(@"✅didCancelSpeechUtterance->%@",utterance.speechString);
}
//将要播放的语音文字
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{
NSLog(@"✅willSpeakRangeOfSpeechString->characterRange.location = %zd->characterRange.length = %zd->utterance.speechString= %@",characterRange.location,characterRange.length,utterance.speechString);
//self.speechLabel.text = utterance.speechString;
}

@end
