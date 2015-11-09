//
//  AppDelegate.h
//  AuthSDKDemo
//
//  Created by Jeason on 10/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DocumentsViewController;
@class UserInfoViewController;
@class MessageBoardViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) DocumentsViewController *documentsView;
@property (nonatomic, strong) UserInfoViewController *userInfoView;
@property (nonatomic, strong) MessageBoardViewController *messageBoardView;
@property (nonatomic, assign) BOOL keyboardWasShown;

@end

