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
    // 向微信注册
    // from dotali
    // [WXApi registerApp:@"wx9bb52a653a60a1d3" withDescription:@"demo 2.0"];
    // from tiinpeng
    [WXApi registerApp:@"wx17ef1eaef46752cb" withDescription:@"demo 2.0"];
    // [WXApi registerApp:@"wxd930ea5d5a258f4f" withDescription:@"wechatauthdemo 0.1.0"];
    
    [self presentLoginView];
    
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

- (void)presentLoginView
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        if ([self.infoMgr isInfoExist]) {
            [self presentAcctView];
            return;
        }
        self.window.rootViewController = [[[LoginViewController alloc] init] autorelease];
        [self.window makeKeyAndVisible];
    });
}

- (void)presentAcctView
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        if (![[self infoMgr] isInfoExist]) {
            [self presentLoginView];
            return;
        }
        self.window.rootViewController = [[[AcctViewController alloc] init] autorelease];
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

- (void)presentAlert:(NSObject*)error
{
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSString* errorStr = [NSString stringWithFormat:@"%@", error];
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", nil) message:NSLocalizedString(errorStr, nil) delegate:self cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles:nil] autorelease];
        [alert show];
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
