//
//  NSString+ErrorTitle.m
//  wechatauthdemo
//
//  Created by Jeason on 26/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//
#import "ErrorTitle.h"
#import "ADNetworkEngine.h"

@implementation NSString (ErrorTitle)

+ (NSString *)errorTitleFromResponse:(ADBaseResp *)resp
                        defaultError:(NSString *)defaultError {
    if (resp.errmsg)
        return resp.errmsg;
    
    NSString *errorTitle = defaultError;
    switch (resp.errcode) {
        case ADErrorCodeAlreadyBind:
            errorTitle = @"用户已经绑定";
            break;
        case ADErrorCodeUserExisted:
            errorTitle = @"账号已注册";
            break;
        case ADErrorCodeTokenExpired:
        case ADErrorCodeTicketExpired:
            errorTitle = @"太久没有登录了，为了安全起见，请重新登录";
            break;
        case ADErrorCodeTicketNotMatch:
            errorTitle = @"登录票据错误";
            break;
        case ADErrorCodeUserNotExisted:
            errorTitle = @"该账号未注册";
            break;
        case ADErrorCodePasswordNotMatch:
            errorTitle = @"密码不正确";
            break;
        case ADErrorCodeClientDescryptError:
            errorTitle = @"网络错误";
            break;
        default:
            break;
    }
    return errorTitle;
}

@end