//
//  WXAuthManager.m
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/25/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import "WXAuthManager.h"

@implementation WXAuthManager

#pragma mark - Life Cycle
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXAuthManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initInPrivate];
    });
    return instance;
}

- (instancetype)initInPrivate {
    self = [super init];
    if (self) {
        _delegate = nil;
    }
    return self;
}

- (instancetype)init {
    return nil;
}

- (instancetype)copy {
    return nil;
}

#pragma mark - Public Methods
- (void)sendAuthRequestWithController:(UIViewController*)viewController
                             delegate:(id<WXAuthDelegate>)delegate {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    // TODO: random number here
    req.state = @"123";
    self.delegate = delegate;
    [WXApi sendAuthReq:req viewController:viewController delegate:self];
}

#pragma mark - WXApiDelegate
-(void)onReq:(BaseReq*)req {
    // just leave it here, wechat will not call our app
}

-(void)onResp:(BaseResp*)resp {
    if (self.delegate == nil)
        return;
    
    if([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp* authResp = (SendAuthResp*)resp;
        switch (resp.errCode) {
            case WXSuccess:
                NSLog(@"RESP:code:%@,state:%@\n", authResp.code, authResp.state);
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthSucceed:)])
                    [self.delegate wxAuthSucceed:authResp.code];
                break;
            case WXErrCodeAuthDeny:
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthDenied)])
                    [self.delegate wxAuthDenied];
                break;
            case WXErrCodeUserCancel:
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthCancel)])
                    [self.delegate wxAuthCancel];
            default:
                break;
        }
    }
}

@end