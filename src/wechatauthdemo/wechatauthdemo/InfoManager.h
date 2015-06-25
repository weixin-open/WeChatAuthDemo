//
//  InfoManager.h
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/25/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#ifndef wechatauthdemo_InfoManager_h
#define wechatauthdemo_InfoManager_h

#import <Foundation/Foundation.h>

extern NSString * const INFO_KEY;
extern NSString * const SUBINFO_ACCT_KEY;
extern NSString * const SUBINFO_WECHAT_KEY;

@interface InfoManager : NSObject

@property (strong, nonatomic) NSMutableDictionary *userInfo;

- (void)saveInfo;
- (void)readInfo;
- (void)delInfo;
- (NSDictionary*)getSubInfo:(NSString*)key;
- (void)delSubInfo:(NSString*)key;
- (void)setSubInfo:(NSDictionary*)subInfo forKey:(NSString*)key;

@end

#endif
