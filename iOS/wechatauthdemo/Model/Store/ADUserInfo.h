//
//  ADUserInfo.h
//
//  Created by Jeason  on 18/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ADUserInfo : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *openid;
@property (nonatomic, assign) UInt32 uin;
@property (nonatomic, strong) NSString *mail;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *pwdH1;
@property (nonatomic, strong) NSString *loginTicket;
@property (nonatomic, strong) NSString *unionid;
@property (nonatomic, strong) NSString *authCode;
@property (nonatomic, strong) NSString *headimgurl;
@property (nonatomic, assign) double sessionExpireTime;
@property (nonatomic, assign) ADSexType sex;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

+ (instancetype)currentUser;
+ (instancetype)visitorUser;
- (BOOL)save;
- (BOOL)load;
- (void)clear;

@end
