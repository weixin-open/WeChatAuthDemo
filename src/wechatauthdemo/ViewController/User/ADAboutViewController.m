//
//  AboutViewController.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADAboutViewController.h"

static NSString* const kTitleText = @"关于我们";
static NSString* const kAboutUsText = @"微信登录Demo为微信团队开源项目，用于微信开发者进行微信登录、分享功能开发时的参考Demo。微信开发者可以参考项目中的代码来开发应用，也可以直接使用项目中的代码到自己的App中。\n开发者可以自由使用并传播本代码，但需要保留原作者信息。\n\n源代码下载地址：\n https://github.com/weixin-open/WeChatAuthDemo\n联系我们：weixin-open@qq.com";

@interface ADAboutViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation ADAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = kTitleText;
    [self.view addSubview:self.textView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.textView.frame = CGRectMake(inset,
                                     inset,
                                     ScreenWidth-inset * 2,
                                     ScreenHeight-inset-navigationBarHeight-statusBarHeight);
}

#pragma mark - Lazy Initializers
- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont fontWithName:kChineseFont
                                         size:17];
        _textView.text = kAboutUsText;
        _textView.editable = NO;
    }
    return _textView;
}

@end
