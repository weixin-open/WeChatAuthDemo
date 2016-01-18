//
//  UserNickNameCell.m
//  wechatauthdemo
//
//  Created by WeChat on 15/10/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "UserNickNameCell.h"

static const CGFloat kTitleFontSize = 16.0f;

@interface UserNickNameCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation UserNickNameCell

- (void)awakeFromNib {
    // Initialization code
    self.nameLabel.font = [UIFont fontWithName:kChineseFont
                                          size:kTitleFontSize];
    self.titleLabel.font = [UIFont fontWithName:kChineseFont
                                           size:kTitleFontSize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
