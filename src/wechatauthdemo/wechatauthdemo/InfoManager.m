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
NSString * const SUBINFO_WX_KEY =@"wechatinfo";

@interface InfoManager ()

@end

@implementation InfoManager

- (id)init
{
    self = [super init];
    if (self) {
        _userInfo = nil;
        _uid = nil;
        _userTicket = nil;
    }
    return self;
}

- (void)dealloc
{
    [_userInfo release];
    [_uid release];
    [_userTicket release];
    [super dealloc];
}

- (BOOL)isInfoExist
{
    return self.uid != nil;
}

- (void)saveInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.userInfo forKey:INFO_KEY];
    [userDefaults setObject:self.uid forKey:@"uid"];
    [userDefaults setObject:self.userTicket forKey:@"userticket"];
    [userDefaults synchronize];
}

- (void)loadInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.userInfo = [NSMutableDictionary dictionaryWithDictionary:[userDefaults dictionaryForKey:INFO_KEY]];
    
    self.uid = [userDefaults valueForKey:@"uid"];
    self.userTicket = [userDefaults valueForKey:@"userticket"];
    
    // mock
    // self.uid = [NSNumber numberWithInt:100];
    // self.userTicket = @"abcd";
    // mock account info
    // [self setSubInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"BOSHAO", @"nickname", @"daboshao@yeah.net", @"mail", nil] forKey:SUBINFO_ACCT_KEY];
    // mock wechat info
    /*
    [self setSubInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                      @"OPENID", @"openid",
                      @"NICKNAME", @"nickname",
                      @"http://wx.qlogo.cn/mmopeng3MonUZtNHkdmzicIlibx6iaFqAc56vxLSUfpb6n5WKSYVY0ChQKkiaJSgQ1dZuTOgvLLrhJbERQQ4eMsv84eavHiaiceqxibJxCfHe/0", @"headimgurl",
                      @"o6_bmasdasdsad6_2sgVt7hMZOPfL", @"unionid",
                      nil] forKey:SUBINFO_WX_KEY];*/
}

- (void)delInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:INFO_KEY];
    [userDefaults removeObjectForKey:@"uid"];
    [userDefaults removeObjectForKey:@"userticket"];
    
    [self.userInfo removeAllObjects];
    [self.uid release];
    _uid = nil;
    [self.userTicket release];
    _userTicket = nil;
    
    [userDefaults synchronize];
}

- (BOOL)isSubInfoExist:(NSString*)key
{
    return [self.userInfo valueForKey:key] != nil;
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