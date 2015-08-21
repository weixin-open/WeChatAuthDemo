//
//  ADAPPBindWXResp.m
//
//  Created by Jeason  on 14/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADAPPBindWXResp.h"
#import "ADBaseResp.h"


NSString *const kADAPPBindWXRespBaseResp = @"base_resp";
NSString *const kADAPPBindWXRespUin = @"uin";
NSString *const kADAPPBindWXRespLoginTicket = @"login_ticket";


@interface ADAPPBindWXResp ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADAPPBindWXResp

@synthesize baseResp = _baseResp;
@synthesize uin = _uin;
@synthesize loginTicket = _loginTicket;


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
            self.baseResp = [ADBaseResp modelObjectWithDictionary:[dict objectForKey:kADAPPBindWXRespBaseResp]];
            self.uin = [[self objectOrNilForKey:kADAPPBindWXRespUin fromDictionary:dict] doubleValue];
            self.loginTicket = [self objectOrNilForKey:kADAPPBindWXRespLoginTicket fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.baseResp dictionaryRepresentation] forKey:kADAPPBindWXRespBaseResp];
    [mutableDict setValue:[NSNumber numberWithDouble:self.uin] forKey:kADAPPBindWXRespUin];
    [mutableDict setValue:self.loginTicket forKey:kADAPPBindWXRespLoginTicket];

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

    self.baseResp = [aDecoder decodeObjectForKey:kADAPPBindWXRespBaseResp];
    self.uin = [aDecoder decodeDoubleForKey:kADAPPBindWXRespUin];
    self.loginTicket = [aDecoder decodeObjectForKey:kADAPPBindWXRespLoginTicket];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_baseResp forKey:kADAPPBindWXRespBaseResp];
    [aCoder encodeDouble:_uin forKey:kADAPPBindWXRespUin];
    [aCoder encodeObject:_loginTicket forKey:kADAPPBindWXRespLoginTicket];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADAPPBindWXResp *copy = [[ADAPPBindWXResp alloc] init];
    
    if (copy) {

        copy.baseResp = [self.baseResp copyWithZone:zone];
        copy.uin = self.uin;
        copy.loginTicket = [self.loginTicket copyWithZone:zone];
    }
    
    return copy;
}


@end
