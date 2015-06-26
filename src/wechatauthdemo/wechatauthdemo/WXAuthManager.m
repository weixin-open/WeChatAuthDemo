//
//  WXAuthManager.m
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/25/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import "WXAuthManager.h"

@interface WXAuthManager ()

@end

@implementation WXAuthManager

- (id)init
{
    self = [super init];
    if (self) {
        _delegate = nil;
    }
    return self;
}

- (void)sendAuthRequest
{
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    // TODO: random number here
    req.state = @"123" ;
    [WXApi sendReq:req];
    [req release];
}

-(void)onReq:(BaseReq*)req
{
    // just leave it here, wechat will not call our app
}

-(void)onResp:(BaseResp*)resp
{
    if (self.delegate == nil) {
        return;
    }
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp* authResp = (SendAuthResp*)resp;
        
        switch (resp.errCode) {
            // ERR_OK
            case 0:
            {
                NSString *code = authResp.code;
                NSString *state = authResp.state;
                NSLog(@"RESP:code:%@,state:%@\n", code, state);
                [self.delegate wxAuthSucceed:code];
                break;
            }
            // ERR_AUTH_DENIED
            case -4:
            {
                [self.delegate wxAuthDenied];
            }
            // ERR_USER_CANCEL
            case -2:
            {
                [self.delegate wxAuthCancel];
            }
        }
    }
}

@end