//
//  ADRegisterViewController.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADRegisterViewController.h"
#import "MD5.h"
#import "EmailFormatValidate.h"
#import "InputWithTextFieldCell.h"
#import "InputWithPickerBar.h"
#import "RegisterHeaderView.h"
#import "ADNetworkEngine.h"
#import "ADRegisterResp.h"
#import "ADCheckLoginResp.h"
#import "ADWXBindAPPResp.h"
#import "ADUserInfo.h"

/* Message Text */
static NSString* const kBackButtonTitle = @"取消";
static NSString* const kInputCellIdentifier = @"kInputCellIdentifierForRegister";
static NSString* const kNormalCellIdentifier = @"kNormalCellIdentifierForRegister";
static NSString* const kNameDescText = @"名称";
static NSString* const kSexDescText = @"性别";
static NSString* const kMailDescText = @"账户邮箱";
static NSString* const kPswDescText = @"密码";
static NSString* const kConfirmPswText = @"密码确认";
static NSString* const kNameWarningText = @"用户名至多20个字符";
static NSString* const kNameEmptyWarningText = @"用户名不能为空";
static NSString* const kSexWarningText = @"请选择性别";
static NSString* const kEmailWarningText = @"请输入有效邮箱账号";
static NSString* const kPasswordWarningText = @"密码至少6位";
static NSString* const kConfirmWarningText = @"两次密码应一致";
static NSString* const kRegisterButtonText = @"注册";
static NSString* const kRegisterProgressText = @"请稍候";
static NSString* const kRegisterFailText = @"注册失败";
static NSString* const kLoginFailText = @"登录失败";
static NSString* const kBindingFailText = @"绑定失败";
static NSString* const kSexTypeMaleText = @"男";
static NSString* const kSexTypeFemaleText = @"女";
/* Font */
static const CGFloat kBackButtonFontSize = 13.0f;
static const CGFloat kRegisterButtonFontSize = 16.0f;
/* Size */
static const int kBackButtonWidth = 44;
static const int kBackButtonHeight = 44;
static const int kTableCellHeight = 49;
static const int kMaxNameLength = 20;
static const int kMinPswLength = 6;
static const int kPickerHeight = 168;

@interface ADRegisterViewController ()<UITableViewDataSource, UITableViewDelegate,
                                        UITextFieldDelegate, UIActionSheetDelegate,
                                        UIPickerViewDelegate, UIPickerViewDataSource,
                    UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) RegisterHeaderView *header;
@property (nonatomic, strong) UITableView *registerTable;
@property (nonatomic, strong) UIPickerView *sexPickerView;
@property (nonatomic, strong) InputWithPickerBar *pickerBar;
@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, weak) UITextField *activeField;
@property (nonatomic, weak) UITextField *nameTextField;
@property (nonatomic, weak) UITextField *sexTextField;
@property (nonatomic, weak) UITextField *mailTextField;
@property (nonatomic, weak) UITextField *pswTextField;
@property (nonatomic, weak) UITextField *confirmPswTextField;
@property (nonatomic, strong) UIImage *headImage;

@end

@implementation ADRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.registerTable];
    [self.view addSubview:self.registerButton];
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
    
    int registerTableHeight = ScreenHeight - CGRectGetMaxY(self.backButton.frame) - normalHeight - 2 * inset;
    int registerTableCenterY = CGRectGetMaxY(self.backButton.frame) + registerTableHeight/2;
    self.registerTable.frame = CGRectMake(0, 0, ScreenWidth - inset*3, registerTableHeight);
    self.registerTable.center = CGPointMake(self.view.center.x-0.5*inset, registerTableCenterY);
    
    int registerButtonCenterY = CGRectGetMaxY(self.registerTable.frame);
    self.registerButton.frame = CGRectMake(0, 0, ScreenWidth - inset * 4.5, normalHeight);
    self.registerButton.center = CGPointMake(self.view.center.x + 0.5 * inset, registerButtonCenterY);
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

