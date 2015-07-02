//
//  NetworkManager.h
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/25/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NetworkManager : NSObject

- (void)wxLogin:(NSString*)code
        completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket, NSString* nickname, BOOL hasBindApp))handler;

- (void)appLogin:(NSString*)mail password:(NSString*)password
        completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket, NSString* nickname, BOOL hasBindWx))handler;

- (void)appRegAcct:(NSString*)mail password:(NSString*)password nickname:(NSString*)nickname
        completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket))handler;

- (void)wxBindApp:(NSNumber*)uid userticket:(NSString*)userticket mail:(NSString*)mail password:(NSString*)password completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket, NSString* nickname))handler;

- (void)wxBindNewApp:(NSNumber*)uid userticket:(NSString*)userticket mail:(NSString*)mail nickname:(NSString*)nickname password:(NSString*)password completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket, NSString* nickname))handler;

- (void)appBindWx:(NSNumber*)uid userticket:(NSString*)userticket code:(NSString*)code completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket))handler;

- (void)appUnbindWx:(NSNumber*)uid userticket:(NSString*)userticket completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket))handler;

- (void)getWxUserInfo:(NSNumber*)uid userticket:(NSString*)userticket realtime:(BOOL)realtime completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket, NSDictionary* info))handler;

- (void)getAppUserInfo:(NSNumber*)uid userticket:(NSString*)userticket realtime:(BOOL)realtime completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket, NSDictionary* info))handler;

- (void)refreshTicket:(NSNumber*)uid userticket:(NSString*)userticket completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket))handler;

@end
