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

- (id)init
{
    self = [super init];    
    if (self) {
        _infoMgr = nil;
        _wxAuthMgr = nil;
        _networkMgr = nil;
    }
    return self;
}

- (void)dealloc
{
    [_infoMgr release];
    [_wxAuthMgr release];
    [_networkMgr release];
    
    [super dealloc];
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
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        if ([self.infoMgr isInfoExist]) {
            [self presentAcctView];
            return;
        }
        self.window.rootViewController = [[[HomeViewController alloc] init] autorelease];
        [self.window makeKeyAndVisible];
    });
}

- (void)presentAcctView
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        if (![[self infoMgr] isInfoExist]) {
            [self presentHomeView];
            return;
        }
        self.window.rootViewController = [[[AcctViewController alloc] init] autorelease];
        [self.window makeKeyAndVisible];
    });
}

- (void)presentLoginView
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        self.window.rootViewController = [[[LoginViewController alloc] init] autorelease];
        [self.window makeKeyAndVisible];
    });
}

- (void)presentRegView
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        self.window.rootViewController = [[[RegViewController alloc] init] autorelease];
        [self.window makeKeyAndVisible];
    });
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
