//
//  ADCoomentList.m
//
//  Created by Jeason  on 16/10/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADCoomentList.h"
#import "ADReplyList.h"
#import "ADUser.h"


NSString *const kADCoomentListReplyList = @"reply_list";
NSString *const kADCoomentListId = @"id";
NSString *const kADCoomentListContent = @"content";
NSString *const kADCoomentListReplyCount = @"reply_count";
NSString *const kADCoomentListDate = @"date";
NSString *const kADCoomentListUser = @"user";


@interface ADCoomentList ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADCoomentList

@synthesize replyList = _replyList;
@synthesize coomentListIdentifier = _coomentListIdentifier;
@synthesize content = _content;
@synthesize replyCount = _replyCount;
@synthesize date = _date;
@synthesize user = _user;


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
    NSObject *receivedADReplyList = [dict objectForKey:kADCoomentListReplyList];
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
            self.coomentListIdentifier = [self objectOrNilForKey:kADCoomentListId fromDictionary:dict];
            self.content = [self objectOrNilForKey:kADCoomentListContent fromDictionary:dict];
            self.replyCount = [[self objectOrNilForKey:kADCoomentListReplyCount fromDictionary:dict] doubleValue];
            self.date = [[self objectOrNilForKey:kADCoomentListDate fromDictionary:dict] doubleValue];
            self.user = [ADUser modelObjectWithDictionary:[dict objectForKey:kADCoomentListUser]];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForReplyList] forKey:kADCoomentListReplyList];
    [mutableDict setValue:self.coomentListIdentifier forKey:kADCoomentListId];
    [mutableDict setValue:self.content forKey:kADCoomentListContent];
    [mutableDict setValue:[NSNumber numberWithDouble:self.replyCount] forKey:kADCoomentListReplyCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.date] forKey:kADCoomentListDate];
    [mutableDict setValue:[self.user dictionaryRepresentation] forKey:kADCoomentListUser];

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

    self.replyList = [aDecoder decodeObjectForKey:kADCoomentListReplyList];
    self.coomentListIdentifier = [aDecoder decodeObjectForKey:kADCoomentListId];
    self.content = [aDecoder decodeObjectForKey:kADCoomentListContent];
    self.replyCount = [aDecoder decodeDoubleForKey:kADCoomentListReplyCount];
    self.date = [aDecoder decodeDoubleForKey:kADCoomentListDate];
    self.user = [aDecoder decodeObjectForKey:kADCoomentListUser];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_replyList forKey:kADCoomentListReplyList];
    [aCoder encodeObject:_coomentListIdentifier forKey:kADCoomentListId];
    [aCoder encodeObject:_content forKey:kADCoomentListContent];
    [aCoder encodeDouble:_replyCount forKey:kADCoomentListReplyCount];
    [aCoder encodeDouble:_date forKey:kADCoomentListDate];
    [aCoder encodeObject:_user forKey:kADCoomentListUser];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADCoomentList *copy = [[ADCoomentList alloc] init];
    
    if (copy) {

        copy.replyList = [self.replyList copyWithZone:zone];
        copy.coomentListIdentifier = [self.coomentListIdentifier copyWithZone:zone];
        copy.content = [self.content copyWithZone:zone];
        copy.replyCount = self.replyCount;
        copy.date = self.date;
        copy.user = [self.user copyWithZone:zone];
    }
    
    return copy;
}


@end
