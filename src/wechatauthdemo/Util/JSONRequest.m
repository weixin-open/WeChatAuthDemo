//
//  JSONRequest.m
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#import <objc/runtime.h>
#import "JSONRequest.h"
#import "AES.h"
#import "RSA.h"
#import "ADNetworkConfigManager.h"
#import "ADNetworkConfigItem.h"

static char publicKeyId;
static char sessionKeyId;

/**
 *  iOS7里给NSURL Session增加Category会导致unrecognized selectors exception，
 *  可以看到iOS7里的NSURLSession在Runtime其实是__NSCFURLSession，
 *  所以说这个NSURLSession只是一个alias.这里耍个手段在NSObject上添加Category.
 */
@implementation NSObject (SessionKey)

- (NSString *)sessionKey {
    return objc_getAssociatedObject(self, &sessionKeyId);
}

- (void)setSessionKey:(NSString *)sessionKey {
    objc_setAssociatedObject(self, &sessionKeyId, sessionKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)publicKey {
    return objc_getAssociatedObject(self, &publicKeyId);
}

- (void)setPublicKey:(NSString *)publicKey {
    objc_setAssociatedObject(self, &publicKeyId, publicKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation NSObject (JSONRequest)

- (NSURLSessionDataTask *)JSONTaskForHost:(NSString *)host
                                     Para:(NSDictionary *)para
                            ConfigKeyPath:(NSString *)configKeyPath
                           WithCompletion:(JSONCallBack)handler {
    __weak NSURLSession *selfSession = (NSURLSession *)self;
    
    ADNetworkConfigItem *config = [[ADNetworkConfigManager sharedManager] getConfigForKeyPath:configKeyPath];
    /* Encrypt Data */
    NSData *encryptedData = [selfSession encryptJSONObject:para
                                                ForKeyPath:config.encryptKeyPath
                                            UsingAlgorithm:config.encryptAlgorithm];
    
    /* 异步请求，在这里备份一份SessionKey，防止返回前SessionKey被修改。*/
    NSString *preSessionKey = selfSession.sessionKey;
    
    /* Setup Request */
    NSURL *url = [NSURL URLWithString:[host stringByAppendingString:config.requestPath]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:config.httpMethod];
    [request setHTTPBody:encryptedData];
    
    /* Setup DataTask */
    return  [selfSession dataTaskWithRequest:request
                           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                               /* Process Network Error */
                               if (error) {
                                   NSLog(@"NetWork Error: %@", error);
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       handler (nil, error);
                                   });
                                   return;
                               }
                               /* Process Response Error */
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                               if (httpResponse.statusCode != 200) {
                                   NSLog(@"HTTP Bad Response: %ld", (long)httpResponse.statusCode);
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSError *httpError = [NSError errorWithDomain:@"Http Response Error"
                                                                                code:httpResponse.statusCode
                                                                            userInfo:nil];
                                       handler (nil, httpError);
                                   });
                                   return;
                               }
                               /* Process JSON Error */
                               NSError *jsonError = nil;
                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:NSJSONReadingAllowFragments
                                                                                      error:&jsonError];
                               if (jsonError) {
                                   NSString *jsonString = [[NSString alloc] initWithData:data
                                                                                encoding:NSUTF8StringEncoding];
                                   NSLog(@"JSON Error: %@ While Serialize %@", jsonError, jsonString);
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       handler (nil, jsonError);
                                   });
                                   return;
                               }
                               
                               /* Decrypt Dict */
                               dict = [selfSession decryptJSONObject:dict
                                                          ForKeyPath:config.decryptKeyPath
                                                      UsingAlgorithm:config.decryptAlgorithm
                                                      WithSessionKey:preSessionKey];
                               
                               /* Get Response Buffer */
                               NSString *respString = dict[config.decryptKeyPath];
                               data = [respString dataUsingEncoding:NSUTF8StringEncoding];
                               
                               /* Get Response JSON */
                               dict = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingAllowFragments
                                                                        error:&jsonError];
                               if (jsonError) {
                                   NSLog(@"JSON Error: %@ While Serialize %@", jsonError, respString);
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       handler (nil, jsonError);
                                   });
                                   return;
                               }
                               
                               /* Ok, Return */
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   handler (dict, nil);
                               });
                           }];
}

