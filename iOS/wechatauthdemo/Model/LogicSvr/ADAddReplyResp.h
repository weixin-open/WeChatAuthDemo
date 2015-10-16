//
//  ADAddReplyResp.h
//
//  Created by Jeason  on 16/10/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ADAddReplyResp : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *reply;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
