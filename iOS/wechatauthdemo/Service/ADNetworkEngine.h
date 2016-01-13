//
//  BaseNetWorkHandler.h
//  AuthSDKDemo
//
//  Created by WeChat on 11/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetworkEngine.h"

@class ADGetCommentListResp;
@class ADGetReplyListResp;
@class ADAddCommentResp;
@class ADAddReplyResp;

typedef void(^GetCommentListCallBack)(ADGetCommentListResp *resp);
typedef void(^GetReplyListCallBack)(ADGetReplyListResp *resp);
typedef void(^AddCommentCallBack)(ADAddCommentResp *resp);
typedef void(^AddReplyCallBack)(ADAddReplyResp *resp);

@interface ADNetworkEngine : BaseNetworkEngine

/**
 *  获取某个startId之后的留言板的留言。
 *
 *  @restrict 可以在临时或正式安全通道里进行.
 *  
 *  @param uin 正式Uin
 *  @param startId 开始的留言Id，nil则为从头开始
 *  @param completion 获取完成的回调，参数包括留言列表，留言个数，每页的最多数量。
 */
- (void)getCommentListForUin:(UInt32)uin
                        From:(NSString *)startId
              WithCompletion:(GetCommentListCallBack)completion;

/**
 *  获取某个留言下的评论。
 *  
 *  @restrict 可以在临时或正式安全通道里进行.
 *
 *  @param uin 正式Uin
 *  @param commentId 该留言的Id
 *  @param completion 获取完成的回调.
 */
- (void)getReplyListForUin:(UInt32)uin
                 OfComment:(NSString *)commentId
            WithCompletion:(GetReplyListCallBack)completion;

/**
 *  发布一条留言
 *  
 *  @restrict 必须在正式安全通道里进行.
 *
 *  @param content 留言的文字
 *  @param uin 正式uin
 *  @param loginTicket 用户的登录票据
 *  @param completion 发布完成的回调
 *
 */
- (void)addCommentContent:(NSString *)content
                   ForUin:(UInt32)uin
              LoginTicket:(NSString *)loginTicket
           WithCompletion:(AddCommentCallBack)completion;

/**
 *  发布一条评论
 *
 *  @restrict 必须在正式安全通道里进行.
 *
 *  @param content
 *  @param commentId
 *  @param replyId
 *  @param uin
 *  @param loginTicket
 *  @param completion
 */
- (void)addReplyContent:(NSString *)content
              ToComment:(NSString *)commentId
              OrToReply:(NSString *)replyId
                 ForUin:(UInt32)uin
            LoginTicket:(NSString *)loginTicket
         WithCompletion:(AddReplyCallBack)completion;
@end