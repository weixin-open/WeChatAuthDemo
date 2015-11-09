//
//  NSData+AES.m
//  AuthSDKDemo
//
//  Created by Jeason on 12/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "AES.h"
#import "RandomKey.h"
#import <CommonCrypto/CommonCryptor.h>

static const int AES_256_IV_SIZE = 16;  //TLS V1.2协议

@implementation NSData (AES)

- (NSData *)AES256EncryptWithKey:(NSString *)key {
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    NSMutableData *data = [[NSString randomDataWithLength:AES_256_IV_SIZE] mutableCopy];
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key cStringUsingEncoding:NSUTF8StringEncoding],
                                          [key length],
                                          [data bytes],
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        [data appendBytes:buffer length:numBytesEncrypted];
        free(buffer);
        return data;
    }
    free(buffer);
    return nil;
}

- (NSData *)AES256DecryptWithKey:(NSString *)key {
    unsigned char iv[AES_256_IV_SIZE] = {0};
    memcpy(iv, [self bytes], sizeof(iv));
    
    NSUInteger dataLength = [self length]-AES_256_IV_SIZE;
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key cStringUsingEncoding:NSUTF8StringEncoding],
                                          [key length],
                                          iv,
                                          [self bytes]+AES_256_IV_SIZE,
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

@end

@implementation NSString (AES)

- (NSString *)AES256EncryptWithKey:(NSString *)key {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self
                                                       options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *entryptData = [data AES256EncryptWithKey:key];
    return [[NSString alloc] initWithData:entryptData
                                 encoding:NSUTF8StringEncoding];
}

- (NSString *)AES256DecryptWithKey:(NSString *)key {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self
                                                       options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptData = [data AES256DecryptWithKey:key];
    return [[NSString alloc] initWithData:decryptData
                                 encoding:NSUTF8StringEncoding];
}



@end
