//
//  RegViewController.m
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import "RegViewController.h"
#import "AppDelegate.h"

@interface RegViewController ()

@end

@implementation RegViewController

- (id)init {
    self = [super init];
    if (self) {
        _tfMail = nil;
        _tfNickName = nil;
        _tfPassword = nil;
        _tfConfirm = nil;
    }
    return self;
}

- (void)dealloc
{
    [_tfMail release];
    [_tfNickName release];
    [_tfPassword release];
    [_tfConfirm release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int w = [[UIScreen mainScreen] bounds].size.width;
    int h = [[UIScreen mainScreen] bounds].size.height;
    
    int wEle = 200;
    int xEle = (w - wEle)/2;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *tfMail = [[UITextField alloc] initWithFrame:CGRectMake(xEle, 120, wEle, 40)];
    tfMail.borderStyle = UITextBorderStyleRoundedRect;
    tfMail.font = [UIFont systemFontOfSize:15];
    tfMail.placeholder = @"mail address";
    tfMail.keyboardType = UIKeyboardTypeDefault;
    tfMail.returnKeyType = UIReturnKeyDone;
    tfMail.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfMail.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:tfMail];
    self.tfMail = tfMail;
    [tfMail release];
    
    UITextField *tfNickName = [[UITextField alloc] initWithFrame:CGRectMake(xEle, 180, wEle, 40)];
    tfNickName.borderStyle = UITextBorderStyleRoundedRect;
    tfNickName.font = [UIFont systemFontOfSize:15];
    tfNickName.placeholder = @"nickname";
    tfNickName.keyboardType = UIKeyboardTypeDefault;
    tfNickName.returnKeyType = UIReturnKeyDone;
    tfNickName.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfNickName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:tfNickName];
    self.tfNickName = tfNickName;
    [tfNickName release];
    
    UITextField *tfPassword = [[UITextField alloc] initWithFrame:CGRectMake(xEle, 240, wEle, 40)];
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
    
    UITextField *tfConfirm = [[UITextField alloc] initWithFrame:CGRectMake(xEle, 300, wEle, 40)];
    tfConfirm.borderStyle = UITextBorderStyleRoundedRect;
    tfConfirm.font = [UIFont systemFontOfSize:15];
    tfConfirm.placeholder = @"confirm password";
    tfConfirm.keyboardType = UIKeyboardTypeDefault;
    tfConfirm.returnKeyType = UIReturnKeyDone;
    tfConfirm.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfConfirm.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:tfConfirm];
    self.tfConfirm = tfConfirm;
    [tfConfirm release];
    
    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnConfirm setTitle:@"Confirm" forState:UIControlStateNormal];
    btnConfirm.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnConfirm setFrame:CGRectMake(xEle, 360, wEle, 40)];
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
    NSString* nickname = [self.tfNickName text];
    NSString* password = [self.tfPassword text];
    NSString* confirm_pwd = [self.tfConfirm text];
    
    if ( (![mail isEqualToString:@""]) && (![nickname isEqualToString:@""]) && (![password isEqualToString:@""]) && [confirm_pwd isEqualToString:password])
    {
        AppDelegate* app = [AppDelegate appDelegate];
        
        [[AppDelegate appDelegate].networkMgr appRegAcct:mail password:password nickname:nickname completionHandler:^(NSString *error, NSNumber* uid, NSString *userticket) {
            if (error) {
                NSLog(@"ERR:%@", error);
            } else {
                [app.infoMgr setSubInfo:[NSDictionary dictionaryWithObjectsAndKeys:mail, @"mail", nickname, @"nickname", nil] forKey:SUBINFO_ACCT_KEY];
                if ([app.infoMgr isSubInfoExist:SUBINFO_WX_KEY]) {
                    [app.networkMgr wxBindApp:app.infoMgr.uid userticket:app.infoMgr.userTicket mail:mail password:password completionHandler:^(NSString *error, NSNumber *uid, NSString *userticket, NSString *nickname) {
                        if (error) {
                            NSLog(@"ERR:%@", error);
                        } else {
                            [[AppDelegate appDelegate] presentAcctView];
                        }
                    }];
                } else {
                    [[AppDelegate appDelegate] presentAcctView];
                }
            }
        }];
        
    } else {
        // TODO: add alert, mail and password cannot be empty
    }
    
    if ( (![mail isEqualToString:@""]) && (![nickname isEqualToString:@""]) && (![password isEqualToString:@""])
            && [confirm_pwd isEqualToString:password]) {
        
    }
}

- (void)onClickBtnCancel
{
    [[AppDelegate appDelegate] presentHomeView];
}

- (void)didReceiveMemoryWarning {
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
