//
//  RegViewController.m
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import "RegViewController.h"

@interface RegViewController ()

@end

@implementation RegViewController

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
    
    UITextField *tf_confirm = [[UITextField alloc] initWithFrame:CGRectMake(ele_x, 260, ele_width, 40)];
    tf_confirm.borderStyle = UITextBorderStyleRoundedRect;
    tf_confirm.font = [UIFont systemFontOfSize:15];
    tf_confirm.placeholder = @"confirm password";
    tf_confirm.keyboardType = UIKeyboardTypeDefault;
    tf_confirm.returnKeyType = UIReturnKeyDone;
    tf_confirm.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf_confirm.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:tf_confirm];
    self.tf_confirm = tf_confirm;
    [tf_confirm release];
    
    UIButton *btn_confirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_confirm setTitle:@"Confirm" forState:UIControlStateNormal];
    btn_confirm.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_confirm setFrame:CGRectMake(ele_x, 320, ele_width, 40)];
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

- (void)regAcct:(NSString*)username withPwd:(NSString*)password
{
    NSDictionary *jsonObject = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:nil];
    // NSData *postData = [[NSString stringWithFormat:@"username=%@&password=%@", username, password] dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSURL *url = [NSURL URLWithString:[@"https://urltoserver" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            [self regError:connectionError];
        } else {
            [self regDone:data];
        }
    }];
}

- (void)regError:(NSError*)error
{
    NSLog(@"ERR:%@", error);
}

- (void)regDone:(NSData*)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"ACCT_INFO:%@", str);
    // TODO: jump to account view
    [self.delegate presentAcctView];
}

- (void)onClickBtnConfirm
{
    NSString* username = [self.tf_username text];
    NSString* password = [self.tf_password text];
    NSString* confirm_pwd = [self.tf_confirm text];
    if ( (![username isEqualToString:@""]) && (![password isEqualToString:@""])
            && [confirm_pwd isEqualToString:password]) {
        [self regAcct:username withPwd:password];
    }
}

- (void)onClickBtnCancel
{
    [self.delegate presentHomeView];
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
