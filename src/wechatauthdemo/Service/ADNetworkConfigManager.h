//
//  ADNetworkConfigManager.h
//  wechatauthdemo
//
//  Created by Jeason on 20/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ADNetworkConfigItem;

extern const NSString *kConnectCGIName;
extern const NSString *kRegisterCGIName;
extern const NSString *kLoginCGIName;
extern const NSString *kWXLoginCGIName;
extern const NSString *kCheckLoginCGIName;
extern const NSString *kGetUserInfoCGIName;
extern const NSString *kWXBindAppCGIName;
extern const NSString *kAppBindWXCGIName;

@interface ADNetworkConfigManager : NSObject

+ (instancetype)sharedManager;

- (void)setup;

- (void)registerConfig:(ADNetworkConfigItem *)item forKeyPath:(NSString *)keyPath;

- (void)removeConfigForKeyPath:(NSString *)keyPath;

- (ADNetworkConfigItem *)getConfigForKeyPath:(NSString *)keyPath;

@end
