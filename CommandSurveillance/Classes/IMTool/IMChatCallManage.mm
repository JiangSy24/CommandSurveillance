//
//  IMChatCallManage.m
//  CommandSurveillance
//
//  Created by liangcong on 2018/6/7.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import "IMChatCallManage.h"
#import "IMSdk.h"
#import "LMCallModel.h"
#import "NSMutableArray+WeakReferences.h"
#define CallPhone   @"CallPhone"
#define GetWMGroupCallType(nId1, nId2) (nId1 << 8 | nId2)

void WMChatMsgCallBack(int32_t nMsgId, const char* pMsgData, int32_t nDataLen, void* pUser){
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{

        NSString *tem =[NSString stringWithUTF8String:pMsgData];
        NSData *stringData = [tem dataUsingEncoding:NSUTF8StringEncoding];
        LMPhoneActModel *model = [LMPhoneActModel mj_objectWithKeyValues:stringData];
        NSLog(@"WM_IM_ChatMsgId_Invite_Notify chartid:[%d] sponsorid[%d]",model.chatid,model.sponsorid);
        model.nMsgId = nMsgId;
        [[NSNotificationCenter defaultCenter] postNotificationName:CallPhone object:model];
    });
 
}

@interface IMChatCallManage()<AgoraRtcEngineDelegate>

@property (strong, nonatomic) AgoraRtcEngineKit *rtcEngine;

@property (strong, nonatomic) NSMutableArray<id<WMIMChatCallManageDelegate>>* delegateArray;

@property (nonatomic, assign) WM_IM_CallType curChattype;

@end

@implementation IMChatCallManage

- (instancetype)init {
    self = [super init];
    if (self) {
        self.curChattype = WM_IM_CallType_Invalid;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessage:) name:CallPhone object:nil];
    }
    return self;
}
/*
 //通话消息ID
 enum enmChatMsgId
 {
 WM_IM_ChatMsgId_Invalid = 0,
 WM_IM_ChatMsgId_Invite_Notify,  //邀请通知, {"chatid", "sponsorid", "chattype"}
 WM_IM_ChatMsgId_Invite_Response, //邀请回应，{"chatid", "userid", "response"}
 WM_IM_ChatMsgId_MemAdd_Notify,  //成员增加通知, {"chatid", "sponsorid", "userid"}
 WM_IM_ChatMsgId_MemLost_Notify,  //成员减少通知, {"chatid", "userid"}
 WM_IM_ChatMsgId_CancelInvite_Notify, //取消邀请通知, {"chatid"}
 WM_IM_ChatMsgId_RobMic_Notify, //抢麦通知, {"chatid", "userid", "time"}
 WM_IM_ChatMsgId_FreeMic_Notify, //放麦通知, {"chatid", "userid", "time"}
 };
 */
