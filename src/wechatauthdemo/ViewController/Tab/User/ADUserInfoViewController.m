//
//  UserInfoViewController.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <SVProgressHUD.h>
#import "UserInfoDisplayCell.h"
#import "ADUserInfoViewController.h"
#import "WXLoginViewController.h"
#import "ADNetworkEngine.h"
#import "ADUserInfo.h"
#import "ADGetUserInfoResp.h"

static NSString *kUserInfoCellIdentifier = @"cellIdentifierForUserInfo";
static NSString *kButtonCellIdentifier = @"cellIdentifierForButton";

@interface ADUserInfoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *userInfoTable;
@property (nonatomic, strong) ADGetUserInfoResp *userInfoResp;

@end

static NSString *kUserInfoTitle = @"个人信息";

@implementation ADUserInfoViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kUserInfoTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.userInfoTable];
    
    [[ADNetworkEngine sharedEngine] getUserInfoForUin:[ADUserInfo currentUser].uin
                                          LoginTicket:[ADUserInfo currentUser].loginTicket
                                       WithCompletion:^(ADGetUserInfoResp *resp) {
                                           [self handleGetUserInfoResponse:resp];
                                       }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.userInfoTable.frame = self.view.frame;
}

#pragma mark - UITableViewDataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNumArray[] = {6, 1, 1, 1};
    return rowNumArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserInfoDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellIdentifier];
        switch (indexPath.row) {
            case 0: //Email
                cell.descLabel.text = @"账户邮箱";
                cell.valueLabel.text = self.userInfoResp.mail;
                break;
            case 1: //WeChat ID
                cell.descLabel.text = @"微信号";
                cell.valueLabel.text = @"暂无";
                break;
            case 2: //Open ID
                cell.descLabel.text = @"OpenID";
                cell.valueLabel.text = self.userInfoResp.openid;
                break;
            case 3: //Union ID
                cell.descLabel.text = @"UnionID";
                cell.valueLabel.text = self.userInfoResp.unionid;
                break;
            case 4: //Access Token
                cell.descLabel.text = @"Access token有效期至";
                cell.valueLabel.text = [self getDateStringFromUnixTime:self.userInfoResp.accessTokenExpireTime
                                                               Formate:@"yyyy-MM-dd"];
                break;
            case 5: //Refresh Token
                cell.descLabel.text = @"Refresh token有效期至";
                cell.valueLabel.text = [self getDateStringFromUnixTime:self.userInfoResp.refreshTokenExpireTime
                                                               Formate:@"yyyy-MM-dd"];
                break;
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {    //Access Log
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kButtonCellIdentifier];
        cell.textLabel.text = @"访问记录";
        cell.textLabel.font = [UIFont fontWithName:kTitleLabelFont
                                              size:12];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kButtonCellIdentifier];
        cell.textLabel.text = @"关于我们";
        cell.textLabel.font = [UIFont fontWithName:kTitleLabelFont
                                              size:12];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kButtonCellIdentifier];
        cell.textLabel.text = @"退出登录";
        cell.textLabel.font = [UIFont fontWithName:kTitleLabelFont
                                              size:12];
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 49 : 40;
}

#pragma mark - Network Handler
- (void)handleGetUserInfoResponse:(ADGetUserInfoResp *)resp {
    if (resp && resp.mail) {
        NSLog(@"Get UserInfo Success");
        self.userInfoResp = resp;
        [self.userInfoTable reloadData];
    } else {
        NSLog(@"Get UserInfo Fail");
        [SVProgressHUD showErrorWithStatus:@"获取用户信息失败"];
    }
}

#pragma mark - Lazy Initializers
- (UITableView *)userInfoTable {
    if (_userInfoTable == nil) {
        _userInfoTable = [[UITableView alloc] initWithFrame:CGRectZero
                                                      style:UITableViewStyleGrouped];
        [_userInfoTable registerNib:[UINib nibWithNibName:@"UserInfoDisplayCell"
                                                   bundle:nil] forCellReuseIdentifier:kUserInfoCellIdentifier];
        [_userInfoTable registerClass:[UITableViewCell class]
               forCellReuseIdentifier:kButtonCellIdentifier];
        _userInfoTable.sectionHeaderHeight = _userInfoTable.sectionFooterHeight = inset/2;
        _userInfoTable.dataSource = self;
        _userInfoTable.delegate = self;
    }
    return _userInfoTable;
}

#pragma mark - Private Methods
- (NSString *)getDateStringFromUnixTime:(double)time Formate:(NSString *)formateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formateString;
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:time]];
}

@end