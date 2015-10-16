//
//  ADGetCommentListResp.h
//
//  Created by Jeason  on 16/10/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADBaseResp;

@interface ADGetCommentListResp : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *coomentList;
@property (nonatomic, strong) ADBaseResp *baseResp;
@property (nonatomic, assign) double commentCount;
@property (nonatomic, assign) double perpage;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