- (void)onClickRegister:(UIButton *)sender {
    if (sender != self.registerButton)
        return;
    
    if ([self.nameTextField.text length] == 0) {
        ADShowErrorAlert(kNameEmptyWarningText);
    } else if ([self.nameTextField.text length] > kMaxNameLength) {
        ADShowErrorAlert(kNameWarningText);
    } else if (![EmailFormatValidate isValidate:self.mailTextField.text]) {
        ADShowErrorAlert(kEmailWarningText);
    }else if ([self.pswTextField.text length] < kMinPswLength) {
        ADShowErrorAlert(kPasswordWarningText);
    } else if (![self.pswTextField.text isEqualToString:self.confirmPswTextField.text]) {
        ADShowErrorAlert(kConfirmWarningText);
    } else {
        ADShowActivity(self.view);
        ADSexType sex = [self.sexTextField.text isEqualToString:kSexTypeMaleText] ? ADSexTypeMale : ADSexTypeFemale;
        if (self.isUsedForBindApp) {
            [[ADNetworkEngine sharedEngine] wxBindAppForUin:[ADUserInfo currentUser].uin
                                                LoginTicket:[ADUserInfo currentUser].loginTicket
                                                       Mail:self.mailTextField.text
                                                   Password:[self.pswTextField.text MD5]
                                                   NickName:self.nameTextField.text
                                                        Sex:sex
                                               HeadImageUrl:[ADUserInfo currentUser].headimgurl
                                                 IsToCreate:YES
                                             WithCompletion:^(ADWXBindAPPResp *resp) {
                                                 [self handleBindAppResp:resp];
                                             }];
        } else {
            [[ADNetworkEngine sharedEngine] registerForMail:self.mailTextField.text
                                                   Password:[self.pswTextField.text MD5]
                                                   NickName:self.nameTextField.text
                                                  HeadImage:UIImageJPEGRepresentation(self.headImage, 0.7)
                                                        Sex:sex
                                             WithCompletion:^(ADRegisterResp *resp) {
                                                 [self handleRegisterResp:resp];
                                             }];
        }
    }
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

#pragma mark - Notification
// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.registerTable.contentInset = contentInsets;
    self.registerTable.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;   //NickName,SexType,Email,Password,Confirm Password
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    return kTableCellHeight;
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

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    switch (buttonIndex) {
        case 0: //拍照上传
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            break;
        case 1: //从相册选择
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        default:
            break;
    }
    picker.allowsEditing = YES;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.headImage = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.header.headImageButton setImage:self.headImage forState:UIControlStateNormal];
    self.header.cameraImage.hidden = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
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
                                              [self handleCheckLoginResponse:resp];
                                          }];
    } else {
        NSLog(@"Register Fail");
        NSString *errorTitle = [NSString errorTitleFromResponse:resp.baseResp
                                                   defaultError:kRegisterFailText];
        ADShowErrorAlert(errorTitle);
    }
}

- (void)handleCheckLoginResponse:(ADCheckLoginResp *)resp {
    ADHideActivity;
    if (resp && resp.sessionKey) {
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

- (void)handleBindAppResp:(ADWXBindAPPResp *)resp {
    ADHideActivity;
    if (resp && resp.loginTicket) {
        NSLog(@"BindApp Success");
        [ADUserInfo currentUser].uin = resp.uin;
        [ADUserInfo currentUser].loginTicket = resp.loginTicket;
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSLog(@"BindApp Fail");
        NSString *errorTitle = [NSString errorTitleFromResponse:resp.baseResp
                                                   defaultError:kBindingFailText];
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

- (RegisterHeaderView *)header {
    if (_header == nil) {
        _header = [[[NSBundle mainBundle] loadNibNamed:@"RegisterHeaderView"
                                                owner:nil
                                              options:nil] firstObject];
        __weak typeof(self) weakSelf = self;
        _header.headImageCallBack = ^(UIButton *sender) {
            [[[UIActionSheet alloc] initWithTitle:nil
                                        delegate:weakSelf
                               cancelButtonTitle:@"取消"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"拍照上传",@"从相册中选择", nil] showInView:weakSelf.view];
        };
    }
    return _header;
}

- (UITableView *)registerTable {
    if (_registerTable == nil) {
        _registerTable = [[UITableView alloc] initWithFrame:CGRectZero
                                                      style:UITableViewStylePlain];
        [_registerTable registerNib:[UINib nibWithNibName:@"InputWithTextFieldCell"
                                                   bundle:nil] forCellReuseIdentifier:kInputCellIdentifier];
        [_registerTable registerClass:[UITableViewCell class]
               forCellReuseIdentifier:kNormalCellIdentifier];
        _registerTable.sectionHeaderHeight = _registerTable.sectionFooterHeight = inset;
        _registerTable.backgroundColor = [UIColor whiteColor];
        _registerTable.showsVerticalScrollIndicator = NO;
        _registerTable.tableHeaderView = self.header;
        _registerTable.dataSource = self;
        _registerTable.delegate = self;
        _registerTable.tableFooterView = [[UIView alloc] init];
        _registerTable.tableFooterView.backgroundColor = [UIColor clearColor];
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
        __weak typeof(self) weakSelf = self;
        _pickerBar.onClickDoneCallBack = ^(id sneder) {
            weakSelf.sexTextField.text = [weakSelf.sexPickerView selectedRowInComponent:0] == 0 ? @"男" : @"女";
            [weakSelf.sexTextField resignFirstResponder];
            [weakSelf.mailTextField becomeFirstResponder];
        };
    }
    return _pickerBar;
}

- (UIImage *)headImage {
    if (_headImage == nil) {
        _headImage = [UIImage imageNamed:@"wxLogoGreen"];
    }
    return _headImage;
}

- (UIButton *)registerButton {
    if (_registerButton == nil) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.titleLabel.font = [UIFont fontWithName:kChineseFont
                                                          size:kRegisterButtonFontSize];
        _registerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_registerButton setBackgroundColor:[UIColor loginButtonColor]];
        [_registerButton setTitleColor:[UIColor whiteColor]
                              forState:UIControlStateNormal];
        [_registerButton setTitle:kRegisterButtonText
                         forState:UIControlStateNormal];
        [_registerButton addTarget:self
                            action:@selector(onClickRegister:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

@end