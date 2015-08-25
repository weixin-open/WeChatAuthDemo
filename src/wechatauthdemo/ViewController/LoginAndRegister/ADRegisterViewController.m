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
#import "ButtonColor.h"
#import "InputWithTextFieldCell.h"
#import "InputWithPickerBar.h"
#import "ADNetworkEngine.h"
#import "ADRegisterResp.h"
#import "ADCheckLoginResp.h"
#import "ADUserInfo.h"

/* Message Text */
static NSString *kBackButtonTitle = @"取消";
static NSString *kRegisterViewTitle = @"用户注册";
static NSString *kInputCellIdentifier = @"kInputCellIdentifierForRegister";
static NSString *kNormalCellIdentifier = @"kNormalCellIdentifierForRegister";
static NSString *kNameDescText = @"名称";
static NSString *kSexDescText = @"性别";
static NSString *kMailDescText = @"账户邮箱";
static NSString *kPswDescText = @"密码";
static NSString *kConfirmPswText = @"密码确认";
static NSString *kNameWarningText = @"用户名至多20个字符";
static NSString *kSexWarningText = @"请选择性别";
static NSString *kEmailWarningText = @"请输入有效邮箱账号";
static NSString *kPasswordWarningText = @"密码至少6位";
static NSString *kConfirmWarningText = @"两次密码应一致";
static NSString *kRegisterButtonText = @"注册";
static NSString *kRegisterProgressText = @"请稍候";
/* Font */
static const CGFloat kBackButtonFontSize = 13.0f;
static const CGFloat kRegisterButtonFontSize = 16.0f;
static const CGFloat kTitleLabelFontSize = 20.0f;
/* Size */
static const int kBackButtonWidth = 44;
static const int kBackButtonHeight = 44;
static const int kTitleLabelWidth = 150;
static const int kTitleLabelHeight = 44;
static const int kTableCellHeight = 49;
static const int kMaxNameLength = 20;
static const int kMinPswLength = 6;
static const int kPickerHeight = 168;

@interface ADRegisterViewController ()<UITableViewDataSource, UITableViewDelegate,
                                        UITextFieldDelegate,
                                        UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *registerTable;
@property (nonatomic, strong) UIPickerView *sexPickerView;
@property (nonatomic, strong) InputWithPickerBar *pickerBar;
@property (nonatomic, weak) UITextField *activeField;
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
    
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.registerTable];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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
    
    int registerTableHeight = ScreenHeight - CGRectGetMaxY(self.titleLabel.frame);
    int registerTableCenterY = CGRectGetMaxY(self.titleLabel.frame) + registerTableHeight/2;
    self.registerTable.frame = CGRectMake(0, 0, ScreenWidth-inset * 2, registerTableHeight);
    self.registerTable.center = CGPointMake(self.view.center.x, registerTableCenterY);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - User Actions
