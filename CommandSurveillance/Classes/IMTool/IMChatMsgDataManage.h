//
//  IMChatMsgDataManage.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/31.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMChatMangeProtocol.h"
#import "WMIMDeleteMessagesOption.h"

@interface IMChatMsgDataManage : NSObject<WMIMChatMsgData>
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
 存储session，如果存在更新，如果不存在则保存

 @param session 会话
 */
- (void)saveSessionInfo:(WMIMSession *_Nonnull)session;

/**
 *  从本地db读取所有会话
 *
 *  @param limit   个数限制
 *
 */
- (void)sessionsInDblimit:(NSInteger)limit complete:(void (^)(NSArray<WMIMSession *>* sessionArray))complete;

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
