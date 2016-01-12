//
//  ADReplyList.h
//
//  Created by WeChat  on 16/10/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADUser;

@interface ADReplyList : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) ADUser *user;
@property (nonatomic, strong) NSString *replyListIdentifier;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *replyToId;
@property (nonatomic, assign) double date;
@property (nonatomic, assign) CGFloat height;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
