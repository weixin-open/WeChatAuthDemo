//
//  AppDelegate.m
//  AuthSDKDemo
//
//  Created by Jeason on 10/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "AppDelegate.h"
#import "WXLoginViewController.h"
#import "ADUserInfoViewController.h"
#import "WXApi.h"
#import "WXAuthManager.h"
#import "ADNetworkEngine.h"
#import "ADNetworkConfigManager.h"
#import "ADUserInfo.h"

@interface AppDelegate ()

@end

static NSString *YourAppIdInWeChat = @"wx17ef1eaef46752cb";

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ADUserInfoViewController *userInfoView = [[ADUserInfoViewController alloc] init];
    WXLoginViewController *wxLoginView = [[WXLoginViewController alloc] init];
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:userInfoView];
    rootNav.navigationBar.hidden = YES;
    /* Setup NavigationBar */
    rootNav.navigationBar.tintColor = [UIColor blackColor];
    UIFont *barFont = [UIFont fontWithName:kTitleLabelFont
                                      size:16];
    NSDictionary *barAttributes = @{
                                    NSFontAttributeName: barFont
                                    };
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:barAttributes
                                                                                            forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTitleTextAttributes:barAttributes];

    /* Register For WeChat */
    [WXApi registerApp:YourAppIdInWeChat
       withDescription:@"Auth Demo 2.0"];
    
    /* Setup Network */
    [[ADNetworkConfigManager sharedManager] setup];
    
    if (![[ADUserInfo currentUser] load]) { //if load fail
        [rootNav pushViewController:wxLoginView animated:NO];
    }
    self.window.rootViewController = rootNav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:[WXAuthManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:[WXAuthManager sharedManager]];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
