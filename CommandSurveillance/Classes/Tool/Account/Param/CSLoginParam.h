//
//  CSLoginParam.h
//  CloudSurveillance
//
//  Created by liangcong on 16/11/4.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSLoginParam : NSObject

@property (nonatomic,assign) int    msgid; //  msgid:消息ID，参见HttpMsgId定义

@property (nonatomic,copy) NSString *signature;// 签名

@property (nonatomic,assign) int userid;

@property (nonatomic,assign) int pageid;

@property (nonatomic,assign) int pagecount;
@end

/*
 http://ip:port/?msgid=120&authkey=...&accountid=100&accountname=...&tel=...&isvalid=1&organizeid=1&pageid=1&pagecount=10
 ip:服务器IP地址；
 port:服务器端口号（默认8050）；
 msgid:消息ID，参见HttpMsgId定义；
 accountid:账号ID（登录返回的id）;
 accountname:账号（可选项）；
 tel:手机号（可选项）；
 isvalid:是否启用（可选项）（0：不启用，1启用）；
 organizeid:组织结构id（可选项）;
 pageid：当前页数；
 pagecount：每页个数；
 
 回复：
 { "result" :0,"accouncount":10,"accounts":[{"id":1,"account":...,"role":3,"tel":...,""organizeid":1,organizename":"...""enpid":1,"email":"...","userauthflag":"1"},.....]}
 result：结果值(0-成功，1-失败，其他-错误码);
 accouncount：账号总数
 id:用户人员唯一标识ID；
 account:用户账号；（可以是用户名也可以是手机号）；
 role:用户角色，参见用户角色枚举定义；
 tel:用户联系方式；
 email:用户邮箱
 organizeid:组织结构id
 organizename:组织结构名；
 enpid:账户所属企业ID；
 userauthflag:用户认证标记（0没有认证1已认证）

 */
@class CSOneUserModel;
@interface CSUsersModel : NSObject
@property (nonatomic,assign) int result;//：结果值(0-成功，1-失败，其他-错误码);
@property (nonatomic,assign) int totnum;//：账号总数
@property (nonatomic,strong) NSMutableArray<CSOneUserModel*> *accounts;

@property (nonatomic,strong) NSMutableDictionary *dicPreAccount;//存储每个account,键值id ,CSOneUserModel
@property (nonatomic,strong) NSMutableDictionary *dicAccounts;//每个索引下的数据array
@property (nonatomic,strong) NSMutableArray *arrySortedKeys;//索引数组
+ (instancetype)instance;
- (void)makeData;

/**
 处理任意用户数组

 @param array 要处理的数组
 @param dicAccouts 返回处理好的dic，按照A B C D E F...
 @return 返回通讯录右侧的索引
 */
+ (NSMutableArray*)makeArrayData:(NSMutableArray<CSOneUserModel*>*)array toDic:(NSMutableDictionary*)dicAccouts;
@end
@interface CSOneUserModel : NSObject
@property (nonatomic,assign) int id;//:用户人员唯一标识ID；
@property (nonatomic,copy) NSString *name;//用户名

@property (nonatomic,assign) BOOL bIsSelect;
@property (nonatomic,assign) BOOL bIsOnline;
@property (nonatomic,copy) NSString* strPinYin;// 
@property (nonatomic,copy) NSString* strLetter;// 首字母
@end
