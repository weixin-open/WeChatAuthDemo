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
    
    int hAcctInfo = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    AppDelegate* app = [AppDelegate appDelegate];
    NSDictionary* acctInfo = [app.infoMgr getSubInfo:SUBINFO_ACCT_KEY];
    NSDictionary* wechatInfo = [app.infoMgr getSubInfo:SUBINFO_WX_KEY];
    
    NSMutableString *strBuf = [[NSMutableString alloc] init];
    if (acctInfo != nil) {
        // [strBuf appendString:@"--------- ACCOUNT INFO ---------\n"];
        [strBuf appendFormat:@"%@ : %@\n", NSLocalizedString(@"mail", nil), [acctInfo valueForKey:@"mail"]];
        [strBuf appendFormat:@"%@ : %@\n", NSLocalizedString(@"nickname", nil), [acctInfo valueForKey:@"nickname"]];
        
        UILabel *lbAcct = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, w, 30)];
        lbAcct.text = NSLocalizedString(@"acct info", nil);
        lbAcct.font = [UIFont systemFontOfSize:19];
        lbAcct.numberOfLines = 1;
        lbAcct.baselineAdjustment = YES;
        lbAcct.adjustsFontSizeToFitWidth = YES;
        lbAcct.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lbAcct];
        
        UITextView *tvAcct = [[UITextView alloc] initWithFrame:CGRectMake(30, 80, w-2*30, 80)];
        tvAcct.scrollEnabled = YES;
        tvAcct.editable = NO;
        tvAcct.font = [UIFont systemFontOfSize:15];
        [tvAcct setText:strBuf];
        [self.view addSubview:tvAcct];
        [tvAcct release];
        
        hAcctInfo = 100;
        
    } else {
        UIButton *btnLogin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnLogin setTitle:NSLocalizedString(@"bind existed account", nil) forState:UIControlStateNormal];
        btnLogin.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnLogin setFrame:CGRectMake(xEle, h - 250, wEle, 50)];
        [btnLogin addTarget:self action:@selector(onClickBtnLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnLogin];
        
        UIButton *btnReg = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnReg setTitle:NSLocalizedString(@"bind new account", nil) forState:UIControlStateNormal];
        btnReg.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnReg setFrame:CGRectMake(xEle, h - 200, wEle, 50)];
        [btnReg addTarget:self action:@selector(onClickBtnReg) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnReg];
    }
    if (wechatInfo != nil) {
        [strBuf setString:@""];
        
        // [strBuf appendString:@"--------- WECHAT INFO ---------\n"];
        [strBuf appendFormat:@"%@ : %@\n", NSLocalizedString(@"nickname", nil), [wechatInfo valueForKey:@"nickname"]];
        [strBuf appendFormat:@"%@ : %@\n", NSLocalizedString(@"city", nil), [wechatInfo valueForKey:@"city"]];
        NSString* sexStr = [[NSString stringWithFormat:@"%@", [wechatInfo valueForKey:@"sex"]] isEqualToString:@"1"] ? NSLocalizedString(@"male", nil) : NSLocalizedString(@"female", nil);
        [strBuf appendFormat:@"%@ : %@\n", NSLocalizedString(@"sex", nil), sexStr];
        [strBuf appendFormat:@"%@ : \n", NSLocalizedString(@"weixin head image", nil)];
        
        UILabel *lbWx = [[UILabel alloc]initWithFrame:CGRectMake(0, 40+hAcctInfo, w, 30)];
        lbWx.text = NSLocalizedString(@"wx info", nil);
        lbWx.font = [UIFont systemFontOfSize:19];
        lbWx.numberOfLines = 1;
        lbWx.baselineAdjustment = YES;
        lbWx.adjustsFontSizeToFitWidth = YES;
        lbWx.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:lbWx];
        
        UITextView *tvWx = [[UITextView alloc] initWithFrame:CGRectMake(30, 80+hAcctInfo, w-2*30, 120)];
        tvWx.scrollEnabled = YES;
        tvWx.editable = NO;
        tvWx.font = [UIFont systemFontOfSize:15];
        [tvWx setText:strBuf];
        [self.view addSubview:tvWx];
        [tvWx release];
        
        UIImageView *imageView=[[[UIImageView alloc] initWithFrame:CGRectMake(w/2-40, 170+hAcctInfo, 80, 80)] autorelease];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *imgUrl = [NSString stringWithFormat:@"%@", [wechatInfo valueForKey:@"headimgurl"]];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];

            dispatch_async(dispatch_get_main_queue(), ^{
                [imageView setImage:[UIImage imageWithData:data]];
                [self.view addSubview:imageView];
            });
        });
    } else {
        UIButton *btnAuth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnAuth setTitle:NSLocalizedString(@"bind weixin", nil) forState:UIControlStateNormal];
        btnAuth.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnAuth setFrame:CGRectMake(xEle, h - 200, wEle, 50)];
        [btnAuth addTarget:self action:@selector(onClickBtnAuth) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnAuth];
    }
    
    /*
    if (acctInfo != nil && wechatInfo != nil) {
        UIButton *btnUnbind = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [btnUnbind setTitle:NSLocalizedString(@"unbind weixin", nil) forState:UIControlStateNormal];
        btnUnbind.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnUnbind setFrame:CGRectMake(xEle, h - 200, wEle, 50)];
        [btnUnbind addTarget:self action:@selector(onClickBtnUnbind) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnUnbind];
    }
     */

    [strBuf release];
    
    UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnLogout setTitle:NSLocalizedString(@"logout", nil) forState:UIControlStateNormal];
    btnLogout.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnLogout setFrame:CGRectMake(xEle, h - 120, wEle, 50)];
    [btnLogout addTarget:self action:@selector(onClickBtnLogout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogout];
}

