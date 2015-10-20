//
//  MessageBoardReplyCell.m
//  wechatauthdemo
//
//  Created by Jeason on 19/10/2015.
//  Copyright © 2015 boshao. All rights reserved.
//

#import "MessageBoardReplyCell.h"
#import "MessageBoardContentView.h"

@implementation MessageBoardReplyCell

#pragma mark - Life Cycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.replyContentView = [[MessageBoardContentView alloc] init];
        [self.contentView addSubview:self.replyContentView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.replyContentView.frame = CGRectMake(inset*4,
                                             0,
                                             CGRectGetWidth(self.frame)-inset*4,
                                             CGRectGetHeight(self.frame));
}

@end
