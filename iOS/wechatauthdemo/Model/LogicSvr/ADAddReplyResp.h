//
//  ADAddReplyResp.h
//
//  Created by WeChat  on 20/10/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADBaseResp, ADReplyList;

@interface ADAddReplyResp : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) ADBaseResp *baseResp;
@property (nonatomic, strong) ADReplyList *reply;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
