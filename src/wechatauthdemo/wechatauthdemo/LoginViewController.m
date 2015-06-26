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
    tfMail.placeholder = @"mail";
    tfMail.keyboardType = UIKeyboardTypeDefault;
    tfMail.returnKeyType = UIReturnKeyDone;
    tfMail.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfMail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:tfMail];
    self.tfMail = tfMail;
    [tfMail release];
    
    UITextField *tfPassword = [[UITextField alloc] initWithFrame:CGRectMake(xEle, 200, wEle, 40)];
    tfPassword.borderStyle = UITextBorderStyleRoundedRect;
    tfPassword.font = [UIFont systemFontOfSize:15];
    tfPassword.placeholder = @"password";
    tfPassword.keyboardType = UIKeyboardTypeDefault;
    tfPassword.returnKeyType = UIReturnKeyDone;
    tfPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:tfPassword];
    self.tfPassword = tfPassword;
    [tfPassword release];
    
    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnConfirm setTitle:@"Confirm" forState:UIControlStateNormal];
    btnConfirm.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnConfirm setFrame:CGRectMake(xEle, 260, wEle, 40)];
    [btnConfirm addTarget:self action:@selector(onClickBtnConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnConfirm];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnCancel setFrame:CGRectMake(xEle, h - 120, wEle, 80)];
    [btnCancel addTarget:self action:@selector(onClickBtnCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCancel];
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
                } else {
                    [app.infoMgr setSubInfo:[NSDictionary dictionaryWithObjectsAndKeys:mail, @"mail", nickname, @"nickname", nil] forKey:SUBINFO_ACCT_KEY];
                    [[AppDelegate appDelegate] presentAcctView];
                }
            }];
        } else {
            [app.networkMgr appLogin:mail password:password completionHandler:^(NSString *error, NSNumber* uid, NSString *userticket, NSString *nickname, BOOL hasBindWx) {
                if (error) {
                    NSLog(@"ERR:%@", error);
                } else {
                    [app.infoMgr setSubInfo:[NSDictionary dictionaryWithObjectsAndKeys:mail, @"mail", nickname, @"nickname", nil] forKey:SUBINFO_ACCT_KEY];
                    if (hasBindWx) {
                        [app.networkMgr getWxUserInfo:uid userticket:userticket realtime:TRUE
                                     completionHandler:^(NSString *error, NSNumber* uid, NSString* userticket, NSDictionary *info) {
                            if (error) {
                                NSLog(@"ERR:%@", error);
                            } else {
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
        // TODO: add alert, mail and password cannot be empty
    }
}

- (void)onClickBtnCancel
{
    [[AppDelegate appDelegate] presentHomeView];
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
