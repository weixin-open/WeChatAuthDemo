//
//  ADAddReplyResp.m
//
//  Created by WeChat  on 20/10/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADAddReplyResp.h"
#import "ADBaseResp.h"
#import "ADReplyList.h"


NSString *const kADAddReplyRespBaseResp = @"base_resp";
NSString *const kADAddReplyRespReply = @"reply";


@interface ADAddReplyResp ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADAddReplyResp

@synthesize baseResp = _baseResp;
@synthesize reply = _reply;


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
            self.baseResp = [ADBaseResp modelObjectWithDictionary:[dict objectForKey:kADAddReplyRespBaseResp]];
            self.reply = [ADReplyList modelObjectWithDictionary:[dict objectForKey:kADAddReplyRespReply]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.baseResp dictionaryRepresentation] forKey:kADAddReplyRespBaseResp];
    [mutableDict setValue:[self.reply dictionaryRepresentation] forKey:kADAddReplyRespReply];

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

    self.baseResp = [aDecoder decodeObjectForKey:kADAddReplyRespBaseResp];
    self.reply = [aDecoder decodeObjectForKey:kADAddReplyRespReply];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_baseResp forKey:kADAddReplyRespBaseResp];
    [aCoder encodeObject:_reply forKey:kADAddReplyRespReply];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADAddReplyResp *copy = [[ADAddReplyResp alloc] init];
    
    if (copy) {

        copy.baseResp = [self.baseResp copyWithZone:zone];
        copy.reply = [self.reply copyWithZone:zone];
    }
    
    return copy;
}


@end
