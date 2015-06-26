//
//  RegViewController.h
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoManager.h"
#import "NetworkManager.h"

@interface RegViewController : UIViewController

@property (nonatomic, strong) UITextField* tfUserName;
@property (nonatomic, strong) UITextField* tfPassword;
@property (nonatomic, strong) UITextField* tfConfirm;

@end
