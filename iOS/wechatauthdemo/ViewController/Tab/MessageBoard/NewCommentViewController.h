//
//  NewCommentViewController.h
//  wechatauthdemo
//
//  Created by Jeason on 19/10/2015.
//  Copyright © 2015 boshao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewCommentViewController;

@protocol NewCommentViewControllerDelegate <NSObject>

@optional
- (void)onNewCommentDidFinish;

@end

@interface NewCommentViewController : UIViewController

@property (nonatomic, assign) id<NewCommentViewControllerDelegate> delegate;

@end
