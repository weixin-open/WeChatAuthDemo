//
//  ViewController.m
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    [[AppDelegate appDelegate].wxAuthMgr setDelegate:self];
    [[AppDelegate appDelegate].wxAuthMgr sendAuthRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int w = [[UIScreen mainScreen] bounds].size.width;
    int h = [[UIScreen mainScreen] bounds].size.height;
    
    int wBtn = 200;
    int hBtn = 80;
    int xBtn = (w - wBtn)/2;
    int yCenter = (h - hBtn)/2;
    int yGap = 100;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    btnLogin.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnLogin setFrame:CGRectMake(xBtn, yCenter - yGap, wBtn, hBtn)];
    [btnLogin addTarget:self action:@selector(onClickBtnLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogin];
    [btnLogin release];
    
    UIButton *btnReg = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnReg setTitle:@"Register" forState:UIControlStateNormal];
    btnReg.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnReg setFrame:CGRectMake(xBtn, yCenter, wBtn, hBtn)];
    [btnReg addTarget:self action:@selector(onClickBtnReg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnReg];
    [btnReg release];
    
    UIButton *btnAuth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnAuth setTitle:@"WeChat Auth" forState:UIControlStateNormal];
    btnAuth.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnAuth setFrame:CGRectMake(xBtn, yCenter + yGap, wBtn, hBtn)];
    [btnAuth addTarget:self action:@selector(onClickBtnAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAuth];
    [btnAuth release];
    
    UIButton *btnAcct = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnAcct setTitle:@"temp to account" forState:UIControlStateNormal];
    btnAcct.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnAcct setFrame:CGRectMake(xBtn, h - 100, wBtn, hBtn)];
    [btnAcct addTarget:[AppDelegate appDelegate] action:@selector(presentAcctView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnAcct];
    [btnAcct release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)wxAuthSucceed:(NSString*)code
{
    [[AppDelegate appDelegate].networkMgr getWeChatInfoByCode:code completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            NSLog(@"ERR:%@", connectionError);
        } else {
            NSString *str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
            NSLog(@"WECHAT_INFO:%@", str);
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

@end
