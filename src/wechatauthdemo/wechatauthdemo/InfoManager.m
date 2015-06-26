//
//  InfoManager.m
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/25/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//


#import "InfoManager.h"

NSString * const INFO_KEY = @"userinfo";
NSString * const SUBINFO_ACCT_KEY = @"acctinfo";
NSString * const SUBINFO_WECHAT_KEY =@"wechatinfo";

@interface InfoManager ()

@end

@implementation InfoManager

- (id)init
{
    [super init];
    if (self) {
        _userInfo = nil;
    }
    return self;
}

- (void)dealloc
{
    [_userInfo release];
    [super dealloc];
}

- (BOOL)isInfoExist
{
    return self.userInfo != nil;
}

- (void)saveInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.userInfo forKey:INFO_KEY];
    [userDefaults synchronize];
}

- (void)loadInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.userInfo = [NSMutableDictionary dictionaryWithDictionary:[userDefaults dictionaryForKey:INFO_KEY]];
    // mock account info
    // [self setSubInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"BOSHAO", @"username", nil] forKey:SUBINFO_ACCT_KEY];
    // mock wechat info
    // if (NO)
    {
        [self setSubInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"OPENID", @"openid",
                          @"NICKNAME", @"nickname",
                          @"http://wx.qlogo.cn/mmopeng3MonUZtNHkdmzicIlibx6iaFqAc56vxLSUfpb6n5WKSYVY0ChQKkiaJSgQ1dZuTOgvLLrhJbERQQ4eMsv84eavHiaiceqxibJxCfHe/0", @"headimgurl",
                          @"o6_bmasdasdsad6_2sgVt7hMZOPfL", @"unionid",
                          nil] forKey:SUBINFO_WECHAT_KEY];
    }
}

- (void)delInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:INFO_KEY];
    self.userInfo = nil;
    [userDefaults synchronize];
}

- (NSDictionary*)getSubInfo:(NSString*)key
{
    return [self.userInfo valueForKey:key];
}

- (void)delSubInfo:(NSString*)key
{
    [self.userInfo removeObjectForKey:key];
    [self saveInfo];
}

- (void)setSubInfo:(NSDictionary*)subInfo forKey:(NSString*)key
{
    [self.userInfo setObject:subInfo forKey:key];
    [self saveInfo];
}

@end