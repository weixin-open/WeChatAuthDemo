//
//  AppDelegate.h
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "LoginViewController.h"
#import "RegViewController.h"
#import "AcctViewController.h"
#import "InfoManager.h"
#import "WXAuthManager.h"
#import "NetworkManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) UIWindow *window;

@property (nonatomic, retain) InfoManager *infoMgr;
@property (nonatomic, retain) WXAuthManager *wxAuthMgr;
@property (nonatomic, retain) NetworkManager *networkMgr;

- (void) presentAcctView;
- (void) presentLoginView;
- (void) presentRegView;
- (void) presentAlert:(NSObject*)error;

+ (AppDelegate *)appDelegate;

@end

