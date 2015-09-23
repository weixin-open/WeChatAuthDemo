//
//  WXApiManager.h
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/25/15.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "WXApiObject.h"

@protocol WXAuthDelegate <NSObject>

@optional
- (void)wxAuthSucceed:(NSString*)code;
- (void)wxAuthDenied;
- (void)wxAuthCancel;

@end

@interface WXApiManager : NSObject <WXApiDelegate>

@property (nonatomic, assign) id<WXAuthDelegate, NSObject> delegate;

/**
 *  严格单例，唯一获得实例的方法.
 *
 *  @return 实例对象.
 */
+ (instancetype)sharedManager;

/**
 *  发送微信验证请求.
 *
 *  @restrict 该方法支持未安装微信的用户.
 *
 *  @param viewController 发起验证的VC
 *  @param delegate       处理验证结果的代理
 */
- (void)sendAuthRequestWithController:(UIViewController*)viewController
                             delegate:(id<WXAuthDelegate>)delegate;

/**
 *  发送链接到微信.
 *
 *  @restrict 该方法要求用户一定要安装微信.
 *
 *  @param urlString 链接的Url
 *  @param title     链接的Title
 *  @param desc      链接的描述
 *  @param scene     发送的场景，分为朋友圈, 会话和收藏
 *
 *  @return 发送成功返回YES
 */
- (BOOL)sendLinkContent:(NSString *)urlString
                  Title:(NSString *)title
            Description:(NSString *)desc
                AtScene:(enum WXScene)scene;

@end
