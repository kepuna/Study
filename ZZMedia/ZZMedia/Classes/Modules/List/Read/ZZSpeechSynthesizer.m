//
//  ZZSpeechSynthesizer.m
//  ZZMedia_Example
//
//  Created by MOMO on 2020/8/25.
//  Copyright © 2020 iPhoneHH. All rights reserved.
//

#import "ZZSpeechSynthesizer.h"

@interface ZZSpeechSynthesizer ()

@property(nonatomic,strong)CALayer *higlightLayer;

@end

@implementation ZZSpeechSynthesizer

#pragma mark - Singleton method
+(id)sharedSyntheSize{
    
    static dispatch_once_t once;
    static ZZSpeechSynthesizer *speechSynthesizer;
    dispatch_once(&once, ^{
        speechSynthesizer = [[ZZSpeechSynthesizer alloc]init];
    });
    return speechSynthesizer;
    
}


#pragma mark - init method
//设置语速,语速介于AVSpeechUtteranceMaximumSpeechRate 和 AVSpeechUtteranceMinimumSpeechRate 之间
//AVSpeechUtteranceMaximumSpeechRate
//AVSpeechUtteranceMinimumSpeechRate
//AVSpeechUtteranceDefaultSpeechRate

-(id)init{
    if (self=[super init]) {
        
        _speechSynthesizer=[[AVSpeechSynthesizer alloc]init]; // AVSpeechSynthesizer全局变量
        _speechSynthesizer.delegate=self;
        _speechBoundary=AVSpeechBoundaryImmediate;
//        _uRate=AVSpeechUtteranceDefaultSpeechRate/8;
        
        //设置音高,[0.5 - 2] 默认 = 1
        //AVSpeechUtteranceMaximumSpeechRate
        //AVSpeechUtteranceMinimumSpeechRate
        //AVSpeechUtteranceDefaultSpeechRate
        _pitchMultiplier=1.2;
        _higlightColor=[UIColor blueColor];
        _speechLanguage=nil;
    }
    return self;
}

#pragma mark -global method

-(void)startRead{
    
    if (!_speechString)
        return;
    
    [self stopReading];
    
    if (_speechUtterence)
        _speechUtterence=nil;
    
    
    _speechUtterence=[[AVSpeechUtterance alloc]initWithString:_speechString];
//    _speechUtterence.rate=_uRate; //设置速度
    _speechUtterence.pitchMultiplier=_pitchMultiplier;  //设置音高
    [_speechUtterence setVoice:[AVSpeechSynthesisVoice voiceWithLanguage:_speechLanguage]];
    [_speechSynthesizer speakUtterance:_speechUtterence]; //开始朗读
    
    //iOS语音合成在iOS8及以下版本系统上语速异常
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
    //        aUtterance.rate = 0.25;//iOS7设置为0.25
    //    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] < 9.0) {
    //        aUtterance.rate = 0.15;//iOS8设置为0.15
    //    }
    
    
}

-(BOOL)isSpeaking{
    return [_speechSynthesizer isSpeaking];
}


-(BOOL)isPaused{
    return [_speechSynthesizer isPaused];
}


// 继续朗读
-(void)continueReading{
    [_speechSynthesizer continueSpeaking];
}

// 停止朗读
//AVSpeechBoundaryImmediate 立即停止
//AVSpeechBoundaryWord    当前词结束后停止
-(void)stopReading{
    
    if ([_speechSynthesizer isSpeaking])
        [_speechSynthesizer stopSpeakingAtBoundary:_speechBoundary];
    
    _speechUtterence=nil;
    
}

//暂停朗读
//AVSpeechBoundaryImmediate 立即停止
//AVSpeechBoundaryWord    当前词结束后停止
-(void)pauseReading{
    if ([_speechSynthesizer isSpeaking])
        [_speechSynthesizer pauseSpeakingAtBoundary:_speechBoundary];
}

