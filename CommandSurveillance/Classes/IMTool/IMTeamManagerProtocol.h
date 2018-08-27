//
//  IMTeamManagerProtocol.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/7/10.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#ifndef IMTeamManagerProtocol_h
#define IMTeamManagerProtocol_h
#import <Foundation/Foundation.h>
#import "LMUserIdModel.h"
#import "IMSdk_i.h"
#import "WMIMDeleteMessagesOption.h"
#import "WMGroupActModel.h"

typedef NS_ENUM(NSInteger, IM_GroupMsgId)
{
    IM_GroupMsgId_Invalid = 0,
    IM_GroupMsgId_Join_Notify, //添加组通知(自己被邀请入群), {"sponsorid", "groupinfo":[{"id", "name", "owner", "createtime", "reserved1", "reserved2", "reserved3", "reserved4", "member":[{"id"}]}]}
    IM_GroupMsgId_Other_Join_Notify, //其他人加群通知, {"sponsorid", "groupid", "joinids":[{"id"}]}
    IM_GroupMsgId_KickOut_Notify,  //被踢通知(自己), {"sponsorid", "groupid"}
    IM_GroupMsgId_Other_KickOut_Notify, //被踢通知(其他), {"sponsorid", "groupid", "kickoutid"}
    IM_GroupMsgId_HadLeft_Notify, //退群通知, {"groupid", "userid"}
    IM_GroupMsgId_Dissolve_Notify, //解散通知, {"sponsorid", "groupid"}
};

@protocol WMIMTeamManageToolDelegate <NSObject>
/**
 *  群组成员变动回调,包括数量增减以及成员属性变动
 *
 *  @param team 变动的群组
 */
- (void)onTeamMemberChanged:(WMGroupActModel *)team;

@end
@protocol WMIMTeamManageTool <NSObject>
/**
 创建组
 
 @param groupName 组名称
 @param array 组成员
 @param success 成功回调
 @param failure 失败回调
 */
- (void)creatNewGroup:(NSString*)groupName members:(NSArray<CSOneUserModel*>*)array success:(void (^)(void))success failure:(void (^)(int error))failure;

/**
 组加人
 
 @param groupId 组id
 @param array 组成员
 @param success 成功回调
 @param failure 失败回调
 */
- (void)groupInviteMember:(int)groupId members:(NSArray<CSOneUserModel*>*)array success:(void (^)(void))success failure:(void (^)(int error))failure;

/**
 组减人
 
 @param groupId 组id
 @param memberid 组成员id
 @param success 成功回调
 @param failure 失败回调
 */
- (void)groupKickOut:(int)groupId memberid:(int)memberid success:(void (^)(void))success failure:(void (^)(int error))failure;


/**
 退出组
 
 @param groupId 组id
 @return  0-成功，1-失败, 其他-错误码
 */
- (int)groupHadLeft:(int)groupId;

/**
 *  添加聊天委托
 *
 *  @param delegate 聊天委托
 */
- (void)addDelegate:(id<WMIMTeamManageToolDelegate>_Nonnull)delegate;

/**
 *  移除聊天委托
 *
 *  @param delegate 聊天委托
 */
- (void)removeDelegate:(nullable id<WMIMTeamManageToolDelegate>)delegate;
@end

#endif /* IMTeamManagerProtocol_h */
