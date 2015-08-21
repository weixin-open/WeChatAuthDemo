//
//  ADLoginViewController.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <SVProgressHUD.h>
#import "EmailFormatValidate.h"
#import "MD5.h"
#import "InputWithTextFieldCell.h"
#import "ADLoginViewController.h"
#import "ADRegisterViewController.h"
#import "ADNetworkEngine.h"
#import "ADLoginResp.h"
#import "ADUserInfo.h"
#import "ADCheckLoginResp.h"

static NSString *kCancleButtonTitle = @"取消";
static NSString *kLoginViewTitle = @"请输入账号密码";
static NSString *kEmailTextFieldPlaceHolder = @"请输入有效邮箱";
static NSString *kPwdTextFieldPlaceHolder = @"至少6位数";

static NSString *kEmailWarningText = @"请输入有效邮箱";
static NSString *kPasswordWarningText = @"密码至少6位";
static NSString *kLoginProgressText = @"登录中...";
static NSString *kLoginSuccText = @"登录成功";
static NSString *kLoginFailText = @"登录失败";

static NSString *kCellIdentifier = @"cellIdentifierForLogin";

static const int kLoginButtonWidth = 250;
static const int kLoginButtonHeight = 44;
static const int kPasswordMinLength = 6;

@interface ADLoginViewController ()<UITableViewDataSource, UITableViewDelegate>

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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kCancleButtonTitle
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onClickCancle:)];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.loginTable];
    
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registerTipsLabel];
    [self.view addSubview:self.registerButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    int titleLabelCenterY = navigationBarHeight + statusBarHeight + inset * 3;
    self.titleLabel.frame = CGRectMake(0, 0, 150, 44);
    self.titleLabel.center = CGPointMake(self.view.center.x, titleLabelCenterY);
    
    int loginTableCenterY = titleLabelCenterY + 100;
    self.loginTable.frame = CGRectMake(0, 0, ScreenWidth, 100);
    self.loginTable.center = CGPointMake(self.view.center.x, loginTableCenterY);
    
    int loginButtonCenterY = self.view.center.y + kLoginButtonHeight;
    self.loginButton.frame = CGRectMake(0, 0, kLoginButtonWidth, kLoginButtonHeight);
    self.loginButton.center = CGPointMake(self.view.center.x, loginButtonCenterY);
    
    int registerTipsCenterY = loginButtonCenterY + kLoginButtonHeight + inset * 2;
    self.registerTipsLabel.frame = CGRectMake(0, 0, 80, 44);
    self.registerTipsLabel.center = CGPointMake(self.view.center.x-(80/2), registerTipsCenterY);
    
    int registerBtnCenterX = self.registerTipsLabel.center.x + (80+70)/2;
    self.registerButton.frame = CGRectMake(0, 0, 70, 44);
    self.registerButton.center = CGPointMake(registerBtnCenterX, registerTipsCenterY);
}

#pragma mark - User Actions
- (void)onClickCancle:(UIBarButtonItem *)sender {
    if (sender != self.navigationItem.leftBarButtonItem)
        return;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickLogin:(UIButton *)sender {
    if (sender != self.loginButton)
        return;
    
    if (![EmailFormatValidate isValidate:self.emailTextField.text]) {
        [SVProgressHUD showErrorWithStatus:kEmailWarningText];
    } else if ([self.passwordTextField.text length] < kPasswordMinLength) {
        [SVProgressHUD showErrorWithStatus:kPasswordWarningText];
    } else {
        [SVProgressHUD showWithStatus:kLoginProgressText];
        [[ADNetworkEngine sharedEngine] loginForMail:self.emailTextField.text
                                            Password:[self.passwordTextField.text MD5]
                                      WithCompletion:^(ADLoginResp *resp) {
                                          [self handleLoginResponse:resp];
                                      }];
    }
}

- (void)onClickRegister:(UIButton *)sender {
    if (sender != self.registerButton)
        return;
    ADRegisterViewController *registerView = [[ADRegisterViewController alloc] init];
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
            cell.descLabel.text = @"账户邮箱";
            cell.textField.placeholder = kEmailTextFieldPlaceHolder;
            cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            cell.textField.returnKeyType = UIReturnKeyNext;
            [cell.textField removeTarget:self
                                  action:@selector(emailEditingFinished:)
                        forControlEvents:UIControlEventEditingDidEndOnExit];
            [cell.textField addTarget:self
                               action:@selector(emailEditingFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
            self.emailTextField = cell.textField;
            break;
        case 1:
            cell.descLabel.text = @"密码";
            cell.textField.placeholder = kPwdTextFieldPlaceHolder;
            cell.textField.secureTextEntry = YES;
            cell.textField.returnKeyType = UIReturnKeyDone;
            [cell.textField removeTarget:self
                                  action:@selector(passwordEditingFinished:)
                        forControlEvents:UIControlEventEditingDidEndOnExit];
            [cell.textField addTarget:self
                               action:@selector(passwordEditingFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
            self.passwordTextField = cell.textField;
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

#pragma mark - Network Handlers
- (void)handleLoginResponse:(ADLoginResp *)resp {
    if (resp && resp.loginTicket) {
        NSLog(@"Login Success");
        [SVProgressHUD dismiss];
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
        NSString *errorTitle = resp.baseResp.errmsg ? resp.baseResp.errmsg : kLoginFailText;
        [SVProgressHUD showErrorWithStatus:errorTitle];
    }
}

- (void)handleCheckLoginResponse:(ADCheckLoginResp *)resp {
    if (resp && resp.sessionKey) {
        NSLog(@"Check Login Success");
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSLog(@"Check Login Fail");
        NSString *errorTitle = resp.baseResp.errmsg ? resp.baseResp.errmsg : kLoginFailText;
        [SVProgressHUD showErrorWithStatus:errorTitle];
    }
}

#pragma mark - Lazy Initializers
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = kLoginViewTitle;
        _titleLabel.font = [UIFont fontWithName:kTitleLabelFont
                                           size:20];
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
        _loginTable.dataSource = self;
        _loginTable.delegate = self;
    }
    return _loginTable;
}

- (UIButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.backgroundColor = [UIColor colorWithRed:0.04
                                                       green:0.73
                                                        blue:0.03
                                                       alpha:1.00];
        [_loginButton setTitle:@"登录"
                      forState:UIControlStateNormal];
        [_loginButton addTarget:self
                         action:@selector(onClickLogin:)
               forControlEvents:UIControlEventTouchUpInside];
        _loginButton.titleLabel.font = [UIFont fontWithName:kTitleLabelFont
                                                       size:16];
    }
    return _loginButton;
}

- (UIButton *)registerButton {
    if (_registerButton == nil) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton setTitle:@"注册账号"
                         forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont fontWithName:kTitleLabelFont
                                                          size:12];
        [_registerButton setTitleColor:[UIColor colorWithRed:0.27
                                                       green:0.60
                                                        blue:0.91
                                                       alpha:1.00]
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
        _registerTipsLabel.text = @"还没有账号？";
        _registerTipsLabel.textColor = [UIColor grayColor];
        _registerTipsLabel.font = [UIFont fontWithName:kTitleLabelFont
                                                  size:12];
    }
    return _registerTipsLabel;
}

@end
