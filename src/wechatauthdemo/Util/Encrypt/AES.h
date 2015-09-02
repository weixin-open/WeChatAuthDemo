//
//  NSData+AES.h
//  AuthSDKDemo
//
//  Created by Jeason on 12/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  AES_256_CBC_PKCS7Padding, 加密后输出的格式为char[16]+密文(TLS V1.2协议)
 */
@interface NSData (AES)

- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;

@end

@interface NSString (AES)

- (NSString *)AES256EncryptWithKey:(NSString *)key;
- (NSString *)AES256DecryptWithKey:(NSString *)key;


@end