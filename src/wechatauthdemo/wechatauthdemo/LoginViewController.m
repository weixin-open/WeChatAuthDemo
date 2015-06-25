//
//  LoginViewController.m
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int width = [[UIScreen mainScreen] bounds].size.width;
    int height = [[UIScreen mainScreen] bounds].size.height;
    
    int ele_width = 200;
    int ele_x = (width - ele_width)/2;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *tf_username = [[UITextField alloc] initWithFrame:CGRectMake(ele_x, 140, ele_width, 40)];
    tf_username.borderStyle = UITextBorderStyleRoundedRect;
    tf_username.font = [UIFont systemFontOfSize:15];
    tf_username.placeholder = @"username";
    tf_username.keyboardType = UIKeyboardTypeDefault;
    tf_username.returnKeyType = UIReturnKeyDone;
    tf_username.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf_username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:tf_username];
    self.tf_username = tf_username;
    [tf_username release];
    
    UITextField *tf_password = [[UITextField alloc] initWithFrame:CGRectMake(ele_x, 200, ele_width, 40)];
    tf_password.borderStyle = UITextBorderStyleRoundedRect;
    tf_password.font = [UIFont systemFontOfSize:15];
    tf_password.placeholder = @"password";
    tf_password.keyboardType = UIKeyboardTypeDefault;
    tf_password.returnKeyType = UIReturnKeyDone;
    tf_password.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf_password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:tf_password];
    self.tf_password = tf_password;
    [tf_password release];
    
    UIButton *btn_confirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_confirm setTitle:@"Confirm" forState:UIControlStateNormal];
    btn_confirm.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_confirm setFrame:CGRectMake(ele_x, 260, ele_width, 40)];
    [btn_confirm addTarget:self action:@selector(onClickBtnConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_confirm];
    [btn_confirm release];
    
    UIButton *btn_cancel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    btn_cancel.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_cancel setFrame:CGRectMake(ele_x, height - 120, ele_width, 80)];
    [btn_cancel addTarget:self action:@selector(onClickBtnCancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_cancel];
    [btn_cancel release];
    
}

- (void) loginAcct:(NSString*)username byPwd:(NSString*)password
{
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://urltoserver?username=%@&password=%@", username, password] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            [self loginError:connectionError];
        } else {
            [self loginDone:data];
        }
    }];
}

- (void)loginError:(NSError*)error
{
    NSLog(@"ERR:%@", error);
}

- (void)loginDone:(NSData*)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"ACCT_INFO:%@", str);
    // TODO: jump to account view
    [self.delegate presentAcctView];
}

- (void)onClickBtnCancel
{
    [self.delegate presentHomeView];
}

- (void)onClickBtnConfirm
{
    NSString* username = [self.tf_username text];
    NSString* password = [self.tf_password text];
    if ( (![username isEqualToString:@""]) && (![password isEqualToString:@""]) ) {
        [self loginAcct:username byPwd:password];
    } else {
        // TODO: add alert, username and password cannot be empty
    }
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
