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
        _tfUserName = nil;
        _tfPassword = nil;
    }
    return self;
}

- (void)dealloc
{
    [_tfUserName release];
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
    
    UITextField *tfUserName = [[UITextField alloc] initWithFrame:CGRectMake(xEle, 140, wEle, 40)];
    tfUserName.borderStyle = UITextBorderStyleRoundedRect;
    tfUserName.font = [UIFont systemFontOfSize:15];
    tfUserName.placeholder = @"username";
    tfUserName.keyboardType = UIKeyboardTypeDefault;
    tfUserName.returnKeyType = UIReturnKeyDone;
    tfUserName.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfUserName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:tfUserName];
    self.tfUserName = tfUserName;
    [tfUserName release];
    
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
    NSString* username = [self.tfUserName text];
    NSString* password = [self.tfPassword text];
    if ( (![username isEqualToString:@""]) && (![password isEqualToString:@""]) ) {
        [[AppDelegate appDelegate].networkMgr loginAcct:username byPwd:password completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data == nil) {
                NSLog(@"ERR:%@", connectionError);
            } else {
                NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"ACCT_INFO:%@", str);
                [str release];
                // TODO: save account info
                [[AppDelegate appDelegate] presentAcctView];
            }
        }];
    } else {
        // TODO: add alert, username and password cannot be empty
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
