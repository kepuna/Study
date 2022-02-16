//
//  ZZSpeechSynthesizer.h
//  ZZMedia_Example
//
//  Created by MOMO on 2020/8/25.
//  Copyright © 2020 iPhoneHH. All rights reserved.
//


/*
设置声音,是AVSpeechSynthesisVoice对象
AVSpeechSynthesisVoice定义了一系列的声音, 主要是不同的语言和地区.

//voiceWithLanguage: 根据制定的语言, 获得一个声音.
//speechVoices: 获得当前设备支持的声音
//currentLanguageCode: 获得当前声音的语言字符串, 比如”ZH-cn”
//language: 获得当前的语言
*/

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

//List of Blocks methods for handling delegate methods of AVSpeechSynthesizer

//Didstart method of speechsythesizer
typedef void (^MVDidStartSpeech)(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence);

//Didfinish method of speechsynthesizer
typedef void (^MVDidFinishSpeech)(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence);

//Didpause method of speechsynthesizer
typedef void (^MVDidPauseSpeech)(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence);

//Didcontinue method of speechsynthesizer
typedef void (^MVDidContinueSpeech)(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence);

//DidCancel method of speechsynthesizer
typedef void (^MVDidCancelSpeech)(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence);

//SpeakRange method of speechsynthesizer
typedef void (^MVSpeakRangeSpeech)(AVSpeechSynthesizer *synthesizer,NSRange range, AVSpeechUtterance *utterence);

//Get speaking word
typedef void (^MVSpeechSpeakingWord)(AVSpeechSynthesizer *synthesizer,NSRange range, AVSpeechUtterance *utterence,NSString *speakingWord);


@interface ZZSpeechSynthesizer : NSObject <AVSpeechSynthesizerDelegate>

//Singleton method
+(id)sharedSyntheSize;


//Pass the input view
@property(nonatomic, strong) UITextView *inputView;

//Higlight color property
@property(nonatomic,retain)UIColor *higlightColor; //Default color is blue

//Decide text higlight option
@property(nonatomic)BOOL isTextHiglight; //Default is true


/* Set lenaguag for speaking
 */
@property(nonatomic,strong)NSString *speechLanguage;//Default is US english

//Set speaking voice
@property(nonatomic,strong)NSString *speechVoice;//


//Set stop/pause boundary attribute
@property(nonatomic)AVSpeechBoundary speechBoundary;//Default is AVSpeechBoundaryImmediate


//Speech synthesizer instance variable
@property(nonatomic,strong,readonly)AVSpeechSynthesizer *speechSynthesizer;

//SpeechUtterence value
@property(nonatomic,strong,readonly)AVSpeechUtterance *speechUtterence;


//Set reading string
@property(nonatomic,strong)NSString *speechString;

//Utterance property
//Set the utterance speech rate
@property(nonatomic)CGFloat uRate;

//Set the pitchmultiplier value for utterance 声音的音调0.5f~2.0f  Default = 1
@property(nonatomic)CGFloat pitchMultiplier;

//Set post delay for utterance 读完一段后的停顿时间 Default is 0.0
@property(nonatomic)CGFloat uPostDelay;

//Set pre delay for utterance 读一段前的停顿时间  Default is 0.0
@property(nonatomic)CGFloat uPreDelay;

// //设置音量,[0-1] 默认 = 1
@property(nonatomic) CGFloat uVolume;


//block methods properties
//will fire while start to read
@property(nonatomic,copy)MVDidStartSpeech speechStartBlock;

//Will fire once the read ended
@property(nonatomic,copy)MVDidFinishSpeech speechFinishBlock;

//Will fire once the read pause
@property(nonatomic,copy)MVDidPauseSpeech speechPauseBlock;

//Will fire when speech continued
@property(nonatomic,copy)MVDidContinueSpeech speechContinueBlock;

//Will fire when cancel the speech
@property(nonatomic,copy)MVDidCancelSpeech speechCancelBlock;

//Will fire continuously when new word read.
@property(nonatomic,copy)MVSpeakRangeSpeech speechRangeBlock;

//Will fire continuously when new word start
@property(nonatomic,copy)MVSpeechSpeakingWord speechSpeakingWord;



//speechSynthesizer going to read
-(void)startRead;

//Continue reading with last paused place
-(void)continueReading;

//Stop the read
-(void)stopReading;

//Pause the reading
-(void)pauseReading;

//Speaking strings
-(NSString*)speakingString;

//Get available languages
-(NSArray*)supportedLanguages;

//Get status of speaking
-(BOOL)isSpeaking;

//Get status of paused
-(BOOL)isPaused;

//Get Current language code
-(NSString*)currentLangaugeCode;

//Get speaking language
-(NSString*)speakingLanguage;

@end

