//
//  NSString+ErrorTitle.h
//  wechatauthdemo
//
//  Created by Jeason on 26/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (ErrorTitle)

/**
 *  根据错误码返回对应的错误描述.
 *
 *  @param resp         服务器返回的响应
 *  @param defaultError 默认错误描述
 *
 *  @return 错误描述语句
 */
+ (NSString *)errorTitleFromResponse:(ADBaseResp *)resp
                        defaultError:(NSString *)defaultError;

@end