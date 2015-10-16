//
//  ADCoomentList.h
//
//  Created by Jeason  on 16/10/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADUser;

@interface ADCoomentList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *replyList;
@property (nonatomic, strong) NSString *coomentListIdentifier;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) double replyCount;
@property (nonatomic, assign) double date;
@property (nonatomic, strong) ADUser *user;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
