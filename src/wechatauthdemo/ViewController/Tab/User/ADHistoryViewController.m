//
//  HistoryViewController.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADHistoryViewController.h"

static NSString *kCellIdentifer = @"kCellIdentifer";
static NSString *kTableHeaderIdentifer = @"kTableHeaderIdentifer";
static NSString *kDateFormat = @"yyyy-MM-dd HH:mm";
static NSString *kTitleText = @"访问记录";
static NSString *kTableHeaderText = @"以下是您最近一段时间的访问记录";

@interface ADHistoryViewController ()

@property (nonatomic, strong) NSArray *accessLogArray;
@property (nonatomic, strong) NSDateFormatter *formatter;

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
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:kTableHeaderIdentifer];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kCellIdentifer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
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
    cell.textLabel.text = [self.formatter stringFromDate:loginDate];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kTableHeaderIdentifer];
    headerView.textLabel.text = kTableHeaderText;
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return normalHeight;
}

#pragma mark - Lazy Initializers
- (NSDateFormatter *)formatter {
    if (_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = kDateFormat;
    }
    return _formatter;
}
@end
