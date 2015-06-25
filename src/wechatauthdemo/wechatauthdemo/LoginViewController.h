//
//  LoginViewController.h
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoManager.h"

@protocol LoginViewDelegate <NSObject>
- (void) presentHomeView;
- (void) presentAcctView;
- (InfoManager*) getInfoManager;
@end

@interface LoginViewController : UIViewController

@property (nonatomic, strong) UITextField* tf_username;
@property (nonatomic, strong) UITextField* tf_password;
@property (nonatomic, assign) id<LoginViewDelegate, NSObject> delegate;

@end
