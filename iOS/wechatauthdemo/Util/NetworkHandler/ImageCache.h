//
//  UIImage+ImageCache.h
//  wechatauthdemo
//
//  Created by Jeason on 26/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageCache)

+ (UIImage *)getCachedImageForUrl:(NSString *)urlString;

- (BOOL)cacheForUrl:(NSString *)urlString;

@end
