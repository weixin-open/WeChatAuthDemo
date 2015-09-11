//
//  Definition.h
//  AuthSDKDemo
//
//  Created by Jeason on 14/08/2015.
//  Copyright (c) 2015 Tencent. All rights reserved.
//

#ifndef AuthSDKDemo_Definition_h
#define AuthSDKDemo_Definition_h
#import "Constant.h"

typedef enum {
    ADSexTypeUnknown,
    ADSexTypeMale,
    ADSexTypeFemale
} ADSexType;

typedef enum {
    ADErrorCodeNoError = 0,
    ADErrorCodeSessionKeyExpired = 10001,
    ADErrorCodeUserExisted = 20001,
    ADErrorCodeAlreadyBind = 20002,
    ADErrorCodeUserNotExisted = 20003,
    ADErrorCodePasswordNotMatch = 20004,
    ADErrorCodeTicketNotMatch = 30001,
    ADErrorCodeTicketExpired = 30002,
    ADErrorCodeTokenExpired = 30003
} ADErrorCode;

typedef enum {
    EncryptAlgorithmNone = 0,
    EncryptAlgorithmRSA = 1 << 0,     /* Rsa Encrypt With Public Key */
    EncryptAlgorithmAES = 1 << 1,    /* AES Encrypt With Session Key */
    EncryptAlgorithmBase64 = 1 << 2,  /* Base64 Encode/Decode */
} EncryptAlgorithm;

typedef enum {
    ADLoginTypeFromUnknown,
    ADLoginTypeFromApp,
    ADLoginTypeFromWX
}ADLoginType;

typedef void(^ButtonCallBack)(id sender);

//A better version of NSLog
#define NSLog(format, ...) do {                                                 \
    fprintf(stderr, "<%s : %d> %s\n",                                           \
    [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
    __LINE__, __func__);                                                        \
    (NSLog)((format), ##__VA_ARGS__);                                           \
    fprintf(stderr, "-------\n");                                               \
} while (0)

//A better version of extern
#ifdef __cplusplus
#define AUTH_DEMO_EXTERN	extern "C" __attribute__((visibility ("default")))
#else
#define AUTH_DEMO_EXTERN	    extern __attribute__((visibility ("default")))
#endif

//Show Error
#define ADShowErrorAlert(wording)                               \
        [[[UIAlertView alloc] initWithTitle:nil                 \
                                    message:wording             \
                                   delegate:nil                 \
                          cancelButtonTitle:kCancleWordingText  \
                          otherButtonTitles:nil] show]

@class UIActivityIndicatorView;

static UIActivityIndicatorView *_indicatorView;
//Show ActivityIndicator
#define ADShowActivity(superView) do { \
    if (_indicatorView == nil) { \
            _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]; \
        }\
    if (![_indicatorView isAnimating]){ \
            [superView addSubview:_indicatorView]; \
            _indicatorView.center = superView.center;\
            [_indicatorView startAnimating]; \
        }   \
    } while(0)
//Hide ActivityIndicator
#define ADHideActivity do { \
    if ([_indicatorView isAnimating]) { \
        [_indicatorView stopAnimating];\
    } \
} while (0)

#import "ADBaseResp.h"
#import "ADAccessLog.h"
#import "ButtonColor.h"
#import "ErrorTitle.h"
#import "ErrorHandler.h"

#endif
