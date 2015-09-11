//
//  HistoryViewController.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADHistoryViewController.h"

static const int kTableHeaderHeight = 60;

static NSString* const kCellIdentifer = @"kCellIdentifer";
static NSString* const kDateFormat = @"yyyy年MM月dd日 HH:mm:ss";
static NSString* const kTitleText = @"访问记录";
static NSString* const kTableHeaderText = @"以下是您最近一段时间的访问记录";
static NSString* const kFromAppLogin = @"从账号密码登录";
static NSString* const kFromWXLogin =  @"从微信授权登录";

@interface ADHistoryViewController ()

@property (nonatomic, strong) NSArray *accessLogArray;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) UITableViewHeaderFooterView *headerView;

@end

@implementation ADHistoryViewController

#pragma mark - Life Cycle
- (instancetype)initWithStyle:(UITableViewStyle)style
                   AccessLogs:(NSArray *)accessLogArray {
    if (self = [self initWithStyle:style]) {
        self.accessLogArray = accessLogArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = kTitleText;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kCellIdentifer];
}

#pragma mark - User Actions
- (void)onClickBack: (UIBarButtonItem *)sender {
    if (sender != self.navigationItem.leftBarButtonItem)
        return;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [self.accessLogArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifer
                                                            forIndexPath:indexPath];
    ADAccessLog *accessLog = [self.accessLogArray objectAtIndex:indexPath.row];
    NSDate *loginDate = [NSDate dateWithTimeIntervalSince1970:accessLog.loginTime];
    NSString *loginDateString = [self.formatter stringFromDate:loginDate];
    NSString *loginTypeString = accessLog.loginType == ADLoginTypeFromApp ? kFromAppLogin : kFromWXLogin;
    cell.textLabel.text = [NSString stringWithFormat:@"%@  %@", loginDateString, loginTypeString];
    cell.textLabel.font = [UIFont fontWithName:kChineseFont
                                          size:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kTableHeaderHeight;
}

#pragma mark - Lazy Initializers
- (NSDateFormatter *)formatter {
    if (_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = kDateFormat;
    }
    return _formatter;
}

- (UITableViewHeaderFooterView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0,
                                                                                    0,
                                                                                    ScreenWidth,
                                                                                    kTableHeaderHeight)];
        _headerView.textLabel.font = [UIFont fontWithName:kChineseFont
                                                    size:14];
        _headerView.textLabel.text = kTableHeaderText;
    }
    return _headerView;
}
@end
