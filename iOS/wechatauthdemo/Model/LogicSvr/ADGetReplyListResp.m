//
//  ADGetReplyListResp.m
//
//  Created by Jeason  on 16/10/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADGetReplyListResp.h"
#import "ADBaseResp.h"
#import "ADReplyList.h"


NSString *const kADGetReplyListRespBaseResp = @"base_resp";
NSString *const kADGetReplyListRespReplyList = @"reply_list";


@interface ADGetReplyListResp ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADGetReplyListResp

@synthesize baseResp = _baseResp;
@synthesize replyList = _replyList;


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
            self.baseResp = [ADBaseResp modelObjectWithDictionary:[dict objectForKey:kADGetReplyListRespBaseResp]];
    NSObject *receivedADReplyList = [dict objectForKey:kADGetReplyListRespReplyList];
    NSMutableArray *parsedADReplyList = [NSMutableArray array];
    if ([receivedADReplyList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedADReplyList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedADReplyList addObject:[ADReplyList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedADReplyList isKindOfClass:[NSDictionary class]]) {
       [parsedADReplyList addObject:[ADReplyList modelObjectWithDictionary:(NSDictionary *)receivedADReplyList]];
    }

    self.replyList = [NSArray arrayWithArray:parsedADReplyList];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.baseResp dictionaryRepresentation] forKey:kADGetReplyListRespBaseResp];
    NSMutableArray *tempArrayForReplyList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.replyList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForReplyList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForReplyList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForReplyList] forKey:kADGetReplyListRespReplyList];

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

    self.baseResp = [aDecoder decodeObjectForKey:kADGetReplyListRespBaseResp];
    self.replyList = [aDecoder decodeObjectForKey:kADGetReplyListRespReplyList];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_baseResp forKey:kADGetReplyListRespBaseResp];
    [aCoder encodeObject:_replyList forKey:kADGetReplyListRespReplyList];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADGetReplyListResp *copy = [[ADGetReplyListResp alloc] init];
    
    if (copy) {

        copy.baseResp = [self.baseResp copyWithZone:zone];
        copy.replyList = [self.replyList copyWithZone:zone];
    }
    
    return copy;
}


@end
