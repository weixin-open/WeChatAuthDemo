//
//  AppDelegate.m
//  AuthSDKDemo
//
//  Created by Jeason on 10/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "AppDelegate.h"
#import "AlertTitleFont.h"
#import "WXLoginViewController.h"
#import "ADUserInfoViewController.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "ADNetworkEngine.h"
#import "ADNetworkConfigManager.h"
#import "ADUserInfo.h"
#import "ADCheckLoginResp.h"

static NSString* const YourAppIdInWeChat = @"wxbeafe42095e03edf";
static NSString* const kYourAppDescription = @"AuthDemo 2.0";
static const CGFloat kAlertTitleFontSize = 16;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    /* Setup RootViewController */
    ADUserInfoViewController *userInfoView = [[ADUserInfoViewController alloc] init];
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:userInfoView];
    self.window.rootViewController = rootNav;

    /* Setup NavigationBar */
    rootNav.navigationBar.tintColor = [UIColor blackColor];
    UIFont *barFont = [UIFont fontWithName:kChineseFont
                                      size:16];
    NSDictionary *barAttributes = @{
                                    NSFontAttributeName: barFont
                                    };
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:barAttributes
                                                                                            forState:UIControlStateNormal];
    [[UINavigationBar appearance] setTitleTextAttributes:barAttributes];
    rootNav.navigationBar.hidden = YES;
    UILabel *alertAppear = nil;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        alertAppear = [UILabel appearanceWhenContainedIn:[UIAlertController class], nil];
    } else {
        alertAppear = [UILabel appearanceWhenContainedIn:[UIActionSheet class], nil];
    }
    [alertAppear setAlertTitleFont:[UIFont fontWithName:kChineseFont size:kAlertTitleFontSize]];
    /* Register For WeChat */
    [WXApi registerApp:YourAppIdInWeChat
       withDescription:kYourAppDescription];
    
    /* Setup Network */
    [[ADNetworkConfigManager sharedManager] setup];
    WXLoginViewController *wxLoginView = [[WXLoginViewController alloc] init];
    
    /* Load Local User */
    if (![[ADUserInfo currentUser] load]) {
        NSLog(@"Load Local User Fail");
        [rootNav pushViewController:wxLoginView animated:NO];
        [self.window makeKeyAndVisible];
    } else {
        NSLog(@"Load Local User Success");
        [[ADNetworkEngine sharedEngine] checkLoginForUin:[ADUserInfo currentUser].uin
                                             LoginTicket:[ADUserInfo currentUser].loginTicket
                                          WithCompletion:^(ADCheckLoginResp *resp) {
                                              if (resp && resp.sessionKey) {
                                                  NSLog(@"Check Login Success");
                                                  [ADUserInfo currentUser].sessionExpireTime = resp.expireTime;
                                                  [[ADUserInfo currentUser] save];
                                              } else {
                                                  NSLog(@"Check Login Fail");
                                                  [rootNav pushViewController:wxLoginView animated:NO];
                                              }
                                              [self.window makeKeyAndVisible];
                                          }];
    }
    return YES;
}

#pragma warnings You MUST implement these two delegate to handle opening WeChat.
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
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
