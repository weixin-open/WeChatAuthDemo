//
//  ADKeyChainWrap.h
//  wechatauthdemo
//
//  Created by WeChat on 13/01/2016.
//  Copyright © 2016 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADKeyChainWrap : NSObject

+ (BOOL)setData:(NSData *)data ForKey:(NSString *)key;

+ (NSData *)getDataForKey:(NSString *)key;

+ (BOOL)deleteDataForKey:(NSString *)key;

@end
