//
//  JSONRequest.h
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JSONCallBack)(NSDictionary *dict, NSError *error);

@interface NSURLSession(JSONRequest)

/**
 *  网络请求建立的统一接口.
 *
 *  @param host          请求的Host
 *  @param para          请求的参数
 *  @param configKeyPath 请求的配置ID， 详情阅读ADNetworkConfigManager
 *  @param handler       请求完成时的回调
 *
 *  @return 返回一个DataTask（需要resume）
 */
- (NSURLSessionDataTask *)JSONTaskForHost:(NSString *)host
                                     Para:(NSDictionary *)para
                            ConfigKeyPath:(NSString *)configKeyPath
                           WithCompletion:(JSONCallBack)handler;
@end

@interface NSURLSession (SessionKey)

@property (nonatomic, retain) NSString *sessionKey;
@property (nonatomic, retain) NSString *publicKey;

@end
