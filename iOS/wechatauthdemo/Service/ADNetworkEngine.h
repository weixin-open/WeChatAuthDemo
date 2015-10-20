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
@class ADGetCommentListResp;
@class ADGetReplyListResp;
@class ADAddCommentResp;
@class ADAddReplyResp;

typedef void(^ConnectCallBack)(ADConnectResp *resp);
typedef void(^RegisterCallBack)(ADRegisterResp *resp);
typedef void(^CheckLoginCallBack)(ADCheckLoginResp *resp);
typedef void(^LoginCallBack)(ADLoginResp *resp);
typedef void(^GetUserInfoCallBack)(ADGetUserInfoResp *resp);
typedef void(^WXBindAppCallBack)(ADWXBindAPPResp *resp);
typedef void(^AppBindWXCallBack)(ADAPPBindWXResp *resp);
typedef void(^WXLoginCallBack)(ADWXLoginResp *resp);
typedef void(^DownloadImageCallBack)(UIImage *image);
typedef void(^GetCommentListCallBack)(ADGetCommentListResp *resp);
typedef void(^GetReplyListCallBack)(ADGetReplyListResp *resp);
typedef void(^AddCommentCallBack)(ADAddCommentResp *resp);
typedef void(^AddReplyCallBack)(ADAddReplyResp *resp);

@interface ADNetworkEngine : NSObject

@property (nonatomic, strong) NSString *host;

/**
 *  严格单例，唯一获得实例的方法.
 *
 *  @return 实例对象.
 */
+ (instancetype)sharedEngine;

/**
 *  与服务器握手，交换psk建立登陆前的安全通道.
 *
 *  @abstract 客户端通过RSA加密一个随机密钥psk给服务器，服务器解密后保存.
 *  之后双方的通信（登陆前）都采用psk作为key进行AES加密报文.
 *
 *  @param completion 握手完成的回调，参数包括一个临时的Uin，以后的请求都需要带上这个Uin以让服务器可以索引到对应的psk.
 */
- (void)connectToServerWithCompletion:(ConnectCallBack)completion;

/**
 *  注册账号.
 *
 *  @restrict 必须在登陆前安全通道进行.
 *
 *  @param mail       邮箱账号
 *  @param pwd        密码（明文MD5后）
 *  @param nickName   昵称
 *  @param imageData  头像数据
 *  @param sex        性别
 *  @param completion 注册完成的回调，参数包括一个正式的Uin和登陆票据
 */
- (void)registerForMail:(NSString *)mail
               Password:(NSString *)pwd
               NickName:(NSString *)nickName
              HeadImage:(NSData *)imageData
                    Sex:(ADSexType)sex
         WithCompletion:(RegisterCallBack)completion;

/**
 *  登录.
 *
 *  @restrict 必须在登陆前安全通道进行.
 *
 *  @param mail       邮箱账号
 *  @param pwd        密码（明文MD5后）
 *  @param completion 登陆完成的回调，参数包括一个正式的Uin和登陆票据
 */
- (void)loginForMail:(NSString *)mail
            Password:(NSString *)pwd
      WithCompletion:(LoginCallBack)completion;

/**
 *  微信登录.
 *
 *  @restrict 必须在登陆前安全通道进行.
 *
 *  @param code       微信授权后获得的code
 *  @param completion 微信登录完成的回调，参数包括一个正式Uin和登陆票据
 */
- (void)wxLoginForAuthCode:(NSString *)code
            WithCompletion:(WXLoginCallBack)completion;

/**
 *  用正式Uin和登录票据进行登录服务器，建立服务器和客户端之间正式安全通道.
 *
 *  @abstract 可以理解为这一步才是真正的登录，前面的注册/登录/微信登录只是为了换取登录票据.
 *  客户端通过RSA加密{uin，loginTicket, 一个临时密钥tempKey}给服务器，然后检查Uin和LoginTicket,
 *  用tempKey加密这个请求的回包，回包里包括了这个会话之后的密钥SessionKey，以后就用这个SessionKey加密通信.
 *
 *  @param uin         正式Uin
 *  @param loginTicket 登录票据
 *  @param completion  正式安全通道建立完成的回调，参数包括SessionKey和SessionKey过期时间
 */
