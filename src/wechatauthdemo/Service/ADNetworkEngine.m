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
#import "ErrorHandler.h"
#import "RandomKey.h"
#import "DataModels.h"
#import "ImageCache.h"

static NSString* const defaultHost = @"http://qytest.weixin.qq.com";
static NSString* const publickeyFileName = @"rsa_public";

@interface ADNetworkEngine ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *RSAKey;

@end

@implementation ADNetworkEngine

#pragma mark - Life Cycle
+ (instancetype)sharedEngine {
    static dispatch_once_t onceToken;
    static ADNetworkEngine *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ADNetworkEngine alloc] initWithHost:defaultHost];
    });
    return instance;
}

- (instancetype)initWithHost:(NSString *)host {
    if (self = [super init]) {
        self.host = host;
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
              HeadImage:(NSData *)imageData
                    Sex:(ADSexType)sex
         WithCompletion:(RegisterCallBack)completion {
    NSParameterAssert(mail && pwd && nickName && imageData);
    [[self.session JSONTaskForHost:self.host
                              Para:@{
                                      @"uin": @([ADUserInfo currentUser].uin),
                                      @"req_buffer": @{
                                              @"headimg_buf":[imageData base64EncodedStringWithOptions:0],
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
                        ADGetUserInfoResp *resp = [ADGetUserInfoResp modelObjectWithDictionary:dict];
                        [ErrorHandler handleNetworkExpiredError:resp.baseResp
                                            WhileCatchErrorCode:^(ADErrorCode code) {
                                                if (code == ADErrorCodeSessionKeyExpired) {
                                                    [self getUserInfoForUin:uin
                                                                LoginTicket:loginTicket
                                                             WithCompletion:completion];
                                                } else {
                                                    completion != nil ? completion (resp) : nil;
                                                }
                                            }];
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
    [[self.session JSONTaskForHost:self.host
                              Para:@{
                                      @"uin": @(uin),
                                      @"req_buffer": @{
                                              @"uin": @(uin),
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
                        ADWXBindAPPResp *resp = [ADWXBindAPPResp modelObjectWithDictionary:dict];
                        [ErrorHandler handleNetworkExpiredError:resp.baseResp
                                            WhileCatchErrorCode:^(ADErrorCode code) {
                                                if (code == ADErrorCodeSessionKeyExpired) {
                                                    [self wxBindAppForUin:uin
                                                              LoginTicket:loginTicket
                                                                     Mail:mail
                                                                 Password:pwd
                                                                 NickName:nickName
                                                                      Sex:sex
                                                             HeadImageUrl:headImageUrl
                                                               IsToCreate:isToCreate
                                                           WithCompletion:completion];
                                                } else {
                                                    completion != nil ? completion (resp) : nil;
                                                }
                                            }];
                    }] resume];
}

- (void)appBindWxForUin:(UInt32)uin
            LoginTicket:(NSString *)loginTicket
               AuthCode:(NSString *)code
         WithCompletion:(AppBindWXCallBack)completion {
    NSParameterAssert(loginTicket && code);
    [[self.session JSONTaskForHost:self.host
                              Para:@{
                                      @"uin": @(uin),
                                      @"req_buffer": @{
                                              @"uin": @(uin),
                                              @"login_ticket": loginTicket,
                                              @"code": code
                                      }
                              }
                     ConfigKeyPath:(NSString *)kAppBindWXCGIName
                    WithCompletion:^(NSDictionary *dict, NSError *error) {
                        ADAPPBindWXResp *resp = [ADAPPBindWXResp modelObjectWithDictionary:dict];
                        [ErrorHandler handleNetworkExpiredError:resp.baseResp
                                            WhileCatchErrorCode:^(ADErrorCode errorCode) {
                                                if (errorCode == ADErrorCodeSessionKeyExpired) {
                                                    [self appBindWxForUin:uin
                                                              LoginTicket:loginTicket
                                                                 AuthCode:code
                                                           WithCompletion:completion];
                                                } else {
                                                    completion != nil ? completion (resp) : nil;
                                                }
                                            }];
                    }] resume];
}

- (void)disConnect {
    self.session = nil;
}

- (void)downloadImageForUrl:(NSString *)urlString
             WithCompletion:(DownloadImageCallBack)completion {
    if (!urlString || !completion)
        return;
    UIImage *cachedImage = [UIImage getCachedImageForUrl:urlString];
    if (cachedImage) {
        NSLog(@"Cache Hit");
        completion (cachedImage);
    } else {
        NSLog(@"Cache Miss");
        NSURL *url = [NSURL URLWithString:urlString];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *image = [UIImage imageWithData:data];
                [image cacheForUrl:urlString];
                completion (image);
            });
        });
    }
}

- (void)makeRefreshTokenExpired:(UInt32)uin
                    LoginTicket:(NSString *)loginTicket {
    [[self.session JSONTaskForHost:self.host
                             Para:@{
                                    @"uin": @(uin),
                                    @"req_buffer": @{
                                            @"uin": @(uin),
                                            @"login_ticket": loginTicket
                                            }
                                    }
                    ConfigKeyPath:(NSString *)kMakeExpiredCGIName
                   WithCompletion:^(NSDictionary *dict, NSError *error) {
                       NSLog(@"%@",dict);
                   }] resume];
}

#pragma mark - Lazy Initializer
- (NSURLSession *)session {
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
        _session.sessionKey = [NSString randomKey];
        _session.publicKey = self.RSAKey;
    }
    return _session;
}

- (NSString *)RSAKey {
    if (_RSAKey == nil) {
        NSString *keyPath = [[NSBundle mainBundle] pathForResource:publickeyFileName ofType:@"key"];
        NSData *keyData = [[NSFileManager defaultManager] contentsAtPath:keyPath];
        _RSAKey = [[NSString alloc] initWithData:keyData
                                        encoding:NSUTF8StringEncoding];
    }
    return _RSAKey;
}

@end