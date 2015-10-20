//
//  InputWithTextFeildBar.m
//  wechatauthdemo
//
//  Created by Jeason on 20/10/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "InputWithTextFeildBar.h"

@implementation InputWithTextFeildBar

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.font = [UIFont fontWithName:kChineseFont
                                          size:14.0f];
}

@end