-(void)receiveMessage:(NSNotification *)noti{
    LMPhoneActModel *model = noti.object;
    
    switch (model.nMsgId) {
        case WM_IM_CallMsgId_Invite_Notify://邀请通知
        {
            model.userid = model.sponsorid;
//            (uint32_t)chanId & 0x000000FF
            model.chattype = (uint32_t)model.chattype & 0x000000FF;
            self.curChattype = (WM_IM_CallType)model.chattype;
            // 数据库存在就不存
            [self emFun:^(id<WMIMChatCallManageDelegate> tem) {
                if (tem && [tem respondsToSelector:@selector(onRTSRequest:from:services:)]) {
                    [tem onRTSRequest:model.chatid from:model.sponsorid services:(WM_IM_CallType)model.chattype];
                }
            }];
            break;
        }
        case WM_IM_CallMsgId_Invite_Response://邀请回应
        {
            //邀请回应, 1 是拒绝
            [self emFun:^(id<WMIMChatCallManageDelegate> tem) {
                if (tem && [tem respondsToSelector:@selector(onRTSResponse:userid:response:)]) {
                    [tem onRTSResponse:model.chatid userid:model.userid response:model.response];
                }
            }];
            break;
        }
        case WM_IM_CallMsgId_MemAdd_Notify://成员增加通知
        {
            [self emFun:^(id<WMIMChatCallManageDelegate> tem) {
                if (tem && [tem respondsToSelector:@selector(onUserJoined:chatid:)]) {
                    [tem onUserJoined:model.userid chatid:model.chatid];
                }
            }];
            break;
        }
        case WM_IM_CallMsgId_MemLost_Notify://成员减少通知
        {
            if (self.curChattype == WM_IM_CallType_Single_Voice) {
                [self.rtcEngine leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
                    [self emFun:^(id<WMIMChatCallManageDelegate> tem) {
                        if (tem && [tem respondsToSelector:@selector(onRTSTerminate:)]) {
                            [tem onRTSTerminate:model.chatid];
                        }
                    }];
                }];
            }else{
                [self emFun:^(id<WMIMChatCallManageDelegate> tem) {
                    if (tem && [tem respondsToSelector:@selector(onUserLeft:chatid:)]) {
                        [tem onUserLeft:model.userid chatid:model.chatid];
                    }
                }];
            }
            break;
        }
        case WM_IM_CallMsgId_CancelInvite_Notify://主叫方取消邀请通知
        {
            // 只有当邀请方判断没有其他人在会议中才会发这个，界面退出不做应答
            [self emFun:^(id<WMIMChatCallManageDelegate> tem) {
                if (tem && [tem respondsToSelector:@selector(onRTSTerminate:)]) {
                    [tem onRTSTerminate:model.chatid];
                }
            }];
            break;
        }
        case WM_IM_CallMsgId_RobMic_Notify:
        {
            //抢麦通知, {"chatid", "userid", "time"}
            [self emFun:^(id<WMIMChatCallManageDelegate> tem) {
                if (tem && [tem respondsToSelector:@selector(userOnMic:chatid:)]) {
                    [tem userOnMic:model.userid chatid:model.chatid];
                }
            }];
            break;
        }
        case WM_IM_CallMsgId_FreeMic_Notify:
        {
            //放麦通知, {"chatid", "userid", "time"}
            [self emFun:^(id<WMIMChatCallManageDelegate> tem) {
                if (tem && [tem respondsToSelector:@selector(userLeftMic:chatid:)]) {
                    [tem userLeftMic:model.userid chatid:model.chatid];
                }
            }];
            break;
        }
        case WM_IM_CallMsgId_KickOutOther_Notify:
        {
            //其他人被踢通知k;
        }
        default:
            break;
    }
    
}

- (AgoraRtcEngineKit*)rtcEngine{
    if (_rtcEngine == nil) {//@"1326422b979541dea84df76b0db2b28f"
        _rtcEngine = [AgoraRtcEngineKit sharedEngineWithAppId:[CSUrlString instance].account.sysconf.thirdparty.swsignature delegate:self];
    }
    return _rtcEngine;
}

/**
 *  主叫发起实时会话请求
 *
 *  @param session 会话xin'xi
 *  @param completion  发起实时会话结果回调
 *
 */
