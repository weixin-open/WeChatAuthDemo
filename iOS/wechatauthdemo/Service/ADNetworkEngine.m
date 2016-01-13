//
//  BaseNetWorkHandler.m
//  AuthSDKDemo
//
//  Created by WeChat on 11/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//
#import "ADNetworkEngine.h"
#import "ADNetworkConfigManager.h"
#import "JSONRequest.h"
#import "ErrorHandler.h"
#import "DataModels.h"

@implementation ADNetworkEngine

- (void)getCommentListForUin:(UInt32)uin
                        From:(NSString *)startId
              WithCompletion:(GetCommentListCallBack)completion {
    
    NSMutableDictionary *requestBuffer = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                                           @"uin": @(uin),
                                                                                           }];
    if (startId != nil) {
        requestBuffer[@"start_id"] = startId;
    }
    [[self.manager JSONTaskForHost:self.host
                              Para:@{
                                     @"uin": @(uin),
                                     @"req_buffer": requestBuffer
                                     }
                     ConfigKeyPath:(NSString *)kGetCommentListCGIName
                    WithCompletion:^(NSDictionary *dict, NSError *error) {
                        ADGetCommentListResp *resp = [ADGetCommentListResp modelObjectWithDictionary:dict];
                        [ErrorHandler handleNetworkExpiredError:resp.baseResp
                                            WhileCatchErrorCode:^(ADErrorCode code) {
                                                if (code == ADErrorCodeSessionKeyExpired) {
                                                    [self getCommentListForUin:uin
                                                                          From:startId
                                                                WithCompletion:completion];
                                                } else {
                                                    completion != nil ? completion (resp) : nil;
                                                }
                                            }];
                    }] resume];
}

- (void)getReplyListForUin:(UInt32)uin
                 OfComment:(NSString *)commentId
            WithCompletion:(GetReplyListCallBack)completion {
    [[self.manager JSONTaskForHost:self.host
                              Para:@{
                                     @"uin": @(uin),
                                     @"req_buffer": @{
                                             @"uin": @(uin),
                                             @"comment_id": commentId
                                             }
                                     }
                     ConfigKeyPath:(NSString *)kGetReplyListCGIName
                    WithCompletion:^(NSDictionary *dict, NSError *error) {
                        ADGetReplyListResp *resp = [ADGetReplyListResp modelObjectWithDictionary:dict];
                        [ErrorHandler handleNetworkExpiredError:resp.baseResp
                                            WhileCatchErrorCode:^(ADErrorCode code) {
                                                if (code == ADErrorCodeSessionKeyExpired) {
                                                    [self getReplyListForUin:uin
                                                                   OfComment:commentId
                                                              WithCompletion:completion];
                                                } else {
                                                    completion != nil ? completion (resp) : nil;
                                                }
                                            }];
                    }] resume];
}

- (void)addCommentContent:(NSString *)content
                   ForUin:(UInt32)uin
              LoginTicket:(NSString *)loginTicket
           WithCompletion:(AddCommentCallBack)completion {
    [[self.manager JSONTaskForHost:self.host
                              Para:@{
                                     @"uin": @(uin),
                                     @"req_buffer": @{
                                             @"uin": @(uin),
                                             @"login_ticket": loginTicket,
                                             @"content": content
                                             }
                                     }
                     ConfigKeyPath:(NSString *)kAddCommentCGIName
                    WithCompletion:^(NSDictionary *dict, NSError *error) {
                        ADAddCommentResp *resp = [ADAddCommentResp modelObjectWithDictionary:dict];
                        [ErrorHandler handleNetworkExpiredError:resp.baseResp
                                            WhileCatchErrorCode:^(ADErrorCode code) {
                                                if (code == ADErrorCodeSessionKeyExpired) {
                                                    [self addCommentContent:content
                                                                     ForUin:uin
                                                                LoginTicket:loginTicket
                                                             WithCompletion:completion];
                                                } else {
                                                    completion != nil ? completion (resp) : nil;
                                                }
                                            }];

                    }] resume];
}

- (void)addReplyContent:(NSString *)content
              ToComment:(NSString *)commentId
              OrToReply:(NSString *)replyId
                 ForUin:(UInt32)uin
            LoginTicket:(NSString *)loginTicket
         WithCompletion:(AddReplyCallBack)completion {
    
    JSONCallBack callBack = ^(NSDictionary *dict, NSError *error) {
        ADAddReplyResp *resp = [ADAddReplyResp modelObjectWithDictionary:dict];
        [ErrorHandler handleNetworkExpiredError:resp.baseResp
                            WhileCatchErrorCode:^(ADErrorCode code) {
                                if (code == ADErrorCodeSessionKeyExpired) {
                                    [self addReplyContent:content
                                                ToComment:commentId
                                                OrToReply:replyId
                                                   ForUin:uin
                                              LoginTicket:loginTicket
                                           WithCompletion:completion];
                                } else {
                                    completion != nil ? completion (resp) : nil;
                                }
                            }];
    };
    if (replyId == nil) {
        [[self.manager JSONTaskForHost:self.host
                                  Para:@{
                                         @"uin": @(uin),
                                         @"req_buffer": @{
                                                 @"uin": @(uin),
                                                 @"login_ticket": loginTicket,
                                                 @"comment_id": commentId,
                                                 @"content": content
                                                 }
                                         }
                         ConfigKeyPath:(NSString *)kAddReplyCGIName
                        WithCompletion:callBack] resume];
    } else {
        [[self.manager JSONTaskForHost:self.host
                                  Para:@{
                                         @"uin": @(uin),
                                         @"req_buffer": @{
                                                 @"uin": @(uin),
                                                 @"login_ticket": loginTicket,
                                                 @"comment_id": commentId,
                                                 @"reply_to_id": replyId,
                                                 @"content": content
                                                 }
                                         }
                         ConfigKeyPath:(NSString *)kAddReplyCGIName
                        WithCompletion:callBack] resume];
    }

}

@end