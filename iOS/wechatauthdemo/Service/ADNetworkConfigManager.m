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
const NSString *kMakeExpiredCGIName = @"testfunc";
const NSString *kGetCommentListCGIName = @"appcgi_getCommentList";
const NSString *kGetReplyListCGIName = @"appcgi_getReplyList";
const NSString *kAddCommentCGIName = @"appcgi_addComment";
const NSString *kAddReplyCGIName = @"appcgi_addReply";

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
@property (nonatomic, strong) ADNetworkConfigItem *makeExpiredConfig;
@property (nonatomic, strong) ADNetworkConfigItem *getCommentListConfig;
@property (nonatomic, strong) ADNetworkConfigItem *getReplyListConfig;
@property (nonatomic, strong) ADNetworkConfigItem *addCommentConfig;
@property (nonatomic, strong) ADNetworkConfigItem *addReplyConfig;

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
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ADNetworkConfigAll"] == nil) {
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
        [self registerConfig:self.makeExpiredConfig
                  forKeyPath:self.makeExpiredConfig.cgiName];
        [self registerConfig:self.getCommentListConfig
                  forKeyPath:self.getCommentListConfig.cgiName];
        [self registerConfig:self.getReplyListConfig
                  forKeyPath:self.getReplyListConfig.cgiName];
        [self registerConfig:self.addCommentConfig
                  forKeyPath:self.addCommentConfig.cgiName];
        [self registerConfig:self.addReplyConfig
                  forKeyPath:self.addReplyConfig.cgiName];
        [self save];
    } else {
        NSData *configData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ADNetworkConfigAll"];
        allConfig = [NSKeyedUnarchiver unarchiveObjectWithData:configData];
    }
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

- (NSArray *)allConfigKeys {
    return [allConfig allKeys];
}

- (void)save {
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:allConfig]
                                              forKey:@"ADNetworkConfigAll"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Laze Initializer
