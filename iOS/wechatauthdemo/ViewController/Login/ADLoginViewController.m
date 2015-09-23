//
//  ADLoginViewController.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "EmailFormatValidate.h"
#import "MD5.h"
#import "InputWithTextFieldCell.h"
#import "ADLoginViewController.h"
#import "ADRegisterViewController.h"
#import "ADNetworkEngine.h"
#import "ADLoginResp.h"
#import "ADUserInfo.h"
#import "ADCheckLoginResp.h"
#import "ADWXBindAPPResp.h"

/* Message Text */
static NSString* const kBackButtonTitle = @"返回";
static NSString* const kLoginViewTitle = @"请输入账号密码";
static NSString* const kEmailDescText = @"账户邮箱";
static NSString* const kPswDescText = @"密码";
static NSString* const kEmailWarningText = @"请输入有效邮箱账号";
static NSString* const kPasswordWarningText = @"密码至少6位";
static NSString* const kLoginButtonText = @"登录";
static NSString* const kRegisterTipsText = @"还没有账号？";
static NSString* const kRegisterButtonText = @"注册新账号";
static NSString* const kLoginProgressText = @"登录中";
static NSString* const kLoginFailText = @"登录失败";
static NSString* const kBindErrorText = @"绑定失败";
static NSString* const kCellIdentifier = @"cellIdentifierForLogin";
/* Font */
static const CGFloat kBackButtonFontSize = 13.0f;
static const CGFloat kTitleLabelFontSize = 20.0f;
static const CGFloat kLoginButtonFontSize = 16.0f;
/* Size */
static const int kBackButtonWidth = 44;
static const int kBackButtonHeight = 44;
static const int kTitleLabelWidth = 150;
static const int kTitleLabelHeight = 44;
static const int kLoginTableCellHeight = 49;
static const int kLoginButtonHeight = 44;
static const int kPasswordMinLength = 6;
static const int kRegisterTipLabelWidth = 80;
static const int kRegisterTipLabelHeight = 44;
static const int kRegisterButtonWidth = 70;
static const int kRegisterButtonHeight = 44;

@interface ADLoginViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *loginTable;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UILabel *registerTipsLabel;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UITextField *emailTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation ADLoginViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.loginTable];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registerTipsLabel];
    [self.view addSubview:self.registerButton];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    int backButtonCenterX = inset/2 + kBackButtonWidth/2;
    int backButtonCenterY = statusBarHeight + navigationBarHeight / 2;
    self.backButton.frame = CGRectMake(0, 0, kBackButtonWidth, kBackButtonHeight);
    self.backButton.center = CGPointMake(backButtonCenterX, backButtonCenterY);

    int titleLabelCenterY = navigationBarHeight + statusBarHeight + inset * 3;
    self.titleLabel.frame = CGRectMake(0, 0, kTitleLabelWidth, kTitleLabelHeight);
    self.titleLabel.center = CGPointMake(self.view.center.x, titleLabelCenterY);
    
    int loginTableCenterY = titleLabelCenterY + inset*5 + kLoginTableCellHeight;
    self.loginTable.frame = CGRectMake(0, 0, ScreenWidth-inset*2, kLoginTableCellHeight*2);
    self.loginTable.center = CGPointMake(self.view.center.x, loginTableCenterY);
    
    int loginButtonCenterY = loginTableCenterY + kLoginTableCellHeight*2 + inset;
    self.loginButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.loginTable.frame)-inset, kLoginButtonHeight);
    self.loginButton.center = CGPointMake(self.view.center.x+inset * 0.7, loginButtonCenterY);
    
    int registerTipsCenterY = loginButtonCenterY + kLoginButtonHeight/2 + inset * 2;
    self.registerTipsLabel.frame = CGRectMake(0, 0, kRegisterTipLabelWidth, kRegisterTipLabelHeight);
    self.registerTipsLabel.center = CGPointMake(self.view.center.x-(kRegisterTipLabelWidth/2), registerTipsCenterY);
    
    int registerBtnCenterX = self.registerTipsLabel.center.x + (kRegisterTipLabelWidth + kRegisterButtonWidth)/2;
    self.registerButton.frame = CGRectMake(0, 0, kRegisterButtonWidth, kRegisterButtonHeight);
    self.registerButton.center = CGPointMake(registerBtnCenterX, registerTipsCenterY);
}

