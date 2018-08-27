//
//  LMPhoneActModel.h
//  LZRemotePlatform
//
//  Created by liangcong on 17/7/7.
//  Copyright © 2017年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 WM_IM_ChatMsgId_Invalid = 0,
 WM_IM_ChatMsgId_Invite_Notify,  //邀请通知, {"chatid", "sponsorid", "chattype"}
 WM_IM_ChatMsgId_Invite_Response, //邀请回应，{"chatid", "userid", "response"}
 WM_IM_ChatMsgId_MemAdd_Notify,  //成员增加通知, {"chatid", "sponsorid", "userid"}
 WM_IM_ChatMsgId_MemLost_Notify,  //成员减少通知, {"chatid", "userid"}
 */

@interface LMPhoneActModel : NSObject
@property (nonatomic,assign) int chatid;        //会话id
@property (nonatomic,assign) int sponsorid;     //发起者id
@property (nonatomic,assign) uint32_t chattype;      //会议类型 enmWM_IM_CallType
@property (nonatomic,assign) int userid;        //减少成员id
@property (nonatomic,assign) int nMsgId;    // 通话消息ID enmCallMsgId
@property (nonatomic,assign) int response;  // 1是拒绝

/*
 //基本消息ID
 enum enmSvrMsgId
 {
 WM_IM_SvrMsgId_Invalid = 0,
 WM_IM_SvrMsgId_UserOnline, //上线通知, {"userid", "signature", "maccode"}
 WM_IM_SvrMsgId_UserOffline,//离线通知, {"userid"}
 WM_IM_SvrMsgId_DisConnect,//断线通知
 WM_IM_SvrMsgId_ReConnect,//重连通知, {"result", "syncuser":[{"id", "maccode"}], "syncgroup":[{"id", "name", "owner", "createtime", "reserved1", "reserved2", "reserved3", "reserved4", "member":[{"id"}]}]}
 WM_IM_SvrMsgId_KickOut,//被服务器踢通知,
 };
 */
@property (nonatomic,copy) NSString* signature;     // 签名
@property (nonatomic,copy) NSString* maccode;       //

// 抢麦
//{"result", "userid", "time"}
@property (nonatomic,assign) int result;
@property (nonatomic,assign) int time;
@end
