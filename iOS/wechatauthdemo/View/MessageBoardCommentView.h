//
//  MessageBoardCommentView.h
//  wechatauthdemo
//
//  Created by WeChat on 19/10/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageBoardContentView;

@interface MessageBoardCommentView : UITableViewHeaderFooterView

@property (nonatomic, strong) MessageBoardContentView *commentContent;

@end
