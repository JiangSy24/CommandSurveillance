//
//  CSQCenterParam.h
//  CloudSurveillance
//
//  Created by liangcong on 16/10/25.
//  Copyright © 2016年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>

/*

 msgid:消息ID，参见HttpMsgId定义；
 userid:用户ID（登录返回的userid），即问题创建人；
 problemtypeid :问题分类ID；
 relateddeviceid :关联设备ID；
 createtime:问题创建时间（精确到秒）；
 donetime:问题被处理的截止时间（精确到日期，以当天24:00为最终截止点）；
 ownerid:问题责任人ID；
 ccuserids:问题抄送人ID字符串（多个ID使用’;’分割）；
 imagecontent:图片内容
 
 
 ip:服务器IP地址；
 port:服务器端口号（默认8050）；
 msgid:消息ID，参见HttpMsgId定义；
 userid:用户ID（登录返回的userid），即问题创建人；
 problemtypeid :问题分类ID；
 relateddeviceid :关联设备ID；
 createtime:问题创建时间（精确到秒）；
 donetime:问题被处理的截止时间（精确到日期，以当天24:00为最终截止点）；
 ownerid:问题责任人ID；
 ccuserids:问题抄送人ID字符串（多个ID使用’,’分割,如：1,3,5,）；
 imagecontent:图片内容

 
 ip:服务器IP地址；
 port:服务器端口号（默认8050）；
 msgid:消息ID，参见HttpMsgId定义；
 userid:用户ID（登录返回的userid），即问题创建人；
 problemtypeid :问题分类ID；
 relateddeviceid :关联设备ID；
 donetime:问题被处理的截止时间（精确到日期，以当天24:00为最终截止点）；
 ownerid:问题责任人ID；
 ccuserids:问题抄送人ID字符串（多个ID使用’,’分割,如：1,3,5,）；
 problemdesp:问题描述；
 imagecontent:图片内容（内容在传输前使用urlencode方式加密，可选字段）
 imagetype:图片类型（可选字段，PNG类型值为1， JPG类型值为2）
 
 sourcetype:问题来源类型（1：表示“定点监控”；2：表示“现场巡视”）；
 relateddeviceid :关联监控点ID；（如果包含图片，则需要根据图片属性的关联来自动赋值，对于该字段只在问题来源为“定点监控”情况下有效）
 relatedsubfactoryid:关联厂区ID；（如果包含图片，则需要根据图片属性的关联来自动赋值，对于该字段只在问题来源为“现场巡视”情况下有效）
 */

@interface CSQCenterParam : NSObject

@property (nonatomic,assign) int    msgid; //  msgid:消息ID，参见HttpMsgId定义

@property (nonatomic,assign) int    userid; //  userid:用户ID（登录返回的userid)

@property (nonatomic, copy) NSString *signature;

@property (nonatomic,assign) int    problemtypeid; // 就是标签

@property (nonatomic,assign) int    relateddeviceid; //关联设备ID；（如果包含图片，则需要根据图片属性的关联来自动赋值，对于该字段只在问题来源为“定点监控”情况下有效）

//@property (nonatomic,assign) int    createtime; // 问题创建时间（精确到秒）；

@property (nonatomic,assign) int    donetime; // 问题被处理的截止时间

@property (nonatomic,assign) int    ownerid; // 问题责任人ID；

@property (nonatomic,copy) NSString *problemdesp; // 问题描述

@property (nonatomic,copy) NSString *ccuserids; // 问题抄送人ID字符串（多个ID使用’;’分割）；

@property (nonatomic,copy) NSString *imagecontent; // 图片内容

@property (nonatomic,assign) int imagetype; // 图片类型

//@property (nonatomic,assign) int sourcetype; // 问题来源类型（1：表示“定点监控”；2：表示“现场巡视”）；

@property (nonatomic,assign) int relatedsubfactoryid;//:关联厂区ID；（如果包含图片，则需要根据图片属性的关联来自动赋值，对于该字段只在问题来源为“现场巡视”情况下有效）

@end
