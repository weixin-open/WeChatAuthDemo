//
//  UserInfoViewController.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <SVProgressHUD.h>
#import "UserInfoDisplayCell.h"
#import "UserInfoHeaderView.h"
#import "ADUserInfoViewController.h"
#import "WXLoginViewController.h"
#import "ADHistoryViewController.h"
#import "ADAboutViewController.h"
#import "ADLoginViewController.h"
#import "ADShareViewController.h"
#import "ADNetworkEngine.h"
#import "WXApiManager.h"
#import "ADUserInfo.h"
#import "ADGetUserInfoResp.h"
#import "ADAPPBindWXResp.h"
#import "ADCheckLoginResp.h"

/* Text Message */
static NSString *kUserInfoCellIdentifier = @"cellIdentifierForUserInfo";
static NSString *kButtonCellIdentifier = @"cellIdentifierForButton";
static NSString *kUserInfoTitle = @"个人信息";
static NSString *kMailDescText = @"账户邮箱";
static NSString *kOpenIdDescText = @"OpenID";
static NSString *kUnionIdDescText = @"UnionID";
static NSString *kAccessTokenDescText =  @"Access token有效期至";
static NSString *kRefreshTokenDescText = @"Refresh token有效期至";
static NSString *kSessionKeyDescText =   @"App 登录态有效期至";
static NSString *kAccessLogDescText = @"访问记录";
static NSString *kShareText = @"开发指引";
static NSString *kAboutUsText = @"关于我们";
static NSString *kLogoutButtonText = @"退出登录";
static NSString *kDateFormat = @"yyyy-MM-dd HH:mm";
static NSString *kGetUserInfoWarningText = @"获取用户信息失败";
static NSString *kWXAuthDenyTitle = @"微信授权失败";
static NSString *kBindWXWarningText = @"绑定微信失败";
static NSString *kBindingWXProgress = @"请稍候";
static NSString *kLogoutTitleText = @"退出不会删除用户数据，下次登录依然可以使用本账号";
static NSString *kCancelTitleText = @"取消";
static NSString *kLoginErrorTitle = @"登录错误";
/* Font */
static const CGFloat kButtonCellFontSize = 12.0f;
/* Size */
static const CGFloat kUserInfoCellHeight = 49.0f;
static const CGFloat kButtonCellHeight = 40.0f;

@interface ADUserInfoViewController ()<UITableViewDataSource, UITableViewDelegate,
                                        WXAuthDelegate, UIActionSheetDelegate,
                                        UIAlertViewDelegate>

@property (nonatomic, strong) UserInfoHeaderView *userInfoHeader;
@property (nonatomic, strong) UITableView *userInfoTable;
@property (nonatomic, strong) ADGetUserInfoResp *userInfoResp;
@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

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

#pragma mark - User Actions
- (void)onLongPressedUserInfoTable: (UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        CGPoint pressPoint = [sender locationInView:self.userInfoTable];
        NSIndexPath *indexPath = [self.userInfoTable indexPathForRowAtPoint:pressPoint];
        if (indexPath.section == 0 && indexPath.row == 5) { //Refresh Token
            if (self.userInfoResp.refreshTokenExpireTime != kRefreshTokenTimeNone) {   //Have Refresh Token ExpireTime
                [[[UIAlertView alloc] initWithTitle:@"测试功能"
                                            message:@"这是一个测试功能，你可以使refresh token过期，以体验过期后的行为"
                                           delegate:self
                                  cancelButtonTitle:@"取消"
                                  otherButtonTitles:@"确定", nil] show];
            }
        }
    }
}

