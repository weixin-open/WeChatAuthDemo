//
//  ADGetUserInfoResp.h
//
//  Created by Jeason  on 24/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADBaseResp;

@interface ADGetUserInfoResp : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *mail;
@property (nonatomic, strong) NSString *openid;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) ADBaseResp *baseResp;
@property (nonatomic, strong) NSString *headimgurl;
@property (nonatomic, strong) NSString *unionid;
@property (nonatomic, assign) double refreshTokenExpireTime;
@property (nonatomic, assign) ADSexType sex;
@property (nonatomic, assign) double accessTokenExpireTime;
@property (nonatomic, strong) NSArray *accessLog;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
