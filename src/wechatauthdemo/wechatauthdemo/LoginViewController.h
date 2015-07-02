//
//  LoginViewController.h
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiObject.h"
#import "InfoManager.h"
#import "WXAuthManager.h"
#import "NetworkManager.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate, WXAuthDelegate>

@property (nonatomic, retain) UITextField* tfMail;
@property (nonatomic, retain) UITextField* tfPassword;

@end
