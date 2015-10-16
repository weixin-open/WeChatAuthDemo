//
//  ADGetCommentListResp.m
//
//  Created by Jeason  on 16/10/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADGetCommentListResp.h"
#import "ADCoomentList.h"
#import "ADBaseResp.h"


NSString *const kADGetCommentListRespCoomentList = @"cooment_list";
NSString *const kADGetCommentListRespBaseResp = @"base_resp";
NSString *const kADGetCommentListRespCommentCount = @"comment_count";
NSString *const kADGetCommentListRespPerpage = @"perpage";


@interface ADGetCommentListResp ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADGetCommentListResp

@synthesize coomentList = _coomentList;
@synthesize baseResp = _baseResp;
@synthesize commentCount = _commentCount;
@synthesize perpage = _perpage;


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
    NSObject *receivedADCoomentList = [dict objectForKey:kADGetCommentListRespCoomentList];
    NSMutableArray *parsedADCoomentList = [NSMutableArray array];
    if ([receivedADCoomentList isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedADCoomentList) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedADCoomentList addObject:[ADCoomentList modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedADCoomentList isKindOfClass:[NSDictionary class]]) {
       [parsedADCoomentList addObject:[ADCoomentList modelObjectWithDictionary:(NSDictionary *)receivedADCoomentList]];
    }

    self.coomentList = [NSArray arrayWithArray:parsedADCoomentList];
            self.baseResp = [ADBaseResp modelObjectWithDictionary:[dict objectForKey:kADGetCommentListRespBaseResp]];
            self.commentCount = [[self objectOrNilForKey:kADGetCommentListRespCommentCount fromDictionary:dict] doubleValue];
            self.perpage = [[self objectOrNilForKey:kADGetCommentListRespPerpage fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForCoomentList = [NSMutableArray array];
    for (NSObject *subArrayObject in self.coomentList) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForCoomentList addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForCoomentList addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForCoomentList] forKey:kADGetCommentListRespCoomentList];
    [mutableDict setValue:[self.baseResp dictionaryRepresentation] forKey:kADGetCommentListRespBaseResp];
    [mutableDict setValue:[NSNumber numberWithDouble:self.commentCount] forKey:kADGetCommentListRespCommentCount];
    [mutableDict setValue:[NSNumber numberWithDouble:self.perpage] forKey:kADGetCommentListRespPerpage];

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

    self.coomentList = [aDecoder decodeObjectForKey:kADGetCommentListRespCoomentList];
    self.baseResp = [aDecoder decodeObjectForKey:kADGetCommentListRespBaseResp];
    self.commentCount = [aDecoder decodeDoubleForKey:kADGetCommentListRespCommentCount];
    self.perpage = [aDecoder decodeDoubleForKey:kADGetCommentListRespPerpage];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_coomentList forKey:kADGetCommentListRespCoomentList];
    [aCoder encodeObject:_baseResp forKey:kADGetCommentListRespBaseResp];
    [aCoder encodeDouble:_commentCount forKey:kADGetCommentListRespCommentCount];
    [aCoder encodeDouble:_perpage forKey:kADGetCommentListRespPerpage];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADGetCommentListResp *copy = [[ADGetCommentListResp alloc] init];
    
    if (copy) {

        copy.coomentList = [self.coomentList copyWithZone:zone];
        copy.baseResp = [self.baseResp copyWithZone:zone];
        copy.commentCount = self.commentCount;
        copy.perpage = self.perpage;
    }
    
    return copy;
}


@end
