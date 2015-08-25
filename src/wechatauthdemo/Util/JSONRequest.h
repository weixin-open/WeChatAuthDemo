//
//  JSONRequest.h
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^JSONCallBack)(NSDictionary *dict, NSError *error);

@interface NSURLSession(JSONRequest)

- (NSURLSessionDataTask *)JSONTaskForHost:(NSString *)host
                                     Para:(NSDictionary *)para
                            ConfigKeyPath:(NSString *)configKeyPath
                           WithCompletion:(JSONCallBack)handler;
@end

@interface NSURLSession (SessionKey)

@property (nonatomic, retain) NSString *sessionKey;
@property (nonatomic, retain) NSString *publicKey;

@end
