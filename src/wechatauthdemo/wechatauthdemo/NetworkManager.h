//
//  NetworkManager.h
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/25/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkManager : NSObject

- (void)getWeChatInfoByCode:(NSString*)code
          completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler;
- (void) loginAcct:(NSString*)username byPwd:(NSString*)password
          completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler;
- (void)regAcct:(NSString*)username withPwd:(NSString*)password
          completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler;
@end
