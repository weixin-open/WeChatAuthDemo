//
//  ADAddReplyResp.m
//
//  Created by Jeason  on 16/10/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADAddReplyResp.h"


NSString *const kADAddReplyRespReply = @"reply";


@interface ADAddReplyResp ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADAddReplyResp

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
            self.reply = [self objectOrNilForKey:kADAddReplyRespReply fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.reply forKey:kADAddReplyRespReply];

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

    self.reply = [aDecoder decodeObjectForKey:kADAddReplyRespReply];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_reply forKey:kADAddReplyRespReply];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADAddReplyResp *copy = [[ADAddReplyResp alloc] init];
    
    if (copy) {

        copy.reply = [self.reply copyWithZone:zone];
    }
    
    return copy;
}


@end
