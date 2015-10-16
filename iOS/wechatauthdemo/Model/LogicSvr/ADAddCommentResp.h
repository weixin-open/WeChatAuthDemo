//
//  ADAddCommentResp.h
//
//  Created by Jeason  on 16/10/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADBaseResp;

@interface ADAddCommentResp : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) ADBaseResp *baseResp;
@property (nonatomic, strong) NSString *comment;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
