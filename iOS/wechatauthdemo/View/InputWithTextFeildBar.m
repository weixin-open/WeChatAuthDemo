//
//  InputWithTextFeildBar.m
//  wechatauthdemo
//
//  Created by WeChat on 20/10/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "InputWithTextFeildBar.h"

static CGFloat const kTextFieldFontSize = 14.0f;

@implementation InputWithTextFeildBar

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.font = [UIFont fontWithName:kChineseFont
                                          size:kTextFieldFontSize];
}

@end
