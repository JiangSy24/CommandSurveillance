//
//  IMTeamManage.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/7/10.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "IMTeamManage.h"
#import "WMGroupActModel.h"
#import "IMSdk.h"
#import "NSMutableArray+WeakReferences.h"
#define GroupChange     @"GroupChangeNotic"


//群组消息回调
void WMGroupMsgCallBack(int32_t nMsgId, const char* pMsgData, int32_t nDataLen, void* pUser){
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        NSString *tem =[NSString stringWithUTF8String:pMsgData];
        NSData *stringData = [tem dataUsingEncoding:NSUTF8StringEncoding];
        WMGroupActModel *model = [WMGroupActModel mj_objectWithKeyValues:stringData];
//        NSLog(@"WM_IM_ChatMsgId_Invite_Notify chartid:[%d] sponsorid[%d]",model.chatid,model.sponsorid);
        model.nMsgId = nMsgId;
        [[NSNotificationCenter defaultCenter] postNotificationName:GroupChange object:model];
    });

}
@interface IMTeamManage()
@property (nonatomic,strong) NSMutableArray<id<WMIMTeamManageToolDelegate>> *delegateArray;
@end
@implementation IMTeamManage

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:GroupChange object:nil];
    }
    return self;
}

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
-(void)receiveMessage:(NSNotification *)noti{
    WMGroupActModel *model = noti.object;
    
    [self emFun:^(id<WMIMTeamManageToolDelegate> tem) {
        if (tem && [tem respondsToSelector:@selector(onTeamMemberChanged:)]) {
            [tem onTeamMemberChanged:model];
        }
    }];
}

- (NSMutableArray<id<WMIMTeamManageToolDelegate>>*)delegateArray{
    if (_delegateArray == nil) {
        _delegateArray = [NSMutableArray mutableArrayUsingWeakReferences];
    }
    return _delegateArray;
}

- (void)emFun:(void (^)(id<WMIMTeamManageToolDelegate> tem))actFun{
    for (id<WMIMTeamManageToolDelegate> tem in self.delegateArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (actFun) {
                actFun(tem);
            }
        });
    }
}

- (void)creatNewGroup:(NSString*)groupName members:(NSArray<CSOneUserModel*>*)array success:(void (^)(void))success failure:(void (^)(int error))failure{
    do {
        NSString *strGroupName = [CSStatusTool encodeString:groupName];
        int iret = WM_IM_GroupCreat((char* const)strGroupName.UTF8String);
        if ((iret < 0)||
            (groupName.length == 0)) {
            NSLog(@"creatNewGroup err");
            if (failure) {
                failure(iret);
            }
            break;
        }
        //{ "userids":[{"userid"}]}
        NSMutableString *strJson = [NSMutableString stringWithString:@"{\"userids\":["];
        [strJson appendFormat:@"{\"userid\":%d},",[CSUrlString instance].account.sysconf.accountid];
        for (CSOneUserModel *model in array) {
            if ([model isEqual:array.lastObject]) {
                [strJson appendFormat:@"{\"userid\":%d}",model.id];
            }else{
                [strJson appendFormat:@"{\"userid\":%d},",model.id];
            }
        }
        [strJson appendString:@"]}"];
        
        int iRes = WM_IM_GroupInviteMember(iret, strJson.UTF8String);
        
        if (0 == iRes) {
            LMRegisterSyncgroupModel *model = [[LMRegisterSyncgroupModel alloc] init];
            model.name = groupName;
            model.id = iret;
            model.createtime = [NSDate date].timeIntervalSince1970;
            model.owner = [CSUrlString instance].account.sysconf.accountid;
            [[LMRegisterModle instance].syncgroupArry addObject:model];
            if (success) {
                success();
            }
        }
    } while (FALSE);
}

/**
 组加人
 
 @param groupId 组id
 @param array 组成员
 @param success 成功回调
 @param failure 失败回调
 */
- (void)groupInviteMember:(int)groupId members:(NSArray<CSOneUserModel*>*)array success:(void (^)(void))success failure:(void (^)(int error))failure{
    NSMutableString *strJson = [NSMutableString stringWithString:@"{\"userids\":["];
    [strJson appendFormat:@"{\"userid\":%d},",[CSUrlString instance].account.sysconf.accountid];
    for (CSOneUserModel *model in array) {
        if ([model isEqual:array.lastObject]) {
            [strJson appendFormat:@"{\"userid\":%d}",model.id];
        }else{
            [strJson appendFormat:@"{\"userid\":%d},",model.id];
        }
    }
    [strJson appendString:@"]}"];
    
    int iRes = WM_IM_GroupInviteMember(groupId, strJson.UTF8String);
    
    if (0 == iRes) {
        if (success) {
            success();
        }
    }else{
        if (failure) {
            failure(iRes);
        }
    }
}

/**
 组减人
 
 @param groupId 组id
 @param array 组成员
 @param success 成功回调
 @param failure 失败回调
 */
- (void)groupKickOut:(int)groupId memberid:(int)memberid success:(void (^)(void))success failure:(void (^)(int error))failure{
    
    int iRes = WM_IM_GroupKickOut(groupId, memberid);
    
    if (0 == iRes) {
        if (success) {
            success();
        }
    }else{
        if (failure) {
            failure(iRes);
        }
    }
}

/**
 退出组
 
 @param groupId 组id
 @return  0-成功，1-失败, 其他-错误码
 */
- (int)groupHadLeft:(int)groupId{
    return WM_IM_GroupHadLeft(groupId);
}

/**
 *  添加聊天委托
 *
 *  @param delegate 聊天委托
 */
- (void)addDelegate:(id<WMIMTeamManageToolDelegate>_Nonnull)delegate{
    [self.delegateArray addObject:delegate];
}

/**
 *  移除聊天委托
 *
 *  @param delegate 聊天委托
 */
- (void)removeDelegate:(nullable id<WMIMTeamManageToolDelegate>)delegate{
    for (id<WMIMTeamManageToolDelegate> tem in self.delegateArray) {
        if ([tem isEqual:delegate]) {
            [self.delegateArray removeObject:tem];
            break;
        }
    }
}
@end
