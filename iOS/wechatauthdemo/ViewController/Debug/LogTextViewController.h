//
//  LogTextViewController.h
//  wechatauthdemo
//
//  Created by WeChat on 16/09/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogTextViewController : UIViewController

+ (instancetype)sharedLogTextView;

- (void)insertLog:(NSString *)log;

@property (nonatomic, assign) BOOL presented;

@end
