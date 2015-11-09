//
//  MessageBoardContentView.h
//  wechatauthdemo
//
//  Created by Jeason on 19/10/2015.
//  Copyright © 2015 boshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADCommentList;
@class ADReplyList;

typedef void(^ClickContentCallBack)(void);

@interface MessageBoardContentView : UIView

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *timeStamp;
@property (nonatomic, strong) ClickContentCallBack clickCallBack;

- (void)configureViewWithComment:(ADCommentList *)comment;

- (void)configureViewWithReply:(ADReplyList *)reply;

+ (CGFloat)calcHeightForComment:(ADCommentList *)comment;

+ (CGFloat)calcHeightForReply:(ADReplyList *)reply;

@end