- (void)onClickBtnLogin
{
    [[AppDelegate appDelegate] presentLoginView:YES];
}

- (void)onClickBtnReg
{
    [[AppDelegate appDelegate] presentRegView];
}

- (void)onClickBtnAuth
{
    [[AppDelegate appDelegate].wxAuthMgr sendAuthRequestWithController:self delegate:self];
}

- (void)onClickBtnUnbind
{
    AppDelegate* app = [AppDelegate appDelegate];
    [app.networkMgr appUnbindWx:app.infoMgr.uid userticket:app.infoMgr.userTicket completionHandler:^(NSString* error, NSNumber* uid, NSString* userticket) {
        if (error) {
            NSLog(@"ERR:%@", error);
            [[AppDelegate appDelegate] presentAlert:error];
        } else {
            app.infoMgr.uid = uid;
            app.infoMgr.userTicket = userticket;
            [app.infoMgr delSubInfo:SUBINFO_WX_KEY];
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_async(queue, ^{
                NSArray *viewsToRemove = [self.view subviews];
                for (UIView *v in viewsToRemove) {
                    [v removeFromSuperview];
                }
                [self viewDidLoad];
            });
        }
    }];
}


- (void)wxAuthSucceed:(NSString*)code
{
    AppDelegate* app = [AppDelegate appDelegate];
    [app.networkMgr appBindWx:app.infoMgr.uid userticket:app.infoMgr.userTicket code:code completionHandler:^(NSString *error, NSNumber *uid, NSString *userticket) {
        if (error) {
            NSLog(@"ERR:%@", error);
            [[AppDelegate appDelegate] presentAlert:error];
        } else {
            app.infoMgr.uid = uid;
            app.infoMgr.userTicket = userticket;
            [app.networkMgr getWxUserInfo:uid userticket:userticket realtime:TRUE
                        completionHandler:^(NSString *error, NSNumber* uid, NSString* userticket, NSDictionary *info){
                if (error) {
                    NSLog(@"ERR:%@", error);
                    [[AppDelegate appDelegate] presentAlert:error];
                } else {
                    if (!info) {
                        return;
                    }
                    [app.infoMgr setSubInfo:info forKey:SUBINFO_WX_KEY];
                    app.infoMgr.userTicket = userticket;
                    [app presentAcctView];
                }
            }];
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
    [[AppDelegate appDelegate] presentLoginView:NO];
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
