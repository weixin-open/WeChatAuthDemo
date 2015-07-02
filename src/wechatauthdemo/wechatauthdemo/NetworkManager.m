//
//  NetworkManager.m
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/25/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import "NetworkManager.h"
#import "AppDelegate.h"

@implementation NetworkManager

// const static NSString *YOUR_SERVER_ADDR = @"http://10.9.177.112:5000";
// const static NSString *YOUR_SERVER_ADDR = @"http://127.0.0.1:5000";
// const static NSString *YOUR_SERVER_ADDR = @"http://120.204.202.174/demoapi";
// const static NSString *YOUR_SERVER_ADDR = @"http://api.weixin.qq.com/demoapi";
const static NSString *YOUR_SERVER_ADDR = @"http://wxauthdemo.sinaapp.com";

- (void)wxLogin:(NSString*)code
          completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket, NSString* nickname, BOOL hasBindApp))handler
{
    NSDictionary *jsonObject = [NSDictionary dictionaryWithObjectsAndKeys:code, @"code", nil];
    NSString *url = [NSString stringWithFormat:@"%@/wx/login", YOUR_SERVER_ADDR];
    
    [self postData:jsonObject toUrl:url completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            NSLog(@"ERR:%@", connectionError);
            [[AppDelegate appDelegate] presentAlert:connectionError];
        } else {
            NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            handler([result valueForKey:@"error"], [result valueForKey:@"uid"], [result valueForKey:@"userticket"], [result valueForKey:@"nickname"], [[result valueForKey:@"has_bind_app"] boolValue]);
        }
    }];
}

- (void)appLogin:(NSString*)mail password:(NSString*)password
          completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket, NSString* nickname, BOOL hasBindWx))handler
{
    NSDictionary *jsonObject = [NSDictionary dictionaryWithObjectsAndKeys:mail, @"mail", password, @"pwd", nil];
    NSString *url = [NSString stringWithFormat:@"%@/app/login", YOUR_SERVER_ADDR];
    
    [self postData:jsonObject toUrl:url completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            NSLog(@"ERR:%@", connectionError);
            [[AppDelegate appDelegate] presentAlert:connectionError];
        } else {
            NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            handler([result valueForKey:@"error"], [result valueForKey:@"uid"], [result valueForKey:@"userticket"], [result valueForKey:@"nickname"], [[result valueForKey:@"has_bind_wx"] boolValue]);
        }
    }];
}

- (void)appRegAcct:(NSString*)mail password:(NSString*)password nickname:(NSString*)nickname
          completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket))handler
{
    NSDictionary *jsonObject = [NSDictionary dictionaryWithObjectsAndKeys:mail, @"mail", password, @"pwd", nickname, @"nickname", nil];
    NSString *url = [NSString stringWithFormat:@"%@/app/create", YOUR_SERVER_ADDR];
    
    [self postData:jsonObject toUrl:url completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            NSLog(@"ERR:%@", connectionError);
            [[AppDelegate appDelegate] presentAlert:connectionError];
        } else {
            NSLog(@"DATA:%@", data);
            NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            handler([result valueForKey:@"error"], [result valueForKey:@"uid"], [result valueForKey:@"userticket"]);
        }
    }];
}

- (void)wxBindApp:(NSNumber*)uid userticket:(NSString*)userticket mail:(NSString*)mail password:(NSString*)password
          completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket, NSString* nickname))handler
{
    NSDictionary *jsonObject = [NSDictionary dictionaryWithObjectsAndKeys:
                                uid, @"uid", userticket, @"userticket", mail, @"mail", password, @"pwd", [NSNumber numberWithBool:NO], @"to_create", nil];
    NSString *url = [NSString stringWithFormat:@"%@/wx/bindapp", YOUR_SERVER_ADDR];
    
    [self postData:jsonObject toUrl:url completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            NSLog(@"ERR:%@", connectionError);
            [[AppDelegate appDelegate] presentAlert:connectionError];
        } else {
            NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            handler([result valueForKey:@"error"], [result valueForKey:@"uid"], [result valueForKey:@"userticket"], [result valueForKey:@"nickname"]);
        }
    }];
}

- (void)wxBindNewApp:(NSNumber*)uid userticket:(NSString*)userticket mail:(NSString*)mail password:(NSString*)password completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket, NSString* nickname))handler
{
    NSDictionary *jsonObject = [NSDictionary dictionaryWithObjectsAndKeys:
                                uid, @"uid", userticket, @"userticket", mail, @"mail", password, @"pwd", [NSNumber numberWithBool:YES], @"to_create", nil];
    NSString *url = [NSString stringWithFormat:@"%@/wx/bindapp", YOUR_SERVER_ADDR];
    
    [self postData:jsonObject toUrl:url completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            NSLog(@"ERR:%@", connectionError);
            [[AppDelegate appDelegate] presentAlert:connectionError];
        } else {
            NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            handler([result valueForKey:@"error"], [result valueForKey:@"uid"], [result valueForKey:@"userticket"], [result valueForKey:@"nickname"]);
        }
    }];
}