#pragma mark - User Actions
- (void)onClickCancle:(UIButton *)sender {
    if (sender != self.backButton)
        return;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickLogin:(UIButton *)sender {
    if (sender != self.loginButton)
        return;
    
    if (![EmailFormatValidate isValidate:self.emailTextField.text]) {
        ADShowErrorAlert(kEmailWarningText);
    } else if ([self.passwordTextField.text length] < kPasswordMinLength) {
        ADShowErrorAlert(kPasswordWarningText);
    } else {
        ADShowActivity(self.view);
        if (self.isUsedForBindApp) {
            [[ADNetworkEngine sharedEngine] wxBindAppForUin:[ADUserInfo currentUser].uin
                                                LoginTicket:[ADUserInfo currentUser].loginTicket
                                                       Mail: self.emailTextField.text
                                                   Password:[self.passwordTextField.text MD5]
                                                   NickName:[ADUserInfo currentUser].nickname
                                                        Sex:[ADUserInfo currentUser].sex
                                               HeadImageUrl:[ADUserInfo currentUser].headimgurl
                                                 IsToCreate:NO
                                             WithCompletion:^(ADWXBindAPPResp *resp) {
                                                 [self handleBindAppResponse:resp];
                                             }];
        } else {
            [[ADNetworkEngine sharedEngine] loginForMail:self.emailTextField.text
                                                Password:[self.passwordTextField.text MD5]
                                          WithCompletion:^(ADLoginResp *resp) {
                                              [self handleLoginResponse:resp];
                                          }];
        }
    }
}

- (void)onClickRegister:(UIButton *)sender {
    if (sender != self.registerButton)
        return;
    ADRegisterViewController *registerView = [[ADRegisterViewController alloc] init];
    registerView.isUsedForBindApp = self.isUsedForBindApp;
    [self.navigationController pushViewController:registerView
                                         animated:YES];
}

- (void)emailEditingFinished:(UITextField *)sender {
    if (sender != self.emailTextField)
        return;
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField becomeFirstResponder];
}

