//
//  UIViewController+ShakeDebug.m
//  wechatauthdemo
//
//  Created by Jeason on 18/09/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "ShakeDebug.h"
#import "LogTextViewController.h"

@implementation UIViewController (ShakeDebug)

#ifdef DEBUG
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [super motionEnded:motion withEvent:event];
    if (event.type == UIEventSubtypeMotionShake) {
        UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:[LogTextViewController sharedLogTextView]];
        [self.navigationController presentViewController:navigation
                                                animated:YES
                                              completion:nil];
    }
}
#endif

@end
