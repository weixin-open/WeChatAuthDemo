//
//  NSString+RandomString.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//
#import <sys/time.h>
#import "RandomKey.h"
#import "MD5.h"

@implementation NSString (RandomKey)

+ (NSString *)randomKey {
    /* Get Random UUID */
    NSString *UUIDString;
    CFUUIDRef UUIDRef = CFUUIDCreate(NULL);
    CFStringRef UUIDStringRef = CFUUIDCreateString(NULL, UUIDRef);
    UUIDString = (NSString *)CFBridgingRelease(UUIDStringRef);
    CFRelease(UUIDRef);
    /* Get Time */
    double time = CFAbsoluteTimeGetCurrent();
    /* MD5 With Sale */
    return [[NSString stringWithFormat:@"%@%f", UUIDString, time] MD5];
}

@end

@implementation NSData (RandomData)

+ (NSData *)randomDataWithLength:(NSUInteger)length {
    void *bytes = malloc(length);
    NSData *ret = [NSData dataWithBytes:bytes length:length];
    free(bytes);
    return ret;
}

@end
