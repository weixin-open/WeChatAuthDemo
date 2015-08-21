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
#import "WXAuthManager.h"
#import "ADWXLoginResp.h"
#import "ADCheckLoginResp.h"
#import "ADUserInfo.h"

static NSString *kNormalLoginTitle = @"普通账号登录";
static NSString *kWXAuthDenyTitle = @"授权失败";
static NSString *kWXLoginErrorTitle = @"微信登陆失败";
static NSString *kCheckLoginErrorTitle = @"登陆失败";
static NSString *kTitleLabelText = @"WeChat Sample";
static const CGFloat kTitleLabelFontSize = 20.0f;
static const int kWXLoginButtonWidth = 250;
static const int kWXLoginButtonHeight = 44;
static const int kNormalLoginButtonWidth = 200;
static const int kNormalLoginButtonHeight = 44;

@interface WXLoginViewController ()<WXAuthDelegate>

@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
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
    [self.view addSubview:self.normalLoginButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.backgroundView.frame = self.view.frame;

    CGFloat logoImageCenterY = 108;
    self.logoImageView.frame = CGRectMake(0, 0, 75, 52);
    self.logoImageView.center = CGPointMake(self.view.center.x, logoImageCenterY);
    
    self.titleLabel.frame = CGRectMake(0, 0, 150, 44);
    self.titleLabel.center = CGPointMake(self.view.center.x, logoImageCenterY+50);
    self.wxLoginButton.frame = CGRectMake(0, 0, kWXLoginButtonWidth, kWXLoginButtonHeight);
    self.wxLoginButton.center = self.view.center;
    
    CGFloat normalBtnCenterY = ScreenHeight-kNormalLoginButtonHeight/2-inset*2;
    self.normalLoginButton.frame = CGRectMake(0, 0, kNormalLoginButtonWidth, kNormalLoginButtonHeight);
    self.normalLoginButton.center = CGPointMake(self.view.center.x, normalBtnCenterY);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - User Actions
- (void)onClickWXLogin: (UIButton *)sender {
    if (sender != self.wxLoginButton)
        return;
    
    [[WXAuthManager sharedManager] sendAuthRequestWithController:self
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
    [[ADNetworkEngine sharedEngine] wxLoginForAuthCode:code
                                        WithCompletion:^(ADWXLoginResp *resp) {
                                            [self handleWXLoginResponse:resp];
                                        }];
}

- (void)wxAuthDenied {
    [SVProgressHUD showErrorWithStatus:kWXAuthDenyTitle];
}

#pragma mark - Network Hanlders
- (void)handleWXLoginResponse:(ADWXLoginResp *)resp {
    if (resp && resp.loginTicket) {
        NSLog(@"WXLogin Success");
        [[ADUserInfo currentUser] setUin:resp.uin];
        [[ADUserInfo currentUser] setLoginTicket:resp.loginTicket];
        [[ADNetworkEngine sharedEngine] checkLoginForUin:resp.uin
                                             LoginTicket:resp.loginTicket
                                          WithCompletion:^(ADCheckLoginResp *resp) {
                                              [self handleCheckLoginResponse:resp];
                                          }];
    } else {
        NSLog(@"WXLogin Fail");
        NSString *errorTitle = resp.baseResp.errmsg ? resp.baseResp.errmsg : kWXLoginErrorTitle;
        [SVProgressHUD showErrorWithStatus:errorTitle];
    }
}

- (void)handleCheckLoginResponse:(ADCheckLoginResp *)resp {
    if (resp && resp.sessionKey) {
        NSLog(@"CheckLogin Success");
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSLog(@"CheckLogin Fail");
        NSString *errorTitle = resp.baseResp.errmsg ? resp.baseResp.errmsg : kCheckLoginErrorTitle;
        [SVProgressHUD showErrorWithStatus:errorTitle];
    }
}

#pragma mark - Lazy Initializers
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
        _wxLoginButton.backgroundColor = [UIColor colorWithRed:0.04
                                                         green:0.73
                                                          blue:0.03
                                                         alpha:1.00];
        [_wxLoginButton setTitle:@"微信登录" forState:UIControlStateNormal];
        [_wxLoginButton addTarget:self
                           action:@selector(onClickWXLogin:)
                 forControlEvents:UIControlEventTouchUpInside];
        _wxLoginButton.titleLabel.font = [UIFont fontWithName:kTitleLabelFont
                                                         size:16];
    }
    return _wxLoginButton;
}

- (UIButton *)normalLoginButton {
    if (_normalLoginButton == nil) {
        _normalLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_normalLoginButton addTarget:self
                               action:@selector(onClickNormalLogin:)
                     forControlEvents:UIControlEventTouchUpInside];
        [_normalLoginButton setTitle:kNormalLoginTitle
                            forState:UIControlStateNormal];
        [_normalLoginButton setTitleColor:[UIColor colorWithRed:0.27
                                                          green:0.60
                                                           blue:0.91
                                                          alpha:1.00]
                                 forState:UIControlStateNormal];
        _normalLoginButton.titleLabel.font = [UIFont fontWithName:kTitleLabelFont
                                                             size:12];
    }
    return _normalLoginButton;
}

@end
