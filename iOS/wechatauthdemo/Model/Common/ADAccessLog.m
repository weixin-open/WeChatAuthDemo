//
//  ADAccessLog.m
//
//  Created by WeChat  on 14/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADAccessLog.h"


NSString *const kADAccessLogLoginTime = @"login_time";
NSString *const kADAccessLogLoginType = @"login_type";

@interface ADAccessLog ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADAccessLog

@synthesize loginTime = _loginTime;
@synthesize loginType = _loginType;

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
            self.loginTime = [[self objectOrNilForKey:kADAccessLogLoginTime fromDictionary:dict] doubleValue];
            self.loginType = [[self objectOrNilForKey:kADAccessLogLoginType fromDictionary:dict] intValue];
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.loginTime] forKey:kADAccessLogLoginTime];
    [mutableDict setValue:[NSNumber numberWithInt:self.loginType] forKey:kADAccessLogLoginType];
    
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

    self.loginTime = [aDecoder decodeDoubleForKey:kADAccessLogLoginTime];
    self.loginType = [aDecoder decodeIntForKey:kADAccessLogLoginType];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_loginTime forKey:kADAccessLogLoginTime];
    [aCoder encodeInt:_loginType forKey:kADAccessLogLoginType];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADAccessLog *copy = [[ADAccessLog alloc] init];
    
    if (copy) {

        copy.loginTime = self.loginTime;
        copy.loginType = self.loginType;
    }
    
    return copy;
}


@end
