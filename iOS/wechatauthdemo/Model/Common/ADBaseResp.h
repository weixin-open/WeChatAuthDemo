//
//  ADBaseResp.h
//
//  Created by WeChat  on 14/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ADBaseResp : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) ADErrorCode errcode;
@property (nonatomic, strong) NSString *errmsg;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
