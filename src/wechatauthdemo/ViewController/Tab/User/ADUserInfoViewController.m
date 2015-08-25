//
//  UserInfoViewController.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <SVProgressHUD.h>
#import "UIImageView+WebCache.h"
#import "UserInfoDisplayCell.h"
#import "UserInfoHeaderView.h"
#import "ADUserInfoViewController.h"
#import "WXLoginViewController.h"
#import "ADHistoryViewController.h"
#import "ADAboutViewController.h"
#import "ADLoginViewController.h"
#import "ADNetworkEngine.h"
#import "WXAuthManager.h"
#import "ADUserInfo.h"
#import "ADGetUserInfoResp.h"
#import "ADAPPBindWXResp.h"

/* Text Message */
static NSString *kUserInfoCellIdentifier = @"cellIdentifierForUserInfo";
static NSString *kButtonCellIdentifier = @"cellIdentifierForButton";
static NSString *kUserInfoTitle = @"个人信息";
static NSString *kMailDescText = @"账户邮箱";
static NSString *kOpenIdDescText = @"OpenID";
static NSString *kUnionIdDescText = @"UnionID";
static NSString *kAccessTokenDescText = @"Access token有效期至";
static NSString *kRefreshTokenDescText = @"Refresh token有效期至";
static NSString *kAccessLogDescText = @"访问记录";
static NSString *kAboutUsText = @"关于我们";
static NSString *kLogoutButtonText = @"退出登录";
static NSString *kDateFormat = @"yyyy-MM-dd HH:mm";
static NSString *kGetUserInfoWarningText = @"获取用户信息失败";
static NSString *kWXAuthDenyTitle = @"微信授权失败";
static NSString *kBindWXWarningText = @"绑定微信失败";
static NSString *kBindingWXProgress = @"请稍候";
static NSString *kLogoutTitleText = @"退出不会删除用户数据，下次登录依然可以使用本账号";
static NSString *kCancleTitleText = @"取消";

/* Font */
static const CGFloat kButtonCellFontSize = 12.0f;
/* Size */
static const int kUserInfoCellHeight = 49.0f;
static const int kButtonCellHeight = 40.0f;

@interface ADUserInfoViewController ()<UITableViewDataSource, UITableViewDelegate,
                                        WXAuthDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UserInfoHeaderView *userInfoHeader;
@property (nonatomic, strong) UITableView *userInfoTable;
@property (nonatomic, strong) ADGetUserInfoResp *userInfoResp;
@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation ADUserInfoViewController
#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kUserInfoTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.userInfoTable];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStyleBordered
                                                                            target:nil
                                                                            action:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    NSInteger rowNumArray[] = {5, 1, 1, 1};
    return rowNumArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserInfoDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellIdentifier];
        switch (indexPath.row) {
            case 0: //Email
                cell.descLabel.text = kMailDescText;
                cell.valueLabel.text = self.userInfoResp && [self.userInfoResp.mail length] == 0 ? @"点击绑定账号" : self.userInfoResp.mail;
                break;
            case 1: //Open ID
                cell.descLabel.text = kOpenIdDescText;
                cell.valueLabel.text = self.userInfoResp && [self.userInfoResp.openid length] == 0 ? @"点击绑定微信" : self.userInfoResp.openid;
                break;
            case 2: //Union ID
                cell.descLabel.text = kUnionIdDescText;
                cell.valueLabel.text = [self.userInfoResp.unionid length] == 0 ? @"暂无" : self.userInfoResp.unionid;
                break;
            case 3: //Access Token
                cell.descLabel.text = kAccessTokenDescText;
                cell.valueLabel.text = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.userInfoResp.accessTokenExpireTime]];
                break;
            case 4: //Refresh Token
                cell.descLabel.text = kRefreshTokenDescText;
                cell.valueLabel.text = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.userInfoResp.refreshTokenExpireTime]];
                break;
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {    //Access Log
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kButtonCellIdentifier];
        cell.textLabel.text = kAccessLogDescText;
        cell.textLabel.font = [UIFont fontWithName:kTitleLabelFont
                                              size:kButtonCellFontSize];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2) {    //About Us
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kButtonCellIdentifier];
        cell.textLabel.text = kAboutUsText;
        cell.textLabel.font = [UIFont fontWithName:kTitleLabelFont
                                              size:kButtonCellFontSize];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {    //Logout
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kButtonCellIdentifier];
        cell.textLabel.text = kLogoutButtonText;
        cell.textLabel.font = [UIFont fontWithName:kTitleLabelFont
                                              size:kButtonCellFontSize];
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? kUserInfoCellHeight : kButtonCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) { //Bind App
        if ([self.userInfoResp.mail length] == 0) {
            ADLoginViewController *bindAppView = [[ADLoginViewController alloc] init];
            bindAppView.isUsedForBindApp = YES;
            [self.navigationController pushViewController:bindAppView
                                                 animated:YES];
        }
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        if ([self.userInfoResp.openid length] == 0) {   //Bind WX
            [[WXAuthManager sharedManager] sendAuthRequestWithController:self
                                                                delegate:self];
        }
    } else {
        switch (indexPath.section) {
            case 1: //Access Log
                [self.navigationController pushViewController:[[ADHistoryViewController alloc] initWithStyle:UITableViewStyleGrouped
                                                                                                  AccessLogs:self.userInfoResp.accessLog]
                                                     animated:YES];
                break;
            case 2: //About Us
                [self.navigationController pushViewController:[[ADAboutViewController alloc] init]
                                                     animated:YES];
                break;
            case 3: //Logout
                [[[UIActionSheet alloc] initWithTitle:kLogoutTitleText
                                            delegate:self
                                   cancelButtonTitle:kCancleTitleText
                              destructiveButtonTitle:kLogoutButtonText
                                    otherButtonTitles:nil] showInView:self.view];
                break;
            default:
                break;
        }
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [[ADNetworkEngine sharedEngine] disConnect];
        WXLoginViewController *wxLoginView = [[WXLoginViewController alloc] init];
        [self.navigationController pushViewController:wxLoginView
                                             animated:YES];
    }
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark - WXAuthDelegate
- (void)wxAuthSucceed:(NSString*)code {
    [SVProgressHUD showWithStatus:kBindingWXProgress];
    [[ADNetworkEngine sharedEngine] appBindWxForUin:[ADUserInfo currentUser].uin
                                        LoginTicket:[ADUserInfo currentUser].loginTicket
                                           AuthCode:code
                                     WithCompletion:^(ADAPPBindWXResp *resp) {
                                         [self handleBindWXResponse:resp];
                                     }];
}

