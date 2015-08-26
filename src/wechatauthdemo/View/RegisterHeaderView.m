//
//  RegisterHeaderView.m
//  wechatauthdemo
//
//  Created by Jeason on 26/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "RegisterHeaderView.h"

@implementation RegisterHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)onClickImage:(UIButton *)sender {
    if (self.headImageCallBack) {
        self.headImageCallBack (sender);
    }
}

@end
