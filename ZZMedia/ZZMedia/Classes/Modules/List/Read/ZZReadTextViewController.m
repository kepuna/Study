//
//  ZZReadTextViewController.m
//  ZZMedia
//
//  Created by MOMO on 2020/8/26.
//

#import "ZZReadTextViewController.h"
#import "ZZTextView.h"
#import "ZZSpeechSynthesizer.h"
#import "ZZMediaPublic.h"
#import <CoreText/CoreText.h>

@interface ZZReadTextViewController () <UITextViewDelegate, ZZTextViewDelegate>
@property (nonatomic, strong) ZZTextView *textView;
@property (nonatomic, strong) UIButton *readBtn;
@property (nonatomic, strong) ZZSpeechSynthesizer *mvSpeech;
@end

@implementation ZZReadTextViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat navHeight = self.navigationController.navigationBar.bounds.size.height;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.readBtn.frame = CGRectMake(20, screenSize.height - 50, screenSize.width - 40, 50);
    self.textView.frame = CGRectMake(15, navHeight, screenSize.width - 30, screenSize.height - navHeight - 10 - 50);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = rgb(244, 245, 246);
    
    [self.view addSubview:self.readBtn];
    [self.view addSubview:self.textView];
    if (self.text) {
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 30;
        
        NSDictionary *attrDict = @{
            NSFontAttributeName:[UIFont systemFontOfSize:16],
            NSForegroundColorAttributeName:rgb(74, 75, 76),
            NSParagraphStyleAttributeName : paragraphStyle, // 行间距
            NSKernAttributeName:@(1.5) // 字间距
        };
        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:self.text attributes:attrDict];
        self.textView.attributedText = attrStr;
    }
    
//    ZZSpeechSynthesizer *mvSpeech = [ZZSpeechSynthesizer sharedSyntheSize];
//    mvSpeech.higlightColor = [UIColor yellowColor];
//    mvSpeech.isTextHiglight = YES;
//    mvSpeech.speechString = self.textView.attributedText.string;
//    mvSpeech.inputView = self.textView;
//
//    self.mvSpeech.speechFinishBlock=^(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence){
//        NSLog(@"播放f完成");
//    };
}



#pragma mark - textview delegate method
- (void)textViewDidChange:(UITextView *)textView{
    ZZSpeechSynthesizer *mvSpeech = [ZZSpeechSynthesizer sharedSyntheSize];
    mvSpeech.speechLanguage = nil;
}

- (void)textView:(ZZTextView *)textView didClickByWord:(NSString *)word {
//    [self.mvSpeech stopReading];
//    self.mvSpeech.speechString = word;
//    [self.mvSpeech startRead];
}

-(void)startRead:(id)sender {
    
    if([[sender currentTitle]isEqualToString:@"Read"]){
        
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        [self.mvSpeech startRead];
        self.mvSpeech.speechStartBlock=^(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence){
            
        };
        
        self.mvSpeech.speechFinishBlock=^(AVSpeechSynthesizer *synthesizer, AVSpeechUtterance *utterence){
            NSLog(@"播放完成");
            [sender setTitle:@"Read" forState:UIControlStateNormal];
        };
    } else {
        [sender setTitle:@"Read" forState:UIControlStateNormal];
        [self.mvSpeech stopReading];
//        ZZSpeechSynthesizer *mvSpeech = [ZZSpeechSynthesizer sharedSyntheSize];
//        [mvSpeech stopReading];
    }
}

- (UIButton *)readBtn {
    if (_readBtn == nil) {
        _readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
           [_readBtn setTitle:@"Read" forState:UIControlStateNormal];
           [_readBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           _readBtn.backgroundColor = [UIColor blueColor];
           [_readBtn addTarget:self action:@selector(startRead:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _readBtn;
}

- (ZZTextView *)textView {
    if (_textView == nil) {
         _textView = [[ZZTextView alloc]initWithFrame:CGRectZero];
         _textView.delegate = self;
         _textView.customDelegate = self;
         _textView.backgroundColor = [UIColor clearColor];
        _textView.showsVerticalScrollIndicator = NO;
        _textView.showsHorizontalScrollIndicator = NO;
         _textView.editable = NO;
    }
    return _textView;
}

- (ZZSpeechSynthesizer *)mvSpeech {
    if (_mvSpeech == nil) {
        _mvSpeech = [ZZSpeechSynthesizer sharedSyntheSize];
        _mvSpeech.higlightColor = [UIColor yellowColor];
        _mvSpeech.isTextHiglight = YES;

//        _mvSpeech.uRate *= 1.2;
        _mvSpeech.speechString = self.textView.attributedText.string;
        _mvSpeech.inputView = self.textView;
        _mvSpeech.speechLanguage = @"en-US";
    }
    return _mvSpeech;
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

