//
//  ADAccessLog.h
//
//  Created by Jeason  on 14/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ADAccessLog : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double loginTime;
@property (nonatomic, assign) ADLoginType loginType;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
