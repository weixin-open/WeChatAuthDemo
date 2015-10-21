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
#import "DocumentsViewController.h"
#import "MessageBoardViewController.h"
#import "UserInfoViewController.h"
#import "WXApi.h"
#import "WXApiManager.h"
#import "ADNetworkEngine.h"
#import "ADNetworkConfigManager.h"
#import "ADUserInfo.h"
#import "ADCheckLoginResp.h"
#import "ADGetUserInfoResp.h"
#import "MessageBoardViewController.h"

static NSString* const YourAppIdInWeChat = @"wxbeafe42095e03edf";
static NSString* const kYourAppDescription = @"AuthDemo 2.0";
static NSString* const kMessageBoardViewTitle = @"留言板";
static NSString* const kUserInfoViewTitle = @"我";
static NSString* const kDocumentsViewTitle = @"开发文档";

static const CGFloat kAlertTitleFontSize = 16;
static const NSInteger kDefaultTabIndex = 0;

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    /* Setup RootViewController */
    self.messageBoardView = [[MessageBoardViewController alloc] init];
    UINavigationController *messageBoardNav = [[UINavigationController alloc] initWithRootViewController:self.messageBoardView];
    messageBoardNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:kMessageBoardViewTitle
                                                               image:[UIImage imageNamed:@"messageBoardIcon"]
                                                       tag:0];
    
    self.documentsView = [[DocumentsViewController alloc] init];
    UINavigationController *documentsNav = [[UINavigationController alloc] initWithRootViewController:self.documentsView];
    documentsNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:kDocumentsViewTitle
                                                            image:[UIImage imageNamed:@"documentsIcon"]
                                                    tag:1];
    
    self.userInfoView = [[UserInfoViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *userInfoNav = [[UINavigationController alloc] initWithRootViewController:self.userInfoView];
    userInfoNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:kUserInfoViewTitle
                                                           image:[UIImage imageNamed:@"userInfoIcon"]
                                                   tag:2];
    
    UITabBarController *rootTabBarView = [[UITabBarController alloc] init];
    rootTabBarView.viewControllers = @[messageBoardNav, documentsNav, userInfoNav];
    rootTabBarView.tabBar.tintColor = [UIColor colorWithRed:0.07 green:0.73 blue:0.02 alpha:1.0];
//    rootTabBarView.tabBar.translucent = NO;
    rootTabBarView.selectedIndex = kDefaultTabIndex;
    
    UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:rootTabBarView];
    self.window.rootViewController = rootNav;
    
    /* Setup NavigationBar */
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:16.0f], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.23 green:0.24 blue:0.25 alpha:1.0f]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
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
    
    /* Load Local User */
    WXLoginViewController *wxLoginView = [[WXLoginViewController alloc] init];
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
                                                  [[ADNetworkEngine sharedEngine] getUserInfoForUin:[ADUserInfo currentUser].uin
                                                                                        LoginTicket:[ADUserInfo currentUser].loginTicket
                                                                                     WithCompletion:^(ADGetUserInfoResp *resp) {
                                                                                         [ADUserInfo currentUser].nickname = resp.nickname;
                                                                                         [ADUserInfo currentUser].headimgurl = resp.headimgurl;
                                                                                         [[ADNetworkEngine sharedEngine] downloadImageForUrl:resp.headimgurl
                                                                                                                              WithCompletion:nil];
                                                                                         self.userInfoView.userInfoResp = resp;
                                                                                     }];
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

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}


@end