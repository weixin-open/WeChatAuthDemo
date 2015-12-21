//
//  AFHTTPSessionManager+JSONRequest.h
//  wechatauthdemo
//
//  Created by Jeason on 21/12/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void (^JSONCallBack)(NSDictionary *dict, NSError *error);

@interface AFURLSessionManager (JSONRequest)

/**
 *  网络请求建立的统一接口.
 *
 *  @param host          请求的Host
 *  @param para          请求的参数
 *  @param configKeyPath 请求的配置ID， 详情阅读ADNetworkConfigManager
 *  @param handler       请求完成时的回调
 *
 */

- (NSURLSessionTask *)JSONTaskForHost:(NSString *)host
                                 Para:(NSDictionary *)para
                        ConfigKeyPath:(NSString *)configKeyPath
                       WithCompletion:(JSONCallBack)handler;
@end

@interface AFURLSessionManager (SessionKey)

@property (nonatomic, retain) NSString *sessionKey;
@property (nonatomic, retain) NSString *publicKey;

@end

