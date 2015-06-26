//
//  NetworkManager.m
//  wechatauthdemo
//
//  Created by Chuang Chen on 6/25/15.
//  Copyright (c) 2015 boshao. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

- (void)getWeChatInfoByCode:(NSString*)code
          completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler
{
    NSURL *url = [NSURL URLWithString:[[@"http://urltoserver?code=" stringByAppendingString:code]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10] autorelease];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:handler];
}

- (void)loginAcct:(NSString*)username byPwd:(NSString*)password
          completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler
{
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"http://urltoserver?username=%@&password=%@", username, password] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10] autorelease];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:handler];
}

- (void)regAcct:(NSString*)username withPwd:(NSString*)password
          completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler
{
    NSDictionary *jsonObject = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password", nil];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:jsonObject options:0 error:nil];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    
    NSURL *url = [NSURL URLWithString:[@"https://urltoserver" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10] autorelease];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:handler];
}


@end
