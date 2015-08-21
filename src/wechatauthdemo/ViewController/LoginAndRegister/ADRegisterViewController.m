//
//  ADRegisterViewController.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADRegisterViewController.h"
#import <SVProgressHUD.h>
#import "MD5.h"
#import "EmailFormatValidate.h"
#import "InputWithTextFieldCell.h"
#import "ADNetworkEngine.h"
#import "ADRegisterResp.h"
#import "ADCheckLoginResp.h"
#import "ADUserInfo.h"

static NSString *kCellIdentifier = @"cellIdentifierForRegister";
static NSString *kRegisterViewTitle = @"用户注册";
static NSString *kEmailWarningText = @"请输入有效邮箱";
static NSString *kPasswordWarningText = @"密码至少6位";

@interface ADRegisterViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *registerTable;
@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, weak) UITextField *nameTextField;
@property (nonatomic, weak) UITextField *sexTextField;
@property (nonatomic, weak) UITextField *mailTextField;
@property (nonatomic, weak) UITextField *pswTextField;
@property (nonatomic, weak) UITextField *confirmPswTextField;

@end

@implementation ADRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onClickCancle:)];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.registerTable];
    [self.view addSubview:self.registerButton];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    int titleLabelCenterY = navigationBarHeight + statusBarHeight + inset * 3;
    self.titleLabel.frame = CGRectMake(0, 0, 150, 44);
    self.titleLabel.center = CGPointMake(self.view.center.x, titleLabelCenterY);
    
    int loginTableCenterY = titleLabelCenterY + 150;
    self.registerTable.frame = CGRectMake(0, 0, ScreenWidth, 250);
    self.registerTable.center = CGPointMake(self.view.center.x, loginTableCenterY);
    
    int registerButtonCenterY = loginTableCenterY + 125 + inset * 6;
    self.registerButton.frame = CGRectMake(0, 0, 250, 44);
    self.registerButton.center = CGPointMake(self.view.center.x, registerButtonCenterY);
}

