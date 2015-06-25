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

- (void)readInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.userInfo = [NSMutableDictionary dictionaryWithDictionary:[userDefaults dictionaryForKey:INFO_KEY]];
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