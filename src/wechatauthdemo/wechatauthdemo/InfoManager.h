//
//  InfoManager.h
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/25/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const INFO_KEY;
extern NSString * const SUBINFO_ACCT_KEY;
extern NSString * const SUBINFO_WX_KEY;

@interface InfoManager : NSObject

@property (nonatomic, retain) NSMutableDictionary *userInfo;
@property (nonatomic, retain) NSNumber* uid;
@property (nonatomic, retain) NSString* userTicket;

- (BOOL)isInfoExist;
- (void)saveInfo;
- (void)loadInfo;
- (void)delInfo;

- (BOOL)isSubInfoExist:(NSString*)key;
- (NSDictionary*)getSubInfo:(NSString*)key;
- (void)delSubInfo:(NSString*)key;
- (void)setSubInfo:(NSDictionary*)subInfo forKey:(NSString*)key;

@end