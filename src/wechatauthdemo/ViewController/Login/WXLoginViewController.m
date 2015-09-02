//
//  WXLoginViewController.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <SVProgressHUD.h>
#import "WXLoginViewController.h"
#import "ADLoginViewController.h"
#import "ADNetworkEngine.h"
#import "WXApiManager.h"
#import "ADWXLoginResp.h"
#import "ADCheckLoginResp.h"
#import "ADUserInfo.h"
#import "ADConnectResp.h"

/* Title Message */
static NSString *kNormalLoginTitle = @"普通账号登录";
static NSString *kWXAuthDenyTitle = @"授权失败";
static NSString *kWXLoginErrorTitle = @"微信登陆失败";
static NSString *kLoginStatusTitle = @"登录中";
static NSString *kTitleLabelText = @"WeChat Sample";
/* Font */
static const CGFloat kTitleLabelFontSize = 18.0f;
static const CGFloat kWXLoginButtonFontSize = 16.0f;
static const CGFloat kNormalButtonFontSize = 12.0f;
/* Size */
static const int kLogoImageWidth = 75;
static const int kLogoImageHeight = 52;
static const int kTitleLabelWidth = 150;
static const int kTitleLabelHeight = 44;
static const int kWXLoginButtonWidth = 280;
static const int kWXLoginButtonHeight = 44;
static const int kWXLogoImageWidth = 25;
static const int kWXLogoImageHeight = 20;
static const int kNormalLoginButtonWidth = 200;
static const int kNormalLoginButtonHeight = 44;

@interface WXLoginViewController ()<WXAuthDelegate>

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *wxLogoImageView;
@property (nonatomic, strong) UIButton *wxLoginButton;
@property (nonatomic, strong) UIButton *normalLoginButton;

@end

@implementation WXLoginViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.navigationItem.hidesBackButton = YES;
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.wxLoginButton];
    [self.view addSubview:self.wxLogoImageView];
    [self.view addSubview:self.normalLoginButton];
    
    /* Setup Network */
    [[ADNetworkEngine sharedEngine] connectToServerWithCompletion:^(ADConnectResp *resp) {
        if (resp && resp.baseResp.errcode == 0) {
            [ADUserInfo currentUser].uin = (UInt32)resp.tempUin;
            NSLog(@"Connect Success");
        } else {
            NSLog(@"Connect Failed");
        }
    }];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.backgroundView.frame = self.view.frame;

    CGFloat logoImageCenterY = ScreenHeight / 5;
    self.logoImageView.frame = CGRectMake(0, 0, kLogoImageWidth, kLogoImageHeight);
    self.logoImageView.center = CGPointMake(self.view.center.x, logoImageCenterY);
    
    CGFloat titleLabelCenterY = logoImageCenterY + kLogoImageHeight/2 + inset*2;
    self.titleLabel.frame = CGRectMake(0, 0, kTitleLabelWidth, kTitleLabelHeight);
    self.titleLabel.center = CGPointMake(self.view.center.x, titleLabelCenterY);
    
    CGFloat loginButtonCenterY = ScreenHeight / 3 * 2;
    self.wxLoginButton.frame = CGRectMake(0, 0, kWXLoginButtonWidth, kWXLoginButtonHeight);
    self.wxLoginButton.center = CGPointMake(self.view.center.x, loginButtonCenterY);
    
    CGFloat wxLogoImageCenterX = self.view.center.x - inset * 3;
    self.wxLogoImageView.frame = CGRectMake(0, 0, kWXLogoImageWidth, kWXLogoImageHeight);
    self.wxLogoImageView.center = CGPointMake(wxLogoImageCenterX, loginButtonCenterY);
    
    CGFloat normalBtnCenterY = ScreenHeight-kNormalLoginButtonHeight/2-inset;
    self.normalLoginButton.frame = CGRectMake(0, 0, kNormalLoginButtonWidth, kNormalLoginButtonHeight);
    self.normalLoginButton.center = CGPointMake(self.view.center.x, normalBtnCenterY);
}

#pragma mark - User Actions
- (void)onClickWXLogin: (UIButton *)sender {
    if (sender != self.wxLoginButton)
        return;
    [[WXApiManager sharedManager] sendAuthRequestWithController:self
                                                        delegate:self];
}

