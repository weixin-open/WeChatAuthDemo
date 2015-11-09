//
//  UILabel+AlertTitleFont.m
//  wechatauthdemo
//
//  Created by Jeason on 10/09/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "AlertTitleFont.h"

@implementation UILabel (AlertTitleFont)

- (void)setAlertTitleFont:(UIFont *)alertTitleFont {
    self.font = alertTitleFont;
}

- (UIFont *)alertTitleFont {
    return self.font;
}

@end

@implementation UIButton (AlertTitleFont)

- (void)setAlertTitleFont:(UIFont *)alertTitleFont {
    self.titleLabel.font = alertTitleFont;
}

- (UIFont *)alertTitleFont {
    return self.titleLabel.font;
}
@end
