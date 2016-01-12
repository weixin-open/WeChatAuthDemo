//
//  HistoryViewController.h
//  AuthSDKDemo
//
//  Created by WeChat on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADHistoryViewController : UITableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
                   AccessLogs:(NSArray *)accessLogArray;
@end
