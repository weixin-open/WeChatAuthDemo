//
//  ADNetworkConfigItem.h
//
//  Created by Jeason  on 20/08/2015
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

AUTH_DEMO_EXTERN NSString *const kEncryptWholePacketParaKey;
AUTH_DEMO_EXTERN NSString *const kDecryptWholePacketRespKey;

@interface ADNetworkConfigItem : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *cgiName;
@property (nonatomic, strong) NSString *encryptKeyPath;
@property (nonatomic, assign) EncryptAlgorithm encryptAlgorithm;
@property (nonatomic, assign) EncryptAlgorithm decryptAlgorithm;
@property (nonatomic, strong) NSString *requestPath;
@property (nonatomic, strong) NSString *decryptKeyPath;
@property (nonatomic, strong) NSString *httpMethod;
@property (nonatomic, strong) NSString *sysErrKeyPath;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