- (void)passwordEditingFinished:(UITextField *)sender {
    if (sender != self.passwordTextField)
        return;
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InputWithTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                                   forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0: //Email
            cell.descLabel.text = kEmailDescText;
            cell.textField.placeholder = kEmailWarningText;
            cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.textField.returnKeyType = UIReturnKeyNext;
            [cell.textField removeTarget:self
                                  action:@selector(emailEditingFinished:)
                        forControlEvents:UIControlEventEditingDidEndOnExit];
            [cell.textField addTarget:self
                               action:@selector(emailEditingFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
            cell.textField.text = @"zhimaikai@tencent.com";
            self.emailTextField = cell.textField;
            break;
        case 1: // Password
            cell.descLabel.text = kPswDescText;
            cell.textField.placeholder = kPasswordWarningText;
            cell.textField.secureTextEntry = YES;
            cell.textField.keyboardType = UIKeyboardTypeDefault;
            cell.textField.returnKeyType = UIReturnKeyDone;
            [cell.textField removeTarget:self
                                  action:@selector(passwordEditingFinished:)
                        forControlEvents:UIControlEventEditingDidEndOnExit];
            [cell.textField addTarget:self
                               action:@selector(passwordEditingFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
            cell.textField.text = @"123456";
            self.passwordTextField = cell.textField;
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kLoginTableCellHeight;
}

#pragma mark - Network Handlers
- (void)handleLoginResponse:(ADLoginResp *)resp {
    if (resp && resp.baseResp.errcode == ADErrorCodeNoError) {
        NSLog(@"Login Success");
        [ADUserInfo currentUser].uin = resp.uin;
        [ADUserInfo currentUser].loginTicket = resp.loginTicket;
        [ADUserInfo currentUser].mail = self.emailTextField.text;
        [ADUserInfo currentUser].pwdH1 = [self.passwordTextField.text MD5];
        [[ADNetworkEngine sharedEngine] checkLoginForUin:resp.uin
                                             LoginTicket:resp.loginTicket
                                          WithCompletion:^(ADCheckLoginResp *resp) {
                                              [self handleCheckLoginResponse:resp];
                                          }];
    } else {
        NSLog(@"Login Fail");
        ADHideActivity;
        NSString *errorTitle = [NSString errorTitleFromResponse:resp.baseResp
                                                   defaultError:kLoginFailText];
        ADShowErrorAlert(errorTitle);
    }
}

- (void)handleCheckLoginResponse:(ADCheckLoginResp *)resp {
    ADHideActivity;
    if (resp && resp.baseResp.errcode == ADErrorCodeNoError) {
        NSLog(@"Check Login Success");
        [ADUserInfo currentUser].sessionExpireTime = resp.expireTime;
        [[ADUserInfo currentUser] save];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSLog(@"Check Login Fail");
        NSString *errorTitle = [NSString errorTitleFromResponse:resp.baseResp
                                                   defaultError:kLoginFailText];
        ADShowErrorAlert(errorTitle);
    }
}

- (void)handleBindAppResponse:(ADWXBindAPPResp *)resp {
    if (resp && resp.baseResp.errcode == ADErrorCodeNoError) {
        NSLog(@"Bind App Success");
        [ADUserInfo currentUser].uin = resp.uin;
        [ADUserInfo currentUser].loginTicket = resp.loginTicket;
        [ADUserInfo currentUser].mail = self.emailTextField.text;
        [ADUserInfo currentUser].pwdH1 = [self.passwordTextField.text MD5];
        [[ADUserInfo currentUser] save];
        [[ADNetworkEngine sharedEngine] checkLoginForUin:resp.uin
                                             LoginTicket:resp.loginTicket
                                          WithCompletion:^(ADCheckLoginResp *resp) {
                                              [self handleCheckLoginResponse:resp];
                                          }];
    } else {
        NSLog(@"Bind App Fail");
        NSString *errorTitle = [NSString errorTitleFromResponse:resp.baseResp
                                                   defaultError:kBindErrorText];
        ADHideActivity;
        ADShowErrorAlert(errorTitle);
    }
}

#pragma mark - Lazy Initializer
- (UIButton *)backButton {
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.titleLabel.font = [UIFont fontWithName:kChineseFont
                                                      size:kBackButtonFontSize];
        
        [_backButton setTitleColor:[UIColor blackColor]
                          forState:UIControlStateNormal];
        [_backButton setTitle:kBackButtonTitle
                     forState:UIControlStateNormal];
        [_backButton addTarget:self
                        action:@selector(onClickCancle:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = kLoginViewTitle;
        _titleLabel.font = [UIFont fontWithName:kChineseFont
                                           size:kTitleLabelFontSize];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UITableView *)loginTable {
    if (_loginTable == nil) {
        _loginTable = [[UITableView alloc] initWithFrame:CGRectZero
                                                   style:UITableViewStylePlain];
        [_loginTable registerNib:[UINib nibWithNibName:@"InputWithTextFieldCell"
                                                bundle:nil] forCellReuseIdentifier:kCellIdentifier];
        _loginTable.scrollEnabled = NO;
        _loginTable.dataSource = self;
        _loginTable.delegate = self;
    }
    return _loginTable;
}

- (UIButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.backgroundColor = [UIColor loginButtonColor];
        _loginButton.layer.cornerRadius = kLoginButtonCornerRadius;
        [_loginButton setTitle:kLoginButtonText
                      forState:UIControlStateNormal];
        [_loginButton addTarget:self
                         action:@selector(onClickLogin:)
               forControlEvents:UIControlEventTouchUpInside];
        _loginButton.titleLabel.font = [UIFont fontWithName:kChineseFont
                                                       size:kLoginButtonFontSize];
    }
    return _loginButton;
}

- (UIButton *)registerButton {
    if (_registerButton == nil) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton setTitle:kRegisterButtonText
                         forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont fontWithName:kChineseFont
                                                          size:kBackButtonFontSize];
        [_registerButton setTitleColor:[UIColor linkButtonColor]
                              forState:UIControlStateNormal];
        [_registerButton addTarget:self
                            action:@selector(onClickRegister:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

- (UILabel *)registerTipsLabel {
    if (_registerTipsLabel == nil) {
        _registerTipsLabel = [[UILabel alloc] init];
        _registerTipsLabel.text = kRegisterTipsText;
        _registerTipsLabel.textColor = [UIColor grayColor];
        _registerTipsLabel.font = [UIFont fontWithName:kChineseFont
                                                  size:kBackButtonFontSize];
    }
    return _registerTipsLabel;
}
@end