- (void)requestRTS:(WMIMSession *)session
              completion:(nullable NIMRTSRequestHandler)completion API_UNAVAILABLE(macos){
    
    NSMutableString *strJson = [NSMutableString stringWithString:@"{\"userids\":["];
    for (CSOneUserModel *model in session.member) {
        
        if (model.id == [CSUrlString instance].account.sysconf.accountid) {
            continue;
        }
        
        if ([model isEqual:session.member.lastObject]) {
            [strJson appendFormat:@"{\"userid\":%d}",model.id];
        }else{
            [strJson appendFormat:@"{\"userid\":%d},",model.id];
        }
    }
    [strJson appendString:@"]}"];

    int iChat = 0;
    WM_IM_CallType tem;
    if (session.callType == WM_IM_CallType_Single_Voice) {
        // 搞语音
        iChat = WM_IM_Chat_Start(WM_IM_CallType_Single_Voice, strJson.UTF8String);
        tem = WM_IM_CallType_Single_Voice;
    }else if (session.callType == WM_IM_CallType_Group_Voice) {
        int iResult = 0;
        iChat = WM_IM_Chat_StartGroup(session.sessionId.intValue, WM_IM_CallType_Group_Voice, strJson.UTF8String, iResult);
        tem = WM_IM_CallType_Group_Voice;
    }else {//if (session.callType == WM_IM_CallType_Group_Voice_RobMic)
        int iResult = 0;
        iChat = WM_IM_Chat_StartGroup(session.sessionId.intValue, WM_IM_CallType_Group_Voice_RobMic, strJson.UTF8String, iResult);
        tem = WM_IM_CallType_Group_Voice_RobMic;
    }

    // 成功后赋值 0是失败
    if (iChat != 0) {
        self.curChattype = tem;
        
        NSString *strKey = [NSString stringWithFormat:@"%d",iChat];
        [self.rtcEngine joinChannelByToken:nil channelId:strKey info:nil uid:0 joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
            
            [self.rtcEngine setEnableSpeakerphone:NO];

            if (session.callType == WM_IM_CallType_Group_Voice_RobMic){
                [self.rtcEngine muteLocalAudioStream:YES];
                [self.rtcEngine setEnableSpeakerphone:YES];
            }
            
        }];
        
    }

    // 呼叫iChat == 0失败 返回错误码1
    if (completion){
        completion((iChat == 0), iChat);
    }
}

/**
 *  邀请他人加入（同步）一个人
 *
 *  @param chatid 实时会话id
 *
 */
- (BOOL)inviteRTS:(int)chatid
        sponsorid:(int)sponsorid
           userid:(int)userid{

    NSString *str = [NSString stringWithFormat: @" {\"userids\" : [{\"userid\" : %d}]}",userid];
    // 搞语音
    int iChat = WM_IM_Chat_Invite(chatid, /*jsonString.UTF8String*/str.UTF8String);//0成功
    return (iChat == 0);
}

/**
 *  被叫响应实时会话请求
 *
 *  @param chatid 实时会话id
 *  @param accept  是否接听
 *  @param sponsorid  发起者id
 *  @param completion  响应呼叫结果回调
 *
 */
- (void)responseRTS:(int)chatid
          sponsorid:(int)sponsorid
             accept:(BOOL)accept
         completion:(nullable NIMRTSResponseHandler)completion API_UNAVAILABLE(macos){
    
    if (accept) {

        NSString *strKey = [NSString stringWithFormat:@"%d",chatid];
        __block NSArray<LMCallModel*> *modelArray = [NSArray array];

        [self.rtcEngine joinChannelByToken:nil channelId:strKey info:nil uid:0 joinSuccess:^(NSString * _Nonnull channel, NSUInteger uid, NSInteger elapsed) {
            [self.rtcEngine setEnableSpeakerphone:NO];//YES 切换到免提，NO切换到耳机
//            [self.rtcEngine setDefaultAudioRouteToSpeakerphone:YES];//yes是免提，NO是耳机
//            [self.rtcEngine muteLocalAudioStream:YES];//设置静音状态 YES:静音。NO:恢复。 抢麦时候用。
            char szBuf[500*1024] = {0};
            int error = WM_IM_Chat_CalleeAck(chatid, sponsorid, 0, szBuf, 500*1024);
            
            if (self.curChattype == WM_IM_CallType_Group_Voice_RobMic){
                [self.rtcEngine muteLocalAudioStream:YES];
                [self.rtcEngine setEnableSpeakerphone:YES];
            }
            
            // 刷ui通话中两个 + szBuf的
            NSString *tem =[NSString stringWithUTF8String:szBuf];
            NSData *stringData = [tem dataUsingEncoding:NSUTF8StringEncoding];

            modelArray = [LMCallModel mj_objectArrayWithKeyValuesArray:stringData];
            if (completion) {
                completion(error, modelArray);
            }
        }];

    }else{
        // 拒接
        char szBuf[500*1024] = {0};
        int error = WM_IM_Chat_CalleeAck(chatid, sponsorid, 1, szBuf, 500*1024);
        if (completion) {
            completion(error, nil);
        }
    }
}
// 场景1，你发起邀请你拒绝
// 如果多人，有人接听了就不发这个了，可能你在邀请通话的情景进行邀请多人，需要一个一个取消。在通话中那个人就不用管了。
// 场景2，你接别人邀请你拒绝
/**
 *  挂断实时会话
 *
 *  @param chatId 需要挂断的实时会话ID
 *
 */
