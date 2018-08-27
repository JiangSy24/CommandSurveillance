//
//  IMTeamManage.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/7/10.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMTeamManagerProtocol.h"
void WMGroupMsgCallBack(int32_t nMsgId, const char* pMsgData, int32_t nDataLen, void* pUser);
@interface IMTeamManage : NSObject<WMIMTeamManageTool>
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
