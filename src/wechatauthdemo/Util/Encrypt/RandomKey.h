//
//  NSString+RandomString.h
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RandomKey)

+ (NSString *)randomKey;

+ (NSData *)randomDataWithLength:(NSUInteger)length;

@end
