//
//  CSAccountParam.h
//  CloudSurveillance
//
//  Created by liangcong on 16/8/3.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSAccountParamTagType : NSObject
@property (nonatomic,assign) int    msgid; //  msgid:消息ID，参见HttpMsgId定义
@property (nonatomic,assign) int    userid; //  userid:用户ID（登录返回的userid)
@property (nonatomic, copy) NSString *signature;
@property (nonatomic,copy) NSString *hashcode;        //哈希串，创建问题，标签用的

@end
@interface CSAccountParam : NSObject

@property (nonatomic,copy) NSString *tel;

@property (nonatomic,assign) int    msgid; //  msgid:消息ID，参见HttpMsgId定义

@property (nonatomic,copy) NSString *verifCode;

@property (nonatomic,copy) NSString *pswd;

@property (nonatomic,assign) int    userid; //  userid:用户ID（登录返回的userid)

@property (nonatomic, copy) NSString *signature;

@property (nonatomic,copy) NSString *newpswd;

@property (nonatomic,copy) NSString *Oldpswd;

@property (nonatomic,copy) NSString*  iconfile;  //MJ报错

@property (nonatomic,assign) int msgversion; // msgversion:上一次获取系统消息中的msgversion，第一次获取消息则赋值为0;

@property (nonatomic,assign) int factoryid; // 工厂id

@property (nonatomic,assign) int subfactoryid; // 厂区id

@property (nonatomic,copy) NSString *hashcode;        //哈希串，创建问题，标签用的

@end