- (void)appBindWx:(NSNumber*)uid userticket:(NSString*)userticket code:(NSString*)code
          completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket))handler
{
    NSDictionary *jsonObject = [NSDictionary dictionaryWithObjectsAndKeys:uid, @"uid", userticket, @"userticket", code, @"code", nil];
    NSString *url = [NSString stringWithFormat:@"%@/app/bindwx", YOUR_SERVER_ADDR];
    
    [self postData:jsonObject toUrl:url completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            NSLog(@"ERR:%@", connectionError);
            [[AppDelegate appDelegate] presentAlert:connectionError];
        } else {
            NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            handler([result valueForKey:@"error"], [result valueForKey:@"uid"], [result valueForKey:@"userticket"]);
        }
    }];
}

- (void)appUnbindWx:(NSNumber*)uid userticket:(NSString*)userticket
          completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket))handler
{
    NSDictionary *jsonObject = [NSDictionary dictionaryWithObjectsAndKeys:uid, @"uid", userticket, @"userticket", nil];
    NSString *url = [NSString stringWithFormat:@"%@/app/unbindwx", YOUR_SERVER_ADDR];
    
    [self postData:jsonObject toUrl:url completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            NSLog(@"ERR:%@", connectionError);
            [[AppDelegate appDelegate] presentAlert:connectionError];
        } else {
            NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            handler([result valueForKey:@"error"], [result valueForKey:@"uid"], [result valueForKey:@"userticket"]);
        }
    }];
}


- (void)getWxUserInfo:(NSNumber*)uid userticket:(NSString*)userticket realtime:(BOOL)realtime
          completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket, NSDictionary* info))handler
{
    NSDictionary *jsonObject = [NSDictionary dictionaryWithObjectsAndKeys:uid, @"uid", userticket, @"userticket", [NSNumber numberWithBool:realtime], @"realtime", nil];
    NSString *url = [NSString stringWithFormat:@"%@/wx/userinfo", YOUR_SERVER_ADDR];
    
    [self postData:jsonObject toUrl:url completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            NSLog(@"ERR:%@", connectionError);
            [[AppDelegate appDelegate] presentAlert:connectionError];
        } else {
            NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            handler([result valueForKey:@"error"], [result valueForKey:@"uid"], [result valueForKey:@"userticket"], [result valueForKey:@"wx_userinfo"]);
        }
    }];
}

- (void)getAppUserInfo:(NSNumber*)uid userticket:(NSString*)userticket realtime:(BOOL)realtime
    completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket, NSDictionary* info))handler
{
    NSDictionary *jsonObject = [NSDictionary dictionaryWithObjectsAndKeys:uid, @"uid", userticket, @"userticket", [NSNumber numberWithBool:realtime], @"realtime", nil];
    NSString *url = [NSString stringWithFormat:@"%@/app/userinfo", YOUR_SERVER_ADDR];
    
    [self postData:jsonObject toUrl:url completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            NSLog(@"ERR:%@", connectionError);
            [[AppDelegate appDelegate] presentAlert:connectionError];
        } else {
            NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            handler([result valueForKey:@"error"], [result valueForKey:@"uid"], [result valueForKey:@"userticket"], [result valueForKey:@"app_userinfo"]);
        }
    }];
}

- (void)refreshTicket:(NSNumber*)uid userticket:(NSString*)userticket
          completionHandler:(void (^)(NSString* error, NSNumber* uid, NSString* userticket))handler
{
    NSDictionary *jsonObject = [NSDictionary dictionaryWithObjectsAndKeys:uid, @"uid", userticket, @"userticket", nil];
    NSString *url = [NSString stringWithFormat:@"%@/ticket/check", YOUR_SERVER_ADDR];
    
    [self postData:jsonObject toUrl:url completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data == nil) {
            NSLog(@"ERR:%@", connectionError);
            [[AppDelegate appDelegate] presentAlert:connectionError];
        } else {
            NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            handler([result valueForKey:@"error"], [result valueForKey:@"uid"], [result valueForKey:@"userticket"]);
        }
    }];
}


- (void)postData:(NSDictionary*)data toUrl:(NSString*)url
    completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler
{
    NSData *postData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"applications/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:handler];
    
    [request release];
    [queue release];
}


@end
