//
//  ADNetworkConfigManager.m
//  wechatauthdemo
//
//  Created by Jeason on 20/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADNetworkConfigManager.h"
#import "ADNetworkConfigItem.h"

const NSString *kConnectCGIName = @"appcgi_connect";
const NSString *kRegisterCGIName = @"appcgi_register";
const NSString *kLoginCGIName = @"appcgi_login";
const NSString *kWXLoginCGIName = @"appcgi_wxlogin";
const NSString *kCheckLoginCGIName = @"appcgi_checklogin";
const NSString *kGetUserInfoCGIName = @"appcgi_getuserinfo";
const NSString *kWXBindAppCGIName = @"appcgi_wxbindapp";
const NSString *kAppBindWXCGIName = @"appcgi_appbindwx";

static NSMutableDictionary *allConfig;

@interface ADNetworkConfigManager ()

@property (nonatomic, strong) ADNetworkConfigItem *connectConfig;
@property (nonatomic, strong) ADNetworkConfigItem *registerConfig;
@property (nonatomic, strong) ADNetworkConfigItem *loginConfig;
@property (nonatomic, strong) ADNetworkConfigItem *wxLoginConfig;
@property (nonatomic, strong) ADNetworkConfigItem *checkLoginConfig;
@property (nonatomic, strong) ADNetworkConfigItem *getUserInfoConfig;
@property (nonatomic, strong) ADNetworkConfigItem *wxBindAppConfig;
@property (nonatomic, strong) ADNetworkConfigItem *appBindWxConfig;

@end

@implementation ADNetworkConfigManager

#pragma mark - Life Cycle
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static ADNetworkConfigManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ADNetworkConfigManager alloc] initInPrivate];
    });
    return instance;
}

- (instancetype)initInPrivate {
    if (self = [super init]) {
        allConfig = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)init {
    return nil;
}

- (instancetype)copy {
    return nil;
}

#pragma mark - Public Methods
- (void)setup {
    [self registerConfig:self.connectConfig
              forKeyPath:self.connectConfig.cgiName];
    [self registerConfig:self.registerConfig
              forKeyPath:self.registerConfig.cgiName];
    [self registerConfig:self.loginConfig
              forKeyPath:self.loginConfig.cgiName];
    [self registerConfig:self.wxLoginConfig
              forKeyPath:self.wxLoginConfig.cgiName];
    [self registerConfig:self.checkLoginConfig
              forKeyPath:self.checkLoginConfig.cgiName];
    [self registerConfig:self.getUserInfoConfig
              forKeyPath:self.getUserInfoConfig.cgiName];
    [self registerConfig:self.wxBindAppConfig
              forKeyPath:self.wxBindAppConfig.cgiName];
    [self registerConfig:self.appBindWxConfig
              forKeyPath:self.appBindWxConfig.cgiName];
}

- (void)registerConfig:(ADNetworkConfigItem *)item forKeyPath:(NSString *)keyPath {
    [allConfig setObject:item forKey:keyPath];
}

- (void)removeConfigForKeyPath:(NSString *)keyPath {
    [allConfig removeObjectForKey:keyPath];
}

- (ADNetworkConfigItem *)getConfigForKeyPath:(NSString *)keyPath {
    return [allConfig objectForKey:keyPath];
}

#pragma mark - Laze Initializers
- (ADNetworkConfigItem *)connectConfig {
    if (_connectConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kConnectCGIName,
                                     @"request_path": @"/demoapi/app/connect/appcgi_connect",
                                     @"encrypt_algorithm":@(EncryptAlgorithmRSA|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": kEncryptWholePacketParaKey,
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer"
                                     };
        _connectConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _connectConfig;
}

- (ADNetworkConfigItem *)registerConfig {
    if (_registerConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kRegisterCGIName,
                                     @"request_path": @"/demoapi/app/register/appcgi_register",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer"
                                     };
        _registerConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _registerConfig;
}

- (ADNetworkConfigItem *)loginConfig {
    if (_loginConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kLoginCGIName,
                                     @"request_path": @"/demoapi/app/login/appcgi_login",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer"
                                     };
        _loginConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _loginConfig;
}

- (ADNetworkConfigItem *)wxLoginConfig {
    if (_wxLoginConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kWXLoginCGIName,
                                     @"request_path": @"/demoapi/wx/login/appcgi_wxlogin",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer"
                                     };
        _wxLoginConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _wxLoginConfig;
}

- (ADNetworkConfigItem *)checkLoginConfig {
    if (_checkLoginConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kCheckLoginCGIName,
                                     @"request_path": @"/demoapi/app/ticket/checklogin/appcgi_checklogin",
                                     @"encrypt_algorithm":@(EncryptAlgorithmRSA|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": kEncryptWholePacketParaKey,
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer"
                                     };
        _checkLoginConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _checkLoginConfig;
}

- (ADNetworkConfigItem *)getUserInfoConfig {
    if (_getUserInfoConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kGetUserInfoCGIName,
                                     @"request_path": @"/demoapi/wx/getuserinfo/appcgi_getuserinfo",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer"
                                     };
        _getUserInfoConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _getUserInfoConfig;
}

- (ADNetworkConfigItem *)wxBindAppConfig {
    if (_wxBindAppConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kWXBindAppCGIName,
                                     @"request_path": @"/demoapi/wx/bindapp/appcgi_wxbindapp",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer"
                                     };
        _wxBindAppConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _wxBindAppConfig;
}

- (ADNetworkConfigItem *)appBindWxConfig {
    if (_appBindWxConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kAppBindWXCGIName,
                                     @"request_path": @"/demoapi/app/bindwx/appcgi_appbindwx",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer"
                                     };
        _appBindWxConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _appBindWxConfig;
}
@end