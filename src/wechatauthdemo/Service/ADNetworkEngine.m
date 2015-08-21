//
//  BaseNetWorkHandler.m
//  AuthSDKDemo
//
//  Created by Jeason on 11/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//
#import "ADNetworkEngine.h"
#import "ADNetworkConfigManager.h"
#import "JSONRequest.h"
#import "RSA.h"
#import "AES.h"
#import "MD5.h"
#import "RandomKey.h"
#import "DataModels.h"

static NSString *defaultHost = @"http://qytest.weixin.qq.com";
static NSString *publickeyFileName = @"rsa_public";

typedef enum {
    ADNetworkEngineStateStop = 0,
    ADNetworkEngineStateHaveConnected = 1 << 0,
    ADNetworkEngineStateHaveWXLogin = 1 << 1,
    ADNetworkEngineStateHaveLoginAPP = 1 << 2,
    ADNetworkEngineStateHaveCheckLogin = 1 << 3
} ADNetworkEngineState;

/**
 *  Two Flow Chart for State Conversion
 *  1.   Stop----->Connected------------------>WXLogin--------->CheckLogin
 *  CGI: NoneCGI-->Register/WXLogin/LoginApp-->CheckLogin------>WXBindApp,GetUserInfo
 *
 *  2.   Stop----->Connected------------------>AppLogin--------->CheckLogin
 *  CGI: NoneCGI-->Register/WXLogin/LoginApp-->CheckLogin------->AppBindWX,GetUserInfo
 */

@interface ADNetworkEngine ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *RSAKey;
@property (nonatomic, assign) ADNetworkEngineState state;

@end

@implementation ADNetworkEngine

#pragma mark - Life Cycle
+ (instancetype)sharedEngine {
    static dispatch_once_t onceToken;
    static ADNetworkEngine *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ADNetworkEngine alloc] initWithHost:defaultHost];
        instance.state = ADNetworkEngineStateStop;
    });
    return instance;
}

