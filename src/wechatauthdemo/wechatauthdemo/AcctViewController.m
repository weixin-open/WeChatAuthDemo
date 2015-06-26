//
//  AcctViewController.m
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import "AcctViewController.h"
#import "AppDelegate.h"

@interface AcctViewController ()

@end

@implementation AcctViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int w = [[UIScreen mainScreen] bounds].size.width;
    int h = [[UIScreen mainScreen] bounds].size.height;
    
    int wEle = 200;
    int xEle = (w - wEle)/2;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary* acctInfo = [[AppDelegate appDelegate].infoMgr getSubInfo:SUBINFO_ACCT_KEY];
    NSDictionary* wechatInfo = [[AppDelegate appDelegate].infoMgr getSubInfo:SUBINFO_WECHAT_KEY];
    
    UITextView *tvInfo = [[UITextView alloc] initWithFrame:CGRectMake(30, 30, w-2*30, h-300)];
    tvInfo.scrollEnabled = YES;
    tvInfo.editable = NO;
    tvInfo.font = [UIFont systemFontOfSize:15];
    
    NSMutableString *strBuf = [[NSMutableString alloc] init];
    if (acctInfo != nil) {
        [strBuf appendString:@"--------- ACCOUNT INFO ---------\n"];
        [strBuf appendFormat:@"%@\n", acctInfo];
    } else {
        UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnLogin setTitle:@"Bind Existed Account" forState:UIControlStateNormal];
        btnLogin.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnLogin setFrame:CGRectMake(xEle, h - 250, wEle, 50)];
        [btnLogin addTarget:self action:@selector(onClickBtnLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnLogin];
        
        UIButton *btnReg = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnReg setTitle:@"Bind New Account" forState:UIControlStateNormal];
        btnReg.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnReg setFrame:CGRectMake(xEle, h - 200, wEle, 50)];
        [btnReg addTarget:self action:@selector(onClickBtnReg) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnReg];
    }
    [strBuf appendString:@"\n"];
    
    if (wechatInfo != nil) {
        [strBuf appendString:@"--------- WECHAT INFO ---------\n"];
        [strBuf appendFormat:@"%@\n", wechatInfo];
    } else {
        UIButton *btnAuth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnAuth setTitle:@"WeChat Bind" forState:UIControlStateNormal];
        btnAuth.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnAuth setFrame:CGRectMake(xEle, h - 200, wEle, 50)];
        [btnAuth addTarget:self action:@selector(onClickBtnAuth) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnAuth];
    }
    
    [tvInfo setText:strBuf];
    [strBuf release];
    
    [self.view addSubview:tvInfo];
    [tvInfo release];
    
    UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnLogout setTitle:@"Logout" forState:UIControlStateNormal];
    btnLogout.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnLogout setFrame:CGRectMake(xEle, h - 120, wEle, 50)];
    [btnLogout addTarget:self action:@selector(onClickBtnLogout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogout];
}

- (void)onClickBtnLogin
{
    [[AppDelegate appDelegate] presentLoginView];
}

- (void)onClickBtnReg
{
    [[AppDelegate appDelegate] presentRegView];
}

- (void)onClickBtnAuth
{
    [AppDelegate appDelegate].wxAuthMgr.delegate = self;
    [[AppDelegate appDelegate].wxAuthMgr sendAuthRequest];
}

- (void)wxAuthSucceed:(NSString*)code
{
    [[AppDelegate appDelegate].networkMgr getWeChatInfoByCode:code completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            NSLog(@"ERR:%@", connectionError);
        } else {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"WECHAT_INFO:%@", str);
            [str release];
            // TODO: save wechat info
            [[AppDelegate appDelegate] presentAcctView];
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
    [[AppDelegate appDelegate].infoMgr delInfo];
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
