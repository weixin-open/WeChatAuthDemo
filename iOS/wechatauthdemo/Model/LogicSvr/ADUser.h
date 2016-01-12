//
//  ADUser.h
//
//  Created by WeChat  on 16/10/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ADUser : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double sex;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *headimgurl;
@property (nonatomic, strong) NSString *openid;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
