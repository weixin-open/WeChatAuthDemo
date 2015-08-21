//
//  ADGetUserInfoResp.m
//
//  Created by Jeason  on 14/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADGetUserInfoResp.h"
#import "ADBaseResp.h"
#import "ADAccessLog.h"


NSString *const kADGetUserInfoRespMail = @"mail";
NSString *const kADGetUserInfoRespOpenid = @"openid";
NSString *const kADGetUserInfoRespNickname = @"nickname";
NSString *const kADGetUserInfoRespBaseResp = @"base_resp";
NSString *const kADGetUserInfoRespUnionid = @"unionid";
NSString *const kADGetUserInfoRespRefreshTokenExpireTime = @"refresh_token_expire_time";
NSString *const kADGetUserInfoRespAccessTokenExpireTime = @"access_token_expire_time";
NSString *const kADGetUserInfoRespAccessLog = @"access_log";
NSString *const kADGetUserInfoRespHeadImgUrl = @"headimgurl";

@interface ADGetUserInfoResp ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADGetUserInfoResp

@synthesize mail = _mail;
@synthesize openid = _openid;
@synthesize nickname = _nickname;
@synthesize baseResp = _baseResp;
@synthesize unionid = _unionid;
@synthesize refreshTokenExpireTime = _refreshTokenExpireTime;
@synthesize accessTokenExpireTime = _accessTokenExpireTime;
@synthesize accessLog = _accessLog;
@synthesize headimgurl = _headimgurl;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.mail = [self objectOrNilForKey:kADGetUserInfoRespMail fromDictionary:dict];
            self.openid = [self objectOrNilForKey:kADGetUserInfoRespOpenid fromDictionary:dict];
            self.nickname = [self objectOrNilForKey:kADGetUserInfoRespNickname fromDictionary:dict];
            self.baseResp = [ADBaseResp modelObjectWithDictionary:[dict objectForKey:kADGetUserInfoRespBaseResp]];
            self.unionid = [self objectOrNilForKey:kADGetUserInfoRespUnionid fromDictionary:dict];
            self.refreshTokenExpireTime = [[self objectOrNilForKey:kADGetUserInfoRespRefreshTokenExpireTime fromDictionary:dict] doubleValue];
            self.accessTokenExpireTime = [[self objectOrNilForKey:kADGetUserInfoRespAccessTokenExpireTime fromDictionary:dict] doubleValue];
            self.headimgurl = [self objectOrNilForKey:kADGetUserInfoRespHeadImgUrl fromDictionary:dict];
    NSObject *receivedADAccessLog = [dict objectForKey:kADGetUserInfoRespAccessLog];
    NSMutableArray *parsedADAccessLog = [NSMutableArray array];
    if ([receivedADAccessLog isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedADAccessLog) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedADAccessLog addObject:[ADAccessLog modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedADAccessLog isKindOfClass:[NSDictionary class]]) {
       [parsedADAccessLog addObject:[ADAccessLog modelObjectWithDictionary:(NSDictionary *)receivedADAccessLog]];
    }

    self.accessLog = [NSArray arrayWithArray:parsedADAccessLog];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.mail forKey:kADGetUserInfoRespMail];
    [mutableDict setValue:self.openid forKey:kADGetUserInfoRespOpenid];
    [mutableDict setValue:self.nickname forKey:kADGetUserInfoRespNickname];
    [mutableDict setValue:[self.baseResp dictionaryRepresentation] forKey:kADGetUserInfoRespBaseResp];
    [mutableDict setValue:self.unionid forKey:kADGetUserInfoRespUnionid];
    [mutableDict setValue:[NSNumber numberWithDouble:self.refreshTokenExpireTime] forKey:kADGetUserInfoRespRefreshTokenExpireTime];
    [mutableDict setValue:[NSNumber numberWithDouble:self.accessTokenExpireTime] forKey:kADGetUserInfoRespAccessTokenExpireTime];
    [mutableDict setValue:self.headimgurl forKey:kADGetUserInfoRespHeadImgUrl];
    NSMutableArray *tempArrayForAccessLog = [NSMutableArray array];
    for (NSObject *subArrayObject in self.accessLog) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForAccessLog addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForAccessLog addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForAccessLog] forKey:kADGetUserInfoRespAccessLog];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.mail = [aDecoder decodeObjectForKey:kADGetUserInfoRespMail];
    self.openid = [aDecoder decodeObjectForKey:kADGetUserInfoRespOpenid];
    self.nickname = [aDecoder decodeObjectForKey:kADGetUserInfoRespNickname];
    self.baseResp = [aDecoder decodeObjectForKey:kADGetUserInfoRespBaseResp];
    self.unionid = [aDecoder decodeObjectForKey:kADGetUserInfoRespUnionid];
    self.headimgurl = [aDecoder decodeObjectForKey:kADGetUserInfoRespHeadImgUrl];
    self.refreshTokenExpireTime = [aDecoder decodeDoubleForKey:kADGetUserInfoRespRefreshTokenExpireTime];
    self.accessTokenExpireTime = [aDecoder decodeDoubleForKey:kADGetUserInfoRespAccessTokenExpireTime];
    self.accessLog = [aDecoder decodeObjectForKey:kADGetUserInfoRespAccessLog];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_mail forKey:kADGetUserInfoRespMail];
    [aCoder encodeObject:_openid forKey:kADGetUserInfoRespOpenid];
    [aCoder encodeObject:_nickname forKey:kADGetUserInfoRespNickname];
    [aCoder encodeObject:_baseResp forKey:kADGetUserInfoRespBaseResp];
    [aCoder encodeObject:_unionid forKey:kADGetUserInfoRespUnionid];
    [aCoder encodeDouble:_refreshTokenExpireTime forKey:kADGetUserInfoRespRefreshTokenExpireTime];
    [aCoder encodeDouble:_accessTokenExpireTime forKey:kADGetUserInfoRespAccessTokenExpireTime];
    [aCoder encodeObject:_accessLog forKey:kADGetUserInfoRespAccessLog];
    [aCoder encodeObject:_headimgurl forKey:kADGetUserInfoRespHeadImgUrl];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADGetUserInfoResp *copy = [[ADGetUserInfoResp alloc] init];
    
    if (copy) {

        copy.mail = [self.mail copyWithZone:zone];
        copy.openid = [self.openid copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.baseResp = [self.baseResp copyWithZone:zone];
        copy.unionid = [self.unionid copyWithZone:zone];
        copy.headimgurl = [self.headimgurl copyWithZone:zone];
        copy.refreshTokenExpireTime = self.refreshTokenExpireTime;
        copy.accessTokenExpireTime = self.accessTokenExpireTime;
        copy.accessLog = [self.accessLog copyWithZone:zone];
    }
    
    return copy;
}


@end
