//
//  IMChatMangeProtocol.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/31.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#ifndef IMChatMangeProtocol_h
#define IMChatMangeProtocol_h
#import <Foundation/Foundation.h>
#import "IMSdk_i.h"
#import "WMIMDeleteMessagesOption.h"
#import "LMCallModel.h"

@protocol WMIMChatManageToolDelegate <NSObject>

@optional
/**
 *  有信息来了,直接存入数据库，代理通知外部刷新数据。
 *  开始表演
 *
 */
- (void)recvMessage:(WMIMMessage *_Nonnull)message;

/**
 *  发送消息完成回调
 *
 *  @param message 当前发送的消息
 *  @param error   失败原因,如果发送成功则error为nil
 */
- (void)sendMessage:(WMIMMessage *_Nonnull)message didCompleteWithError:(nullable NSError *)error;
@end

@protocol WMIMChatManageTool <NSObject>

/**
 *  发送数据
 */
- (void)sendMessage:(WMIMMessage* _Nonnull)msg;

/**
 *  添加聊天委托
 *
 *  @param delegate 聊天委托
 */
- (void)addDelegate:(id<WMIMChatManageToolDelegate>_Nonnull)delegate;

/**
 *  移除聊天委托
 *
 *  @param delegate 聊天委托
 */
- (void)removeDelegate:(nullable id<WMIMChatManageToolDelegate>)delegate;
@end

@protocol WMIMChatMsgData <NSObject>

/**
 *  存数据到数据库
 *
 *  @param message 聊天消息
 */
- (void)saveMessage:(WMIMMessage*_Nonnull)message;

/**
 *  从本地db读取一个会话里某条消息之前的若干条的消息
 *
 *  @param session 消息所属的会话
 *  @param message 当前最早的消息,没有则传入nil
 *  @param limit   个数限制
 *
 *  @return 消息列表，按时间从小到大排列
 */
- (nullable NSArray<WMIMMessage *> *)messagesInSession:(WMIMSession *_Nonnull)session
                                              message:(nullable WMIMMessage *)message
                                                limit:(NSInteger)limit;

/**
 *  从本地db读取所有会话
 *
 *  @param limit   个数限制
 *
 */
- (void)sessionsInDblimit:(NSInteger)limit complete:(void (^_Nullable)(NSArray<WMIMSession *>* _Nullable sessionArray))complete;

/**
 存储session，如果存在更新，如果不存在则保存
 
 @param session 会话
 */
- (void)saveSessionInfo:(WMIMSession *_Nonnull)session;

/**
 *  删除某个会话的所有消息
 *
 *  @param session 待删除会话
 *  @param option 删除消息选项
 */
- (void)deleteAllmessagesInSession:(WMIMSession *_Nonnull)session
                            option:(nullable WMIMDeleteMessagesOption *)option;


/**
 *  更新某个会话的已读状态
 *
 *  @param session 会话
 */
- (void)updateAllmessagesStatusInSession:(WMIMSession *_Nonnull)session;
@end

/**
 *  发起实时会话请求Block
 *
 *  @param error 发起结果, 如果成功 error 为 0
 *  @param chatid 发起的实时会话的id
 */
typedef void(^NIMRTSRequestHandler)(int error, int chatid);

/**
 *  响应实时会话请求Block
 *
 *  @param error  响应实时会话请求, 如果成功 error 为 0
 *  @param array  通话的人数
 */
typedef void(^NIMRTSResponseHandler)(int error, NSArray<LMCallModel*>* _Nullable array);

/**
 *  抢麦回调Block（同步的回调）
 *
 *  @param micResult 发起结果, 0-成功，1-失败, 其他-错误码
 *  @param userid 在麦用户id
 *  @param chatid 发起的实时会话的id
 */
typedef void(^NIMRTSMicRequestHandler)(int micResult, int chatid, int userid);

@protocol WMIMChatCallManageDelegate <NSObject>

@optional
/**
 *  被叫收到实时会话请求
 *
 *  @param chatid 实时会话ID
 *  @param sponsorid 主叫用户id
 *  @param chattype 会话类型
 */
- (void)onRTSRequest:(int)chatid
                from:(int)sponsorid
            services:(WM_IM_CallType)chattype;

/**
 *  主叫收到被叫实时会话响应
 *
 *  @param chatid 实时会话ID
 *  @param userid 被叫用户id
 *  @param response 是否接听, 1 是拒绝
 *
 */
- (void)onRTSResponse:(int)chatid
               userid:(int)userid
             response:(int)response;

/**
 *  对方结束实时会话
 *
 *  @param chatid 实时会话ID
 */
- (void)onRTSTerminate:(int)chatid;

/**
 *  用户加入了多人会议
 *
 *  @param userid     用户 id
 *  @param chatid     会议 id
 */
- (void)onUserJoined:(int)userid
              chatid:(int)chatid;

/**
 *  用户离开了多人会议
 *
 *  @param userid    用户 id
 *  @param chatid    会议 id
 */
- (void)onUserLeft:(int)userid
            chatid:(int)chatid;

/**
 *  成员抢麦成功
 *
 *  @param userid    用户 id
 *  @param chatid    会议 id
 */
- (void)userOnMic:(int)userid
            chatid:(int)chatid;

/**
 *  成员放麦
 *
 *  @param userid    用户 id
 *  @param chatid    会议 id
 */
- (void)userLeftMic:(int)userid
           chatid:(int)chatid;

@end

@protocol WMIMChatCallManage <NSObject>
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
 *  @param mute 是否开启静音 YES:静音。NO:恢复。
 *
 */
- (void)setMute:(BOOL)mute API_UNAVAILABLE(macos);

/**
 *  设置当前实时会话扬声器模式 YES 切换到免提，NO切换到耳机
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

#endif /* IMChatMangeProtocol_h */
