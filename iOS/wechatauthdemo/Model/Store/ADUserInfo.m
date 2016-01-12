//
//  ADUserInfo.m
//
//  Created by WeChat  on 18/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import "ADUserInfo.h"


NSString *const kADUserInfoOpenid = @"openid";
NSString *const kADUserInfoUin = @"uin";
NSString *const kADUserInfoMail = @"mail";
NSString *const kADUserInfoNickname = @"nickname";
NSString *const kADUserInfoPwdH1 = @"pwd_h1";
NSString *const kADUserInfoLoginTicket = @"login_ticket";
NSString *const kADUserInfoUnionid = @"unionid";
NSString *const kADUserInfoAuthCode = @"auth_code";
NSString *const kADUserInfoHeadimgurl = @"headimgurl";
NSString *const kADUserInfoSex = @"sex";

@interface ADUserInfo ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation ADUserInfo

@synthesize openid = _openid;
@synthesize uin = _uin;
@synthesize mail = _mail;
@synthesize nickname = _nickname;
@synthesize pwdH1 = _pwdH1;
@synthesize loginTicket = _loginTicket;
@synthesize unionid = _unionid;
@synthesize authCode = _authCode;
@synthesize headimgurl = _headimgurl;
@synthesize sex = _sex;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.openid = [self objectOrNilForKey:kADUserInfoOpenid fromDictionary:dict];
            self.uin = [[self objectOrNilForKey:kADUserInfoUin fromDictionary:dict] unsignedIntValue];
            self.mail = [self objectOrNilForKey:kADUserInfoMail fromDictionary:dict];
            self.nickname = [self objectOrNilForKey:kADUserInfoNickname fromDictionary:dict];
            self.pwdH1 = [self objectOrNilForKey:kADUserInfoPwdH1 fromDictionary:dict];
            self.loginTicket = [self objectOrNilForKey:kADUserInfoLoginTicket fromDictionary:dict];
            self.unionid = [self objectOrNilForKey:kADUserInfoUnionid fromDictionary:dict];
            self.authCode = [self objectOrNilForKey:kADUserInfoAuthCode fromDictionary:dict];
            self.headimgurl = [self objectOrNilForKey:kADUserInfoHeadimgurl fromDictionary:dict];
            self.sex = [[self objectOrNilForKey:kADUserInfoSex fromDictionary:dict] intValue];
    }
    
    return self;
    
}

+ (instancetype)currentUser {
    static dispatch_once_t onceToken;
    static ADUserInfo *currentUser_ = nil;
    dispatch_once(&onceToken, ^{
        currentUser_ = [[ADUserInfo alloc] init];
    });
    return currentUser_;
}

- (void)setUin:(UInt32)uin {
    _uin = uin;
}

+ (instancetype)visitorUser {
    ADUserInfo *visitorUser = [[ADUserInfo alloc] init];
    visitorUser.nickname = @"访客";
    visitorUser.uin = [[ADUserInfo currentUser] uin];
    return visitorUser;
}

- (BOOL)save {
    [[NSUserDefaults standardUserDefaults] setObject:@(self.uin)
                                              forKey:kADUserInfoUin];
    [[NSUserDefaults standardUserDefaults] setObject:self.loginTicket
                                              forKey:kADUserInfoLoginTicket];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)load {
    self.uin = [[self objectOrNilForKey:kADUserInfoUin
                        fromUserDefault:[NSUserDefaults standardUserDefaults]] intValue];
    self.loginTicket = [self objectOrNilForKey:kADUserInfoLoginTicket
                               fromUserDefault:[NSUserDefaults standardUserDefaults]];
    return self.uin != 0 && self.loginTicket != nil;
}

- (void)clear {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kADUserInfoUin];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kADUserInfoLoginTicket];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.openid = nil;
    self.mail = nil;
    self.pwdH1 = nil;
    self.uin = 0;
    self.loginTicket = nil;
    self.unionid = nil;
    self.authCode = nil;
    self.headimgurl = nil;
    self.sex = ADSexTypeUnknown;
    self.sessionExpireTime = 0;
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.openid forKey:kADUserInfoOpenid];
    [mutableDict setValue:@(self.uin) forKey:kADUserInfoUin];
    [mutableDict setValue:self.mail forKey:kADUserInfoMail];
    [mutableDict setValue:self.nickname forKey:kADUserInfoNickname];
    [mutableDict setValue:self.pwdH1 forKey:kADUserInfoPwdH1];
    [mutableDict setValue:self.loginTicket forKey:kADUserInfoLoginTicket];
    [mutableDict setValue:self.unionid forKey:kADUserInfoUnionid];
    [mutableDict setValue:self.authCode forKey:kADUserInfoAuthCode];
    [mutableDict setValue:self.headimgurl forKey:kADUserInfoHeadimgurl];
    [mutableDict setValue:@(self.sex) forKey:kADUserInfoSex];
    
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

- (id)objectOrNilForKey:(id)aKey fromUserDefault:(NSUserDefaults *)dict {
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.openid = [aDecoder decodeObjectForKey:kADUserInfoOpenid];
    self.uin = [[aDecoder decodeObjectForKey:kADUserInfoUin] unsignedIntValue];
    self.mail = [aDecoder decodeObjectForKey:kADUserInfoMail];
    self.nickname = [aDecoder decodeObjectForKey:kADUserInfoNickname];
    self.pwdH1 = [aDecoder decodeObjectForKey:kADUserInfoPwdH1];
    self.loginTicket = [aDecoder decodeObjectForKey:kADUserInfoLoginTicket];
    self.unionid = [aDecoder decodeObjectForKey:kADUserInfoUnionid];
    self.authCode = [aDecoder decodeObjectForKey:kADUserInfoAuthCode];
    self.headimgurl = [aDecoder decodeObjectForKey:kADUserInfoHeadimgurl];
    self.sex = [aDecoder decodeIntForKey:kADUserInfoSex];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_openid forKey:kADUserInfoOpenid];
    [aCoder encodeObject:@(_uin) forKey:kADUserInfoUin];
    [aCoder encodeObject:_mail forKey:kADUserInfoMail];
    [aCoder encodeObject:_nickname forKey:kADUserInfoNickname];
    [aCoder encodeObject:_pwdH1 forKey:kADUserInfoPwdH1];
    [aCoder encodeObject:_loginTicket forKey:kADUserInfoLoginTicket];
    [aCoder encodeObject:_unionid forKey:kADUserInfoUnionid];
    [aCoder encodeObject:_authCode forKey:kADUserInfoAuthCode];
    [aCoder encodeObject:_headimgurl forKey:kADUserInfoHeadimgurl];
    [aCoder encodeInt:_sex forKey:kADUserInfoSex];
}

- (id)copyWithZone:(NSZone *)zone
{
    ADUserInfo *copy = [[ADUserInfo alloc] init];
    
    if (copy) {

        copy.openid = [self.openid copyWithZone:zone];
        copy.uin = self.uin;
        copy.mail = [self.mail copyWithZone:zone];
        copy.nickname = [self.nickname copyWithZone:zone];
        copy.pwdH1 = [self.pwdH1 copyWithZone:zone];
        copy.loginTicket = [self.loginTicket copyWithZone:zone];
        copy.unionid = [self.unionid copyWithZone:zone];
        copy.authCode = [self.authCode copyWithZone:zone];
        copy.headimgurl = [self.headimgurl copyWithZone:zone];
        copy.sex = self.sex;
    }
    
    return copy;
}


@end
