//
//  ViewController.m
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
    [self.delegate sendAuthRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    int width = [[UIScreen mainScreen] bounds].size.width;
    int height = [[UIScreen mainScreen] bounds].size.height;
    
    int btn_width = 200;
    int btn_height = 80;
    int btn_x = (width - btn_width)/2;
    int center_y = (height - btn_height)/2;
    int gap_y = 100;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn_login = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_login setTitle:@"Login" forState:UIControlStateNormal];
    btn_login.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_login setFrame:CGRectMake(btn_x, center_y - gap_y, btn_width, btn_height)];
    [btn_login addTarget:self action:@selector(onClickBtnLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_login];
    [btn_login release];
    
    UIButton *btn_reg = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_reg setTitle:@"Register" forState:UIControlStateNormal];
    btn_reg.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_reg setFrame:CGRectMake(btn_x, center_y, btn_width, btn_height)];
    [btn_reg addTarget:self action:@selector(onClickBtnReg) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_reg];
    [btn_reg release];
    
    UIButton *btn_auth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_auth setTitle:@"WeChat Auth" forState:UIControlStateNormal];
    btn_auth.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_auth setFrame:CGRectMake(btn_x, center_y + gap_y, btn_width, btn_height)];
    [btn_auth addTarget:self action:@selector(onClickBtnAuth) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_auth];
    [btn_auth release];
    
    UIButton *btn_acct = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn_acct setTitle:@"temp to account" forState:UIControlStateNormal];
    btn_acct.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn_acct setFrame:CGRectMake(btn_x, height - 100, btn_width, btn_height)];
    [btn_acct addTarget:self.delegate action:@selector(presentAcctView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_acct];
    [btn_acct release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
