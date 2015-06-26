//
//  AppDelegate.h
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "RegViewController.h"
#import "AcctViewController.h"
#import "InfoManager.h"
#import "WXAuthManager.h"
#import "NetworkManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HomeViewController *homeViewController;
@property (strong, nonatomic) LoginViewController *loginViewController;
@property (strong, nonatomic) RegViewController *regViewController;
@property (strong, nonatomic) AcctViewController *acctViewController;

@property (strong, nonatomic) InfoManager *infoMgr;
@property (strong, nonatomic) WXAuthManager *wxAuthMgr;
@property (strong, nonatomic) NetworkManager *networkMgr;

- (void) presentHomeView;
- (void) presentAcctView;
- (void) presentLoginView;
- (void) presentRegView;

+ (AppDelegate *)appDelegate;

@end