- (void)onClickCancle:(UIButton *)sender {
    if (sender != self.backButton)
        return;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nameEditingFinished:(UITextField *)sender {
    if (sender != self.nameTextField)
        return;
    [self.nameTextField resignFirstResponder];
    [self.sexTextField becomeFirstResponder];
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

#pragma mark - Notification: Moving Content That Is Located Under the Keyboard
// Called when the UIKeyboardDidShowNotification is sent.
// Taken from Apple's Document:
// https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/KeyboardManagement/KeyboardManagement.html#//apple_ref/doc/uid/TP40009542-CH5-SW7
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.registerTable.contentInset = contentInsets;
    self.registerTable.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.registerTable scrollRectToVisible:self.activeField.frame
                                       animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.registerTable.contentInset = contentInsets;
    self.registerTable.scrollIndicatorInsets = contentInsets;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowsArray[] = {5, 1};
    return rowsArray[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {   //Register Button
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNormalCellIdentifier
                                                                forIndexPath:indexPath];
        cell.backgroundColor = [UIColor loginButtonColor];
        cell.layer.cornerRadius = kLoginButtonCornerRadius;
        cell.textLabel.text = kRegisterButtonText;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:kTitleLabelFont
                                              size:kRegisterButtonFontSize];
        return cell;
    }
    
    InputWithTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:kInputCellIdentifier
                                                                   forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0: //NickName
            cell.descLabel.text = kNameDescText;
            cell.textField.placeholder = kNameWarningText;
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
            cell.descLabel.text = kSexDescText;
            cell.textField.placeholder = kSexWarningText;
            cell.textField.returnKeyType = UIReturnKeyNext;
            cell.textField.inputView = self.sexPickerView;
            cell.textField.inputAccessoryView = self.pickerBar;
            self.sexTextField = cell.textField;
            break;
        case 2: //Email
            cell.descLabel.text = kMailDescText;
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
            cell.descLabel.text = kPswDescText;
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
            cell.descLabel.text = kConfirmPswText;
            cell.textField.placeholder =kConfirmWarningText;
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
    cell.textField.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? kTableCellHeight : normalHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {  //Register Button
        if ([self.nameTextField.text length] > kMaxNameLength) {
            [SVProgressHUD showErrorWithStatus:kNameWarningText];
        } else if (![EmailFormatValidate isValidate:self.mailTextField.text]) {
            [SVProgressHUD showErrorWithStatus:kEmailWarningText];
        }else if ([self.pswTextField.text length] < kMinPswLength) {
            [SVProgressHUD showErrorWithStatus:kPasswordWarningText];
        } else if (![self.pswTextField.text isEqualToString:self.confirmPswTextField.text]) {
            [SVProgressHUD showErrorWithStatus:kConfirmWarningText];
        } else {
            [SVProgressHUD showWithStatus:kRegisterProgressText];
            [[ADNetworkEngine sharedEngine] registerForMail:self.mailTextField.text
                                                   Password:[self.pswTextField.text MD5]
                                                   NickName:self.nameTextField.text
                                                        Sex:[self.sexTextField.text isEqualToString:@"男"]?ADSexTypeMale:ADSexTypeFemale WithCompletion:^(ADRegisterResp *resp) {
                                                            [self handleRegisterResp:resp];
                                                        }];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.activeField = nil;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 2;
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *titleArray = @[@"男", @"女"];
    return titleArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *titleArray = @[@"男", @"女"];
    self.sexTextField.text = titleArray[row];
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
        [SVProgressHUD dismiss];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSLog(@"Check Login Fail");
        NSString *errorTitle = resp.baseResp.errmsg ? resp.baseResp.errmsg : @"登录失败";
        [SVProgressHUD showErrorWithStatus:errorTitle];
    }
}

#pragma mark - Lazy Initializers
- (UIButton *)backButton {
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.titleLabel.font = [UIFont fontWithName:kTitleLabelFont
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
        _titleLabel.text = kRegisterViewTitle;
        _titleLabel.font = [UIFont fontWithName:kTitleLabelFont
                                           size:kTitleLabelFontSize];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

- (UITableView *)registerTable {
    if (_registerTable == nil) {
        _registerTable = [[UITableView alloc] initWithFrame:CGRectZero
                                                      style:UITableViewStyleGrouped];
        [_registerTable registerNib:[UINib nibWithNibName:@"InputWithTextFieldCell"
                                                   bundle:nil] forCellReuseIdentifier:kInputCellIdentifier];
        [_registerTable registerClass:[UITableViewCell class]
               forCellReuseIdentifier:kNormalCellIdentifier];
        _registerTable.sectionHeaderHeight = _registerTable.sectionFooterHeight = inset;
        _registerTable.backgroundColor = [UIColor whiteColor];
        _registerTable.showsVerticalScrollIndicator = NO;
        _registerTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _registerTable.dataSource = self;
        _registerTable.delegate = self;
    }
    return _registerTable;
}

- (UIPickerView *)sexPickerView {
    if (_sexPickerView == nil) {
        _sexPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kPickerHeight)];
        _sexPickerView.showsSelectionIndicator = YES;
        _sexPickerView.backgroundColor = [UIColor whiteColor];
        _sexPickerView.delegate = self;
        _sexPickerView.dataSource = self;
    }
    return _sexPickerView;
}

- (InputWithPickerBar *)pickerBar {
    if (_pickerBar == nil) {
        _pickerBar = [[[NSBundle mainBundle] loadNibNamed:@"InputWithPickerBar" owner:nil options:nil] firstObject];
        __weak typeof (self) weakSelf = self;
        _pickerBar.onClickDoneCallBack = ^(id sneder) {
            weakSelf.sexTextField.text = [weakSelf.sexPickerView selectedRowInComponent:0] == 0 ? @"男" : @"女";
            [weakSelf.sexTextField resignFirstResponder];
            [weakSelf.mailTextField becomeFirstResponder];
        };
    }
    return _pickerBar;
}

@end