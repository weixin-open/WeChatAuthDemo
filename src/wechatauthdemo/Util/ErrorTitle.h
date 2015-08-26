//
//  NSString+ErrorTitle.h
//  wechatauthdemo
//
//  Created by Jeason on 26/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ErrorTitle)

+ (NSString *)errorTitleFromResponse:(ADBaseResp *)resp
                        defaultError:(NSString *)defaultError;

@end
