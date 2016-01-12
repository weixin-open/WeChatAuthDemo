//
//  ADConnectResp.m
//
//  Created by WeChat  on 14/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADConnectResp.h"
#import "ADBaseResp.h"


NSString *const kADConnectRespBaseResp = @"base_resp";
NSString *const kADConnectRespTempUin = @"tmp_uin";


@interface ADConnectResp ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADConnectResp

@synthesize baseResp = _baseResp;
@synthesize tempUin = _tempUin;


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
            self.baseResp = [ADBaseResp modelObjectWithDictionary:[dict objectForKey:kADConnectRespBaseResp]];
            self.tempUin = [[self objectOrNilForKey:kADConnectRespTempUin fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.baseResp dictionaryRepresentation] forKey:kADConnectRespBaseResp];
    [mutableDict setValue:[NSNumber numberWithDouble:self.tempUin] forKey:kADConnectRespTempUin];

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

    self.baseResp = [aDecoder decodeObjectForKey:kADConnectRespBaseResp];
    self.tempUin = [aDecoder decodeDoubleForKey:kADConnectRespTempUin];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_baseResp forKey:kADConnectRespBaseResp];
    [aCoder encodeDouble:_tempUin forKey:kADConnectRespTempUin];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADConnectResp *copy = [[ADConnectResp alloc] init];
    
    if (copy) {

        copy.baseResp = [self.baseResp copyWithZone:zone];
        copy.tempUin = self.tempUin;
    }
    
    return copy;
}


@end
