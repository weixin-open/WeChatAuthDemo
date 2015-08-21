//
//  ADCheckLoginResp.m
//
//  Created by Jeason  on 14/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADCheckLoginResp.h"
#import "ADBaseResp.h"


NSString *const kADCheckLoginRespBaseResp = @"base_resp";
NSString *const kADCheckLoginRespSessionKey = @"session_key";


@interface ADCheckLoginResp ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADCheckLoginResp

@synthesize baseResp = _baseResp;
@synthesize sessionKey = _sessionKey;


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
            self.baseResp = [ADBaseResp modelObjectWithDictionary:[dict objectForKey:kADCheckLoginRespBaseResp]];
            self.sessionKey = [self objectOrNilForKey:kADCheckLoginRespSessionKey fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.baseResp dictionaryRepresentation] forKey:kADCheckLoginRespBaseResp];
    [mutableDict setValue:self.sessionKey forKey:kADCheckLoginRespSessionKey];

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

    self.baseResp = [aDecoder decodeObjectForKey:kADCheckLoginRespBaseResp];
    self.sessionKey = [aDecoder decodeObjectForKey:kADCheckLoginRespSessionKey];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_baseResp forKey:kADCheckLoginRespBaseResp];
    [aCoder encodeObject:_sessionKey forKey:kADCheckLoginRespSessionKey];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADCheckLoginResp *copy = [[ADCheckLoginResp alloc] init];
    
    if (copy) {

        copy.baseResp = [self.baseResp copyWithZone:zone];
        copy.sessionKey = [self.sessionKey copyWithZone:zone];
    }
    
    return copy;
}


@end
