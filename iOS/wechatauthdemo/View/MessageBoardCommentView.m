//
//  MessageBoardCommentView.m
//  wechatauthdemo
//
//  Created by WeChat on 19/10/2015.
//  Copyright © 2015 boshao. All rights reserved.
//

#import "MessageBoardCommentView.h"
#import "MessageBoardContentView.h"

@implementation MessageBoardCommentView

#pragma mark - Life Cycle
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.commentContent];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.commentContent.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

#pragma mark - Lazy Initializer
- (MessageBoardContentView *)commentContent {
    if (_commentContent == nil) {
        _commentContent = [[MessageBoardContentView alloc] init];
    }
    return _commentContent;
}

@end
