//
//  MD5.h
//  AuthSDKDemo
//
//  Created by WeChat on 11/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (RSA)

- (NSData *)RSAEncryptWithPublicKey:(NSString *)pubKey;

@end

@interface NSString (RSA)

- (NSString *)RSAEncryptWithPublicKey:(NSString *)pubKey;

@end