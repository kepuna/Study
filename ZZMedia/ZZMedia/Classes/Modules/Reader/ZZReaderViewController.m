//
//  ZZReaderViewController.m
//  HighPerformance
//
//  Created by MOMO on 2020/7/14.
//  Copyright © 2020 HelloWorld. All rights reserved.
//  使用 TextKit 製作橫向滾動 Reader https://arcovv.github.io/ios/2019/09/20/textkit-tutorial.html

#import "ZZReaderViewController.h"


@interface ZZReaderViewController ()
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) NSMutableArray *textViews;
@property (nonatomic, copy) NSString *contentText;
@end

@implementation ZZReaderViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
     self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"Reader";
    [self loadTxt];
    [self setupContentView];
   
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self setupReader];
}

/*
 
阅读器是可以横向不断滚动下去的，而每一个我们所见的text区域，其实就是由每一个UITextView所组成并呈现的，因此我们需要 repeat - while loop来协助我们处理这件事件，而 index / glyphRange / numberOfGlyghs会帮助我们处理loop的条件

 构建我们的 NSTextContainer， 并把它们加到 textLayout 中计算每一个TextView 的座標

构造UITextView ，在这里传入我们的 textContainer 对textView做一点样式上的调整， 使其在滚动过程看起来更舒服；
 把每一个textView加入到我们的textViews 中，就可以依据cont计算出一共多少页了；
 并再把它们加入成contentView 的subView 通过glyphRange可以知道目前字形glyph到哪一个点， 再与 numberOfGlyphs 比较，就可以判断中断条件了 计算repeat - while 何时中断

 

 */
- (void)setupReader {
    
    if (self.contentText == nil) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 1.2;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:self.contentText attributes:@{
        NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody], NSParagraphStyleAttributeName:paragraphStyle
    }];
    
    NSTextStorage *storage = [[NSTextStorage alloc] initWithAttributedString:attrString]; // 内容存储
    
    NSLayoutManager *textLayoutManager = [[NSLayoutManager alloc] init];
    [storage addLayoutManager:textLayoutManager];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.contentView.bounds.size];
    [textLayoutManager addTextContainer:textContainer];

    
    // code here
    CGSize viewSize = self.contentView.bounds.size;
    UIEdgeInsets textInsets = UIEdgeInsetsMake(16, 16, 16, 16);

    NSInteger index = 0;
    NSInteger glyphRange = 0;
    NSInteger numberOfGlyphs = 0;
    do {
        // 每一页的子内容
        // 每一页里都是一个 UITextView
        
        NSTextContainer *childTextContailer = [[NSTextContainer alloc] initWithSize:viewSize];
        [textLayoutManager addTextContainer:childTextContailer];
        CGRect textViewFrame = CGRectMake(index * viewSize.width, 0, viewSize.width, viewSize.height);

        UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame textContainer:childTextContailer];
        textView.editable = NO;
        textView.selectable = NO;
        textView.textContainerInset = textInsets;
        textView.showsVerticalScrollIndicator = NO;
        textView.showsHorizontalScrollIndicator = NO;
        textView.scrollEnabled = NO;
        textView.bounces = NO;
        textView.bouncesZoom = NO;

        [self.textViews addObject:textView];
        [self.contentView addSubview:textView];

        index += 1;
        glyphRange = NSMaxRange([textLayoutManager glyphRangeForTextContainer:childTextContailer]);
        numberOfGlyphs = textLayoutManager.numberOfGlyphs;

    } while (glyphRange < numberOfGlyphs - 1);

    CGFloat width = viewSize.width * self.textViews.count;
    CGFloat height = viewSize.height;
    self.contentView.contentSize = CGSizeMake(width, height);
    
}

- (void)setupContentView {
    self.contentView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.pagingEnabled = YES; // 使用分页方式来滚动
    
}

- (void)loadTxt {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"reader" ofType:@"txt"];
    NSError *error;
    NSString *content = [[NSString alloc] initWithContentsOfFile:filePath encoding:(NSUTF8StringEncoding) error:&error];
    self.contentText = content;
    
}

- (NSMutableArray *)textViews {
    if (_textViews == nil) {
        _textViews = [NSMutableArray arrayWithCapacity:5];
    }
    return _textViews;
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
