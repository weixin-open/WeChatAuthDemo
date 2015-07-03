//
//  LoginViewController.m
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)init {
    self = [super init];
    if (self) {
        _tfMail = nil;
        _tfPassword = nil;
    }
    return self;
}

- (void)dealloc
{
    [_tfMail release];
    [_tfPassword release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int w = [[UIScreen mainScreen] bounds].size.width;
    int h = [[UIScreen mainScreen] bounds].size.height;
    
    int wEle = 200;
    int xEle = (w - wEle)/2;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *tfMail = [[UITextField alloc] initWithFrame:CGRectMake(xEle, 140, wEle, 40)];
    tfMail.borderStyle = UITextBorderStyleRoundedRect;
    tfMail.font = [UIFont systemFontOfSize:15];
    tfMail.placeholder = NSLocalizedString(@"mail", nil);
    tfMail.keyboardType = UIKeyboardTypeDefault;
    tfMail.returnKeyType = UIReturnKeyDone;
    tfMail.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfMail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tfMail.keyboardType = UIKeyboardTypeEmailAddress;
    tfMail.delegate = self;
    [self.view addSubview:tfMail];
    self.tfMail = tfMail;
    [tfMail release];
    
    UITextField *tfPassword = [[UITextField alloc] initWithFrame:CGRectMake(xEle, 200, wEle, 40)];
    tfPassword.borderStyle = UITextBorderStyleRoundedRect;
    tfPassword.font = [UIFont systemFontOfSize:15];
    tfPassword.placeholder = NSLocalizedString(@"password", nil);
    tfPassword.keyboardType = UIKeyboardTypeDefault;
    tfPassword.returnKeyType = UIReturnKeyDone;
    tfPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tfPassword.secureTextEntry = YES;
    tfPassword.delegate = self;
    [self.view addSubview:tfPassword];
    self.tfPassword = tfPassword;
    [tfPassword release];
    
    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnConfirm setTitle:NSLocalizedString(@"login", nil) forState:UIControlStateNormal];
    btnConfirm.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnConfirm setFrame:CGRectMake(xEle, 260, wEle, 40)];
    [btnConfirm addTarget:self action:@selector(onClickBtnConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnConfirm];
    
    if (![[AppDelegate appDelegate].infoMgr isSubInfoExist:SUBINFO_WX_KEY]) {
        UIButton *btnReg = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnReg setTitle:NSLocalizedString(@"register", nil) forState:UIControlStateNormal];
        btnReg.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnReg setFrame:CGRectMake(xEle, h-100, wEle, 40)];
        [btnReg addTarget:self action:@selector(onClickBtnReg) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnReg];
        
        UIButton *btnAuth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnAuth setTitle:NSLocalizedString(@"wxlogin", nil) forState:UIControlStateNormal];
        btnAuth.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnAuth setFrame:CGRectMake(xEle, h-70, wEle, 40)];
        [btnAuth addTarget:self action:@selector(onClickBtnAuth) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnAuth];
    } else {
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnCancel setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
        btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnCancel setFrame:CGRectMake(xEle, h - 120, wEle, 80)];
        [btnCancel addTarget:self action:@selector(onClickBtnCancel) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnCancel];
    }
    
    UITapGestureRecognizer *tapGr = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)] autorelease];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.tfMail resignFirstResponder];
    [self.tfPassword resignFirstResponder];
}

- (void)onClickBtnCancel
{
    [[AppDelegate appDelegate] presentAcctView];
}

