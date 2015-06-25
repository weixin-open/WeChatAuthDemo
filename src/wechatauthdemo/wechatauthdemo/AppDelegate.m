//
//  AppDelegate.m
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (id)init {
    self = [super init];
    
    self.homeViewController = nil;
    self.loginViewController = nil;
    self.acctViewController = nil;
    self.regViewController = nil;
    
    self.infoMgr = nil;
    self.wxAuthMgr = nil;
    self.networkMgr = nil;
    
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // load user info
    [self initInfoManager];
    [self presentHomeView];
    //向微信注册
    [WXApi registerApp:@"wx9bb52a653a60a1d3" withDescription:@"wechatauthdemo 0.1.0"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (void) presentHomeView
{
    if ([self.infoMgr isInfoExist]) {
        [self presentAcctView];
        return;
    }
    if (self.homeViewController == nil) {
        self.homeViewController = [[[HomeViewController alloc] init] autorelease];
    }
    self.homeViewController.delegate = self;
    self.window.rootViewController = self.homeViewController;
    [self.window makeKeyAndVisible];
}

- (void) presentAcctView
{
    if (![self.infoMgr isInfoExist]) {
        [self presentHomeView];
        return;
    }
    if (self.acctViewController == nil) {
        self.acctViewController = [[[AcctViewController alloc] init] autorelease];
    }
    self.acctViewController.delegate = self;
    self.window.rootViewController = self.acctViewController;
    [self.window makeKeyAndVisible];
}

- (void) presentLoginView
{
    if (self.loginViewController == nil) {
        self.loginViewController = [[[LoginViewController alloc] init] autorelease];
    }
    self.loginViewController.delegate = self;
    self.window.rootViewController = self.loginViewController;
    [self.window makeKeyAndVisible];
}

- (void) presentRegView
{
    if (self.regViewController == nil) {
        self.regViewController = [[[RegViewController alloc] init] autorelease];
    }
    self.regViewController.delegate = self;
    self.window.rootViewController = self.regViewController;
    [self.window makeKeyAndVisible];
}

- (void) initInfoManager
{
    self.infoMgr = [[[InfoManager alloc] init] autorelease];
    [self.infoMgr readInfo];
    [self.infoMgr saveInfo];
}

- (InfoManager*) getInfoManager
{
    [self initInfoManager];
    return self.infoMgr;
}

- (WXAuthManager*) getWXAuthManager
{
    if (self.wxAuthMgr == nil) {
        self.wxAuthMgr = [[[WXAuthManager alloc] init] autorelease];
    }
    return self.wxAuthMgr;
}

- (NetworkManager*) getNetworkManager
{
    if (self.networkMgr == nil) {
        self.networkMgr = [[[NetworkManager alloc] init] autorelease];
    }
    return self.networkMgr;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
