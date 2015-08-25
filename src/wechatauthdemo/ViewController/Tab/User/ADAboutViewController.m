//
//  AboutViewController.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADAboutViewController.h"

static NSString *kTitleText = @"关于我们";
static NSString *kAboutUsText = @"微信授权Demo为开源项目，为微信开发者提供开发Demo，开发者可以进行参考，并应用到自己的App中。";

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.textView.frame = CGRectMake(inset,
                                     inset,
                                     ScreenWidth-inset * 2,
                                     ScreenHeight-inset-navigationBarHeight-statusBarHeight);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lazy Initializers
- (UITextView *)textView {
    if (_textView == nil) {
        _textView = [[UITextView alloc] init];
        _textView.text = kAboutUsText;
        _textView.editable = NO;
    }
    return _textView;
}

@end