-(NSString*)speakingString{
    if (_speechUtterence)
        return _speechUtterence.speechString;
    
    return nil;
}

-(NSArray*)supportedLanguages{
    return [AVSpeechSynthesisVoice speechVoices];
}

-(NSString*)currentLangaugeCode{
    return [AVSpeechSynthesisVoice currentLanguageCode];
}

-(NSString*)speakingLanguage{
    return _speechVoice;
}


#pragma mark - Private methods
-(void)setSpeechString:(NSString *)speechString{
    
    if (!_speechLanguage){
        NSString *detectedLanaguage=[self detectLanguage:speechString];
        [[self supportedLanguages]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSArray *tmpArray=[[obj language] componentsSeparatedByString:@"-"];
            if ([tmpArray[0] isEqualToString:detectedLanaguage]) {
                _speechLanguage=[obj language];
                *stop=YES;
                
            }
        }];
        
        //if single word send to speechstring means it won't return language
        //So we take default as enlish in us
        if (!_speechLanguage) {
            _speechLanguage=@"en-US";
        }
    }
    _speechString=speechString;
}
- (CGRect)frameOfTextRange:(NSRange)range inTextView:(UITextView *)textView{
    
    UITextPosition *beginning = textView.beginningOfDocument;
    UITextPosition *start = [textView positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textView positionFromPosition:start offset:range.length];
    UITextRange *textRange = [textView textRangeFromPosition:start toPosition:end];
    CGRect rect = [textView firstRectForRange:textRange];
    return [textView convertRect:rect fromView:textView.textInputView];
}
-(void)showHiglightLayerAt:(CGRect)rect{
    [_higlightLayer removeFromSuperlayer];
    _higlightLayer=[CALayer layer];
    [_higlightLayer setBackgroundColor:_higlightColor.CGColor];
    [_higlightLayer setOpacity:0.5f];
    [_higlightLayer setFrame:rect];
    [self.inputView.layer addSublayer:_higlightLayer];
    //    [[_inputView layer] addSublayer:_higlightLayer];
    
}

-(NSString*)detectLanguage:(NSString*)string{
    
    NSArray *tagschemes = [NSArray arrayWithObjects:NSLinguisticTagSchemeLanguage, nil];
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:tagschemes options:0];
    [tagger setString:string];
    NSString *language = [tagger tagAtIndex:0 scheme:NSLinguisticTagSchemeLanguage tokenRange:NULL sentenceRange:NULL];
    return language;
    
}

#pragma mark -
#pragma mark - AVSpeechSynthesizerDelegate

//开始朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance{
    if (_speechStartBlock) {
        _speechStartBlock(synthesizer,utterance);
    }
}

//结束朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance{
    
    if(_isTextHiglight)
        [_higlightLayer removeFromSuperlayer];
    
    if (_speechFinishBlock) {
        _speechFinishBlock(synthesizer,utterance);
    }
    _speechUtterence=nil;
}
//暂停朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance *)utterance{
    if (_speechPauseBlock) {
        _speechPauseBlock(synthesizer,utterance);
    }
}

//继续朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance *)utterance{
    if (_speechContinueBlock) {
        _speechContinueBlock(synthesizer,utterance);
    }
}

//取消朗读的代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance *)utterance{
    if (_speechCancelBlock) {
        _speechCancelBlock(synthesizer,utterance);
    }
}

//将要播放的语音文字代理方法
- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance{
    
    if(_isTextHiglight){
        
        CGRect finalLineRect=[self frameOfTextRange:characterRange inTextView:_inputView];
        [self showHiglightLayerAt:finalLineRect];
        
        [_inputView scrollRangeToVisible:characterRange];
    }
    
    if (_speechSpeakingWord) {
        _speechSpeakingWord(synthesizer,characterRange,utterance,[utterance.speechString substringWithRange:characterRange]);
    }
    
    if (_speechRangeBlock) {
        _speechRangeBlock(synthesizer,characterRange,utterance);
    }
}


@end
