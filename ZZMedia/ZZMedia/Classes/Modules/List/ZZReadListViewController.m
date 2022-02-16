//
//  ZZReadListViewController.m
//  ZZMedia
//
//  Created by MOMO on 2020/8/26.
//

#import "ZZReadListViewController.h"
#import "ZZReadTextViewController.h"
#import "ZZReadListCell.h"

@interface ZZReadListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSString *text;
@end

@implementation ZZReadListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    
     NSString *string = @"THE WIND AND THE SUN.\nOnce the Wind and the Sun had an argument. I am stronger than you said the Wind. No, you are not, said the Sun. Just at that moment they saw a traveler walking across the road. He was wrapped in a shawl. The Sun and the Wind agreed that whoever could separate the traveller from his shawl was stronger. The Wind took the first turn. He blew with all his might to tear the traveller’s shawl from his shoulders. But the harder he blew, the tighter the traveller gripped the shawl to his body. The struggle went on till the Wind’s turn was over. Now it was the Sun’s turn. The Sun smiled warmly. The traveller felt the warmth of the smiling Sun. Soon he let the shawl fall open. The Sun’s smile grew warmer and warmer... hotter and hotter. Now the traveller no longer needed his shawl. He took it off and dropped it on the ground. The Sun was declared stronger than the Wind. \nMoral: Brute force can’t achieve what a gentle smile can.\n Welcome, I am MVSpeechSynthesizer.\nI can speak the following languages those are, English, Hindi, Thai, Portuguese, Slovak, French, Romanian, Norwegian, Finnish, Polish, German, Dutch, Indonesian, Turkish, Italian, Russian, Spanish, Chinese, Swedish, Hungarian, Arabic, Korean, Czech, Danish, Greek, Japanese.\nHow can i choose language?\nPress language button which is present in the right side of top bar. There you can find list of languages, By tapping row you can choose language. \nWhat is my aim? \nMy aim is atleast one person to become a good reader by using this app.\n Who need this?\nWhoever developing the kids reading book or audio book.\n Whoever want to integrate voice navigation.\n Whoever wants to read their privacy policy and EULA to user.\nWhoever wants to read the webpage.\nWhat i can do for you? \n I can read any paragraph which is present in textbox. I can detect language myself. I can autoscroll the page myself.";
    
    self.text = string;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(ZZReadListCell.class) forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZReadTextViewController *vc = [ZZReadTextViewController new];
    vc.text = self.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.rowHeight = 90;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ZZReadListCell class] forCellReuseIdentifier:NSStringFromClass(ZZReadListCell.class)];
    }
    return _tableView;
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