#pragma mark - User Actions
- (void)onClickCancle:(UIBarButtonItem *)sender {
    if (sender != self.navigationItem.leftBarButtonItem)
        return;
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onClickRegister:(UIButton *)sender {
    if (sender != self.registerButton)
        return;
    if ([self.nameTextField.text length] > 20) {
        [SVProgressHUD showErrorWithStatus:@"名字过长"];
    } else if (![EmailFormatValidate isValidate:self.mailTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"密码至少6位"];
    } else if (![self.pswTextField.text isEqualToString:self.confirmPswTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
    } else {
        [[ADNetworkEngine sharedEngine] registerForMail:self.mailTextField.text
                                               Password:[self.pswTextField.text MD5]
                                               NickName:self.nameTextField.text
                                                    Sex:[self.sexTextField.text isEqualToString:@"M"]?ADSexTypeMale:ADSexTypeFemale WithCompletion:^(ADRegisterResp *resp) {
                                                        [self handleRegisterResp:resp];
                                                    }];
    }
}

- (void)nameEditingFinished:(UITextField *)sender {
    if (sender != self.nameTextField)
        return;
    [self.nameTextField resignFirstResponder];
    [self.sexTextField becomeFirstResponder];
}

- (void)sexEditingFinished:(UITextField *)sender {
    if (sender != self.sexTextField)
        return;
    [self.sexTextField resignFirstResponder];
    [self.pswTextField becomeFirstResponder];
}

- (void)emailEditingFinished:(UITextField *)sender {
    if (sender != self.mailTextField)
        return;
    [self.mailTextField resignFirstResponder];
    [self.pswTextField becomeFirstResponder];
}

- (void)passwordEditingFinished:(UITextField *)sender {
    if (sender != self.pswTextField)
        return;
    [self.pswTextField resignFirstResponder];
    [self.confirmPswTextField becomeFirstResponder];
}

- (void)confirmPswEditingFinished:(UITextField *)sender {
    if (sender != self.confirmPswTextField)
        return;
    [self.confirmPswTextField resignFirstResponder];
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InputWithTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                                   forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0: //NickName
            cell.descLabel.text = @"名称";
            cell.textField.placeholder = @"输入您的昵称";
            cell.textField.returnKeyType = UIReturnKeyNext;
            [cell.textField removeTarget:self
                                  action:@selector(nameEditingFinished:)
                        forControlEvents:UIControlEventEditingDidEndOnExit];
            [cell.textField addTarget:self
                               action:@selector(nameEditingFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
            self.nameTextField = cell.textField;
            break;
        case 1: //SexType
            cell.descLabel.text = @"性别";
            cell.textField.placeholder = @"输入您的性别";
            cell.textField.returnKeyType = UIReturnKeyNext;
            [cell.textField removeTarget:self
                                  action:@selector(sexEditingFinished:)
                        forControlEvents:UIControlEventEditingDidEndOnExit];
            [cell.textField addTarget:self
                               action:@selector(sexEditingFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
            self.sexTextField = cell.textField;
            break;
        case 2: //Email
            cell.descLabel.text = @"账户邮箱";
            cell.textField.placeholder = kEmailWarningText;
            cell.textField.returnKeyType = UIReturnKeyNext;
            cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
            [cell.textField removeTarget:self
                                  action:@selector(emailEditingFinished:)
                        forControlEvents:UIControlEventEditingDidEndOnExit];
            [cell.textField addTarget:self
                               action:@selector(emailEditingFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
            self.mailTextField = cell.textField;
            break;
        case 3: //Password
            cell.descLabel.text = @"密码";
            cell.textField.placeholder = kPasswordWarningText;
            cell.textField.returnKeyType = UIReturnKeyNext;
            cell.textField.secureTextEntry = YES;
            [cell.textField removeTarget:self
                                  action:@selector(passwordEditingFinished:)
                        forControlEvents:UIControlEventEditingDidEndOnExit];
            [cell.textField addTarget:self
                               action:@selector(passwordEditingFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
            self.pswTextField = cell.textField;
            break;
        case 4: //Confirm Password
            cell.descLabel.text = @"密码确认";
            cell.textField.placeholder = @"请再次输入密码";
            cell.textField.returnKeyType = UIReturnKeyDone;
            cell.textField.secureTextEntry = YES;
            [cell.textField removeTarget:self
                                  action:@selector(confirmPswEditingFinished:)
                        forControlEvents:UIControlEventEditingDidEndOnExit];
            [cell.textField addTarget:self
                               action:@selector(confirmPswEditingFinished:)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
            self.confirmPswTextField = cell.textField;
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 49;
}

#pragma mark - Network Handler
- (void)handleRegisterResp:(ADRegisterResp *)resp {
    if (resp && resp.loginTicket) {
        NSLog(@"Register Success");
        [ADUserInfo currentUser].uin = resp.uin;
        [ADUserInfo currentUser].loginTicket = resp.loginTicket;
        [[ADNetworkEngine sharedEngine] checkLoginForUin:resp.uin
                                             LoginTicket:resp.loginTicket
                                          WithCompletion:^(ADCheckLoginResp *resp) {
                                              [self handleCheckLoginResp:resp];
                                          }];
    } else {
        NSLog(@"Register Fail");
        NSString *errorTitle = resp.baseResp.errmsg ? resp.baseResp.errmsg : @"注册失败";
        [SVProgressHUD showErrorWithStatus:errorTitle];
    }
}

- (void)handleCheckLoginResp: (ADCheckLoginResp *)resp {
    if (resp && resp.sessionKey) {
        NSLog(@"Check Login Success");
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSLog(@"Check Login Fail");
        NSString *errorTitle = resp.baseResp.errmsg ? resp.baseResp.errmsg : @"登录失败";
        [SVProgressHUD showErrorWithStatus:errorTitle];
    }
}

#pragma mark - Lazy Initializers
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = kRegisterViewTitle;
        _titleLabel.font = [UIFont fontWithName:kTitleLabelFont
                                           size:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UITableView *)registerTable {
    if (_registerTable == nil) {
        _registerTable = [[UITableView alloc] initWithFrame:CGRectZero
                                                      style:UITableViewStylePlain];
        [_registerTable registerNib:[UINib nibWithNibName:@"InputWithTextFieldCell"
                                                   bundle:nil] forCellReuseIdentifier:kCellIdentifier];
        _registerTable.dataSource = self;
        _registerTable.delegate = self;
    }
    return _registerTable;
}

- (UIButton *)registerButton {
    if (_registerButton == nil) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton setTitle:@"注册"
                         forState:UIControlStateNormal];
        [_registerButton setBackgroundColor:[UIColor colorWithRed:0.04
                                                            green:0.73
                                                             blue:0.03
                                                            alpha:1.00]];
        _registerButton.titleLabel.font = [UIFont fontWithName:kTitleLabelFont
                                                          size:16];
        [_registerButton addTarget:self
                            action:@selector(onClickRegister:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

@end
