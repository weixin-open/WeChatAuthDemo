//
//  GameViewController.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <SVProgressHUD.h>
#import "ADShareViewController.h"
#import "WXAuthManager.h"

static NSString *kTitleText = @"微信登录开发指引";
static NSString *kShareUrlString = @"http://mp.weixin.qq.com/s?__biz=MjM5NDAxMDg4MA==&mid=208833692&idx=1&sn=daa41a5b34ce7ffeb48985964e613941&scene=1&srcid=TnXuoDUuLCjDSJoLqkdG&from=singlemessage&isappinstalled=0#rd";
static NSString *kShareButtonText = @"分享";
static NSString *kShareDescText = @"分享一个链接";
static NSString *kShareFailedText = @"分享失败";

@interface ADShareViewController ()<WXAuthDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *urlRequest;

@end

@implementation ADShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = kTitleText;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kShareButtonText
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onClickShare:)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillLayoutSubviews {
    self.webView.frame = self.view.frame;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)onClickShare:(UIBarButtonItem *)sender {
    if (sender != self.navigationItem.rightBarButtonItem)
        return;
    
    BOOL succ = [[WXAuthManager sharedManager] sendLinkContent:kShareUrlString
                                                         Title:kTitleText
                                                   Description:kShareDescText
                                                       AtScene:WXSceneTimeline
                                                      Delegate:self];
    if (!succ) {
        [SVProgressHUD showErrorWithStatus:kShareFailedText];
    }
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        [_webView loadRequest:self.urlRequest];
    }
    return _webView;
}

- (NSURLRequest *)urlRequest {
    if (_urlRequest == nil) {
        NSURL *url = [NSURL URLWithString:kShareUrlString];
        _urlRequest = [[NSURLRequest alloc] initWithURL:url];
    }
    return _urlRequest;
}

@end
