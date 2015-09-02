//
//  Constant.h
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#ifndef AuthSDKDemo_Constant_h
#define AuthSDKDemo_Constant_h
#import <Foundation/Foundation.h>

static const int inset = 10;
static const int navigationBarHeight = 44;
static const int statusBarHeight = 20;
static const int normalHeight = 44;
static const float kLoginButtonCornerRadius = 4.0f;
static int64_t kRefreshTokenTimeNone = 2592000;
static int64_t kAccessTokenTimeNone = 0;
static NSString *kTitleLabelFont = @"STHeitiSC-Light";
static NSString *kEnglishNumberFont = @"HelveticaNeue";

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#endif
