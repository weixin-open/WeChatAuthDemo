//
//  NSString+RandomString.h
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RandomKey)

/**
 *  产生一个随机Key，长度为32.
 */
+ (NSString *)randomKey;

@end

@interface NSData (RandomData)
/**
 *  产生随机数据.
 *  @param length 随机数据的长度
 *
 */
+ (NSData *)randomDataWithLength:(NSUInteger)length;

@end
