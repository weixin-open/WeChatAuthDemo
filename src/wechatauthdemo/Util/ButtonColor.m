//
//  UIColor+buttonColor.m
//  wechatauthdemo
//
//  Created by Jeason on 24/08/2015.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import "ButtonColor.h"

@implementation UIColor (buttonColor)

+ (instancetype)loginButtonColor {
    return [UIColor colorWithRed:0.04
                           green:0.73
                            blue:0.03
                           alpha:1.00];
}

+ (instancetype)linkButtonColor {
    return [UIColor colorWithRed:0.27
                           green:0.60
                            blue:0.91
                           alpha:1.00];
}

@end
