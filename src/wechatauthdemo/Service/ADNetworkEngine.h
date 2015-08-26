//
//  BaseNetWorkHandler.h
//  AuthSDKDemo
//
//  Created by Jeason on 11/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADConnectResp;
@class ADRegisterResp;
@class ADCheckLoginResp;
@class ADLoginResp;
@class ADGetUserInfoResp;
@class ADWXBindAPPResp;
@class ADAPPBindWXResp;
@class ADWXLoginResp;

typedef void(^ConnectCallBack)(ADConnectResp *resp);
typedef void(^RegisterCallBack)(ADRegisterResp *resp);
typedef void(^CheckLoginCallBack)(ADCheckLoginResp *resp);
typedef void(^LoginCallBack)(ADLoginResp *resp);
typedef void(^GetUserInfoCallBack)(ADGetUserInfoResp *resp);
typedef void(^WXBindAppCallBack)(ADWXBindAPPResp *resp);
typedef void(^AppBindWXCallBack)(ADAPPBindWXResp *resp);
typedef void(^WXLoginCallBack)(ADWXLoginResp *resp);
typedef void(^DownloadImageCallBack)(UIImage *image);

@interface ADNetworkEngine : NSObject

@property (nonatomic, strong) NSString *host;

+ (instancetype)sharedEngine;

- (void)connectToServerWithCompletion:(ConnectCallBack)completion;

- (void)registerForMail:(NSString *)mail
               Password:(NSString *)pwd
               NickName:(NSString *)nickName
              HeadImage:(NSData *)imageData
                    Sex:(ADSexType)sex
         WithCompletion:(RegisterCallBack)completion;

- (void)loginForMail:(NSString *)mail
            Password:(NSString *)pwd
      WithCompletion:(LoginCallBack)completion;

- (void)wxLoginForAuthCode:(NSString *)code
            WithCompletion:(WXLoginCallBack)completion;

- (void)checkLoginForUin:(UInt32)uin
             LoginTicket:(NSString *)loginTicket
          WithCompletion:(CheckLoginCallBack)completion;

- (void)getUserInfoForUin:(UInt32)uin
              LoginTicket:(NSString *)loginTicket
           WithCompletion:(GetUserInfoCallBack)completion;

- (void)wxBindAppForUin:(UInt32)uin
            LoginTicket:(NSString *)loginTicket
                   Mail:(NSString *)mail
               Password:(NSString *)pwd
               NickName:(NSString *)nickName
                    Sex:(ADSexType)sex
           HeadImageUrl:(NSString *)headImageUrl
             IsToCreate:(BOOL)isToCreate
         WithCompletion:(WXBindAppCallBack)completion;

- (void)appBindWxForUin:(UInt32)uin
            LoginTicket:(NSString *)loginTicket
               AuthCode:(NSString *)code
         WithCompletion:(AppBindWXCallBack)completion;

- (void)disConnect;

- (void)downloadImageForUrl:(NSString *)urlString
             WithCompletion:(DownloadImageCallBack)completion;

@end