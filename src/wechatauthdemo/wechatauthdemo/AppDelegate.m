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
    [WXApi registerApp:@"wxd930ea5d5a258f4f" withDescription:@"wechatauthdemo 0.1.0"];
    
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
    if (self.homeViewController == nil) {
        self.homeViewController = [[[HomeViewController alloc] init] autorelease];
    }
    self.homeViewController.delegate = self;
    self.window.rootViewController = self.homeViewController;
    [self.window makeKeyAndVisible];
}

- (void) presentAcctView
{
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
    //[self.infoMgr setSubInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"BOSHAO", @"username", nil] forKey:SUBINFO_ACCT_KEY];
    [self.infoMgr saveInfo];
}

- (InfoManager*) getInfoManager
{
    [self initInfoManager];
    return self.infoMgr;
}

- (void)sendAuthRequest
{
    SendAuthReq* req =[[[SendAuthReq alloc] init] autorelease];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123" ;
    [WXApi sendReq:req];
}

-(void)onReq:(BaseReq*)req
{
    // just leave it here, wechat will not call our app
}

-(void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp* authResp = (SendAuthResp*)resp;
        NSString *code = authResp.code;
        NSString *state = authResp.state;
        NSLog(@"RESP:code:%@,state:%@\n", code, state);
        // TODO: send code to our app server and get wechat info async
        [self getWeChatInfoByCode:code];
    }
}

- (BOOL)getWeChatInfoByCode:(NSString*)code
{
    NSURL *url = [NSURL URLWithString:[[@"http://urltoserver?code=" stringByAppendingString:code]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            [self getWeChatInfoByCodeError:connectionError];
        } else {
            [self getWeChatInfoByCodeDone:data];
        }
    }];
    return true;
}

- (void)getWeChatInfoByCodeError:(NSError*)error
{
    NSLog(@"ERR:%@", error);
}

- (void)getWeChatInfoByCodeDone:(NSData*)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"WECHAT_INFO:%@", str);
    // TODO: jump to account view
    [self presentAcctView];
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
