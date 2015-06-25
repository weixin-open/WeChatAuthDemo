//
//  AcctViewController.h
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoManager.h"

@protocol AcctViewDelegate <NSObject>
- (void) presentHomeView;
- (void) presentLoginView;
- (void) presentRegView;
- (void) sendAuthRequest;
- (InfoManager*) getInfoManager;
@end

@interface AcctViewController : UIViewController

@property (nonatomic, assign) id<AcctViewDelegate, NSObject> delegate;

@end
