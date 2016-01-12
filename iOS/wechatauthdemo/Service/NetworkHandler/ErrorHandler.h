//
// Created by WeChat on 28/08/15.
// Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ErrorSignal)(ADErrorCode code);

@interface ErrorHandler : NSObject

/**
 *  处理会话过期，Toekn过期时的行为。
 *
 *  @param resp        服务器返回的响应
 *  @param errorSignal 处理完成后的回调
 */
+ (void)handleNetworkExpiredError:(ADBaseResp *)resp
              WhileCatchErrorCode:(ErrorSignal)errorSignal;

@end