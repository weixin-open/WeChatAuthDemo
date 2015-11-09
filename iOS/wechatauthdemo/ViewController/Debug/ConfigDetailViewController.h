//
//  ConfigDetailViewController.h
//  wechatauthdemo
//
//  Created by Jeason on 15/09/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADNetworkConfigItem;

@interface ConfigDetailViewController : UITableViewController

@property (nonatomic, assign) ADNetworkConfigItem *configItem;

@end
