//
//  DebugInfoViewController.h
//  wechatauthdemo
//
//  Created by WeChat on 15/10/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ADGetUserInfoResp;

@interface DebugInfoViewController : UITableViewController

@property (nonatomic, strong) ADGetUserInfoResp *userInfoResp;

@end
