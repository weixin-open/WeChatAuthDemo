//
//  UIImage+ImageCache.m
//  wechatauthdemo
//
//  Created by WeChat on 26/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ImageCache.h"
#import "MD5.h"

static  NSString *kCacheImageDirectory = @"com.wechat.authdemo.image";

@implementation UIImage (ImageCache)

+ (UIImage *)getCachedImageForUrl:(NSString *)urlString {
    if (!urlString)
        return nil;
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *imageCacheDir = [cachePath stringByAppendingPathComponent:kCacheImageDirectory];
    NSString *filePath = [imageCacheDir stringByAppendingPathComponent:[urlString MD5]];

    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return [UIImage imageWithData:data];
}

- (BOOL)cacheForUrl:(NSString *)urlString {
    if (!urlString)
        return NO;
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *imageCacheDir = [cachePath stringByAppendingPathComponent:kCacheImageDirectory];
    NSError *fileError = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:imageCacheDir
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:&fileError];
    if (fileError) {
        NSLog(@"File Error: %@", fileError);
        return NO;
    }
    NSString *filePath = [imageCacheDir stringByAppendingPathComponent:[urlString MD5]];
    NSData *data = UIImageJPEGRepresentation(self, 1.0f);
    return [data writeToFile:filePath atomically:YES];
}

@end
