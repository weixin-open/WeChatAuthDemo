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
    
    UITextField *tfMail = [[UITextField alloc] initWithFrame:CGRectMake(xEle, 50, wEle, 40)];
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
    
    if (![[AppDelegate appDelegate].infoMgr isSubInfoExist:SUBINFO_WX_KEY]) {
        UITextField *tfNickName = [[UITextField alloc] initWithFrame:CGRectMake(xEle, 100, wEle, 40)];
        tfNickName.borderStyle = UITextBorderStyleRoundedRect;
        tfNickName.font = [UIFont systemFontOfSize:15];
        tfNickName.placeholder = NSLocalizedString(@"nickname", nil);
        tfNickName.keyboardType = UIKeyboardTypeDefault;
        tfNickName.returnKeyType = UIReturnKeyDone;
        tfNickName.clearButtonMode = UITextFieldViewModeWhileEditing;
        tfNickName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        tfNickName.delegate = self;
        [self.view addSubview:tfNickName];
        self.tfNickName = tfNickName;
        [tfNickName release];
    } else {
        [self.tfMail setFrame:CGRectMake(xEle, 100, wEle, 40)];
    }
    
    UITextField *tfPassword = [[UITextField alloc] initWithFrame:CGRectMake(xEle, 150, wEle, 40)];
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
    
    UITextField *tfConfirm = [[UITextField alloc] initWithFrame:CGRectMake(xEle, 200, wEle, 40)];
    tfConfirm.borderStyle = UITextBorderStyleRoundedRect;
    tfConfirm.font = [UIFont systemFontOfSize:15];
    tfConfirm.placeholder = NSLocalizedString(@"confirm password", nil);
    tfConfirm.keyboardType = UIKeyboardTypeDefault;
    tfConfirm.returnKeyType = UIReturnKeyDone;
    tfConfirm.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfConfirm.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tfConfirm.secureTextEntry = YES;
    tfConfirm.delegate = self;
    [self.view addSubview:tfConfirm];
    self.tfConfirm = tfConfirm;
    [tfConfirm release];
    
    UIButton *btnConfirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnConfirm setTitle:NSLocalizedString(@"confirm", nil) forState:UIControlStateNormal];
    btnConfirm.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnConfirm setFrame:CGRectMake(xEle, 250, wEle, 40)];
    [btnConfirm addTarget:self action:@selector(onClickBtnConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnConfirm];
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnCancel setTitle:NSLocalizedString(@"cancel", nil) forState:UIControlStateNormal];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnCancel setFrame:CGRectMake(xEle, h - 120, wEle, 80)];
    [btnCancel addTarget:self action:@selector(onClickBtnCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnCancel];
    
    UITapGestureRecognizer *tapGr = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)] autorelease];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.tfMail resignFirstResponder];
    if (self.tfNickName) {
        [self.tfNickName resignFirstResponder];
    }
    [self.tfPassword resignFirstResponder];
    [self.tfConfirm resignFirstResponder];
}

- (void)onClickBtnConfirm
{
    NSString* mail = [self.tfMail text];
    NSString* nickname = nil;
    if (self.tfNickName) {
        nickname = [self.tfNickName text];
    }
    [self.tfNickName text];
    NSString* password = [self.tfPassword text];
    NSString* confirm_pwd = [self.tfConfirm text];
    
    if ([mail isEqualToString:@""]) {
        [[AppDelegate appDelegate] presentAlert:@"mail cannot be empty"];
    } else if ([nickname isEqualToString:@""]) {
        [[AppDelegate appDelegate] presentAlert:@"nickname cannot be empty"];
    } else if ([password isEqualToString:@""]) {
        [[AppDelegate appDelegate] presentAlert:@"password cannot be empty"];
    } else if (![confirm_pwd isEqualToString:password]) {
        [[AppDelegate appDelegate] presentAlert:@"password confirm error"];
    } else {
        AppDelegate* app = [AppDelegate appDelegate];
        
        if ([app.infoMgr isSubInfoExist:SUBINFO_WX_KEY])
        {
            [[AppDelegate appDelegate].networkMgr wxBindNewApp:app.infoMgr.uid userticket:app.infoMgr.userTicket mail:mail password:password completionHandler:^(NSString *error, NSNumber *uid, NSString *userticket, NSString *nickname)
            {
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
        }
        else
        {
            [[AppDelegate appDelegate].networkMgr appRegAcct:mail password:password nickname:nickname completionHandler:^(NSString *error, NSNumber* uid, NSString *userticket)
            {
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
        }
        
    }
    
    // for haitian's servre
    /*
    if ( (![mail isEqualToString:@""]) && (![nickname isEqualToString:@""]) && (![password isEqualToString:@""]) && [confirm_pwd isEqualToString:password])
    {
        AppDelegate* app = [AppDelegate appDelegate];
        [[AppDelegate appDelegate].networkMgr appRegAcct:mail password:password nickname:nickname completionHandler:^(NSString *error, NSNumber* uid, NSString *userticket)
        {
            if (error) {
                NSLog(@"ERR:%@", error);
                [[AppDelegate appDelegate] presentAlert:error];
            } else {
                app.infoMgr.uid = uid;
                app.infoMgr.userTicket = userticket;
                [app.infoMgr setSubInfo:[NSDictionary dictionaryWithObjectsAndKeys:mail, @"mail", nickname, @"nickname", nil] forKey:SUBINFO_ACCT_KEY];
                
                if ([app.infoMgr isSubInfoExist:SUBINFO_WX_KEY])
                {
                    [[AppDelegate appDelegate].networkMgr wxBindApp:app.infoMgr.uid userticket:app.infoMgr.userTicket mail:mail password:password completionHandler:^(NSString *error, NSNumber *uid, NSString *userticket, NSString *nickname)
                     {
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
                    [[AppDelegate appDelegate] presentAcctView];
                }
            }
        }];
    } else {
        [[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(@"mail or password error", nil) delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }*/
}

- (void)onClickBtnCancel
{
    [[AppDelegate appDelegate] presentLoginView:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
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