- (void)onClickNormalLogin: (UIButton *)sender {
    if (sender != self.normalLoginButton)
        return;
    
    ADLoginViewController *normalLoginView = [[ADLoginViewController alloc] init];
    [self.navigationController pushViewController:normalLoginView animated:YES];
}

#pragma mark - WXAuthDelegate
- (void)wxAuthSucceed:(NSString *)code {
    [ADUserInfo currentUser].authCode = code;
    [SVProgressHUD showWithStatus:kLoginStatusTitle];
    [[ADNetworkEngine sharedEngine] wxLoginForAuthCode:code
                                        WithCompletion:^(ADWXLoginResp *resp) {
                                            [self handleWXLoginResponse:resp];
                                        }];
}

- (void)wxAuthDenied {
    [SVProgressHUD showErrorWithStatus:kWXAuthDenyTitle];
}

#pragma mark - Network Handlers
- (void)handleWXLoginResponse:(ADWXLoginResp *)resp {
    if (resp && resp.loginTicket) {
        NSLog(@"WXLogin Success");
        [ADUserInfo currentUser].uin = (UInt32)resp.uin;
        [ADUserInfo currentUser].loginTicket = resp.loginTicket;
        [[ADNetworkEngine sharedEngine] checkLoginForUin:resp.uin
                                             LoginTicket:resp.loginTicket
                                          WithCompletion:^(ADCheckLoginResp *checkLoginResp) {
                                              [self handleCheckLoginResponse:checkLoginResp];
                                          }];
    } else {
        NSLog(@"WXLogin Fail");
        NSString *errorTitle = [NSString errorTitleFromResponse:resp.baseResp
                                                   defaultError:kWXLoginErrorTitle];
        [SVProgressHUD showErrorWithStatus:errorTitle];
    }
}

- (void)handleCheckLoginResponse:(ADCheckLoginResp *)resp {
    if (resp && resp.sessionKey) {
        NSLog(@"Check Login Success");
        [SVProgressHUD dismiss];
        [ADUserInfo currentUser].sessionExpireTime = resp.expireTime;
        [[ADUserInfo currentUser] save];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSLog(@"Check Login Fail");
        NSString *errorTitle = [NSString errorTitleFromResponse:resp.baseResp
                                                   defaultError:kWXLoginErrorTitle];
        [SVProgressHUD showErrorWithStatus:errorTitle];
    }
}

#pragma mark - Lazy Initializer
- (UIImageView *)backgroundView {
    if (_backgroundView == nil) {
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wxLoginBackground"]];
    }
    return _backgroundView;
}

- (UIImageView *)logoImageView {
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AppLogo"]];
    }
    return _logoImageView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = kTitleLabelText;
        _titleLabel.font = [UIFont fontWithName:kTitleLabelFont
                                           size:kTitleLabelFontSize];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

- (UIButton *)wxLoginButton {
    if (_wxLoginButton == nil) {
        _wxLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _wxLoginButton.backgroundColor = [UIColor loginButtonColor];
        _wxLoginButton.layer.cornerRadius = kLoginButtonCornerRadius;
        [_wxLoginButton setTitle:@"        微信登录" forState:UIControlStateNormal];
        [_wxLoginButton addTarget:self
                           action:@selector(onClickWXLogin:)
                 forControlEvents:UIControlEventTouchUpInside];
        _wxLoginButton.titleLabel.font = [UIFont fontWithName:kTitleLabelFont
                                                         size:kWXLoginButtonFontSize];
    }
    return _wxLoginButton;
}

- (UIImageView *)wxLogoImageView {
    if (_wxLogoImageView == nil) {
        _wxLogoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wxLogo"]];
    }
    return _wxLogoImageView;
}

- (UIButton *)normalLoginButton {
    if (_normalLoginButton == nil) {
        _normalLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_normalLoginButton addTarget:self
                               action:@selector(onClickNormalLogin:)
                     forControlEvents:UIControlEventTouchUpInside];
        [_normalLoginButton setTitle:kNormalLoginTitle
                            forState:UIControlStateNormal];
        [_normalLoginButton setTitleColor:[UIColor linkButtonColor]
                                 forState:UIControlStateNormal];
        _normalLoginButton.titleLabel.font = [UIFont fontWithName:kTitleLabelFont
                                                             size:kNormalButtonFontSize];
    }
    return _normalLoginButton;
}
@end