- (void)terminateRTS:(int)chatId API_UNAVAILABLE(macos){
    [self.rtcEngine leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        // 挂断
        WM_IM_Chat_End(chatId);
    }];
}

/**
 *  取消邀请
 *
 *  @param chatId 实时会话ID
 *
 *  @userid 需要取消邀请的成员id
 */
- (void)cancelRTS:(int)chatId users:(int)userid{
    NSString *str = [NSString stringWithFormat: @" {\"userids\" : [{\"userid\" : %d}]}",userid];
    WM_IM_Chat_CancelInvite(chatId, str.UTF8String);
}

/**
 *  设置当前实时会话静音模式
 *
 *  @param mute 是否开启静音 YES:静音。NO:恢复。
 *
 */
- (void)setMute:(BOOL)mute API_UNAVAILABLE(macos){
    [self.rtcEngine muteLocalAudioStream:mute];//设置静音状态 YES:静音。NO:恢复。 抢麦时候用。
}

/**
 *  设置当前实时会话扬声器模式
 *
 *  @param useSpeaker 是否开启扬声器 YES 切换到免提，NO切换到耳机
 *
 */
- (void)setSpeaker:(BOOL)useSpeaker API_UNAVAILABLE(macos){
    [self.rtcEngine setEnableSpeakerphone:useSpeaker];//YES 切换到免提，NO切换到耳机
}

/**
 *  抢麦
 *
 *  @param chatId 会话ID
 *
 */
- (void)chatRobMic:(int)chatId
        completion:(nullable NIMRTSMicRequestHandler)completion{
    char szBuf[512] = {0};
    int iResult = WM_IM_Chat_RobMic(chatId, szBuf, 512);// 抢麦0是成功
    NSString *tem =[NSString stringWithUTF8String:szBuf];
    NSData *stringData = [tem dataUsingEncoding:NSUTF8StringEncoding];
    LMPhoneActModel *model = [LMPhoneActModel mj_objectWithKeyValues:stringData];
    [self.rtcEngine muteLocalAudioStream:iResult];// no 是有声音
    if (completion) {
        completion(iResult, chatId, model.userid);
    }
}

/**
 *  放麦
 *
 *  @param chatId 会话ID
 *
 */
- (int)chatFreeMic:(int)chatId{
    int iRet = WM_IM_Chat_FreeMic(chatId);
    [self.rtcEngine muteLocalAudioStream:YES];
    return iRet;
}

- (NSMutableArray<id<WMIMChatCallManageDelegate>>*)delegateArray{
    if (_delegateArray == nil) {
        _delegateArray = [NSMutableArray mutableArrayUsingWeakReferences];
    }
    return _delegateArray;
}

- (void)emFun:(void (^)(id<WMIMChatCallManageDelegate> tem))actFun{
    for (id<WMIMChatCallManageDelegate> tem in self.delegateArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (actFun) {
                actFun(tem);
            }
        });
    }
}

/**
 *  添加实时会话委托
 *
 *  @param delegate 实时会话委托
 */
- (void)addDelegate:(id<WMIMChatCallManageDelegate>)delegate API_UNAVAILABLE(macos){
    [self.delegateArray addObject:delegate];
}

/**
 *  移除实时会话委托
 *
 *  @param delegate 实时会话委托
 */
- (void)removeDelegate:(id<WMIMChatCallManageDelegate>)delegate API_UNAVAILABLE(macos){
    for (id<WMIMChatCallManageDelegate> tem in self.delegateArray) {
        if ([tem isEqual:delegate]) {
            [self.delegateArray removeObject:tem];
            break;
        }
    }
}

@end
