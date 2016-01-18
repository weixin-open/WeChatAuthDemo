//
//  UserHeadPhotoCell.m
//  wechatauthdemo
//
//  Created by WeChat on 15/10/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "UserHeadPhotoCell.h"

static const CGFloat kTitleFontSize = 19.0f;

@interface UserHeadPhotoCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation UserHeadPhotoCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLabel.font = [UIFont fontWithName:kChineseFont
                                           size:kTitleFontSize];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
