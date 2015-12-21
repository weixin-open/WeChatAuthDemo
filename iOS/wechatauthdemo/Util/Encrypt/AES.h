//
//  NSData+AES.h
//  AuthSDKDemo
//
//  Created by Jeason on 12/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)
/**
 *  AES_256_CBC_PKCS7Padding+HMAC, 加密后输出的格式为IV+AES密文+SHA256+Salt
 */
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end

@interface NSString (AES)

- (NSString *)AES256EncryptWithKey:(NSString *)key;
- (NSString *)AES256DecryptWithKey:(NSString *)key;

@end