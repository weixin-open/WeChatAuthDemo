//
//  ADCheckLoginResp.h
//
//  Created by Jeason  on 14/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADBaseResp;

@interface ADCheckLoginResp : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) ADBaseResp *baseResp;
@property (nonatomic, strong) NSString *sessionKey;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
