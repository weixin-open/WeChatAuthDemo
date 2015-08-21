//
//  ADWXBindAPPResp.h
//
//  Created by Jeason  on 14/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADBaseResp;

@interface ADWXBindAPPResp : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) ADBaseResp *baseResp;
@property (nonatomic, assign) double uin;
@property (nonatomic, strong) NSString *loginTicket;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
