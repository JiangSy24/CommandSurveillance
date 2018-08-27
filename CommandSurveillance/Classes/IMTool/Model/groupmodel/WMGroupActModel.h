//
//  WMGroupActModel.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/7/10.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 //群组消息ID
 enum enmGroupMsgId
 {
 WM_IM_GroupMsgId_Invalid = 0,
 WM_IM_GroupMsgId_Join_Notify, //添加组通知(自己被邀请入群), {"sponsorid", "groupinfo":[{"id", "name", "owner", "createtime", "reserved1", "reserved2", "reserved3", "reserved4", "member":[{"id"}]}]}
 WM_IM_GroupMsgId_Other_Join_Notify, //其他人加群通知, {"sponsorid", "groupid", "joinids":[{"id"}]}
 WM_IM_GroupMsgId_KickOut_Notify,  //被踢通知(自己), {"sponsorid", "groupid"}
 WM_IM_GroupMsgId_Other_KickOut_Notify, //被踢通知(其他), {"sponsorid", "groupid", "kickoutid"}
 WM_IM_GroupMsgId_HadLeft_Notify, //退群通知, {"groupid", "userid"}
 WM_IM_GroupMsgId_Dissolve_Notify, //解散通知, {"sponsorid", "groupid"}
 };
 */
@class WMGroupMsgUserModel;
@class WMGroupMsgModel;
@interface WMGroupActModel : NSObject
@property (nonatomic, assign) int sponsorid;
@property (nonatomic, assign) int groupid;
@property (nonatomic, assign) int kickoutid;
@property (nonatomic, assign) int userid;
@property (nonatomic, strong) WMGroupMsgModel *groupinfo;
@property (nonatomic, strong) NSMutableArray <WMGroupMsgUserModel*>* joinids;

@property (nonatomic, assign) int32_t nMsgId;
@end


@interface WMGroupMsgModel : NSObject
@property (nonatomic, assign) int id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int owner;
@property (nonatomic, assign) int createtime;
@property (nonatomic, strong) NSMutableArray<WMGroupMsgUserModel*> *member;
@end

@interface WMGroupMsgUserModel : NSObject
@property (nonatomic, assign) int id;
@end
