//
//  ADNetworkConfigManager.m
//  wechatauthdemo
//
//  Created by WeChat on 20/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADNetworkConfigManager.h"
#import "ADNetworkConfigItem.h"

const NSString *kConnectCGIName = @"appcgi_connect";
const NSString *kWXLoginCGIName = @"appcgi_wxlogin";
const NSString *kCheckLoginCGIName = @"appcgi_checklogin";
const NSString *kGetUserInfoCGIName = @"appcgi_getuserinfo";
const NSString *kMakeExpiredCGIName = @"testfunc";
const NSString *kGetCommentListCGIName = @"appcgi_commentlist";
const NSString *kGetReplyListCGIName = @"appcgi_replylist";
const NSString *kAddCommentCGIName = @"appcgi_addcomment";
const NSString *kAddReplyCGIName = @"appcgi_addreply";

static NSMutableDictionary *allConfig;

@implementation ADNetworkConfigManager

#pragma mark - Life Cycle
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static ADNetworkConfigManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[ADNetworkConfigManager alloc] initInPrivate];
    });
    return instance;
}

- (instancetype)initInPrivate {
    if (self = [super init]) {
        allConfig = [[NSMutableDictionary alloc] init];
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
- (void)setup {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"NetworkConfigItems" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    for (NSDictionary *dict in json) {
        ADNetworkConfigItem *item = [ADNetworkConfigItem modelObjectWithDictionary:dict];
        [self registerConfig:item
                  forKeyPath:item.cgiName];
    }
}

- (void)registerConfig:(ADNetworkConfigItem *)item forKeyPath:(NSString *)keyPath {
    [allConfig setObject:item forKey:keyPath];
}

- (void)removeConfigForKeyPath:(NSString *)keyPath {
    [allConfig removeObjectForKey:keyPath];
}

- (ADNetworkConfigItem *)getConfigForKeyPath:(NSString *)keyPath {
    return [allConfig objectForKey:keyPath];
}

- (NSArray *)allConfigKeys {
    return [allConfig allKeys];
}

- (void)save {
    NSArray *allKeys = [self allConfigKeys];
    NSMutableArray *jsonArray = [NSMutableArray array];
    for (NSString *key in allKeys) {
        NSDictionary *dict = [allConfig[key] dictionaryRepresentation];
        [jsonArray addObject:dict];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"NetworkConfigItems" ofType:@"json"];
    [jsonData writeToFile:filePath
               atomically:YES];
}

@end