- (instancetype)initWithHost:(NSString *)host {
    if (self = [super init]) {
        self.host = host;
        self.state = ADNetworkEngineStateStop;
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
- (void)connectToServerWithCompletion:(ConnectCallBack)completion {
//    NSAssert(self.state == ADNetworkEngineStateStop, @"You Can Not Connect Until You Clear Pre-Session Key");
    
    [[self.session JSONTaskForHost:self.host
                              Para:@{
                                     @"psk": self.session.sessionKey
                                     }
                     ConfigKeyPath:(NSString *)kConnectCGIName
                    WithCompletion:^(NSDictionary *dict, NSError *error) {
                        if (completion)
                            completion (error == nil ? [ADConnectResp modelObjectWithDictionary:dict] : nil);
                    }] resume];
}

- (void)registerForMail:(NSString *)mail
               Password:(NSString *)pwd
               NickName:(NSString *)nickName
                    Sex:(ADSexType)sex
         WithCompletion:(RegisterCallBack)completion {
    NSParameterAssert(mail && pwd && nickName);
//    NSAssert(self.state != ADNetworkEngineStateHaveConnected, @"You Can Not Register New Account Until You Have Connected");
    
    [[self.session JSONTaskForHost:self.host
                              Para:@{
                                     @"uin": @([ADUserInfo currentUser].uin),
                                     @"req_buffer": @{
                                             @"mail": mail,
                                             @"pwd_h1": pwd,
                                             @"nickname": nickName,
                                             @"sex": @(sex),
                                             }
                                     }
                     ConfigKeyPath:(NSString *)kRegisterCGIName
                    WithCompletion:^(NSDictionary *dict, NSError *error) {
                        if (completion)
                            completion (error == nil ? [ADRegisterResp modelObjectWithDictionary:dict] : nil);
                    }] resume];
}

- (void)loginForMail:(NSString *)mail
            Password:(NSString *)pwd
      WithCompletion:(LoginCallBack)completion {
    NSParameterAssert(mail);
//    NSAssert(self.state != ADNetworkEngineStateHaveConnected, @"You Can Not Login With Account Until You Have Connected");
    
    [[self.session JSONTaskForHost:self.host
                              Para:@{
                                     @"uin": @([ADUserInfo currentUser].uin),
                                     @"req_buffer": @{
                                             @"mail": mail,
                                             @"pwd_h1": pwd
                                             }
                                     }
                     ConfigKeyPath:(NSString *)kLoginCGIName
                    WithCompletion:^(NSDictionary *dict, NSError *error) {
                        if (completion)
                            completion (error == nil ? [ADLoginResp modelObjectWithDictionary:dict] : nil);
                    }] resume];
}

- (void)wxLoginForAuthCode:(NSString *)code
            WithCompletion:(WXLoginCallBack)completion {
    NSParameterAssert(code);
//    NSAssert(self.state != ADNetworkEngineStateHaveConnected, @"You Can Not Login With WeChat Until You Have Connected");
    
    [[self.session JSONTaskForHost:self.host
                              Para:@{
                                     @"uin": @([ADUserInfo currentUser].uin),
                                     @"req_buffer": @{
                                             @"code": code
                                             }
                                     }
                     ConfigKeyPath:(NSString *)kWXLoginCGIName
                    WithCompletion:^(NSDictionary *dict, NSError *error) {
                        if (completion)
                            completion (error == nil ? [ADWXLoginResp modelObjectWithDictionary:dict] : nil);
                    }] resume];
}

- (void)checkLoginForUin:(UInt32)uin
             LoginTicket:(NSString *)loginTicket
          WithCompletion:(CheckLoginCallBack)completion {
    NSParameterAssert(loginTicket);
//    NSAssert(self.state != ADNetworkEngineStateHaveWXLogin || self.state != ADNetworkEngineStateHaveLoginAPP,
//             @"You Should CheckLogin ONLY After You Have Login With Account Or Login With WeChat");
    
    [[self.session JSONTaskForHost:self.host
                              Para:@{
                                     @"uin": @(uin),
                                     @"login_ticket": loginTicket,
                                     @"tmp_key": self.session.sessionKey
                                     }
                     ConfigKeyPath:(NSString *)kCheckLoginCGIName
                    WithCompletion:^(NSDictionary *dict, NSError *error) {
                        ADCheckLoginResp *resp = nil;
                        if (error == nil) {
                            resp = [ADCheckLoginResp modelObjectWithDictionary:dict];
                            self.session.sessionKey = resp.sessionKey;
                        }
                        if (completion)
                            completion(resp);
                    }] resume];
}

- (void)getUserInfoForUin:(UInt32)uin
              LoginTicket:(NSString *)loginTicket
           WithCompletion:(GetUserInfoCallBack)completion {
    NSParameterAssert(loginTicket);
//    NSAssert(self.state & ADNetworkEngineStateHaveCheckLogin, @"You Can Not Get UserInfo Until CheckLogin");
    
    [[self.session JSONTaskForHost:self.host
                              Para:@{
                                     @"uin": @(uin),
                                     @"req_buffer": @{
                                             @"login_ticket": loginTicket,
                                             @"uin": @(uin)
                                             }
                                     }
                     ConfigKeyPath:(NSString *)kGetUserInfoCGIName
                    WithCompletion:^(NSDictionary *dict, NSError *error) {
                        if (completion)
                            completion (error == nil ? [ADGetUserInfoResp modelObjectWithDictionary:dict] : nil);
                    }] resume];
}

- (void)wxBindAppForUin:(UInt32)uin
            LoginTicket:(NSString *)loginTicket
                   Mail:(NSString *)mail
               Password:(NSString *)pwd
               NickName:(NSString *)nickName
                    Sex:(ADSexType)sex
           HeadImageUrl:(NSString *)headImageUrl
             IsToCreate:(BOOL)isToCreate
         WithCompletion:(WXBindAppCallBack)completion {
    NSParameterAssert(loginTicket && mail && pwd && nickName && headImageUrl);
//    NSAssert((self.state & ADNetworkEngineStateHaveCheckLogin) && (self.state & ADNetworkEngineStateHaveWXLogin),
//             @"You Can Bind App ONLY When You Login With WeChat And Have CheckedLogin");
    
    [[self.session JSONTaskForHost:self.host
                              Para:@{
                                     @"uin": @(uin),
                                     @"req_buffer": @{
                                             @"login_ticket": loginTicket,
                                             @"mail": mail,
                                             @"pwd_h1": pwd,
                                             @"nickname": nickName,
                                             @"sex": @(sex),
                                             @"headimgurl": headImageUrl,
                                             @"is_to_create": @(isToCreate)
                                             }
                                     }
                     ConfigKeyPath:(NSString *)kWXBindAppCGIName
                    WithCompletion:^(NSDictionary *dict, NSError *error) {
                        if (completion)
                            completion (error == nil ? [ADWXBindAPPResp modelObjectWithDictionary:dict] : nil);
                    }] resume];
}

- (void)appBindWxForUin:(UInt32)uin
            LoginTicket:(NSString *)loginTicket
               AuthCode:(NSString *)code
         WithCompletion:(AppBindWXCallBack)completion {
    NSParameterAssert(loginTicket && code);
//    NSAssert((self.state & ADNetworkEngineStateHaveLoginAPP) && (self.state & ADNetworkEngineStateHaveCheckLogin),
//             @"You Can Bind WX ONLY When You Login With Account And Have CheckedLogin");
    
    [[self.session JSONTaskForHost:self.host
                              Para:@{
                                     @"uin": @(uin),
                                     @"req_buffer": @{
                                             @"login_ticket": loginTicket,
                                             @"code": code
                                             }
                                     }
                     ConfigKeyPath:(NSString *)kAppBindWXCGIName
                    WithCompletion:^(NSDictionary *dict, NSError *error) {
                        if (completion)
                            completion (error == nil ? [ADAPPBindWXResp modelObjectWithDictionary:dict] : nil);
                    }] resume];
}

#pragma mark - Lazy Initializer
- (NSURLSession *)session {
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
        _session.sessionKey = @"31323334353637383930313233343536";
        _session.publicKey = self.RSAKey;
    }
    return _session;
}

- (NSString *)RSAKey {
    if (_RSAKey == nil) {
        NSString *keyPath = [[NSBundle mainBundle] pathForResource:publickeyFileName ofType:@"key"];
        NSData *keyData = [[NSFileManager defaultManager] contentsAtPath:keyPath];
        _RSAKey = [[NSString alloc] initWithData:keyData encoding:NSUTF8StringEncoding];
    }
    return _RSAKey;
}

@end