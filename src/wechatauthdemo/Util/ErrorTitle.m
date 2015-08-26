//
//  NSString+ErrorTitle.m
//  wechatauthdemo
//
//  Created by Jeason on 26/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ErrorTitle.h"

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
            errorTitle = @"邮箱已注册";
            break;
        case ADErrorCodeTokenExpired:
//            errorTitle = @"太久没有使用了，为了安全起见，请重新输入密码登录";
//            break;
        case ADErrorCodeTicketExpired:
            errorTitle = @"太久没有输入密码了，为了安全起见，请重新输入密码登录";
            break;
        case ADErrorCodeTicketNotMatch:
            errorTitle = @"登录票据错误";
            break;
        case ADErrorCodeUserNotExisted:
            errorTitle = @"邮箱不存在";
            break;
        case ADErrorCodePasswordNotMatch:
            errorTitle = @"密码不正确";
            break;
        default:
            break;
    }
    return errorTitle;
}

@end
