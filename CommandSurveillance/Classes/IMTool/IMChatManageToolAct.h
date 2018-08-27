//
//  IMChatManageToolAct.h
//  CommandSurveillance
//
//  Created by liangcong on 2018/5/31.
//  Copyright © 2018年 liangcong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IMChatMangeProtocol.h"

@interface IMChatManageToolAct : NSObject<WMIMChatManageTool>

void WMChatMsgCallBack(int32_t nMsgTypeId, int32_t nChatMsgId, const char* pMsgData, int32_t nDataLen, void* pUser);

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
