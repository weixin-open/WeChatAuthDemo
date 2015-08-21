//
//  ADLoginResp.m
//
//  Created by Jeason  on 14/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADLoginResp.h"
#import "ADBaseResp.h"


NSString *const kADLoginRespBaseResp = @"base_resp";
NSString *const kADLoginRespUin = @"uin";
NSString *const kADLoginRespLoginTicket = @"login_ticket";


@interface ADLoginResp ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADLoginResp

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
            self.baseResp = [ADBaseResp modelObjectWithDictionary:[dict objectForKey:kADLoginRespBaseResp]];
            self.uin = [[self objectOrNilForKey:kADLoginRespUin fromDictionary:dict] doubleValue];
            self.loginTicket = [self objectOrNilForKey:kADLoginRespLoginTicket fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.baseResp dictionaryRepresentation] forKey:kADLoginRespBaseResp];
    [mutableDict setValue:[NSNumber numberWithDouble:self.uin] forKey:kADLoginRespUin];
    [mutableDict setValue:self.loginTicket forKey:kADLoginRespLoginTicket];

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

    self.baseResp = [aDecoder decodeObjectForKey:kADLoginRespBaseResp];
    self.uin = [aDecoder decodeDoubleForKey:kADLoginRespUin];
    self.loginTicket = [aDecoder decodeObjectForKey:kADLoginRespLoginTicket];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_baseResp forKey:kADLoginRespBaseResp];
    [aCoder encodeDouble:_uin forKey:kADLoginRespUin];
    [aCoder encodeObject:_loginTicket forKey:kADLoginRespLoginTicket];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADLoginResp *copy = [[ADLoginResp alloc] init];
    
    if (copy) {

        copy.baseResp = [self.baseResp copyWithZone:zone];
        copy.uin = self.uin;
        copy.loginTicket = [self.loginTicket copyWithZone:zone];
    }
    
    return copy;
}


@end
