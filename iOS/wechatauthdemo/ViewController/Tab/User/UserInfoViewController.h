//
//  UserInfoViewController.h
//  wechatauthdemo
//
//  Created by Jeason on 15/10/2015.
//  Copyright © 2015 boshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADGetUserInfoResp;

@interface UserInfoViewController : UITableViewController

@property (nonatomic, strong) ADGetUserInfoResp *userInfoResp;

@end
