//
//  UIApplication+HandleWarning.h
//  wechatauthdemo
//
//  Created by Jeason on 21/12/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
@interface UIApplication (ResolveDebugWarning)

- (void)_handleNonLaunchSpecificActions:(id)arg1
                               forScene:(id)arg2
                  withTransitionContext:(id)arg3
                             completion:(void(^)())completionHandler;

@end
#endif
