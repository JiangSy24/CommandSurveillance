//
//  CSAccount.h
//  CloudSurveillance
//
//  Created by liangcong on 16/8/3.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSVfilesvr.h"
/*
 veyesvrip: Veye平台服务器IP；
 veyesvrport: Veye平台服务器端口；
     回复：{ "result" : 0,"hasRegister" : 0, "verifCode" : "7889" }
     result：结果值(0-成功，1-失败，其他-错误码);
     hasRegister:是否已注册（0-否，1-是）;
     verifCode:验证码，参考迭代开发中参数说明
 
 vfilesvr：录像文件服务器
 vfilesvrid:录像文件服务器ID；
 vfilesvrip:录像文件服务器IP；
 vfilesvrport:录像文件服务器端口；
 */

@interface CSAccount : NSObject

/**
 *  Veye平台服务器Port
 */
@property (nonatomic,assign) int veyesvrport;

/**
 *  Veye平台服务器IP
 */
@property (nonatomic,copy) NSString *veyesvrip;

/**
 *  返回结果
 */
@property (nonatomic,assign) int result;

/**
 *  是否已经注册
 */
@property (nonatomic,assign) int hasRegister;

/**
 *  验证码
 */
@property (nonatomic,copy)  NSString*   verifCode;

/**
 *  用户唯一标识id 登录用的
 */
@property (nonatomic,assign) int userid;

/**
 *  用户id 用户过滤信息用的
 */
@property (nonatomic,assign) int accountid;

/**
 *  个人头像图片文件HTTP服务器端文件路径，默认路径http://ip:8090/conf/account/accountid.jpg	(accountid为账号唯一标识ID)
 */
//@property (nonatomic, copy) NSString *iconData;

/**
 *  上传个人头像图片base64编码后的路径二进制数据;
 */
@property (nonatomic, copy) NSString* icondata;

/**
 *  veye的用户名
 */
@property (nonatomic, copy) NSString* veyeuserid;

/**
 *  veye的密码
 */
@property (nonatomic, copy) NSString *veyekey;

/**
 *  是否为已注册用户 0 游客 1已注册
 */
@property (nonatomic, assign) int hasregister;

@property (nonatomic, strong) CSVfilesvr *vfilesvr;

/**
 *  0 标清 1高清 2超清
 */
@property (nonatomic, assign) int iPicQuality;

/**
 *  现场巡视是否有最新 0没有 1有
 */
@property (nonatomic, assign) BOOL bIsVideoNew;

/**
 *  问题中心是否有最新 0没有 1有
 */
@property (nonatomic, assign) BOOL bIsNewProblem;

/**
 *  是否允许4g
 */
@property (nonatomic,assign) BOOL bIsAllow4G;

/*
 veyepswd = e10adc3949ba59ab;
 veyeuser = yundd;
 */
+ (instancetype)accountWithDict:(NSDictionary *)dict;

@end
