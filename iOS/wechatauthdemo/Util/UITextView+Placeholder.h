//
//  UITextView+Placeholder.h
//  wechatauthdemo
//
//  Created by Jeason on 18/09/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Placeholder)

@property (nonatomic, readonly) UILabel *placeholderLabel;

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;

@end
