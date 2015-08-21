//
//  ADWXBindAPPResp.m
//
//  Created by Jeason  on 14/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADWXBindAPPResp.h"
#import "ADBaseResp.h"


NSString *const kADWXBindAPPRespBaseResp = @"base_resp";
NSString *const kADWXBindAPPRespUin = @"uin";
NSString *const kADWXBindAPPRespLoginTicket = @"login_ticket";


@interface ADWXBindAPPResp ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADWXBindAPPResp

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
            self.baseResp = [ADBaseResp modelObjectWithDictionary:[dict objectForKey:kADWXBindAPPRespBaseResp]];
            self.uin = [[self objectOrNilForKey:kADWXBindAPPRespUin fromDictionary:dict] doubleValue];
            self.loginTicket = [self objectOrNilForKey:kADWXBindAPPRespLoginTicket fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.baseResp dictionaryRepresentation] forKey:kADWXBindAPPRespBaseResp];
    [mutableDict setValue:[NSNumber numberWithDouble:self.uin] forKey:kADWXBindAPPRespUin];
    [mutableDict setValue:self.loginTicket forKey:kADWXBindAPPRespLoginTicket];

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

    self.baseResp = [aDecoder decodeObjectForKey:kADWXBindAPPRespBaseResp];
    self.uin = [aDecoder decodeDoubleForKey:kADWXBindAPPRespUin];
    self.loginTicket = [aDecoder decodeObjectForKey:kADWXBindAPPRespLoginTicket];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_baseResp forKey:kADWXBindAPPRespBaseResp];
    [aCoder encodeDouble:_uin forKey:kADWXBindAPPRespUin];
    [aCoder encodeObject:_loginTicket forKey:kADWXBindAPPRespLoginTicket];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADWXBindAPPResp *copy = [[ADWXBindAPPResp alloc] init];
    
    if (copy) {

        copy.baseResp = [self.baseResp copyWithZone:zone];
        copy.uin = self.uin;
        copy.loginTicket = [self.loginTicket copyWithZone:zone];
    }
    
    return copy;
}


@end