- (NSData *)encryptJSONObject:(NSDictionary *)dict
                   ForKeyPath:(NSString *)keyPath
               UsingAlgorithm:(EncryptAlgorithm)algorithm {
    NSObject *toEncryptObject = [keyPath isEqualToString:kEncryptWholePacketParaKey] ? dict : dict[keyPath];
    /* Convert Object to Data */
    NSData *toEncryptData = nil;
    if ([toEncryptObject isKindOfClass:[NSDictionary class]]) {  /* Process Dictionary */
        NSError *jsonError = nil;
        toEncryptData = [NSJSONSerialization dataWithJSONObject:toEncryptObject
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&jsonError];
        if (jsonError) {
            NSLog(@"JSON Error: %@", jsonError);
            return nil;
        }
    } else if ([toEncryptObject isKindOfClass:[NSString class]]) {   /* Process String */
        NSString *stringObject = (NSString *)toEncryptObject;
        toEncryptData = [stringObject dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([toEncryptObject isKindOfClass:[NSNumber class]]) {   /* Process Number */
        NSNumber *numberObject = (NSNumber *)toEncryptObject;
        NSString *numberString = [numberObject stringValue];
        toEncryptData = [numberString dataUsingEncoding:NSUTF8StringEncoding];
    }
    /* Encrypt NSData */
    if (algorithm & EncryptAlgorithmRSA) {  /* RSA */
        toEncryptData = [toEncryptData RSAEncryptWithPublicKey:self.publicKey];
    }
    if (algorithm & EncryptAlgorithmAES) {  /* AES */
        toEncryptData = [toEncryptData AES256EncryptWithKey:self.sessionKey];
    }
    if (algorithm & EncryptAlgorithmBase64) {   /* Base64 */
        toEncryptData = [toEncryptData base64EncodedDataWithOptions:0];
    }
    
    if ([keyPath isEqualToString:kEncryptWholePacketParaKey])
        return toEncryptData;
    /* Replace Object for KeyPath And Setup JSON */
    if (toEncryptData == nil)
        return nil;
    NSMutableDictionary *mutableDict = [dict mutableCopy];
    [mutableDict setObject:[[NSString alloc] initWithData:toEncryptData
                                                 encoding:NSUTF8StringEncoding]
                    forKey:keyPath];
    NSError *jsonError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mutableDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&jsonError];
    if (jsonError) {
        NSLog(@"JSON Error: %@", jsonError);
        return nil;
    }
    
    return jsonData;
}

- (NSDictionary *)decryptJSONObject:(NSDictionary *)dict
                         ForKeyPath:(NSString *)keyPath
                     UsingAlgorithm:(EncryptAlgorithm)algorithm
                     WithSessionKey:(NSString *)sessionKey {
    if (algorithm == EncryptAlgorithmNone)
        return dict;
    
    NSMutableDictionary *mutableDict = [dict mutableCopy];
    NSObject *object = [mutableDict objectForKey:keyPath];
    NSData *toDecryptData = nil;
    
    /* Convert Object to Data */
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSError *jsonError = nil;
        toDecryptData = [NSJSONSerialization dataWithJSONObject:object
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&jsonError];
        if (jsonError) {
            NSLog(@"JSON Error: %@", jsonError);
            return dict;
        }
    } else if ([object isKindOfClass:[NSString class]]) {
        NSString *stringObject = (NSString *)object;
        toDecryptData = [stringObject dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([object isKindOfClass:[NSNumber class]]) {
        NSNumber *numberObject = (NSNumber *)object;
        NSString *numberString = [numberObject stringValue];
        toDecryptData = [numberString dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    /* Decrypt NSData */
    if (algorithm & EncryptAlgorithmBase64) {
        toDecryptData = [[NSData alloc] initWithBase64EncodedData:toDecryptData
                                                          options:NSDataBase64DecodingIgnoreUnknownCharacters];
    }
    if (algorithm & EncryptAlgorithmAES) {
        toDecryptData = [toDecryptData AES256DecryptWithKey:sessionKey];
    }
    /* Rplace Object for KeyPath */
    if (toDecryptData == nil)
        return dict;
    [mutableDict setObject:[[NSString alloc] initWithData:toDecryptData
                                                 encoding:NSUTF8StringEncoding]
                    forKey:keyPath];
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}
@end