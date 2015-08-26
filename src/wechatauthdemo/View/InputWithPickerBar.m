//
//  InputWithPickerBar.m
//  wechatauthdemo
//
//  Created by Jeason on 24/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "InputWithPickerBar.h"

@implementation InputWithPickerBar

- (IBAction)onClickDone:(id)sender {
    if (self.onClickDoneCallBack) {
        self.onClickDoneCallBack (sender);
    }
}

@end
