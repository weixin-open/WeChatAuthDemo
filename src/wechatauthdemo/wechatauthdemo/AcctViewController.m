//
//  AcctViewController.m
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import "AcctViewController.h"

@interface AcctViewController ()

@end

@implementation AcctViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int width = [[UIScreen mainScreen] bounds].size.width;
    int height = [[UIScreen mainScreen] bounds].size.height;
    
    int ele_width = 200;
    int ele_x = (width - ele_width)/2;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary* acctInfo = [[self.delegate getInfoManager] getSubInfo:SUBINFO_ACCT_KEY];
    NSDictionary* wechatInfo = [[self.delegate getInfoManager] getSubInfo:SUBINFO_WECHAT_KEY];
    
    UITextView *tv_info = [[UITextView alloc] initWithFrame:CGRectMake(30, 30, width-2*30, height-300)];
    tv_info.scrollEnabled = YES;
    tv_info.editable = NO;
    tv_info.font = [UIFont systemFontOfSize:15];
    
    NSMutableString *strBuf = [[[NSMutableString alloc] init] autorelease];
    if (acctInfo != nil) {
        [strBuf appendString:@"--------- ACCOUNT INFO ---------\n"];
        [strBuf appendFormat:@"%@\n", acctInfo];
    } else {
        UIButton *btn_login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn_login setTitle:@"Bind Existed Account" forState:UIControlStateNormal];
        btn_login.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn_login setFrame:CGRectMake(ele_x, height - 250, ele_width, 50)];
        [btn_login addTarget:self action:@selector(onClickBtnLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn_login];
        [btn_login release];
        
        UIButton *btn_reg = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn_reg setTitle:@"Bind New Account" forState:UIControlStateNormal];
        btn_reg.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn_reg setFrame:CGRectMake(ele_x, height - 200, ele_width, 50)];
        [btn_reg addTarget:self action:@selector(onClickBtnReg) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn_reg];
        [btn_reg release];
    }
    [strBuf appendString:@"\n"];
    
    if (wechatInfo != nil) {
        [strBuf appendString:@"--------- WECHAT INFO ---------\n"];
        [strBuf appendFormat:@"%@\n", wechatInfo];
    } else {
        UIButton *btn_auth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btn_auth setTitle:@"WeChat Bind" forState:UIControlStateNormal];
        btn_auth.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn_auth setFrame:CGRectMake(ele_x, height - 200, ele_width, 50)];
        [btn_auth addTarget:self action:@selector(onClickBtnAuth) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn_auth];
        [btn_auth release];
    }
    
    [tv_info setText:strBuf];
    [self.view addSubview:tv_info];
    [tv_info release];
    
    UIButton *btn_logout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_logout setTitle:@"Logout" forState:UIControlStateNormal];
    btn_logout.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_logout setFrame:CGRectMake(ele_x, height - 120, ele_width, 50)];
    [btn_logout addTarget:self action:@selector(onClickBtnLogout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_logout];
    [btn_logout release];
}

- (void)onClickBtnLogin
{
    [self.delegate presentLoginView];
}

- (void)onClickBtnReg
{
    [self.delegate presentRegView];
}

- (void)onClickBtnAuth
{
    [[self.delegate getWXAuthManager] setDelegate:self];
    [[self.delegate getWXAuthManager] sendAuthRequest];
}

- (void)wxAuthSucceed:(NSString*)code
{
    [[self.delegate getNetworkManager] getWeChatInfoByCode:code completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            NSLog(@"ERR:%@", connectionError);
        } else {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"WECHAT_INFO:%@", str);
            // TODO: save wechat info
            [self.delegate presentAcctView];
        }
    }];
}

- (void)wxAuthDenied
{
    
}

- (void)wxAuthCancel
{
    
}

- (void)onClickBtnLogout
{
    [[self.delegate getInfoManager] delInfo];
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