- (ADNetworkConfigItem *)connectConfig {
    if (_connectConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kConnectCGIName,
                                     @"request_path": @"/wxoauth/demo/index.php?action=connect",
//                                     @"request_path": @"/demoapi/app/connect/appcgi_connect",
                                     @"encrypt_algorithm":@(EncryptAlgorithmRSA|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": kEncryptWholePacketParaKey,
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer",
                                     @"sys_err_key_path": @"errcode"
                                     };
        _connectConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _connectConfig;
}

- (ADNetworkConfigItem *)registerConfig {
    if (_registerConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kRegisterCGIName,
//                                     @"request_path": @"/demoapi/app/register/appcgi_register",
                                     @"request_path": @"/wxoauth/demo/index.php?action=register",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer",
                                     @"sys_err_key_path": @"errcode"
                                     };
        _registerConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _registerConfig;
}

- (ADNetworkConfigItem *)loginConfig {
    if (_loginConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kLoginCGIName,
//                                     @"request_path": @"/demoapi/app/login/appcgi_login",
                                     @"request_path": @"/wxoauth/demo/index.php?action=login",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer",
                                     @"sys_err_key_path": @"errcode"
                                     };
        _loginConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _loginConfig;
}

- (ADNetworkConfigItem *)wxLoginConfig {
    if (_wxLoginConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kWXLoginCGIName,
//                                     @"request_path": @"/demoapi/wx/login/appcgi_wxlogin",
                                     @"request_path": @"/wxoauth/demo/index.php?action=wxlogin",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer",
                                     @"sys_err_key_path": @"errcode"
                                     };
        _wxLoginConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _wxLoginConfig;
}

- (ADNetworkConfigItem *)checkLoginConfig {
    if (_checkLoginConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kCheckLoginCGIName,
//                                     @"request_path": @"/demoapi/app/ticket/checklogin/appcgi_checklogin",
                                     @"request_path": @"/wxoauth/demo/index.php?action=checklogin",
                                     @"encrypt_algorithm":@(EncryptAlgorithmRSA|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": kEncryptWholePacketParaKey,
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer",
                                     @"sys_err_key_path": @"errcode"
                                     };
        _checkLoginConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _checkLoginConfig;
}

- (ADNetworkConfigItem *)getUserInfoConfig {
    if (_getUserInfoConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kGetUserInfoCGIName,
//                                     @"request_path": @"/demoapi/wx/getuserinfo/appcgi_getuserinfo",
                                     @"request_path": @"/wxoauth/demo/index.php?action=getuserinfo",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer",
                                     @"sys_err_key_path": @"errcode"
                                     };
        _getUserInfoConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _getUserInfoConfig;
}

- (ADNetworkConfigItem *)wxBindAppConfig {
    if (_wxBindAppConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kWXBindAppCGIName,
//                                     @"request_path": @"/demoapi/wx/bindapp/appcgi_wxbindapp",
                                     @"request_path": @"/wxoauth/demo/index.php?action=wxbindapp",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer",
                                     @"sys_err_key_path": @"errcode"
                                     };
        _wxBindAppConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _wxBindAppConfig;
}

- (ADNetworkConfigItem *)appBindWxConfig {
    if (_appBindWxConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kAppBindWXCGIName,
//                                     @"request_path": @"/demoapi/app/bindwx/appcgi_appbindwx",
                                     @"request_path": @"/wxoauth/demo/index.php?action=appbindwx",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer",
                                     @"sys_err_key_path": @"errcode"
                                     };
        _appBindWxConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _appBindWxConfig;
}

- (ADNetworkConfigItem *)makeExpiredConfig {
    if (_makeExpiredConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kMakeExpiredCGIName,
//                                     @"request_path": @"/demoapi/testfunc",
                                     @"request_path": @"/wxoauth/demo/index.php?action=testfunc",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer",
                                     @"sys_err_key_path": @"errcode"
                                     };
        _makeExpiredConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _makeExpiredConfig;
}

- (ADNetworkConfigItem *)getCommentListConfig {
    if (_getCommentListConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kGetCommentListCGIName,
                                     //                                     @"request_path": @"/demoapi/app/bindwx/appcgi_appbindwx",
                                     @"request_path": @"/wxoauth/demo/index.php?action=commentlist",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer",
                                     @"sys_err_key_path": @"errcode"
                                     };
        _getCommentListConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];

    }
    return _getCommentListConfig;
}

- (ADNetworkConfigItem *)getReplyListConfig {
    if (_getReplyListConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kGetReplyListCGIName,
                                     //                                     @"request_path": @"/demoapi/app/bindwx/appcgi_appbindwx",
                                     @"request_path": @"/wxoauth/demo/index.php?action=replylist",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer",
                                     @"sys_err_key_path": @"errcode"
                                     };
        _getReplyListConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];

    }
    return _getReplyListConfig;
}

- (ADNetworkConfigItem *)addCommentConfig {
    if (_addCommentConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kAddCommentCGIName,
                                     //                                     @"request_path": @"/demoapi/app/bindwx/appcgi_appbindwx",
                                     @"request_path": @"/wxoauth/demo/index.php?action=addcomment",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer",
                                     @"sys_err_key_path": @"errcode"
                                     };
        _addCommentConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _addCommentConfig;
}

- (ADNetworkConfigItem *)addReplyConfig {
    if (_addReplyConfig == nil) {
        NSDictionary *configDict = @{
                                     @"cgi_name": kAddReplyCGIName,
                                     //                                     @"request_path": @"/demoapi/app/bindwx/appcgi_appbindwx",
                                     @"request_path": @"/wxoauth/demo/index.php?action=addreply",
                                     @"encrypt_algorithm":@(EncryptAlgorithmAES|EncryptAlgorithmBase64),
                                     @"encrypt_key_path": @"req_buffer",
                                     @"decrypt_algorithm": @(EncryptAlgorithmBase64|EncryptAlgorithmAES),
                                     @"http_method": @"POST",
                                     @"decrypt_key_path": @"resp_buffer",
                                     @"sys_err_key_path": @"errcode"
                                     };
        _addReplyConfig = [ADNetworkConfigItem modelObjectWithDictionary:configDict];
    }
    return _addReplyConfig;
}
@end