- (void)onClickBtnConfirm
{
    NSString* mail = [self.tfMail text];
    NSString* password = [self.tfPassword text];
    if ( (![mail isEqualToString:@""]) && (![password isEqualToString:@""]) ) {
        AppDelegate* app = [AppDelegate appDelegate];
        if ([app.infoMgr isSubInfoExist:SUBINFO_WX_KEY]) {
            [app.networkMgr wxBindApp:app.infoMgr.uid userticket:app.infoMgr.userTicket mail:mail password:password completionHandler:^(NSString *error, NSNumber *uid, NSString *userticket, NSString *nickname) {
                if (error) {
                    NSLog(@"ERR:%@", error);
                    [[AppDelegate appDelegate] presentAlert:error];
                } else {
                    app.infoMgr.uid = uid;
                    app.infoMgr.userTicket = userticket;
                    [app.infoMgr setSubInfo:[NSDictionary dictionaryWithObjectsAndKeys:mail, @"mail", nickname, @"nickname", nil] forKey:SUBINFO_ACCT_KEY];
                    [[AppDelegate appDelegate] presentAcctView];
                }
            }];
        } else {
            [app.networkMgr appLogin:mail password:password completionHandler:^(NSString *error, NSNumber* uid, NSString *userticket, NSString *nickname, BOOL hasBindWx) {
                if (error) {
                    NSLog(@"ERR:%@", error);
                    [[AppDelegate appDelegate] presentAlert:error];
                } else {
                    app.infoMgr.uid = uid;
                    app.infoMgr.userTicket = userticket;
                    [app.infoMgr setSubInfo:[NSDictionary dictionaryWithObjectsAndKeys:mail, @"mail", nickname, @"nickname", nil] forKey:SUBINFO_ACCT_KEY];
                    if (hasBindWx) {
                        [app.networkMgr getWxUserInfo:uid userticket:userticket realtime:YES completionHandler:^(NSString *error, NSNumber* uid, NSString* userticket, NSDictionary *info) {
                            if (error) {
                                NSLog(@"ERR:%@", error);
                                [[AppDelegate appDelegate] presentAlert:error];
                            } else {
                                if (!info) {
                                    return;
                                }
                                [app.infoMgr setSubInfo:info forKey:SUBINFO_WX_KEY];
                                app.infoMgr.userTicket = userticket;
                                [app presentAcctView];
                            }
                        }];
                    } else {
                        [app presentAcctView];
                    }
                }
            }];
        }
        
    } else {
        [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"errmsg", nil) message:NSLocalizedString(@"mail and password cannot be empty", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil] autorelease] show];
    }
}

- (void)wxAuthSucceed:(NSString*)code
{
    AppDelegate* app = [AppDelegate appDelegate];
    [app.networkMgr wxLogin:code completionHandler:^(NSString* error, NSNumber* uid, NSString* userticket, NSString* nickname, BOOL hasBindApp) {
        if (error) {
            NSLog(@"ERR:%@", error);
            [[AppDelegate appDelegate] presentAlert:error];
        } else {
            app.infoMgr.uid = uid;
            app.infoMgr.userTicket = userticket;
            [app.networkMgr getWxUserInfo:uid userticket:userticket realtime:TRUE completionHandler:^(NSString *error, NSNumber* uid, NSString* userticket, NSDictionary *info) {
                if (error) {
                    NSLog(@"ERR:%@", error);
                    [[AppDelegate appDelegate] presentAlert:error];
                } else {
                    if (!info) {
                        return;
                    }
                    [app.infoMgr setSubInfo:info forKey:SUBINFO_WX_KEY];
                    app.infoMgr.userTicket = userticket;
                    if (hasBindApp) {
                        [app.networkMgr getAppUserInfo:uid userticket:userticket realtime:TRUE completionHandler:^(NSString *error, NSNumber* uid, NSString* userticket, NSDictionary *info) {
                            if (error) {
                                NSLog(@"ERR:%@", error);
                                [[AppDelegate appDelegate] presentAlert:error];
                            } else {
                                if (!info) {
                                    return;
                                }
                                [app.infoMgr setSubInfo:info forKey:SUBINFO_ACCT_KEY];
                                app.infoMgr.userTicket = userticket;
                                [app presentAcctView];
                            }
                            
                        }];
                    } else {
                        [app presentAcctView];
                    }
                }
            }];
        }
    }];
}

- (void)wxAuthDenied
{
    
}

- (void)wxAuthCancel
{
    
}

- (void)onClickBtnReg
{
    [[AppDelegate appDelegate] presentRegView];
}

- (void)onClickBtnAuth
{
    [[AppDelegate appDelegate].wxAuthMgr sendAuthRequestWithController:self delegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
