//
//  UILabel+AlertTitleFont.h
//  wechatauthdemo
//
//  Created by Jeason on 10/09/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (AlertTitleFont)

@property (nonatomic, copy) UIFont *alertTitleFont UI_APPEARANCE_SELECTOR;

@end

@interface UIButton (AlertTitleFont)

@property (nonatomic, copy) UIFont *alertTitleFont UI_APPEARANCE_SELECTOR;

@end
