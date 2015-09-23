//
//  RegisterHeaderView.h
//  wechatauthdemo
//
//  Created by Jeason on 26/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterHeaderView : UIView

@property (nonatomic, strong) ButtonCallBack headImageCallBack;
@property (weak, nonatomic) IBOutlet UIButton *headImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *cameraImage;

@end
