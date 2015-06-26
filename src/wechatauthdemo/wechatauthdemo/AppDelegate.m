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
    //向微信注册
    [WXApi registerApp:@"wx9bb52a653a60a1d3" withDescription:@"wechatauthdemo 0.1.0"];
    
    [self presentHomeView];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self.wxAuthMgr];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self.wxAuthMgr];
}

- (void)presentHomeView
{
    if ([self.infoMgr isInfoExist]) {
        [self presentAcctView];
        return;
    }
    if (self.homeViewController == nil) {
        self.homeViewController = [[[HomeViewController alloc] init] autorelease];
    }
    self.window.rootViewController = self.homeViewController;
    [self.window makeKeyAndVisible];
}

- (void)presentAcctView
{
    if (![[self infoMgr] isInfoExist]) {
        [self presentHomeView];
        return;
    }
    if (self.acctViewController == nil) {
        self.acctViewController = [[[AcctViewController alloc] init] autorelease];
    }
    self.window.rootViewController = self.acctViewController;
    [self.window makeKeyAndVisible];
}

- (void)presentLoginView
{
    if (self.loginViewController == nil) {
        self.loginViewController = [[[LoginViewController alloc] init] autorelease];
    }
    self.window.rootViewController = self.loginViewController;
    [self.window makeKeyAndVisible];
}

- (void)presentRegView
{
    if (self.regViewController == nil) {
        self.regViewController = [[[RegViewController alloc] init] autorelease];
    }
    self.window.rootViewController = self.regViewController;
    [self.window makeKeyAndVisible];
}

- (InfoManager*)infoMgr
{
    if (_infoMgr == nil) {
        self.infoMgr = [[[InfoManager alloc] init] autorelease];
        [_infoMgr loadInfo];
    }
    return _infoMgr;
}

- (WXAuthManager*)wxAuthMgr
{
    if (_wxAuthMgr == nil) {
        self.wxAuthMgr = [[[WXAuthManager alloc] init] autorelease];
    }
    return _wxAuthMgr;
}

- (NetworkManager*)networkMgr
{
    if (_networkMgr == nil) {
        self.networkMgr = [[[NetworkManager alloc] init] autorelease];
    }
    return _networkMgr;
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

+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

@end
