//
// Created by Jeason on 28/08/15.
// Copyright (c) 2015 Tencent. All rights reserved.
//

#import <SVProgressHUD/SVProgressHUD.h>
#import "ErrorHandler.h"
#import "ErrorTitle.h"
#import "AppDelegate.h"
#import "WXLoginViewController.h"
#import "ADNetworkEngine.h"
#import "ADUserInfo.h"
#import "ADCheckLoginResp.h"

static int const kHandleErrorMaxDepth = 3;

@implementation ErrorHandler

+ (void)handleNetworkExpiredError:(ADBaseResp *)resp
              WhileCatchErrorCode:(ErrorSignal)errorSignal {
    [self handleNetworkExpiredError:resp
                WhileCatchErrorCode:errorSignal
                            InDepth:0];
}

+ (void)handleNetworkExpiredError:(ADBaseResp *)resp
              WhileCatchErrorCode:(ErrorSignal)errorSignal
                          InDepth:(int)depth {
    if (depth <= kHandleErrorMaxDepth) {
        switch (resp.errcode) {
            case ADErrorCodeSessionKeyExpired: {    //会话过期，再次登陆
                NSLog(@"Session Key Is Expired");
                [[ADNetworkEngine sharedEngine] checkLoginForUin:[ADUserInfo currentUser].uin
                                                     LoginTicket:[ADUserInfo currentUser].loginTicket
                                                  WithCompletion:^(ADCheckLoginResp *checkLoginResp) {
                                                      if (checkLoginResp && checkLoginResp.sessionKey) {
                                                          NSLog(@"Check Login Success");
                                                          [ADUserInfo currentUser].sessionExpireTime = checkLoginResp.expireTime;
                                                          [[ADUserInfo currentUser] save];
                                                          errorSignal != nil ? errorSignal(resp.errcode) : nil;
                                                      } else {
                                                          NSLog(@"Check Login Fail");
                                                          [self handleNetworkExpiredError:resp
                                                                      WhileCatchErrorCode:nil
                                                                                  InDepth:depth+1];
                                                      }
                                                  }];
                break;
            };
            default:
                errorSignal != nil ? errorSignal(resp.errcode) : nil;
                break;
        }
    }
}

@end