#pragma mark - UITableViewDataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowNumArray[] = {6, 1, 1, 1, 1};
    return rowNumArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserInfoDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:kUserInfoCellIdentifier];
        switch (indexPath.row) {
            case 0: { //Email
                cell.descLabel.text = kMailDescText;
                if (self.userInfoResp && [self.userInfoResp.mail length] == 0) {
                    cell.valueLabel.textColor = [UIColor linkButtonColor];
                    cell.valueLabel.text = @"点击绑定账号";
                } else {
                    cell.valueLabel.textColor = [UIColor darkTextColor];
                    cell.valueLabel.text = self.userInfoResp.mail;
                }
                break;
            }
            case 1: { //Open ID
                cell.descLabel.text = kOpenIdDescText;
                if (self.userInfoResp && [self.userInfoResp.openid length] == 0) {
                    cell.valueLabel.textColor = [UIColor linkButtonColor];
                    cell.valueLabel.text = @"点击绑定微信";
                } else {
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    cell.valueLabel.textColor = [UIColor darkTextColor];
                    cell.valueLabel.text = self.userInfoResp.openid;
                }
                break;
            }
            case 2: //Union ID
                cell.descLabel.text = kUnionIdDescText;
                cell.valueLabel.text = [self.userInfoResp.unionid length] == 0 ? @"暂无" : self.userInfoResp.unionid;
                break;
            case 3: //Session Key
                cell.descLabel.text = kSessionKeyDescText;
                cell.valueLabel.text = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[ADUserInfo currentUser].sessionExpireTime]];
                break;
            case 4: //Access Token
                cell.descLabel.text = kAccessTokenDescText;
                cell.valueLabel.text = self.userInfoResp.accessTokenExpireTime == kAccessTokenTimeNone ? @"暂无" : [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.userInfoResp.accessTokenExpireTime]];
                break;
            case 5: { //Refresh Token
                cell.descLabel.text = kRefreshTokenDescText;
                if (self.userInfoResp.refreshTokenExpireTime == kRefreshTokenTimeNone) {
                    cell.valueLabel.text = @"暂无";
                } else {
                    cell.valueLabel.text = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.userInfoResp.refreshTokenExpireTime]];
                }
                break;
            }
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {    //Access Log
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kButtonCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = kAccessLogDescText;
        cell.textLabel.font = [UIFont fontWithName:kTitleLabelFont
                                              size:kButtonCellFontSize];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 2) {    //Share
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kButtonCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = kShareText;
        cell.textLabel.font = [UIFont fontWithName:kTitleLabelFont
                                              size:kButtonCellFontSize];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 3) {    //About Us
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kButtonCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = kAboutUsText;
        cell.textLabel.font = [UIFont fontWithName:kTitleLabelFont
                                              size:kButtonCellFontSize];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {    //Logout
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kButtonCellIdentifier forIndexPath:indexPath];
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
            [[WXApiManager sharedManager] sendAuthRequestWithController:self
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
                [self.navigationController pushViewController:[[ADShareViewController alloc] init]
                                                     animated:YES];
                break;
            case 3: //Logout
                [self.navigationController pushViewController:[[ADAboutViewController alloc] init]
                                                     animated:YES];
                break;
            case 4:
                [[[UIActionSheet alloc] initWithTitle:kLogoutTitleText
                                            delegate:self
                                   cancelButtonTitle:kCancelTitleText
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
        [[ADUserInfo currentUser] clear];
        WXLoginViewController *wxLoginView = [[WXLoginViewController alloc] init];
        [self.navigationController pushViewController:wxLoginView
                                             animated:YES];
    }
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {   //Make Expired
        [[ADNetworkEngine sharedEngine] makeRefreshTokenExpired:[ADUserInfo currentUser].uin
                                                    LoginTicket:[ADUserInfo currentUser].loginTicket];
    } else if (alertView.numberOfButtons == 1) {    //Go to Login
        [[ADNetworkEngine sharedEngine] disConnect];
        [[ADUserInfo currentUser] clear];
        WXLoginViewController *wxLoginView = [[WXLoginViewController alloc] init];
        [self.navigationController pushViewController:wxLoginView
                                             animated:YES];
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark - WXAuthDelegate
- (void)wxAuthSucceed:(NSString*)code {
    NSLog(@"WXAuth Success");
    [SVProgressHUD showWithStatus:kBindingWXProgress];
    [[ADNetworkEngine sharedEngine] appBindWxForUin:[ADUserInfo currentUser].uin
                                        LoginTicket:[ADUserInfo currentUser].loginTicket
                                           AuthCode:code
                                     WithCompletion:^(ADAPPBindWXResp *resp) {
                                         [self handleBindWXResponse:resp];
                                     }];
}

- (void)wxAuthDenied {
    NSLog(@"WXAuth Deny");
    [SVProgressHUD showErrorWithStatus:kWXAuthDenyTitle];
}

#pragma mark - Private Methods
- (void)getUserInfo {
    [[ADNetworkEngine sharedEngine] getUserInfoForUin:[ADUserInfo currentUser].uin
                                          LoginTicket:[ADUserInfo currentUser].loginTicket
                                       WithCompletion:^(ADGetUserInfoResp *resp) {
                                           [self handleGetUserInfoResponse:resp];
                                       }];
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

        self.userInfoHeader.nickNameLabel.text = resp.nickname;
        [[ADNetworkEngine sharedEngine] downloadImageForUrl:resp.headimgurl
                                             WithCompletion:^(UIImage *image) {
                                                 image = image == nil ? [UIImage imageNamed:@"wxLogoGreen"] : image;
                                                 self.userInfoHeader.headPhotoImage.image = image;
                                             }];
        [self.userInfoTable reloadData];
    } else {
        NSLog(@"Get UserInfo Fail");
        if (resp.baseResp.errcode == ADErrorCodeTokenExpired) {
            [[[UIAlertView alloc] initWithTitle:@"Token过期"
                                        message:@"太久没登录了，请重新登录"
                                       delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil] show];
        } else {
            NSString *errorTitle = [NSString errorTitleFromResponse:resp.baseResp
                                                       defaultError:kGetUserInfoWarningText];
            [SVProgressHUD showErrorWithStatus:errorTitle];
        }
    }
}

- (void)handleBindWXResponse: (ADAPPBindWXResp *)resp {
    if (resp && resp.loginTicket) {
        NSLog(@"BindWX Success");
        [SVProgressHUD dismiss];
        [ADUserInfo currentUser].uin = (UInt32) resp.uin;
        [ADUserInfo currentUser].loginTicket = resp.loginTicket;
        [[ADNetworkEngine sharedEngine] getUserInfoForUin:[ADUserInfo currentUser].uin
                                              LoginTicket:[ADUserInfo currentUser].loginTicket
                                           WithCompletion:^(ADGetUserInfoResp *resp) {
                                               [self handleGetUserInfoResponse:resp];
                                           }];
    } else {
        NSLog(@"BindWX Fail");
        NSString *errorTitle = [NSString errorTitleFromResponse:resp.baseResp
                                                   defaultError:kBindWXWarningText];
        [SVProgressHUD showErrorWithStatus:errorTitle];
    }
}

#pragma mark - Lazy Initializer
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
        [_userInfoTable addGestureRecognizer:self.longPressGesture];
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

- (UILongPressGestureRecognizer *)longPressGesture {
    if (_longPressGesture == nil) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(onLongPressedUserInfoTable:)];
    }
    return _longPressGesture;
}

@end