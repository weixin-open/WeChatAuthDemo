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
#import "WXAuthManager.h"
#import "NetworkManager.h"

@protocol HomeViewDelegate <NSObject>
- (void) presentLoginView;
- (void) presentRegView;
- (void) presentAcctView;
- (InfoManager*) getInfoManager;
- (WXAuthManager*) getWXAuthManager;
- (NetworkManager*) getNetworkManager;
@end

@interface HomeViewController : UIViewController <WXAuthDelegate>

@property (nonatomic, assign) id<HomeViewDelegate,NSObject> delegate;

@end