- (void)wxAuthDenied {
    [SVProgressHUD showErrorWithStatus:kWXAuthDenyTitle];
}

#pragma mark - Network Handler
- (void)handleGetUserInfoResponse:(ADGetUserInfoResp *)resp {
    if (resp && resp.mail) {
        NSLog(@"Get UserInfo Success");
        self.userInfoResp = resp;
        [ADUserInfo currentUser].mail = resp.mail;
        [ADUserInfo currentUser].nickname = resp.nickname;
        [ADUserInfo currentUser].headimgurl = resp.headimgurl;
        [ADUserInfo currentUser].sex = resp.sex;
        [self.userInfoTable reloadData];
        [self.userInfoHeader.headPhotoImage sd_setImageWithURL:[NSURL URLWithString:resp.headimgurl]
                                              placeholderImage:[UIImage imageNamed:@"pic_logo_1082168b9"]];
        self.userInfoHeader.nickNameLabel.text = resp.nickname;
    } else {
        NSLog(@"Get UserInfo Fail");
        [SVProgressHUD showErrorWithStatus:kGetUserInfoWarningText];
    }
}

- (void)handleBindWXResponse: (ADAPPBindWXResp *)resp {
    if (resp && resp.loginTicket) {
        NSLog(@"BindWX Success");
        [ADUserInfo currentUser].uin = resp.uin;
        [ADUserInfo currentUser].loginTicket = resp.loginTicket;
        [SVProgressHUD dismiss];
    } else {
        NSLog(@"BindWX Fail");
        [SVProgressHUD showErrorWithStatus:kBindWXWarningText];
    }
}

#pragma mark - Lazy Initializers
- (UserInfoHeaderView *)userInfoHeader {
    if (_userInfoHeader == nil) {
        _userInfoHeader = [[[NSBundle mainBundle] loadNibNamed:@"UserInfoHeaderView"
                                                        owner:nil
                                                      options:nil] firstObject];
    }
    return _userInfoHeader;
}
- (UITableView *)userInfoTable {
    if (_userInfoTable == nil) {
        _userInfoTable = [[UITableView alloc] initWithFrame:CGRectZero
                                                      style:UITableViewStyleGrouped];
        [_userInfoTable registerNib:[UINib nibWithNibName:@"UserInfoDisplayCell"
                                                   bundle:nil]
             forCellReuseIdentifier:kUserInfoCellIdentifier];
        [_userInfoTable registerClass:[UITableViewCell class]
               forCellReuseIdentifier:kButtonCellIdentifier];
        _userInfoTable.sectionHeaderHeight = _userInfoTable.sectionFooterHeight = inset/2;
        _userInfoTable.tableHeaderView = self.userInfoHeader;
        _userInfoTable.dataSource = self;
        _userInfoTable.delegate = self;
    }
    return _userInfoTable;
}

- (NSDateFormatter *)formatter {
    if (_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = kDateFormat;
    }
    return _formatter;
}
@end