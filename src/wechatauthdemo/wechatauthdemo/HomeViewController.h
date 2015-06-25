//
//  ViewController.h
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/24/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApiObject.h"
#import "InfoManager.h"

@protocol HomeViewDelegate <NSObject>
- (void) sendAuthRequest;
- (void) presentLoginView;
- (void) presentRegView;
- (void) presentAcctView;
- (InfoManager*) getInfoManager;
@end

@interface HomeViewController : UIViewController

@property (nonatomic, assign) id<HomeViewDelegate,NSObject> delegate;

@end

