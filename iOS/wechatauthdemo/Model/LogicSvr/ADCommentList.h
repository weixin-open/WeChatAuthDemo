//
//  ADCommentList.h
//
//  Created by WeChat  on 19/10/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADUser;

@interface ADCommentList : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) double date;
@property (nonatomic, strong) NSString *commentListIdentifier;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) double replyCount;
@property (nonatomic, strong) ADUser *user;
@property (nonatomic, strong) NSArray *replyList;
@property (nonatomic, assign) CGFloat height;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
