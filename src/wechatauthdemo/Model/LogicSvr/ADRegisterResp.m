//
//  ADRegisterResp.m
//
//  Created by Jeason  on 14/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADRegisterResp.h"
#import "ADBaseResp.h"


NSString *const kADRegisterRespBaseResp = @"base_resp";
NSString *const kADRegisterRespUin = @"uin";
NSString *const kADRegisterRespLoginTicket = @"login_ticket";


@interface ADRegisterResp ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADRegisterResp

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
            self.baseResp = [ADBaseResp modelObjectWithDictionary:[dict objectForKey:kADRegisterRespBaseResp]];
            self.uin = [[self objectOrNilForKey:kADRegisterRespUin fromDictionary:dict] doubleValue];
            self.loginTicket = [self objectOrNilForKey:kADRegisterRespLoginTicket fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.baseResp dictionaryRepresentation] forKey:kADRegisterRespBaseResp];
    [mutableDict setValue:[NSNumber numberWithDouble:self.uin] forKey:kADRegisterRespUin];
    [mutableDict setValue:self.loginTicket forKey:kADRegisterRespLoginTicket];

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

    self.baseResp = [aDecoder decodeObjectForKey:kADRegisterRespBaseResp];
    self.uin = [aDecoder decodeDoubleForKey:kADRegisterRespUin];
    self.loginTicket = [aDecoder decodeObjectForKey:kADRegisterRespLoginTicket];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_baseResp forKey:kADRegisterRespBaseResp];
    [aCoder encodeDouble:_uin forKey:kADRegisterRespUin];
    [aCoder encodeObject:_loginTicket forKey:kADRegisterRespLoginTicket];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADRegisterResp *copy = [[ADRegisterResp alloc] init];
    
    if (copy) {

        copy.baseResp = [self.baseResp copyWithZone:zone];
        copy.uin = self.uin;
        copy.loginTicket = [self.loginTicket copyWithZone:zone];
    }
    
    return copy;
}


@end
