//
//  UIViewController+ShakeDebug.m
//  wechatauthdemo
//
//  Created by Jeason on 18/09/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "ShakeDebug.h"
#import "LogTextViewController.h"

#ifdef DEBUG
@implementation UIViewController (ShakeDebug)
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventSubtypeMotionShake
        && [LogTextViewController sharedLogTextView].presented == NO) {
        [LogTextViewController sharedLogTextView].presented = YES;
        [self.navigationController pushViewController:[LogTextViewController sharedLogTextView]
                                             animated:YES];
        
    } else if (event.type == UIEventSubtypeMotionShake
               && [LogTextViewController sharedLogTextView].presented == YES) {
        [LogTextViewController sharedLogTextView].presented = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
#endif