- (void)checkLoginForUin:(UInt32)uin
             LoginTicket:(NSString *)loginTicket
          WithCompletion:(CheckLoginCallBack)completion;

/**
 *  获得用户信息.
 *
 *  @restrict 必须在正式安全通道里进行.
 *
 *  @param uin         正式Uin
 *  @param loginTicket 登录票据
 *  @param completion  获得用户信息完成的回调，参数包括用户的一些基本信息.
 */
- (void)getUserInfoForUin:(UInt32)uin
              LoginTicket:(NSString *)loginTicket
           WithCompletion:(GetUserInfoCallBack)completion;

/**
 *  微信登录后绑定App账号.
 *
 *  @restrict 必须在正式安全通道里进行.
 *
 *  @param uin          正式的Uin
 *  @param loginTicket  登录票据
 *  @param mail         邮箱账号
 *  @param pwd          密码（明文MD5后）
 *  @param nickName     昵称
 *  @param sex          性别
 *  @param headImageUrl 头像Url
 *  @param isToCreate   邮箱是否是未注册的新用户
 *  @param completion   绑定完成的回调，参数包括新的Uin和登陆票据
 */
- (void)wxBindAppForUin:(UInt32)uin
            LoginTicket:(NSString *)loginTicket
                   Mail:(NSString *)mail
               Password:(NSString *)pwd
               NickName:(NSString *)nickName
                    Sex:(ADSexType)sex
           HeadImageUrl:(NSString *)headImageUrl
             IsToCreate:(BOOL)isToCreate
         WithCompletion:(WXBindAppCallBack)completion;

/**
 *  App登录后绑定微信号.
 *
 *  @restrict 必须在正式安全通道里进行.
 *
 *  @param uin         正式的Uin
 *  @param loginTicket 登录票据
 *  @param code        微信授权获得的Code
 *  @param completion  绑定完成的回调，参数包括新的Uin和登陆票据.
 */
- (void)appBindWxForUin:(UInt32)uin
            LoginTicket:(NSString *)loginTicket
               AuthCode:(NSString *)code
         WithCompletion:(AppBindWXCallBack)completion;

/**
 *  退出登录.
 */
- (void)disConnect;

/**
 *  下载或从缓存里获得一张图像数据.
 *
 *  @param urlString  图像Url
 *  @param completion 获得完成的回调，参数包括图像数据.
 */
- (void)downloadImageForUrl:(NSString *)urlString
             WithCompletion:(DownloadImageCallBack)completion;

/**
 *  测试功能，强制让Refresh Token快速过期，以让App展现提示用户重新授权/登录的行为.
 *
 *  @restrict 必须在正式安全通道里进行.
 *
 *  @param uin 正式Uin
 *  @param loginTicket 登录票据
 */
- (void)makeRefreshTokenExpired:(UInt32)uin LoginTicket:(NSString *)loginTicket;

- (void)getCommentListForUin:(UInt32)uin
                        From:(NSString *)startId
              WithCompletion:(GetCommentListCallBack)completion;

- (void)getReplyListForUin:(UInt32)uin
                 OfComment:(NSString *)commentId
            WithCompletion:(GetReplyListCallBack)completion;

- (void)addCommentContent:(NSString *)content
                   ForUin:(UInt32)uin
              LoginTicket:(NSString *)loginTicket
           WithCompletion:(AddCommentCallBack)completion;

- (void)addReplyContent:(NSString *)content
              ToComment:(NSString *)commentId
              OrToReply:(NSString *)replyId
                 ForUin:(UInt32)uin
            LoginTicket:(NSString *)loginTicket
         WithCompletion:(AddReplyCallBack)completion;
@end