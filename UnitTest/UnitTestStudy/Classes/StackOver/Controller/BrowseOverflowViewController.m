//
//  BrowseOverflowViewController.m
//  UnitTestStudy
//
//  Created by MOMO on 2020/8/13.
//  Copyright © 2020 HelloWorld. All rights reserved.
//

#import "BrowseOverflowViewController.h"
#import "BrowseOverflowObjectConfiguration.h"
#import "StackOverManager.h"
#import "QuestionListTableDataSource.h"
#import "QuestionDetailDataSource.h"
#import "TopicTableDataSource.h"
#import "StackOverManagerDelegate.h"
#import "ZZTopick.h"
#import "ZZQuestion.h"

@interface BrowseOverflowViewController ()

@end

@implementation BrowseOverflowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self.dataSource;
    self.tableView.dataSource = self.dataSource;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter]
        addObserver: self selector: @selector(userDidSelectTopicNotification:) name: TopicTableDidSelectTopicNotification object: nil];
    if ([self.dataSource isKindOfClass:QuestionListTableDataSource.class]) {
        ((QuestionListTableDataSource *)self.dataSource).notificationCenter = [NSNotificationCenter defaultCenter];
    }
    
    [[NSNotificationCenter defaultCenter]
    addObserver: self
    selector: @selector(userDidSelectQuestionNotification:)
    name: QuestionListDidSelectQuestionNotification
    object: nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
    [[NSNotificationCenter defaultCenter]
     removeObserver: self name: TopicTableDidSelectTopicNotification object: nil];
    [[NSNotificationCenter defaultCenter]
     removeObserver: self name: QuestionListDidSelectQuestionNotification object: nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    
    self.manager = [self.objectConfiguration stackOverflowManager];
    self.manager.delegate = self;
    
    if ([self.dataSource isKindOfClass:QuestionListTableDataSource.class]) {
        ZZTopick *selectedTopic = [(QuestionListTableDataSource *)self.dataSource topic];
        [self.manager fetchQuestionsOnTopic:selectedTopic];
        AvatarStore *avatarStore = [self.objectConfiguration avatarStore];
        [(QuestionListTableDataSource *)self.dataSource setAvatarStore:avatarStore];
    } else if ([self.dataSource isKindOfClass:QuestionDetailDataSource.class]) {
        
        ZZQuestion *selectedQuestion = [(QuestionDetailDataSource *)self.dataSource question];
        [self.manager fetchBodyForQuestion:selectedQuestion];
        [self.manager fetchAnswersForQuestion:selectedQuestion];
        [(QuestionDetailDataSource *)self.dataSource setAvatarStore: [self.objectConfiguration avatarStore]];
    }
}



#pragma mark - Notification handling

/// 用户选择的话题 -》 显示提问列表
- (void)userDidSelectTopicNotification: (NSNotification *)note {
    
    ZZTopick *selectedTopic = (ZZTopick *)[note object];
    
    BrowseOverflowViewController *nextViewController = [[BrowseOverflowViewController alloc] init];
    QuestionListTableDataSource *questionsDataSource = [[QuestionListTableDataSource alloc] init];
    questionsDataSource.topic = selectedTopic;
    nextViewController.dataSource = questionsDataSource;
    nextViewController.objectConfiguration = self.objectConfiguration;
    nextViewController.title = @"## 话题 - 提问列表 ##";
    [[self navigationController] pushViewController: nextViewController animated: YES];
    
}

/// 用户点击了提问列表中某个提问 - 》 显示提问详情
- (void)userDidSelectQuestionNotification: (NSNotification *)note {
    
    ZZQuestion *selectedQuestion = (ZZQuestion *)[note object];
    BrowseOverflowViewController *nextViewController = [[BrowseOverflowViewController alloc] init];
    QuestionDetailDataSource *detailDataSource = [[QuestionDetailDataSource alloc] init];
    detailDataSource.question = selectedQuestion;
    nextViewController.dataSource = detailDataSource;
    nextViewController.objectConfiguration = self.objectConfiguration;
    nextViewController.title = [NSString stringWithFormat:@"## %@- 详情 ##",selectedQuestion.title];
    [[self navigationController] pushViewController: nextViewController animated: YES];
}

#pragma mark - StackOverflowManagerDelegate
- (void)fetchingQuestionsFailedWithError:(NSError *)error {
    
}

// 提问列表
- (void)didReceiveQuestions:(NSArray *)questions {
    ZZTopick *topic = ((QuestionListTableDataSource *)self.dataSource).topic;
    for (ZZQuestion *thisQuestion in questions) {
        [topic addQuestion: thisQuestion];
    }
    // 刷新数据
    [self.tableView reloadData];
}

- (void)fetchingQuestionBodyFailedWithError:(NSError *)error {
    
}

- (void)retrievingAnswersFailedWithError:(NSError *)error {
    
}

- (void)answersReceivedForQuestion:(ZZQuestion *)question {
     [self.tableView reloadData];
}

- (void)bodyReceivedForQuestion:(ZZQuestion *)question {
     [self.tableView reloadData];
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor blueColor];
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
