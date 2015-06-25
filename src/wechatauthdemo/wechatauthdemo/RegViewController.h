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

@protocol RegViewDelegate <NSObject>
- (void) presentHomeView;
- (void) presentAcctView;
- (InfoManager*) getInfoManager;
- (NetworkManager*) getNetworkManager;
@end


@interface RegViewController : UIViewController

@property (nonatomic, strong) UITextField* tf_username;
@property (nonatomic, strong) UITextField* tf_password;
@property (nonatomic, strong) UITextField* tf_confirm;
@property (nonatomic, assign) id<RegViewDelegate, NSObject> delegate;

@end
