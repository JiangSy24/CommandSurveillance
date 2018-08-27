//
//  LMRegisterModle.h
//  LZRemotePlatform
//
//  Created by liangcong on 17/7/6.
//  Copyright © 2017年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LMRegisterSyncuserModel.h"
#import "LMRegisterSyncgroupModel.h"
#import "LMPhoneActModel.h"
 /*
 "result" : 0,
 "syncgroup" : [
 {
 "createtime" : 1505371511,
 "id" : 52,
 "member" : [
 {
 "id" : 3
 },
 {
 "id" : 167
 }
 ],
 "name" : "yhhj",
 "owner" : 167,
 "reserved1" : "",
 "reserved2" : "",
 "reserved3" : "",
 "reserved4" : ""
 },...],
 "syncuser" : [
 {
 "id" : 1,
 "maccode" : "a_864698030364174"
 },
 {
 "id" : 3,
 "maccode" : "VEYE-C768FE68-4562-4BD3-8465-D19E18BA70B4"
 }
 ]
 */

@interface LMRegisterModle : NSObject
//{"result", "syncuser":[{"id", "maccode"}], "syncgroup":[{"id", "name", "owner", "createtime", "reserved1", "reserved2", "reserved3", "reserved4", "member":[{"id"}]}]}
@property (nonatomic,assign) int result;
@property (nonatomic,strong) NSArray<LMRegisterSyncuserModel*> *syncuser;
@property (nonatomic,strong) NSArray<LMRegisterSyncgroupModel*> *syncgroup;

@property (atomic,strong) NSMutableArray<LMRegisterSyncuserModel*> *syncuserArry;   // 在线数组
@property (atomic,strong) NSMutableArray<LMRegisterSyncgroupModel*> *syncgroupArry;

// 通话数组
@property (atomic,strong) NSMutableArray <LMPhoneActModel*> *lmCallArray;
@property (nonatomic,strong) NSLock *lock;
+ (instancetype)instance;
@end

/*
 //聊天消息ID
 enum enmChatMsgTypeId
 {
 WM_IM_ChatMsgTypeId_Invalid = 0,
 WM_IM_ChatMsgTypeId_Single,  //单人聊天消息{"content" : "456", "sendtime" : 1505033490, "srcuserId" : 100, "type" : 0}
 WM_IM_ChatMsgTypeId_Group,  //群组聊天消息 {"content" : "456", "groupid" : 39, "sendtime" : 1505033490, "srcuserId" : 100, "type" : 0}
 };
 */
@interface LMRegisterChatModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) int sendtime;
@property (nonatomic, assign) int srcuserId;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int groupid;
@end

