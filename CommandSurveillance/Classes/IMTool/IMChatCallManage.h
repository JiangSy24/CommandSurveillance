//
//  IMChatCallManage.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/6/7.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMChatMangeProtocol.h"
void WMChatMsgCallBack(int32_t nMsgId, const char* pMsgData, int32_t nDataLen, void* pUser);

@interface IMChatCallManage : NSObject<WMIMChatCallManage>
/**
 *  主叫发起实时会话请求
 *
 *  @param session 会话信息
 *  @param completion  发起实时会话结果回调
 *
 */
- (void)requestRTS:(WMIMSession *_Nonnull)session
              completion:(nullable NIMRTSRequestHandler)completion API_UNAVAILABLE(macos);

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
         completion:(nullable NIMRTSResponseHandler)completion API_UNAVAILABLE(macos);

/**
 *  邀请他人加入（同步）一个人
 *
 *  @param chatid 实时会话id
 *  @param completion  响应呼叫结果回调
 *  YES是成功
 */
- (BOOL)inviteRTS:(int)chatid
          sponsorid:(int)sponsorid
             userid:(int)userid API_UNAVAILABLE(macos);

/**
 *  挂断实时会话
 *
 *  @param chatId 需要挂断的实时会话ID
 *
 *  @discussion 被叫在响应请求之前不要调用挂断接口
 */
- (void)terminateRTS:(int)chatId API_UNAVAILABLE(macos);

/**
 *  取消邀请
 *
 *  @param chatId 实时会话ID
 *
 *  @userid 需要取消邀请的成员id
 */
- (void)cancelRTS:(int)chatId users:(int)userid;

/**
 *  设置当前实时会话静音模式
 *
 *  @param mute 是否开启静音
 *
 */
- (void)setMute:(BOOL)mute API_UNAVAILABLE(macos);

/**
 *  设置当前实时会话扬声器模式
 *
 *  @param useSpeaker 是否开启扬声器
 *
 */
- (void)setSpeaker:(BOOL)useSpeaker API_UNAVAILABLE(macos);

/**
 *  抢麦
 *
 *  @param chatId 会话ID
 *
 */
- (void)chatRobMic:(int)chatId
        completion:(nullable NIMRTSMicRequestHandler)completion API_UNAVAILABLE(macos);

/**
 *  放麦
 *
 *  @param chatId 会话ID
 *  0-成功，1-失败, 其他-错误码
 */
- (int)chatFreeMic:(int)chatId;

/**
 *  添加实时会话委托
 *
 *  @param delegate 实时会话委托
 */
- (void)addDelegate:(id<WMIMChatCallManageDelegate> _Nonnull)delegate API_UNAVAILABLE(macos);

/**
 *  移除实时会话委托
 *
 *  @param delegate 实时会话委托
 */
- (void)removeDelegate:(id<WMIMChatCallManageDelegate> _Nonnull)delegate API_UNAVAILABLE(macos);
@end
