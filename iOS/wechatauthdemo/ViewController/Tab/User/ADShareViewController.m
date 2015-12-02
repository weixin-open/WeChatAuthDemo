//
//  GameViewController.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADShareViewController.h"
#import "WXApiManager.h"

static NSString* const kShareButtonText = @"分享  ";
static NSString* const kShareDescText = @"分享一个链接";
static NSString* const kShareFailedText = @"分享失败";

@interface ADShareViewController ()<UIActionSheetDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURLRequest *urlRequest;

@end

@implementation ADShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kShareButtonText
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(onClickShare:)];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
}

- (void)viewWillLayoutSubviews {
    self.webView.frame = self.view.frame;
}

- (void)onClickShare:(UIBarButtonItem *)sender {
    if (sender != self.navigationItem.rightBarButtonItem)
        return;
    
    [[[UIActionSheet alloc] initWithTitle:@"分享到微信"
                                delegate:self
                       cancelButtonTitle:@"取消"
                  destructiveButtonTitle:nil
                        otherButtonTitles:@"转发到会话", @"分享到朋友圈", nil] showInView:self.view];
}

- (UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        _webView.scrollView.delegate = self;
        [_webView loadRequest:self.urlRequest];
    }
    return _webView;
}

- (NSURLRequest *)urlRequest {
    if (_urlRequest == nil) {
        NSURL *url = [NSURL URLWithString:self.urlString];
        _urlRequest = [[NSURLRequest alloc] initWithURL:url];
    }
    return _urlRequest;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: // 转发到会话
            [[WXApiManager sharedManager] sendLinkContent:[[self.webView.request URL] absoluteString]
                                                    Title:self.title
                                              Description:kShareDescText
                                                  AtScene:WXSceneSession];
            break;
        case 1: //分享到朋友圈
            [[WXApiManager sharedManager] sendLinkContent:[[self.webView.request URL] absoluteString]
                                                    Title:self.title
                                              Description:kShareDescText
                                                  AtScene:WXSceneTimeline];
            break;
        default:
            break;
    }
}

#pragma mark - UIWebViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scrollTop = scrollView.contentOffset.y;
    NSLog(@"[DEBUG]ScrollTop=[%f]", scrollTop);
}

@end
