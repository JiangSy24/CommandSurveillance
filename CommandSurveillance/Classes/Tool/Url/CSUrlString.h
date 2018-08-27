//
//  CSUrlString.h
//  CloudSurveillance
//
//  Created by liangcong on 16/8/3.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/*
 {"userid" : 552,
 "sysconf" : {
     "accountid" : 1,
     "httpport" : 8050,
     "imsvrhttpport" : 9050,
     "imsvrid" : 1,
     "imsvrip" : "192.168.0.187",
     "imsvrport" : 4000,
     "signature" : "c4ca4238a0b92382",
     "thirdparty" : {
         "swsignature" : "abscdwecsdvfbguyjuyhmnghnfr"
     },
     "version" : {
         "number" : "1.0.0.1",
         "url" : "http://192.168.0.187/123.apk"
     },
     "vfilesvrdownport" : 8080,
     "vfilesvrhttpport" : 9090,
     "vfilesvrid" : 1,
     "vfilesvrip" : "192.168.0.187"
 }
 ,
 "signature" : "QNC52e+Klt9u9fhOWgixgXUq1fiLJIg5"}
 */
@interface OutLibModel : NSObject
@property (nonatomic,copy) NSString *swsignature;
@end
@interface VersionModel : NSObject
@property (nonatomic,copy) NSString *number;
@property (nonatomic,copy) NSString *url;
@end
@interface SysconfModel : NSObject//指挥云，外层的是掌巡的
@property (nonatomic,assign) int accountid;
@property (nonatomic,assign) int imsvrhttpport;//im聊天
@property (nonatomic,assign) int httpport;//获取用户
@property (nonatomic,assign) int imsvrid;
@property (nonatomic,copy) NSString *imsvrip;
@property (nonatomic,assign) int imsvrport;//登录im
@property (nonatomic,copy) NSString *signature;// 签名
@property (nonatomic,strong) OutLibModel *thirdparty;
@property (nonatomic,strong) VersionModel *version;
@property (nonatomic,copy) NSString *vfilesvrip;
@property (nonatomic,assign) int vfilesvrdownport;
@property (nonatomic,assign) int vfilesvrhttpport;
@property (nonatomic,assign) int vfilesvrid;
@end

@interface Authenticate : NSObject

@property (nonatomic, copy) NSString *userInfoAddress;
@property (nonatomic, copy) NSString *chatAddress;

//@property (nonatomic,assign) int userid;
@property (nonatomic,strong) SysconfModel *sysconf;
@property (nonatomic,copy) NSString *signature;// 签名
@end
@interface CSUrlString : NSObject

@property (nonatomic,copy)NSString*     strUrl;

@property (nonatomic,copy)NSString*     strRegUrl;

@property (nonatomic,copy) NSString *ip;

@property (nonatomic, assign) int port;

@property (nonatomic,assign) BOOL bErr;

+ (instancetype)instance;

@property (nonatomic, strong) Authenticate* account;

@property (copy, nonatomic) void (^authenticateCallBack)(int32_t nMsgId);

- (int)initAuthenticateIp:(NSString*)strIp port:(int)iPort;

- (void)Authenticate_GetSysConfSuccess:(void (^)(Authenticate* model))success failure:(void (^)(int error))failure;

- (int)Authenticate_LoginType:(int)iType userName:(NSString*)strUserName passWord:(NSString*)strPassword;

- (void)Authenticate_Logout;

- (void)uinitAuthenticate;
@end
